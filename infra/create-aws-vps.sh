#!/usr/bin/env bash
set -euo pipefail

APP_NAME="cicd-vps-aws-demo"
REGION="${AWS_REGION:-us-east-1}"
INSTANCE_TYPE="${INSTANCE_TYPE:-t3.micro}"
KEY_NAME="${APP_NAME}-key"
SG_NAME="${APP_NAME}-sg"
USER_DATA_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/cloud-init.yml"
SECRET_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/.secrets"
KEY_FILE="${SECRET_DIR}/${KEY_NAME}.pem"

mkdir -p "$SECRET_DIR"
chmod 700 "$SECRET_DIR"

echo "Verificando credenciales AWS..."
aws sts get-caller-identity >/dev/null

echo "Buscando VPC default en ${REGION}..."
VPC_ID="$(aws ec2 describe-vpcs \
  --region "$REGION" \
  --filters Name=is-default,Values=true \
  --query 'Vpcs[0].VpcId' \
  --output text)"

if [[ "$VPC_ID" == "None" || -z "$VPC_ID" ]]; then
  echo "No se encontro una VPC default en ${REGION}."
  exit 1
fi

echo "Buscando AMI Ubuntu 24.04 LTS..."
AMI_ID="$(aws ssm get-parameter \
  --region "$REGION" \
  --name /aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id \
  --query 'Parameter.Value' \
  --output text)"

echo "Creando llave SSH si no existe..."
if [[ ! -f "$KEY_FILE" ]]; then
  aws ec2 create-key-pair \
    --region "$REGION" \
    --key-name "$KEY_NAME" \
    --query 'KeyMaterial' \
    --output text > "$KEY_FILE"
  chmod 600 "$KEY_FILE"
else
  echo "La llave local ya existe: $KEY_FILE"
fi

echo "Creando Security Group si no existe..."
SG_ID="$(aws ec2 describe-security-groups \
  --region "$REGION" \
  --filters Name=group-name,Values="$SG_NAME" Name=vpc-id,Values="$VPC_ID" \
  --query 'SecurityGroups[0].GroupId' \
  --output text 2>/dev/null || true)"

if [[ "$SG_ID" == "None" || -z "$SG_ID" ]]; then
  SG_ID="$(aws ec2 create-security-group \
    --region "$REGION" \
    --group-name "$SG_NAME" \
    --description "Security group para demo CI/CD en VPS AWS" \
    --vpc-id "$VPC_ID" \
    --query 'GroupId' \
    --output text)"
fi

echo "Habilitando puertos 22 y 80..."
aws ec2 authorize-security-group-ingress \
  --region "$REGION" \
  --group-id "$SG_ID" \
  --ip-permissions \
    IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges='[{CidrIp=0.0.0.0/0,Description=SSH}]' \
    IpProtocol=tcp,FromPort=80,ToPort=80,IpRanges='[{CidrIp=0.0.0.0/0,Description=HTTP}]' \
  >/dev/null 2>&1 || true

echo "Creando instancia EC2..."
INSTANCE_ID="$(aws ec2 run-instances \
  --region "$REGION" \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --security-group-ids "$SG_ID" \
  --user-data "file://${USER_DATA_FILE}" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${APP_NAME}}]" \
  --query 'Instances[0].InstanceId' \
  --output text)"

echo "Esperando instancia running: ${INSTANCE_ID}"
aws ec2 wait instance-running --region "$REGION" --instance-ids "$INSTANCE_ID"

PUBLIC_IP="$(aws ec2 describe-instances \
  --region "$REGION" \
  --instance-ids "$INSTANCE_ID" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)"

echo "Configurando secretos en GitHub..."
gh secret set VPS_HOST --body "$PUBLIC_IP"
gh secret set VPS_USER --body "ubuntu"
gh secret set VPS_PORT --body "22"
gh secret set VPS_SSH_KEY < "$KEY_FILE"

echo
echo "VPS creada correctamente."
echo "Instancia: ${INSTANCE_ID}"
echo "IP publica: ${PUBLIC_IP}"
echo "URL esperada despues del deploy: http://${PUBLIC_IP}"
echo
echo "Ejecuta ahora:"
echo "  gh workflow run ci-cd.yml"
echo "  gh run watch --exit-status"

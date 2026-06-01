# Pasos para crear la VPS en AWS EC2

1. Entrar a AWS y abrir el servicio EC2.
2. Seleccionar `Launch instance`.
3. Nombre sugerido: `cicd-vps-aws-demo`.
4. Imagen: Ubuntu Server LTS.
5. Tipo de instancia: `t2.micro` o `t3.micro`.
6. Crear o seleccionar un par de llaves SSH.
7. En el Security Group habilitar:
   - SSH: puerto `22`.
   - HTTP: puerto `80`.
8. En `Advanced details`, pegar el contenido de `infra/cloud-init.yml` en `User data`.
9. Crear la instancia y esperar a que quede en estado `Running`.
10. Copiar la IP publica para usarla como secreto `VPS_HOST` en GitHub Actions.

## Comprobacion por SSH

```bash
ssh -i llave.pem ubuntu@IP_PUBLICA
docker --version
docker compose version
```

## Secretos necesarios en GitHub

En `Settings > Secrets and variables > Actions` configurar:

- `VPS_HOST`: IP publica de EC2.
- `VPS_USER`: `ubuntu`.
- `VPS_SSH_KEY`: contenido de la llave privada SSH.
- `VPS_PORT`: `22`.

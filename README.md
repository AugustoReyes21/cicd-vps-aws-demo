# CI/CD en VPS AWS

Proyecto demo para la tarea de automatizacion operativa, control de cambios y despliegue moderno. La aplicacion es un servicio web en Node.js/Express que se valida, construye y despliega automaticamente en una VPS de AWS mediante GitHub Actions.

## Arquitectura

- Repositorio publico en GitHub con el codigo fuente.
- GitHub Actions como servidor de CI/CD.
- VPS en AWS EC2 con Ubuntu Server.
- Docker y Docker Compose instalados en la VPS.
- Aplicacion Node.js ejecutandose en un contenedor.
- Puerto `80` de la VPS apuntando al puerto interno `3000` del contenedor.

## Flujo CI/CD

El workflow esta definido en `.github/workflows/ci-cd.yml` y se ejecuta cuando hay un `push` a la rama `main` o manualmente desde `workflow_dispatch`.

El pipeline realiza estos pasos:

1. Descarga el codigo del repositorio.
2. Configura Node.js 20.
3. Instala dependencias con `npm ci`.
4. Ejecuta pruebas automaticas con `npm test`.
5. Construye el proyecto con `npm run build`.
6. Configura acceso SSH hacia la VPS usando secretos de GitHub.
7. Copia los archivos del proyecto a la VPS con `rsync`.
8. Ejecuta `docker compose up -d --build` para desplegar la nueva version.

## Variables y secretos de GitHub Actions

En el repositorio de GitHub se deben configurar estos secretos en `Settings > Secrets and variables > Actions`:

| Secreto | Descripcion |
| --- | --- |
| `VPS_HOST` | IP publica o dominio de la VPS en AWS |
| `VPS_USER` | Usuario SSH de la VPS, por ejemplo `ubuntu` |
| `VPS_SSH_KEY` | Llave privada SSH con permiso para entrar a la VPS |
| `VPS_PORT` | Puerto SSH. Si no se define, se usa `22` |

Si los secretos todavia no existen, el workflow ejecuta instalacion, pruebas y build, pero omite el despliegue. Al configurar los secretos y volver a ejecutar el workflow, el despliegue hacia la VPS queda activo.

## Preparacion de la VPS en AWS

### Opcion automatica con AWS CLI

Si AWS CLI ya esta autenticado en la terminal, se puede crear la VPS y configurar los secretos de GitHub con:

```bash
chmod +x infra/create-aws-vps.sh
AWS_REGION=us-east-1 ./infra/create-aws-vps.sh
gh workflow run ci-cd.yml
gh run watch --exit-status
```

El script crea una instancia EC2 Ubuntu, un Security Group con puertos `22` y `80`, una llave SSH local en `.secrets/`, configura los secretos de GitHub y deja listo el despliegue automatico.

### Opcion manual desde la consola AWS

1. Crear una instancia EC2 con Ubuntu Server.
2. Abrir en el Security Group los puertos `22` para SSH y `80` para HTTP.
3. Conectarse por SSH:

```bash
ssh -i llave.pem ubuntu@IP_PUBLICA
```

4. Instalar Docker:

```bash
sudo apt update
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker ubuntu
```

5. Cerrar sesion SSH y volver a conectarse para activar el grupo `docker`.

6. Probar Docker:

```bash
docker --version
docker compose version
```

## Instalacion local

```bash
npm install
npm test
npm run build
npm start
```

La aplicacion queda disponible localmente en:

```text
http://localhost:3000
```

Endpoint de salud:

```text
http://localhost:3000/health
```

## Despliegue manual en la VPS

Si se desea desplegar manualmente dentro de la VPS:

```bash
cd ~/cicd-vps-aws-demo
docker compose up -d --build
docker compose ps
```

Luego abrir:

```text
http://IP_PUBLICA_DE_LA_VPS
```

## Evidencia esperada

Para demostrar el funcionamiento se debe mostrar:

- La instancia EC2 creada en AWS.
- La aplicacion respondiendo desde la IP publica de la VPS.
- El repositorio publico en GitHub.
- El archivo `.github/workflows/ci-cd.yml`.
- Una ejecucion exitosa del workflow en GitHub Actions.
- Los pasos de validacion, build y despliegue ejecutados correctamente.

# Documento de entrega - Flujo CI/CD en VPS AWS

## Nombre completo

Escribir aqui el nombre completo del estudiante.

## Arquitectura utilizada

La solucion implementa una aplicacion web Node.js/Express alojada en una VPS creada en AWS EC2. El codigo fuente se encuentra en un repositorio publico de GitHub. GitHub Actions ejecuta el pipeline de CI/CD y se conecta a la VPS mediante SSH para copiar los archivos y ejecutar el despliegue con Docker Compose.

Componentes principales:

- GitHub: repositorio publico y control de versiones.
- GitHub Actions: automatizacion del pipeline.
- AWS EC2: VPS con Ubuntu Server.
- Docker Compose: ejecucion del servicio en contenedor.
- Aplicacion Node.js: servicio web publicado por HTTP.

## Explicacion resumida del flujo CI/CD

El flujo se activa cuando se hace `push` a la rama `main` o cuando se ejecuta manualmente desde GitHub Actions. Primero se descarga el codigo, se configura Node.js 20, se instalan dependencias con `npm ci`, se ejecutan pruebas automaticas con `npm test` y se construye el proyecto con `npm run build`.

Si las validaciones finalizan correctamente, el workflow configura la llave SSH almacenada en los secretos del repositorio, registra la VPS como host conocido, copia el proyecto al servidor con `rsync` y ejecuta `docker compose up -d --build` para dejar corriendo la ultima version de la aplicacion.

## Descripcion de la VPS y entorno de despliegue

- Proveedor: AWS.
- Servicio: EC2.
- Sistema operativo: Ubuntu Server.
- Puertos habilitados: `22` para SSH y `80` para HTTP.
- Usuario SSH: `ubuntu`.
- Ruta de despliegue: `~/cicd-vps-aws-demo`.
- Runtime: Docker y Docker Compose.
- URL de la aplicacion: `http://100.30.254.186`.

## Enlace al video en Google Drive

Pegar aqui el enlace publico o compartido del video en Google Drive.

## Enlace al repositorio publico de GitHub

https://github.com/AugustoReyes21/cicd-vps-aws-demo

## Evidencia documentada

En el video se debe mostrar:

- La VPS creada en AWS EC2.
- La aplicacion funcionando desde la IP publica de la VPS.
- El repositorio publico en GitHub.
- El workflow ubicado en `.github/workflows/ci-cd.yml`.
- Una ejecucion exitosa del pipeline en GitHub Actions.
- Evidencia de validacion, construccion y despliegue.
- Resultado final funcionando en el servidor.

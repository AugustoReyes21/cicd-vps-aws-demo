# Guion para video de maximo 3 minutos

Duracion recomendada: 2 minutos 30 segundos.

## 0:00 - 0:20 VPS en AWS

Mostrar la consola de AWS EC2 con la instancia creada. Decir:

> Esta es la VPS utilizada para el despliegue. Es una instancia EC2 en AWS con Ubuntu Server. Tiene habilitado el puerto 22 para SSH y el puerto 80 para acceder a la aplicacion.

## 0:20 - 0:40 Aplicacion funcionando

Abrir en el navegador:

```text
http://IP_PUBLICA_DE_LA_VPS
```

Luego abrir:

```text
http://IP_PUBLICA_DE_LA_VPS/health
```

Decir:

> Aqui se observa la aplicacion corriendo en la VPS. El endpoint health confirma que el servicio esta activo.

## 0:40 - 1:05 Repositorio en GitHub

Mostrar el repositorio publico. Decir:

> Este es el repositorio publico del proyecto. Incluye el codigo fuente, Dockerfile, docker-compose, README y la configuracion de GitHub Actions.

## 1:05 - 1:30 Workflow

Abrir:

```text
.github/workflows/ci-cd.yml
```

Decir:

> El workflow instala dependencias, ejecuta pruebas, construye el proyecto y luego despliega hacia la VPS mediante SSH y Docker Compose.

## 1:30 - 2:15 Ejecucion del pipeline

Entrar a la pestana Actions y abrir una ejecucion exitosa. Mostrar los pasos:

- Instalar dependencias.
- Ejecutar pruebas automaticas.
- Construir proyecto.
- Copiar archivos hacia la VPS.
- Desplegar con Docker Compose.

Decir:

> Esta ejecucion demuestra que el pipeline valida, construye y despliega correctamente el proyecto.

## 2:15 - 2:50 Resultado final

Volver a la IP publica de la VPS y refrescar la pagina.

Decir:

> Finalmente, este es el resultado funcionando en el servidor. Cada cambio enviado a main puede pasar por el pipeline y quedar desplegado automaticamente en la VPS.

## Revision antes de entregar

- Subir el video a Google Drive.
- Activar permisos de visualizacion para cualquier persona con el enlace.
- Verificar que el video dure menos de 3 minutos.
- Pegar el enlace del video en el PDF final.

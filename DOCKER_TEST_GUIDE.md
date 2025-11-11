# Guía de Prueba Local con Docker

Este documento te guía paso a paso para construir y ejecutar la imagen Docker localmente en tu máquina Windows.

## ⚠ Si el script NO se ejecuta

Si ves un error como:
```
"cannot be loaded because running scripts is disabled on this system"
```

**Usa el script Batch en lugar del PowerShell**:

```batch
docker-local-test.bat
```

O lee `DOCKER_TROUBLESHOOTING.md` para 4 soluciones diferentes.

## Requisitos previos

- **Docker Desktop instalado y corriendo**
  - Descarga desde: https://www.docker.com/products/docker-desktop
  - Instala y asegúrate de que el servicio Docker está corriendo (verás el ícono de Docker en la bandeja del sistema)
  - Verifica que funciona abriendo PowerShell y ejecutando: `docker --version`

## Opción A: Usar el script Batch (recomendado — automatizado, sin restricciones)

### Paso 1: Ejecuta el script

1. Abre el Explorador de Windows
2. Navega a: `D:\Ampps\www\workflowN8N_1`
3. **Haz doble clic en**: `docker-local-test.bat`

O desde PowerShell/cmd:

```batch
docker-local-test.bat
```

El script hará lo siguiente automáticamente:
- Verificará que Docker está disponible
- Construirá la imagen Docker
- Arrancará el contenedor
- Esperará a que n8n esté listo
- Mostrará logs y la dirección donde acceder

### Paso 2-5: [Continúa con los pasos debajo]

---

## Opción B: Usar el script PowerShell (con Bypass)

### Paso 1: Abre PowerShell

1. Presiona `Win + X` y selecciona "Windows PowerShell" (o "Terminal")
2. Navega a la carpeta del proyecto:
   ```powershell
   cd D:\Ampps\www\workflowN8N_1
   ```

### Paso 2: Ejecuta el script

```powershell
powershell -ExecutionPolicy Bypass -File .\docker-local-test.ps1
```

O más simple:

```powershell
.\docker-local-test.ps1
```

(Si ves error de ejecución de scripts, usa el comando Bypass anterior)
- Verificará que Docker está disponible
- Construirá la imagen Docker
- Arrancará el contenedor
- Esperará a que n8n esté listo
- Mostrará logs y la dirección donde acceder

### Paso 3: Accede a n8n

Abre tu navegador en: **http://localhost:5678**

### Paso 4: Verifica que los nodos aparecen

1. En la UI de n8n, haz clic en el ícono de búsqueda (lupa) en la barra lateral
2. Busca: "LlamaParse" → debería aparecer el nodo
3. Busca: "LlamaExtract" → debería aparecer el nodo
4. Busca: "LlamaCloud" → debería aparecer el nodo
5. En la sección de credenciales, verifica que "LlamaCloud API Key" está disponible

### Paso 5: Detener el contenedor

Cuando termines, detén el contenedor ejecutando en PowerShell:

```powershell
docker stop n8n-llama-custom
```

## Opción C: Comandos manuales paso a paso (sin script)

Si prefieres ejecutar los comandos manualmente, aquí están:

### Paso 1: Construir la imagen

```powershell
cd D:\Ampps\www\workflowN8N_1
docker build -t n8n-llama-custom .
```

Espera a que termine (2-5 minutos). Verás líneas que dicen "Step 1/X", "Step 2/X", etc.

### Paso 2: Ejecutar el contenedor

```powershell
docker run -d --name n8n-llama-custom -p 5678:5678 n8n-llama-custom
```

El `-d` indica que corre en segundo plano. Recibirás un ID de contenedor como respuesta.

### Paso 3: Ver los logs

```powershell
docker logs -f n8n-llama-custom
```

Presiona `Ctrl + C` cuando veas que n8n está listo (líneas como "n8n ready on..." o "Server started").

### Paso 4: Acceder a n8n

Abre: **http://localhost:5678**

### Paso 5: Detener

```powershell
docker stop n8n-llama-custom
```

## Comandos útiles adicionales

```powershell
# Ver logs sin seguimiento (últimas 50 líneas)
docker logs -n 50 n8n-llama-custom

# Ver logs en tiempo real
docker logs -f n8n-llama-custom

# Inspeccionar el contenedor
docker inspect n8n-llama-custom

# Eliminar el contenedor (debes detenerlo primero)
docker rm n8n-llama-custom

# Eliminar la imagen
docker rmi n8n-llama-custom

# Ver imágenes disponibles
docker images

# Ver contenedores corriendo
docker ps

# Ver todos los contenedores (incluyendo detenidos)
docker ps -a
```

## Solución de problemas

### "docker: command not found"
- Docker no está instalado o no está en el PATH
- Instala Docker Desktop desde https://www.docker.com/products/docker-desktop
- Reinicia PowerShell después de instalar

### "port 5678 is already allocated"
- Otro contenedor o proceso está usando el puerto 5678
- Ejecuta: `docker stop n8n-llama-custom && docker rm n8n-llama-custom` y luego intenta de nuevo
- O usa un puerto diferente: `docker run -d --name n8n-custom -p 5679:5678 n8n-llama-custom` (accede a http://localhost:5679)

### "Build failed" o errores de compilación
- Verifica que el `Dockerfile` está en la raíz del proyecto
- Verifica que `package.json` y `package-lock.json` están presentes
- Intenta ejecutar primero localmente: `npm install && npm run build`

### n8n no arranca o logs muestran errores
- Ver más logs: `docker logs -n 200 n8n-llama-custom`
- Verifica que la imagen n8n base está disponible: `docker pull n8nio/n8n:latest` (descarga la última versión)

### Los nodos no aparecen en n8n
- Verifica que `dist/` se generó correctamente: `docker run -it n8n-llama-custom ls -la /home/node/.n8n/custom/dist/`
- Recarga la página del navegador (Ctrl + F5)
- Revisa la consola del navegador (F12) para ver si hay errores de JavaScript

## Qué esperar si todo funciona correctamente

- **Build**: deberías ver líneas como:
  ```
  Step 1/15 : FROM node:20 AS builder
  Step 2/15 : WORKDIR /usr/src/app
  ...
  Successfully tagged n8n-llama-custom:latest
  ```

- **Logs de n8n**: deberías ver líneas como:
  ```
  Starting n8n...
  n8n ready on...
  Server started
  ```

- **UI de n8n**: en http://localhost:5678 deberías ver la interfaz de n8n vacía (sin flujos). El ícono de búsqueda debería permitirte buscar los nodos personalizados.

## Próximos pasos después de verificar localmente

1. Si todo funciona localmente, puedes subirlo a Render con confianza
2. Lee `README_DEPLOY.md` para instrucciones de despliegue en Render
3. Usa el archivo `.render.yaml` proporcionado como referencia

## Preguntas frecuentes

**P: ¿Puedo modificar el código mientras Docker está corriendo?**
R: No directamente. Deberías detener el contenedor, hacer cambios, reconstruir la imagen y reiniciar.

**P: ¿Cómo depuro errores en los nodos?**
R: En los logs de Docker verás errores de n8n y de los nodos. Usa `docker logs -f n8n-llama-custom` para verlos en tiempo real.

**P: ¿Puedo guardar datos/flujos dentro del contenedor?**
R: Sí, pero se perderán al detener el contenedor. Para persistencia, necesitarías usar volúmenes Docker. Lee la documentación de n8n para más detalles.

**P: ¿El Dockerfile es el mismo que usará Render?**
R: Sí, Render usará el mismo Dockerfile para construir la imagen en su infraestructura.

---

Para más información, consulta:
- Documentación de Docker: https://docs.docker.com/
- Documentación de n8n: https://docs.n8n.io/
- Documentación de Render: https://render.com/docs

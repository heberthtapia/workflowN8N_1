# Comandos Docker manuales (si los scripts fallan)

## Problema resuelto: BuildKit EOF Error

Si ves:
```
WARNING: No output specified with docker-container driver...
ERROR: failed to build: EOF
```

Usa los comandos con `--load`:

## ✅ Paso 1: Verificar Docker

```batch
docker --version
```

Debe mostrar: `Docker version X.XX.X, build XXXXX`

## ✅ Paso 2: Construir la imagen (con --load)

```batch
docker buildx build -t n8n-llama-custom --load .
```

**Si falla**, intenta sin BuildKit:

```batch
set DOCKER_BUILDKIT=0
docker build -t n8n-llama-custom .
```

## ✅ Paso 3: Ejecutar el contenedor

```batch
docker run -d --name n8n-llama-custom -p 5678:5678 n8n-llama-custom
```

## ✅ Paso 4: Ver logs

```batch
docker logs -f n8n-llama-custom
```

Presiona `Ctrl + C` cuando veas "n8n ready on..." o "Server started"

## ✅ Paso 5: Acceder a n8n

Abre en tu navegador:
```
http://localhost:5678
```

## ✅ Paso 6: Parar cuando termines

```batch
docker stop n8n-llama-custom
```

## 🔍 Verificación

Verifica que la imagen se creó:
```batch
docker images | find "n8n-llama-custom"
```

Verifica que el contenedor corre:
```batch
docker ps | find "n8n-llama-custom"
```

---

## 📋 Todos los comandos juntos (cópialo y pégalo)

```batch
REM Verificar Docker
docker --version

REM Construir imagen
docker buildx build -t n8n-llama-custom --load .

REM Si falla, usa esto:
set DOCKER_BUILDKIT=0
docker build -t n8n-llama-custom .

REM Ejecutar contenedor
docker stop n8n-llama-custom >nul 2>&1
docker rm n8n-llama-custom >nul 2>&1
docker run -d --name n8n-llama-custom -p 5678:5678 n8n-llama-custom

REM Ver logs (presiona Ctrl+C para parar)
docker logs -f n8n-llama-custom

REM Cuando termines:
docker stop n8n-llama-custom
```

---

## 🆘 Si sigue fallando

1. **Verifica que Docker está corriendo**: Busca el ícono de Docker en la bandeja del sistema
2. **Libera espacio**: Necesitas al menos 2GB libres
3. **Reinicia Docker Desktop**: Ciérralo completamente y abre de nuevo
4. **Lee**: `DOCKER_BUILDKIT_FIX.md` para más soluciones

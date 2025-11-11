# SOLUCIÓN RÁPIDA: Error "EOF" en Docker BuildKit

## 🎯 El Problema

```
ERROR: failed to build: EOF
WARNING: No output specified with docker-container driver...
```

## ✅ LA SOLUCIÓN (copia y pega esto)

### Para Windows PowerShell:

```powershell
docker buildx build -t n8n-llama-custom --load .
```

### Para Windows CMD/Batch:

```batch
docker buildx build -t n8n-llama-custom --load .
```

### Si el anterior falla, usa esto:

```batch
set DOCKER_BUILDKIT=0
docker build -t n8n-llama-custom .
```

---

## 🚀 Completo (copia y pega todo)

```batch
REM Construir
docker buildx build -t n8n-llama-custom --load .

REM Limpiar anteriores
docker stop n8n-llama-custom >nul 2>&1
docker rm n8n-llama-custom >nul 2>&1

REM Ejecutar
docker run -d --name n8n-llama-custom -p 5678:5678 n8n-llama-custom

REM Ver logs
docker logs -f n8n-llama-custom
```

---

## 📁 Scripts disponibles

| Archivo | Descripción |
|---------|-------------|
| `docker-local-test-fixed.bat` | ✅ Script batch corregido (RECOMENDADO) |
| `DOCKER_BUILDKIT_FIX.md` | Detalles técnicos del problema |
| `DOCKER_MANUAL_COMMANDS_FIXED.md` | Comandos paso a paso |

---

## 🎬 Acceso rápido

Una vez que veas "n8n ready on...", abre:
```
http://localhost:5678
```

---

**Lee `DOCKER_BUILDKIT_FIX.md` para detalles completos y más soluciones.**

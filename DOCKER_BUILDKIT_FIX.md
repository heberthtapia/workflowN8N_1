# Solución: Error de Docker BuildKit "EOF" / "failed to build"

## Problema

```
WARNING: No output specified with docker-container driver. Build result will only 
remain in the build cache. To push result image into registry use --push or to load 
image into docker use --load
ERROR: failed to build: EOF
X Error durante la construcción de la imagen.
```

## Causa

Docker está usando el driver **BuildKit** (`docker-container`) que requiere:
- `--load` para cargar la imagen en Docker (para pruebas locales)
- `--push` para enviar a un registro (para Render)

## Soluciones

### ✅ Solución 1: Usar `--load` en el comando build (RECOMENDADO)

**Edita el script o ejecuta manualmente:**

```bash
docker buildx build -t n8n-llama-custom --load .
```

O sin BuildKit (compatible):

```bash
DOCKER_BUILDKIT=0 docker build -t n8n-llama-custom .
```

---

### ✅ Solución 2: Deshabilitar BuildKit globalmente

**Opción A: En PowerShell/cmd (sesión actual)**

```bash
$env:DOCKER_BUILDKIT=0
docker build -t n8n-llama-custom .
```

**Opción B: Permanentemente (requiere reiniciar Docker)**

En Docker Desktop:
1. Settings (engranaje)
2. Docker Engine
3. Cambia esto:
```json
{
  "features": {
    "buildkit": false
  }
}
```
4. Aplica y reinicia Docker

---

### ✅ Solución 3: Usar docker buildx (BuildKit moderno)

```bash
docker buildx build -t n8n-llama-custom --load .
docker run -d --name n8n-llama-custom -p 5678:5678 n8n-llama-custom
```

---

## ¿Cuál solución elegir?

| Solución | Facilidad | Recomendado |
|----------|-----------|-------------|
| `--load` con buildx | ⭐ Fácil | ✅ SÍ |
| DOCKER_BUILDKIT=0 | ⭐ Fácil | ✅ SÍ |
| Desactivar BuildKit | ⭐⭐ Medio | ⭐ Opcional |

**Recomendación**: Usa **Solución 1** (`--load`)

---

## Comandos rápidos para copiar/pegar

### Con BuildKit (recomendado):
```bash
docker buildx build -t n8n-llama-custom --load .
docker run -d --name n8n-llama-custom -p 5678:5678 n8n-llama-custom
docker logs -f n8n-llama-custom
```

### Sin BuildKit:
```bash
set DOCKER_BUILDKIT=0
docker build -t n8n-llama-custom .
docker run -d --name n8n-llama-custom -p 5678:5678 n8n-llama-custom
docker logs -f n8n-llama-custom
```

---

## Verificación

Una vez que la imagen se construya exitosamente:

```bash
# Verificar que la imagen existe
docker images | grep n8n-llama-custom

# Ver logs
docker logs -f n8n-llama-custom

# Acceder a n8n
# Abre en navegador: http://localhost:5678
```


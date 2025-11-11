# ⚡ SOLUCIÓN RÁPIDA: El script no se ejecuta

## 🎯 Problema
```
✗ "cannot be loaded because running scripts is disabled on this system"
```

## ✅ SOLUCIÓN MÁS RÁPIDA (sin complicaciones)

**Usa el script `.bat` en lugar del `.ps1`:**

```batch
docker-local-test.bat
```

**O haz doble clic en el archivo desde Windows Explorer**

---

## 🔧 Alternativas (si lo anterior no funciona)

### Alternativa 1: PowerShell Bypass
```powershell
powershell -ExecutionPolicy Bypass -File .\docker-local-test.ps1
```

### Alternativa 2: Comandos manuales
```batch
docker build -t n8n-llama-custom .
docker run -d --name n8n-llama-custom -p 5678:5678 n8n-llama-custom
docker logs -f n8n-llama-custom
```

---

## 📁 Archivos disponibles

| Archivo | Tipo | Funciona sin restricciones |
|---------|------|---------------------------|
| `docker-local-test.bat` | Batch | ✅ **SÍ** - RECOMENDADO |
| `docker-local-test.ps1` | PowerShell | ❌ Requiere bypass o permisos |
| `QUICK_DOCKER_COMMANDS.md` | Instrucciones | ✅ Usa si los scripts fallan |

---

## 🚀 Empieza aquí

1. **Opción recomendada**: Haz doble clic en `docker-local-test.bat`
2. **Opción alternativa**: Lee `DOCKER_TROUBLESHOOTING.md` para 4 soluciones
3. **Comandos manuales**: Copia los comandos de `QUICK_DOCKER_COMMANDS.md`

---

## 🌐 Después de ejecutar

Una vez que Docker inicie n8n, abre tu navegador:

**http://localhost:5678**

Deberías ver la interfaz de n8n.

---

**Lee `DOCKER_TROUBLESHOOTING.md` para más ayuda y solución de problemas.**

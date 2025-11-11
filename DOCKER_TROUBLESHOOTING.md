# Solución de problemas: Ejecutar scripts de Docker localmente

## Problema

El script `docker-local-test.ps1` no se ejecuta con el error:
```
"cannot be loaded because running scripts is disabled on this system"
```

Esto ocurre porque PowerShell tiene una política de ejecución que bloquea scripts.

## Soluciones (elige una)

### Solución 1: Usar el script Batch (RECOMENDADO - más fácil)

**Archivo**: `docker-local-test.bat`

**Uso**:
```batch
docker-local-test.bat
```

O haz doble clic en el archivo desde el Explorador de Windows.

**Ventajas**:
- ✓ Funciona sin configuración adicional
- ✓ Compatible con cmd.exe (Símbolo del sistema)
- ✓ No requiere cambiar permisos
- ✓ Funciona en Windows 7, 8, 10, 11

---

### Solución 2: PowerShell con Bypass (Si prefieres PowerShell)

Abre PowerShell y ejecuta:

```powershell
powershell -ExecutionPolicy Bypass -File .\docker-local-test.ps1
```

O en una línea:

```powershell
powershell -ExecutionPolicy Bypass -NoProfile -File .\docker-local-test.ps1
```

**Ventajas**:
- ✓ Funciona con el script PowerShell
- ✓ No cambia la política de ejecución permanentemente

---

### Solución 3: Cambiar la política de ejecución (Permanente)

Si quieres cambiar la política de ejecución de forma permanente:

**Abre PowerShell como Administrador** (clic derecho → "Run as administrator") y ejecuta:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

Luego ya puedes ejecutar:

```powershell
.\docker-local-test.ps1
```

**Advertencia**: Esto permite que cualquier script se ejecute. Usa con cuidado.

**Para revertir** (volver a RestrictedSigned):

```powershell
Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope CurrentUser -Force
```

---

### Solución 4: Copiar y pegar comandos manualmente

Si ninguna de las anteriores funciona, copia estos comandos uno a uno en PowerShell/cmd:

```batch
REM Paso 1: Verificar Docker
docker --version

REM Paso 2: Construir la imagen (toma 5-15 minutos)
docker build -t n8n-llama-custom .

REM Paso 3: Ejecutar el contenedor
docker run -d --name n8n-llama-custom -p 5678:5678 n8n-llama-custom

REM Paso 4: Ver logs
docker logs -f n8n-llama-custom

REM Paso 5: Acceder a n8n
REM Abre el navegador en: http://localhost:5678

REM Paso 6: Parar el contenedor (cuando termines)
docker stop n8n-llama-custom
```

---

## ¿Cuál solución es mejor?

| Solución | Facilidad | Seguridad | Recomendado |
|----------|-----------|-----------|-------------|
| Script Batch (.bat) | ⭐⭐⭐ Muy fácil | ⭐⭐⭐ Seguro | ✅ SÍ |
| PowerShell Bypass | ⭐⭐ Fácil | ⭐⭐ Adecuado | ✅ SÍ |
| Cambiar política | ⭐ Difícil | ⭐ Riesgo | ❌ NO |
| Comandos manuales | ⭐⭐ Fácil | ⭐⭐⭐ Seguro | ✅ SÍ |

**Recomendación**: Usa **Solución 1** (script Batch) — es la más fácil y segura.

---

## Pasos rápidos para empezar

### Opción A: Usar el script Batch (RECOMENDADO)

1. Abre el Explorador de Windows
2. Navega a: `D:\Ampps\www\workflowN8N_1`
3. Haz doble clic en: `docker-local-test.bat`
4. Espera a que termine (5-15 minutos)
5. Abre en el navegador: http://localhost:5678

### Opción B: Usar PowerShell con Bypass

1. Abre PowerShell
2. Navega a la carpeta: `cd D:\Ampps\www\workflowN8N_1`
3. Ejecuta: `powershell -ExecutionPolicy Bypass -File .\docker-local-test.ps1`
4. Espera a que termine
5. Abre en el navegador: http://localhost:5678

### Opción C: Comandos manuales

1. Abre cmd.exe o PowerShell
2. Navega a: `cd D:\Ampps\www\workflowN8N_1`
3. Copia y pega los comandos del archivo `QUICK_DOCKER_COMMANDS.md`

---

## Verificación posterior

Una vez que Docker esté corriendo, verifica que todo funciona:

1. **Accede a n8n**: http://localhost:5678
2. **Busca los nodos**:
   - Haz clic en el ícono de búsqueda 🔍
   - Escribe: "LlamaParse"
   - Debería encontrarse el nodo
3. **Verifica las credenciales**:
   - Settings (engranaje) → Credentials
   - Busca "LlamaCloud API Key"
   - Debería estar disponible

---

## Solución de problemas adicionales

### Docker no se encuentra (comando not found)

- **Causa**: Docker Desktop no está instalado
- **Solución**: 
  1. Descarga Docker Desktop: https://www.docker.com/products/docker-desktop
  2. Instala y reinicia Windows
  3. Abre el menú de inicio y busca "Docker Desktop"
  4. Ejecuta la aplicación (tardará unos minutos en iniciar)
  5. Verifica: abre PowerShell y ejecuta `docker --version`

### Puerto 5678 ya está en uso

- **Causa**: Otro contenedor o aplicación está usando el puerto
- **Solución**:
  ```batch
  docker stop n8n-llama-custom
  docker rm n8n-llama-custom
  ```
  - O usa un puerto diferente:
  ```batch
  docker run -d --name n8n-custom -p 5679:5678 n8n-llama-custom
  ```
  - Accede a: http://localhost:5679

### Build falla con errores de TypeScript

- **Causa**: El código TypeScript tiene errores de compilación
- **Solución**:
  1. En PowerShell, navega a la carpeta
  2. Ejecuta: `npm.cmd install && npm.cmd run build`
  3. Revisa los errores reportados
  4. Arréglalo y reinicia Docker

### n8n tarda mucho en iniciar

- **Causa**: Es normal la primera vez, Docker está descargando la imagen
- **Solución**: Espera (puede tomar 5-10 minutos)

---

## Contacto y soporte

Si ninguna solución funciona:
1. Verifica que Docker Desktop está corriendo (busca en la bandeja del sistema)
2. Lee el archivo `DOCKER_TEST_GUIDE.md` para más detalles
3. Revisa los logs de Docker: `docker logs -f n8n-llama-custom`


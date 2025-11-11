# Script de asistencia para despliegue en Render.com
# Este script proporciona instrucciones paso a paso para desplegar el proyecto en Render
# Uso: .\render-deploy-guide.ps1

Write-Host "========================================" -ForegroundColor Green
Write-Host "Guía de Despliegue en Render.com" -ForegroundColor Green
Write-Host "LlamaCloud Integration para n8n" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Verificación previa
Write-Host "[PRE-CHECK] Verificando que el repo está listo..." -ForegroundColor Cyan
Write-Host ""

$checks = @(
    @{ name = "Dockerfile"; path = "./Dockerfile" },
    @{ name = "package.json"; path = "./package.json" },
    @{ name = "package-lock.json"; path = "./package-lock.json" },
    @{ name = ".render.yaml"; path = "./.render.yaml" },
    @{ name = "index.ts"; path = "./index.ts" },
    @{ name = "dist/ (compilado)"; path = "./dist" }
)

$allChecked = $true
foreach ($check in $checks) {
    if (Test-Path $check.path) {
        Write-Host "  ✓ $($check.name)" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $($check.name) NO ENCONTRADO" -ForegroundColor Yellow
        $allChecked = $false
    }
}

Write-Host ""

if (-not $allChecked) {
    Write-Host "⚠ Faltan algunos archivos. Ejecuta primero:" -ForegroundColor Yellow
    Write-Host "  npm.cmd install" -ForegroundColor Gray
    Write-Host "  npm.cmd run build" -ForegroundColor Gray
    Write-Host ""
}

# Instrucciones principales
Write-Host "========================================" -ForegroundColor Green
Write-Host "Pasos para desplegar en Render.com" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "[PASO 1] Preparar el repositorio" -ForegroundColor Cyan
Write-Host "-" * 40
Write-Host ""
Write-Host "1a. Asegúrate de que has hecho push de todos los cambios a GitHub:" -ForegroundColor White
Write-Host "    git add ." -ForegroundColor DarkGray
Write-Host "    git commit -m 'Ready for Render deployment: multi-stage Docker, optimized build'" -ForegroundColor DarkGray
Write-Host "    git push origin main" -ForegroundColor DarkGray
Write-Host ""
Write-Host "1b. Verifica que el repositorio es accesible desde GitHub:" -ForegroundColor White
Write-Host "    Abre: https://github.com/heberthtapia/workflowN8N_1" -ForegroundColor DarkGray
Write-Host ""

Write-Host "[PASO 2] Crear servicio en Render.com" -ForegroundColor Cyan
Write-Host "-" * 40
Write-Host ""
Write-Host "2a. Ve a: https://dashboard.render.com/" -ForegroundColor White
Write-Host "2b. Inicia sesión (crea cuenta si no tienes)" -ForegroundColor White
Write-Host "2c. Haz clic en: '+' → 'New' → 'Web Service'" -ForegroundColor White
Write-Host "2d. Selecciona: 'Connect a repository'" -ForegroundColor White
Write-Host "2e. Busca y selecciona: 'workflowN8N_1'" -ForegroundColor White
Write-Host ""

Write-Host "[PASO 3] Configurar el servicio" -ForegroundColor Cyan
Write-Host "-" * 40
Write-Host ""
Write-Host "Rellena los campos de la forma:" -ForegroundColor White
Write-Host ""
Write-Host "  Name: n8n-llamacloud (o el nombre que prefieras)" -ForegroundColor DarkGray
Write-Host "  Branch: main" -ForegroundColor DarkGray
Write-Host "  Environment: Docker" -ForegroundColor DarkGray
Write-Host "  Dockerfile Path: ./Dockerfile (debería estar pre-rellenado)" -ForegroundColor DarkGray
Write-Host "  Region: Choose closest to your location" -ForegroundColor DarkGray
Write-Host "  Instance Type: Starter (recomendado para pruebas)" -ForegroundColor DarkGray
Write-Host ""

Write-Host "[PASO 4] Configurar variables de entorno" -ForegroundColor Cyan
Write-Host "-" * 40
Write-Host ""
Write-Host "En la sección 'Environment' de Render, añade estas variables:" -ForegroundColor White
Write-Host ""
Write-Host "  NODE_ENV                  = production" -ForegroundColor DarkGray
Write-Host "  N8N_PROTOCOL              = https" -ForegroundColor DarkGray
Write-Host "  N8N_HOST                  = [tu-dominio-render].onrender.com" -ForegroundColor DarkGray
Write-Host "  N8N_PORT                  = 5678" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Nota: N8N_HOST se generará automáticamente como 'n8n-llamacloud.onrender.com'" -ForegroundColor Yellow
Write-Host "      (reemplaza 'n8n-llamacloud' con tu nombre de servicio si es diferente)" -ForegroundColor Yellow
Write-Host ""

Write-Host "[PASO 5] Configurar secretos" -ForegroundColor Cyan
Write-Host "-" * 40
Write-Host ""
Write-Host "Aunque este paquete NO requiere variables de secreto en Render," -ForegroundColor White
Write-Host "las credenciales de LlamaCloud se crean en la UI de n8n, puedes:" -ForegroundColor White
Write-Host ""
Write-Host "Opción A (recomendada): Sin variables extra (las credenciales van en la UI de n8n)" -ForegroundColor DarkGray
Write-Host "  → No añadas variables secretas" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Opción B: Si quieres automatizar credenciales" -ForegroundColor DarkGray
Write-Host "  → Añade una variable: LLAMACLOUD_API_KEY = [tu-api-key]" -ForegroundColor DarkGray
Write-Host "  → Luego configura n8n para leerla (avanzado, requiere custom env handling)" -ForegroundColor DarkGray
Write-Host ""

Write-Host "[PASO 6] Deploy" -ForegroundColor Cyan
Write-Host "-" * 40
Write-Host ""
Write-Host "1. Haz clic en 'Create Web Service'" -ForegroundColor White
Write-Host "2. Render construirá la imagen Docker (5-15 minutos)" -ForegroundColor White
Write-Host "3. Verifica los logs en la sección 'Events' o 'Logs'" -ForegroundColor White
Write-Host ""

Write-Host "[PASO 7] Verificar el despliegue" -ForegroundColor Cyan
Write-Host "-" * 40
Write-Host ""
Write-Host "1. Una vez que el status sea 'Live', abre la URL en tu navegador:" -ForegroundColor White
Write-Host "   https://n8n-llamacloud.onrender.com (o tu nombre de servicio)" -ForegroundColor DarkGray
Write-Host ""
Write-Host "2. Verifica que n8n carga correctamente:" -ForegroundColor White
Write-Host "   - Deberías ver la pantalla de login/bienvenida de n8n" -ForegroundColor DarkGray
Write-Host ""
Write-Host "3. Busca los nodos personalizados:" -ForegroundColor White
Write-Host "   - En la UI, busca 'LlamaParse', 'LlamaExtract', 'LlamaCloud'" -ForegroundColor DarkGray
Write-Host "   - Verifica que 'LlamaCloud API Key' aparece en credenciales" -ForegroundColor DarkGray
Write-Host ""

Write-Host "[PASO 8] Crear credenciales" -ForegroundColor Cyan
Write-Host "-" * 40
Write-Host ""
Write-Host "1. En n8n, ve a Settings → Credentials (esquina inferior izquierda)" -ForegroundColor White
Write-Host "2. Haz clic en 'New' → busca 'LlamaCloud API Key'" -ForegroundColor White
Write-Host "3. Rellena tu LlamaCloud API Key" -ForegroundColor White
Write-Host "4. Guarda la credencial" -ForegroundColor White
Write-Host ""
Write-Host "Para obtener tu API key:" -ForegroundColor Yellow
Write-Host "  → Ve a https://cloud.llamaindex.ai/" -ForegroundColor DarkGray
Write-Host "  → Inicia sesión" -ForegroundColor DarkGray
Write-Host "  → Ve a Settings → API Keys" -ForegroundColor DarkGray
Write-Host ""

Write-Host "========================================" -ForegroundColor Green
Write-Host "✓ Despliegue completado" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Próximos pasos:" -ForegroundColor Cyan
Write-Host "1. Crea flujos en n8n usando los nodos personalizados" -ForegroundColor White
Write-Host "2. Prueba que los nodos funcionan correctamente" -ForegroundColor White
Write-Host "3. Configura alertas o monitoreo en Render si es necesario" -ForegroundColor White
Write-Host ""

Write-Host "Solución de problemas:" -ForegroundColor Cyan
Write-Host "- Si el build falla, revisa los logs en Render → Logs" -ForegroundColor White
Write-Host "- Si n8n no carga, verifica que el puerto 5678 está correcto" -ForegroundColor White
Write-Host "- Si los nodos no aparecen, recarga el navegador (Ctrl+F5)" -ForegroundColor White
Write-Host "- Lee RENDER_DEPLOY_TROUBLESHOOTING.md para más ayuda" -ForegroundColor White
Write-Host ""

Write-Host "Documentación útil:" -ForegroundColor Cyan
Write-Host "- Render docs: https://render.com/docs" -ForegroundColor DarkGray
Write-Host "- n8n docs: https://docs.n8n.io/" -ForegroundColor DarkGray
Write-Host "- LlamaIndex docs: https://docs.llamaindex.ai/" -ForegroundColor DarkGray
Write-Host ""

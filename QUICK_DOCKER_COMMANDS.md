# Alternativa: Ejecuta los comandos Docker manualmente en PowerShell
# Si el script .ps1 no se ejecuta, copia y pega estos comandos uno a uno

Write-Host "========================================" -ForegroundColor Green
Write-Host "Docker Local Test - Comandos Manuales" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Paso 1: Verificar Docker" -ForegroundColor Cyan
Write-Host "Ejecuta esto:" -ForegroundColor White
Write-Host "  docker --version" -ForegroundColor DarkGray
Write-Host ""

Write-Host "Paso 2: Construir la imagen (toma 5-15 minutos)" -ForegroundColor Cyan
Write-Host "Ejecuta esto:" -ForegroundColor White
Write-Host "  docker build -t n8n-llama-custom ." -ForegroundColor DarkGray
Write-Host ""

Write-Host "Paso 3: Ejecutar el contenedor" -ForegroundColor Cyan
Write-Host "Ejecuta esto:" -ForegroundColor White
Write-Host "  docker run -d --name n8n-llama-custom -p 5678:5678 n8n-llama-custom" -ForegroundColor DarkGray
Write-Host ""

Write-Host "Paso 4: Ver logs" -ForegroundColor Cyan
Write-Host "Ejecuta esto:" -ForegroundColor White
Write-Host "  docker logs -f n8n-llama-custom" -ForegroundColor DarkGray
Write-Host ""

Write-Host "Paso 5: Acceder a n8n" -ForegroundColor Cyan
Write-Host "Abre tu navegador en:" -ForegroundColor White
Write-Host "  http://localhost:5678" -ForegroundColor DarkGray
Write-Host ""

Write-Host "Paso 6: Parar el contenedor" -ForegroundColor Cyan
Write-Host "Ejecuta esto:" -ForegroundColor White
Write-Host "  docker stop n8n-llama-custom" -ForegroundColor DarkGray
Write-Host ""

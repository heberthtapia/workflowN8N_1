# Script PowerShell para construir y ejecutar la imagen Docker localmente
# Uso: powershell -ExecutionPolicy Bypass -File ./docker-local-test.ps1
# O:   powershell -Command "& { . ./docker-local-test.ps1 }"
# Requisito: Docker Desktop debe estar instalado y corriendo en Windows

Write-Host "========================================" -ForegroundColor Green
Write-Host "Docker Local Test - n8n LlamaCloud" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Paso 1: Verificar que Docker está disponible
Write-Host "[1/4] Verificando que Docker está disponible..." -ForegroundColor Cyan
try {
    $dockerVersion = & docker --version 2>$null
    if ($dockerVersion) {
        Write-Host "✓ Docker detectado: $dockerVersion" -ForegroundColor Green
    } else {
        throw "Docker no encontrado"
    }
} catch {
    Write-Host "✗ Error: Docker no está instalado o no está en el PATH." -ForegroundColor Red
    Write-Host "Por favor, instala Docker Desktop desde: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "O ejecuta manualmente estos comandos:" -ForegroundColor Yellow
    Write-Host "  docker build -t n8n-llama-custom ." -ForegroundColor Gray
    Write-Host "  docker run -d --name n8n-llama-custom -p 5678:5678 n8n-llama-custom" -ForegroundColor Gray
    exit 1
}

Write-Host ""

# Paso 2: Construir la imagen
Write-Host "[2/4] Construyendo la imagen Docker (esto puede tomar 2-5 minutos)..." -ForegroundColor Cyan
Write-Host "Ejecutando: docker build -t n8n-llama-custom ." -ForegroundColor DarkGray
set DOCKER_BUILDKIT=0
& docker build -t n8n-llama-custom .

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Error durante la construcción de la imagen." -ForegroundColor Red
    exit 1
}

Write-Host "✓ Imagen construida exitosamente." -ForegroundColor Green
Write-Host ""

# Paso 3: Ejecutar el contenedor
Write-Host "[3/4] Iniciando el contenedor (mapeando puerto 5678 → 5678)..." -ForegroundColor Cyan
Write-Host "Ejecutando: docker run -d --name n8n-llama-custom -p 5678:5678 n8n-llama-custom" -ForegroundColor DarkGray

# Detener y eliminar el contenedor si ya existe
& docker stop n8n-llama-custom -ErrorAction SilentlyContinue 2>$null | Out-Null
& docker rm n8n-llama-custom -ErrorAction SilentlyContinue 2>$null | Out-Null

& docker run -d --name n8n-llama-custom -p 5678:5678 n8n-llama-custom

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Error al iniciar el contenedor." -ForegroundColor Red
    exit 1
}

Write-Host "✓ Contenedor iniciado (corriendo en segundo plano)." -ForegroundColor Green
Write-Host ""

# Paso 4: Mostrar logs y esperar a que n8n esté listo
Write-Host "[4/4] Esperando a que n8n inicie... (hasta 30 segundos)" -ForegroundColor Cyan
Write-Host ""

$maxRetries = 30
$retryCount = 0
$n8nReady = $false

while ($retryCount -lt $maxRetries -and -not $n8nReady) {
    Start-Sleep -Seconds 1
    $logs = & docker logs n8n-llama-custom 2>&1

    if ($logs -match "n8n ready on" -or $logs -match "Server started") {
        $n8nReady = $true
        Write-Host "✓ n8n está listo." -ForegroundColor Green
    }

    $retryCount++
    if ($retryCount % 5 -eq 0) {
        Write-Host "  Esperando... ($retryCount/30s)" -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✓ Setup completado exitosamente" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "📋 Información útil:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  → n8n está corriendo en: http://localhost:5678" -ForegroundColor White
Write-Host "  → Para ver logs en tiempo real:" -ForegroundColor White
Write-Host "    docker logs -f n8n-llama-custom" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  → Para detener el contenedor:" -ForegroundColor White
Write-Host "    docker stop n8n-llama-custom" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  → Para eliminar el contenedor:" -ForegroundColor White
Write-Host "    docker rm n8n-llama-custom" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  → Para eliminar la imagen:" -ForegroundColor White
Write-Host "    docker rmi n8n-llama-custom" -ForegroundColor DarkGray
Write-Host ""

Write-Host "Últimas líneas del log:" -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Gray
& docker logs -n 30 n8n-llama-custom
Write-Host "----------------------------------------" -ForegroundColor Gray
Write-Host ""

Write-Host "Ahora puedes:" -ForegroundColor Green
Write-Host "1. Abre el navegador en http://localhost:5678" -ForegroundColor White
Write-Host "2. Verifica que los nodos personalizados aparecen en la UI" -ForegroundColor White
Write-Host "3. Busca 'LlamaParse', 'LlamaExtract', 'LlamaCloud' en la paleta de nodos" -ForegroundColor White
Write-Host "4. Verifica que la credencial 'LlamaCloud API Key' está disponible" -ForegroundColor White
Write-Host ""

Write-Host "Para parar el contenedor cuando termines, ejecuta:" -ForegroundColor Yellow
Write-Host "docker stop n8n-llama-custom" -ForegroundColor Gray
Write-Host ""

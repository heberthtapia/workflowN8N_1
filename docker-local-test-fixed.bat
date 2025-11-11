@echo off
REM Script Batch mejorado para ejecutar Docker con soporte para BuildKit
REM Uso: docker-local-test-fixed.bat

setlocal enabledelayedexpansion

echo ========================================
echo Docker Local Test - n8n LlamaCloud (v2 - Corregido BuildKit)
echo ========================================
echo.

echo [1/4] Verificando que Docker está disponible...
docker --version >nul 2>&1
if errorlevel 1 (
    echo X Error: Docker no está instalado o no está en el PATH.
    echo Por favor, instala Docker Desktop desde:
    echo https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)
for /f "tokens=*" %%i in ('docker --version') do set DOCKER_VERSION=%%i
echo OK Docker detectado: %DOCKER_VERSION%
echo.

echo [2/4] Construyendo la imagen Docker (esto puede tomar 5-15 minutos)...
echo.

REM Intenta primero con buildx y --load
echo Intentando: docker buildx build -t n8n-llama-custom --load .
docker buildx build -t n8n-llama-custom --load . >nul 2>&1
if errorlevel 1 (
    echo (BuildKit falló, intentando sin BuildKit)
    echo.
    echo Intentando: DOCKER_BUILDKIT=0 docker build -t n8n-llama-custom .
    set DOCKER_BUILDKIT=0
    docker build -t n8n-llama-custom .
    if errorlevel 1 (
        echo.
        echo X Error durante la construcción de la imagen.
        echo.
        echo Posibles causas:
        echo - Docker Desktop no está corriendo (busca el ícono en la bandeja del sistema)
        echo - Falta espacio en disco (necesita al menos 2GB)
        echo - Problema con BuildKit
        echo.
        echo Soluciones:
        echo 1. Reinicia Docker Desktop
        echo 2. Libera espacio en disco
        echo 3. Lee DOCKER_BUILDKIT_FIX.md para más opciones
        pause
        exit /b 1
    )
)

echo OK Imagen construida exitosamente.
echo.

echo [3/4] Iniciando el contenedor (mapeando puerto 5678)...
docker stop n8n-llama-custom >nul 2>&1
docker rm n8n-llama-custom >nul 2>&1
docker run -d --name n8n-llama-custom -p 5678:5678 n8n-llama-custom
if errorlevel 1 (
    echo X Error al iniciar el contenedor.
    pause
    exit /b 1
)
echo OK Contenedor iniciado (corriendo en segundo plano).
echo.

echo [4/4] Esperando a que n8n inicie... (hasta 30 segundos)
echo.
set /a count=0
:wait_loop
if %count% gtr 30 (
    goto show_logs
)
docker logs n8n-llama-custom 2>nul | findstr /i "n8n ready on" >nul
if not errorlevel 1 (
    echo OK n8n está listo.
    goto show_logs
)
docker logs n8n-llama-custom 2>nul | findstr /i "Server started" >nul
if not errorlevel 1 (
    echo OK n8n está listo.
    goto show_logs
)
timeout /t 1 /nobreak >nul
set /a count=%count%+1
if %count% geq 5 (
    if %count% leq 25 (
        echo   Esperando... (%count%/30s)
    )
)
goto wait_loop

:show_logs
echo.
echo ========================================
echo OK Setup completado exitosamente
echo ========================================
echo.

echo Información útil:
echo.
echo   OK n8n está corriendo en: http://localhost:5678
echo   OK Para ver logs en tiempo real:
echo      docker logs -f n8n-llama-custom
echo.
echo   OK Para detener el contenedor:
echo      docker stop n8n-llama-custom
echo.
echo   OK Para eliminar el contenedor:
echo      docker rm n8n-llama-custom
echo.

echo Últimas líneas del log:
echo ----------------------------------------
docker logs -n 30 n8n-llama-custom
echo ----------------------------------------
echo.

echo Ahora puedes:
echo 1. Abre el navegador en http://localhost:5678
echo 2. Verifica que los nodos personalizados aparecen
echo 3. Busca 'LlamaParse', 'LlamaExtract', 'LlamaCloud'
echo 4. Verifica que 'LlamaCloud API Key' está disponible
echo.

echo Para parar cuando termines:
echo   docker stop n8n-llama-custom
echo.

pause

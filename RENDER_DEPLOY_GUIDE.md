# Guía de Deploy en Render.com - Detalles y Solución de Problemas

Este documento proporciona información detallada sobre cómo desplegar el proyecto en Render.com, configurar credenciales y resolver problemas comunes.

## Visión General

Este proyecto es un paquete de nodos personalizados para n8n que integra LlamaCloud. En Render, desplegaremos:

- Una imagen Docker que contiene n8n + nodos personalizados
- Los nodos se instalan en `/home/node/.n8n/custom`
- Las credenciales se gestionan en la UI de n8n

## Requisitos previos

- Cuenta de GitHub con acceso a `heberthtapia/workflowN8N_1`
- Cuenta de Render (https://render.com - gratis)
- Cuenta de LlamaCloud (https://cloud.llamaindex.ai - para obtener API key)

## Pasos detallados

### 1. Preparar GitHub

```bash
git add .
git commit -m "Prepare for Render deployment"
git push origin main
```

Verifica que el código está en GitHub: https://github.com/heberthtapia/workflowN8N_1

### 2. Crear un Web Service en Render

1. Ve a https://dashboard.render.com
2. Inicia sesión o crea una cuenta
3. Haz clic en: **New** → **Web Service**
4. Selecciona **Connect a repository** → busca `workflowN8N_1`
5. Autoriza a Render acceder a tu GitHub si te lo pide

### 3. Configurar el Web Service

**Configuración básica:**

| Campo | Valor |
|-------|-------|
| Name | `n8n-llamacloud` |
| Environment | Docker |
| Dockerfile Path | `./Dockerfile` |
| Branch | `main` |
| Region | Elige la más cercana a ti (p.ej. Frankfurt, USA) |
| Instance Type | Starter ($7/mes) |

**Opciones avanzadas:**

- Auto-deploy on push: **ON** (opcional - para auto-desplegar al hacer push)
- Auto-pull commits: **ON** (recomendado)

### 4. Variables de entorno

En la sección **Environment**, añade:

```
NODE_ENV=production
N8N_PROTOCOL=https
N8N_HOST=n8n-llamacloud.onrender.com
N8N_PORT=5678
```

Nota: reemplaza `n8n-llamacloud` con el nombre del servicio que especificaste.

### 5. Secretos (si los necesitas)

Para este proyecto, **no es necesario** añadir secretos de API key en Render. Las credenciales se crean en la UI de n8n.

Sin embargo, si quieres automatizar:

```
LLAMACLOUD_API_KEY=[tu-api-key]
```

Luego en n8n, puedes leerlo desde un ambiente variable (avanzado).

### 6. Crear el servicio

Haz clic en **Create Web Service**. Render hará:

1. **Build**: Descarga el código, construye la imagen Docker (5-15 min)
2. **Deploy**: Inicia el contenedor
3. **Live**: El servicio está disponible en `https://n8n-llamacloud.onrender.com`

Monitorea el progreso en la sección **Events** o **Logs**.

### 7. Verificar que todo funciona

#### Paso A: Accede a n8n

Abre en tu navegador: `https://n8n-llamacloud.onrender.com`

Deberías ver:
- Una página de bienvenida o login de n8n
- La interfaz lista para crear flujos

#### Paso B: Verifica los nodos

1. En la UI de n8n, busca nodos (ícono de búsqueda 🔍)
2. Escribe: "LlamaParse" → debería encontrarse
3. Escribe: "LlamaExtract" → debería encontrarse
4. Escribe: "LlamaCloud" → debería encontrarse

Si no aparecen:
- Recarga la página (Ctrl+F5)
- Revisa los logs en Render → Logs → busca errores

#### Paso C: Crear una credencial

1. Ve a Settings (ícono de engranaje en la esquina inferior izquierda)
2. Haz clic en **Credentials**
3. Nuevo → busca "LlamaCloud API Key"
4. Rellena tu API key (obtén una en https://cloud.llamaindex.ai → Settings → API Keys)
5. Guarda

### 8. Crear un flujo de prueba

1. Crea un nuevo workflow
2. Añade un nodo "LlamaParse" (o cualquiera de los personalizados)
3. Configura la credencial que creaste
4. Prueba que funciona

## Solución de problemas

### El servicio no se inicia (estado "Build Failed")

**Problema**: Error durante `docker build`

**Soluciones**:
1. Revisa los logs en Render → **Logs** → busca "Error"
2. Verifica que `Dockerfile`, `package.json`, `package-lock.json` existen en el repo
3. Intenta compilar localmente:
   ```powershell
   npm.cmd install
   npm.cmd run build
   npx.cmd tsc --noEmit
   ```
4. Si el error es de TypeScript, arréglalo y haz push

### El servicio está "Live" pero n8n no carga

**Problema**: Error de conexión o timeout

**Soluciones**:
1. Espera unos minutos (el contenedor puede estar inicializando)
2. Recarga la página (F5)
3. Abre la consola del navegador (F12) → pestaña "Console" → revisa errores
4. En Render → Logs → busca líneas como "n8n ready on..." o errores

### Los nodos no aparecen en n8n

**Problema**: Los nodos se compilaron pero no se cargan en n8n

**Soluciones**:
1. En Render → Logs → busca mensajes de error relacionados con "node"
2. Verifica que `dist/` se generó correctamente:
   - En Render, Logs, deberías ver líneas de compilación (tsc)
3. Recarga completamente n8n en el navegador: Ctrl+F5
4. Revisa la consola del navegador (F12) para errores JavaScript
5. Si el problema persiste, reinicia el servicio en Render:
   - Dashboard → n8n-llamacloud → Manual Redeploy

### El puerto 5678 no es accesible

**Problema**: Render usa un puerto diferente o hay conflicto

**Soluciones**:
1. Verifica la URL: Render asigna automáticamente un dominio (no controlas el puerto)
2. Usa la URL que proporciona Render: `https://n8n-llamacloud.onrender.com`
3. NO uses `http://` (debes usar `https://`)

### Las credenciales de LlamaCloud no funcionan

**Problema**: Error 401 o "Unauthorized" al usar los nodos

**Soluciones**:
1. Verifica que tu API key es correcta:
   - Ve a https://cloud.llamaindex.ai → Settings → API Keys
   - Copia la clave completa (sin espacios)
2. Recrear la credencial en n8n:
   - Settings → Credentials → busca "LlamaCloud"
   - Elimina la anterior
   - Crea una nueva con la clave correcta
3. Si el error persiste, verifica que tu cuenta de LlamaCloud tiene cuota disponible

### La imagen Docker es demasiado grande / se tarda mucho en desplegar

**Problema**: Render tarda mucho en construir la imagen

**Soluciones**:
1. Ya estamos usando un Dockerfile multi-stage optimizado
2. Espera un poco más (la primera construcción es la más lenta)
3. En futuros deploys será más rápido (caché)
4. Si quieres acelerar, reduce el número de `npm audit fix` u otros paso

### Necesito cambiar el código después del deploy

**Proceso**:
1. Haz los cambios localmente
2. Compila: `npm.cmd run build`
3. Testea localmente: `npm.cmd run build && npx.cmd tsc --noEmit`
4. Haz push: `git add . && git commit -m "..." && git push origin main`
5. Render detectará los cambios y re-desplegará automáticamente (si activaste auto-deploy)
6. O manualmente: Dashboard → n8n-llamacloud → Manual Redeploy

## Variables de entorno avanzadas

Si quieres personalizar n8n, Render acepta estas variables:

```
# Seguridad
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=myuser
N8N_BASIC_AUTH_PASSWORD=mypassword

# Base de datos
DATABASE_TYPE=postgres
DATABASE_URL=postgresql://user:pass@host:5432/db

# Logs
LOG_LEVEL=info

# Otros
WEBHOOK_TUNNEL_URL=https://n8n-llamacloud.onrender.com/
```

Para más opciones, consulta: https://docs.n8n.io/hosting/environment-variables/

## Monitoreo y mantenimiento

### Ver logs en tiempo real

En Render Dashboard:
- Ve a tu servicio → **Logs**
- Los logs se actualizan cada pocos segundos
- Busca errores o mensajes importantes

### Reiniciar el servicio

En Render Dashboard:
- Ve a tu servicio → **Manual Redeploy**
- Esto reconstruirá e iniciará el contenedor

### Actualizar sin reconstruir la imagen

Si solo cambias código TypeScript:
1. Haz push del código
2. En Render → Manual Redeploy
3. Solo re-compila, no reconstruye la imagen Docker

### Escalar el servicio

Si necesitas más recursos:
- Dashboard → tu servicio → Settings → Instance Type
- Sube a "Standard" o superior (más CPU, RAM, dinero)

## Costos

- **Starter**: $7/mes (0.5 CPU, 0.5GB RAM) - bueno para pruebas
- **Standard**: $12/mes (1 CPU, 1GB RAM)
- Los free tier tienen limitaciones (30min inactivo = pausa)

## Seguridad

- **No guardes secretos en el repo**: las credenciales van en Environment variables o UI de n8n
- **Usa HTTPS**: Render auto-usa certificados SSL
- **Protege n8n**: usa N8N_BASIC_AUTH para requerir login
- **Mantén dependencias actualizadas**: ejecuta `npm audit` y actualiza regularmente

## Siguientes pasos

1. **Crea flujos**: usa los nodos personalizados en tus workflows
2. **Automatiza**: programa flujos para que se ejecuten en horarios específicos
3. **Integra**: conecta n8n con otras APIs y servicios
4. **Monitorea**: revisa logs regularmente y escala si es necesario

## Contacto y soporte

- Problemas con Render: https://support.render.com
- Problemas con n8n: https://community.n8n.io
- Problemas con LlamaCloud: https://community.llamaindex.ai

## Referencias

- Render documentation: https://render.com/docs
- n8n documentation: https://docs.n8n.io/
- n8n Docker: https://docs.n8n.io/hosting/docker-deployment/
- LlamaIndex docs: https://docs.llamaindex.ai/
- GitHub: https://github.com/heberthtapia/workflowN8N_1

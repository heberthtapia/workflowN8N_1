# Despliegue en Render.com

Este repositorio contiene un paquete de nodos personalizados para n8n que integra LlamaIndex / LlamaCloud. Aquí están los pasos y recomendaciones para desplegarlo en Render.

## Prueba Local Rápida (antes de desplegar a Render)

Si tienes Docker Desktop instalado, puedes probar la imagen localmente:

```powershell
.\docker-local-test.ps1
```

Esto construirá la imagen, la ejecutará y abrirá n8n en http://localhost:5678. Lee `DOCKER_TEST_GUIDE.md` para instrucciones detalladas.

---

## Despliegue a Render.com - Pasos Rápidos

Para desplegar directamente a Render, ejecuta el script de guía interactiva:

```powershell
.\render-deploy-guide.ps1
```

Este script te proporciona paso a paso:
1. Verificación previa (que todo está listo)
2. Instrucciones detalladas para crear el servicio en Render
3. Cómo configurar variables de entorno y secretos
4. Verificación final

Para más detalles, lee: `RENDER_DEPLOY_GUIDE.md`

---

Opciones de despliegue:

- Opción A — Usar el `Dockerfile` incluido (recomendado si quieres controlar el contenedor exactamente):
  1. En Render crea un nuevo servicio de tipo Web Service.
  2. Selecciona el repo y la rama.
  3. En la configuración, especifica que quieres usar el `Dockerfile` en la raíz del repo. Render construirá la imagen usando el Dockerfile proporcionado.
  4. Asegúrate de definir las variables de entorno y secretos en la sección de Environment (no metas keys en el repo).

- Opción B — Usar Node nativo (más simple, pero debes ajustar build/start):
  1. En Render crea un nuevo servicio Web Service.
  2. Selecciona el repo y la rama.
  3. Usa la build command: `npm install && npm run build`
  4. Usa el start command apropiado para n8n si estás desplegando n8n; si estás publicando sólo el paquete de nodos, es mejor usar la opción Docker para colocarlo en `/home/node/.n8n/custom`.

Consideraciones importantes:

- Credenciales: este paquete define una credencial `LlamaCloudApi` que n8n usará para inyectar `apiKey`. No guardes claves en el repo. En n8n (la instancia que uses en Render) crea la credencial en la UI o usa variables de entorno según corresponda.
- Node version: `package.json` requiere Node >= 20.15. Asegura que la imagen de Render o el servicio Node use Node 20.
- Build: el contenedor Dockerfile ya hace `npm install --include=dev` y `npm run build` dentro de la imagen, por tanto la imagen resultante contendrá `dist/` listo.
- Tamaño de la imagen: si prefieres una imagen más pequeña, transforma el Dockerfile en un multi-stage build para no incluir devDependencies en la imagen final.

Pruebas locales rápidas (PowerShell):

```powershell
npm install
npm run build
npx tsc --noEmit
```

Si `npm run build` falla, revisa los errores TypeScript (tsc) y corrígelos. Este repo ahora incluye las correcciones básicas para que `tsc` reconozca `fetch`, `FormData` y `Blob` (se añadió la lib DOM en `tsconfig.json`).

Pasos recomendados para colocar los nodos en una instancia n8n en Render:

1. Construye el paquete y verifica `dist/` contiene `nodes/` y `credentials/`.
2. Copia el contenido de `dist/` al directorio `/home/node/.n8n/custom` dentro del contenedor n8n (el Dockerfile ya lo hace).
3. Reinicia n8n; en la UI debería aparecer el nuevo conjunto de nodos/credenciales.

Notas finales:

- No se suben claves a este repo. Asegúrate de configurar las variables/credenciales en Render y en n8n.
- Si quieres que prepare un `Dockerfile` multi-stage más compacto, lo hago por ti.
README de despliegue en Render.com

Este repositorio contiene nodos personalizados de n8n (TypeScript). A continuación tienes pasos recomendados para desplegar en Render usando el Dockerfile incluido o usando el builder de Node.

Resumen rápido
- Corregí el `tsconfig.json` (añadí la librería `DOM` y removí la entrada inválida).
- Añadí un `index.ts` que exporta nodos y credenciales (antes estaba vacío).
- Corregí un bug en `nodes/LlamaParse/LlamaParse.node.ts` (se usaba `i` en vez de `j`).

Opciones de despliegue en Render

Opción A — Usar el Dockerfile (recomendada)
1. En Render crea un nuevo "Web Service" o "Docker" desde tu repositorio.
2. Selecciona la rama `main` y deja que Render use tu `Dockerfile` (el repo ya contiene uno).
3. Variables/secretos: configura variables en la sección "Environment" de Render según corresponda. No incluyas claves en el repositorio.
   - No es necesario añadir la API key de LlamaCloud en las variables si usarás las credenciales dentro de la UI de n8n; sin embargo, si automatizas credenciales por env vars, configura una variable como `LLAMACLOUD_API_KEY` y úsala en tu flujo seguro.
4. Build & Start: Render detectará el Dockerfile y usará los pasos allí descritos.

Notas sobre el Dockerfile actual
- El Dockerfile instala `devDependencies` y ejecuta `npm run build` dentro de la imagen. Esto funciona, pero produce una imagen más grande. Si quieres una imagen final más ligera, considera un multi-stage build donde compiles en una etapa y copies sólo `dist` y dependencias de producción a la imagen final.

Opción B — Deploy como servicio Node (sin Docker)
1. En Render crea un nuevo "Web Service".
2. En "Build Command" pon:

```
npm install
npm run build
```

3. En "Start Command" pon el comando apropiado para ejecutar n8n (p. ej. `n8n start` si quieres correr n8n).
4. Asegura que el entorno use Node >=20 (según `package.json` usa `>=20.15`). Puedes ajustar el `engines.node` si prefieres una versión menos restrictiva.

Variables de entorno recomendadas para n8n
- N8N_HOST, N8N_PORT (si las necesitas)
- N8N_BASIC_AUTH_ACTIVE=true
- N8N_BASIC_AUTH_USER y N8N_BASIC_AUTH_PASSWORD (para proteger la UI)
- DATABASE_URL o configuración de DB si la necesitas

Credenciales LlamaCloud
- No incluyas el API key en el repo. Crea la credencial desde la UI de n8n o gestiona el secreto en Render y úsalo donde convenga.

Comprobaciones locales antes de deploy
Ejecuta en PowerShell (Windows) desde la raíz del proyecto:

```powershell
npm install
npm run build
npx tsc --noEmit
```

Esto verificará que TypeScript compile correctamente.

Qué hice en el repo (resumen)
- `tsconfig.json`: corregido
- `index.ts`: añadido y exporta los nodos/credenciales
- `nodes/LlamaParse/LlamaParse.node.ts`: arreglo lógico en bucle

Siguientes pasos sugeridos
- Opcional: convertir el Dockerfile a multi-stage para reducir tamaño de imagen.
- Verificar `prepublishOnly` y reglas de ESLint si planeas publicar en npm.
- Probar la imagen Docker localmente antes de subir a Render:

```powershell
docker build -t n8n-llama-custom .
docker run -p 5678:5678 n8n-llama-custom
```

Si quieres, puedo:
- Convertir el Dockerfile a multi-stage.
- Añadir un `README` con instrucciones de uso más detalladas (por ejemplo, cómo crear la credencial en n8n).

Sección: multi-stage Dockerfile y ejemplo `.render.yaml`
---------------------------------------------------

He convertido el `Dockerfile` a un enfoque multi-stage en este repositorio. Resumen:

- Stage `builder` (base: `node:20`): instala dependencias (incluye dev) y ejecuta `npm run build`.
- Stage `runtime` (base: `n8nio/n8n:latest`): copia `dist/` y usa `package-lock.json` para instalar sólo dependencias de producción.

Si prefieres, puedo modificar la copia para:
- copiar sólo `dist/` y `package.json` y luego ejecutar `npm ci --omit=dev` en la etapa final (esto requiere que `package-lock.json` esté presente y producirá una imagen más ligera).

Ejemplo mínimo de `.render.yaml` (colócalo en la raíz del repo):

```yaml
services:
  - type: web
    name: n8n-llamacloud
    env: docker
    plan: starter
    docker:
      dockerfilePath: ./Dockerfile
    autoDeploy: true
    envVars:
      - key: NODE_ENV
        value: production
      # Añade aquí las variables que requieras; configura secretos desde la UI de Render
```

Recuerda: no agregues claves al repositorio. Usa la sección Environment en Render para variables/secretos.



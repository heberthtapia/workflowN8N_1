# 1. Empezar con la imagen oficial de n8n
FROM n8nio/n8n:latest

# 2. Cambiar a usuario root para preparar el entorno
USER root

# 3. Establecer el directorio de trabajo
WORKDIR /home/node/.n8n/

# 4. Copiar todos los archivos del proyecto
COPY . .

# 5. Dar la propiedad de los archivos al usuario 'node'
RUN chown -R node:node /home/node/.n8n/

# 6. Cambiar de vuelta al usuario 'node'
USER node

# 7. Instalar TODAS las dependencias (incluidas las de desarrollo)
RUN npm install --include=dev

# 8. --- LA SOLUCIÓN ESTÁ AQUÍ ---
# Cambiar a root para dar permisos de ejecución a los binarios de node_modules
USER root
RUN chmod +x /home/node/.n8n/node_modules/.bin/*

# 9. Volver al usuario 'node' por seguridad para ejecutar el build
USER node

# 10. Construir el código de TypeScript a JavaScript. ¡Ahora sí funcionará!
RUN npm run build

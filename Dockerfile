# 1. Empezar con la imagen oficial de n8n
FROM n8nio/n8n:latest

# 2. Cambiar a usuario root temporalmente para preparar el entorno
USER root

# 3. Establecer el directorio de trabajo donde n8n busca los nodos
WORKDIR /home/node/.n8n/

# 4. Copiar todos los archivos de tu proyecto al directorio de trabajo
COPY . .

# 5. Darle la propiedad de todos estos archivos al usuario 'node'
RUN chown -R node:node /home/node/.n8n/

# 6. Cambiar de vuelta al usuario 'node' por seguridad
USER node

# 7. --- LA CORRECCIÓN ESTÁ AQUÍ ---
# Instalar TODAS las dependencias, incluidas las devDependencies necesarias para el build.
RUN npm install --include=dev

# 8. Construir el código de TypeScript a JavaScript.
RUN npm run build

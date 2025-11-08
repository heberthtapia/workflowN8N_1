# 1. Empezar con la imagen oficial de n8n
FROM n8nio/n8n:latest

# 2. Cambiar a usuario root temporalmente para preparar el entorno
USER root

# 3. Establecer el directorio de trabajo donde n8n busca los nodos
WORKDIR /home/node/.n8n/

# 4. Copiar todos los archivos de tu proyecto al directorio de trabajo
COPY . .

# 5. Darle la propiedad de todos estos archivos al usuario 'node'
# Esto es VITAL para que los siguientes comandos no fallen por permisos.
RUN chown -R node:node /home/node/.n8n/

# 6. Cambiar de vuelta al usuario 'node' por seguridad
USER node

# 7. Instalar las dependencias de tu nodo (desde package.json)
RUN npm install

# 8. CONSTRUIR el código. Este es el paso clave que faltaba.
# Convierte tus archivos .ts a .js para que n8n pueda ejecutarlos.
RUN npm run build

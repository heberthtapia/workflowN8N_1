# Empezar con la imagen oficial de n8n
FROM n8nio/n8n:latest

# Cambiar a usuario root para instalar paquetes y cambiar permisos
USER root

# Instalar git, que puede ser necesario
RUN apk add --update --no-cache git

# Ir al directorio donde n8n busca los nodos personalizados
WORKDIR /home/node/.n8n/

# Copiar el código de tu nodo personalizado
COPY . .

# --- LA LÍNEA CLAVE DE LA SOLUCIÓN ---
# Asegurarse de que el usuario 'node' sea el dueño de todos los archivos copiados
RUN chown -R node:node /home/node/.n8n/

# Cambiar de vuelta al usuario 'node' por seguridad antes de ejecutar npm
USER node

# Instalar las dependencias de tu nodo personalizado
RUN npm install

# Vincular tu nodo para que n8n lo reconozca
RUN npm link

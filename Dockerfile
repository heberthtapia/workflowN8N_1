# 1. Empezar con la imagen oficial de n8n
FROM n8nio/n8n:latest

# 2. Cambiar a usuario root temporalmente
USER root

# 3. Crear la carpeta 'custom' donde n8n buscará los nodos
RUN mkdir /home/node/.n8n/custom

# 4. Establecer esa carpeta 'custom' como nuestro directorio de trabajo
WORKDIR /home/node/.n8n/custom

# 5. Copiar SOLO el package.json y package-lock.json primero
# Esto aprovecha la caché de Docker para acelerar futuros builds
COPY package*.json ./

# 6. Instalar TODAS las dependencias (incluidas las de desarrollo)
RUN npm install --include=dev

# 7. Ahora, copiar el RESTO de los archivos de tu proyecto
COPY . .

# 8. Dar la propiedad de todo al usuario 'node'
RUN chown -R node:node /home/node/.n8n/

# 9. Cambiar de vuelta al usuario 'node' por seguridad
USER node

# 10. Construir el código de TypeScript a JavaScript.
RUN npm run build

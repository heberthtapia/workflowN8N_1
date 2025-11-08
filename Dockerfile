# Empezar con la imagen oficial de n8n
FROM n8nio/n8n:latest

# Instalar git, que puede ser necesario para algunas dependencias de npm
USER root
RUN apk add --update --no-cache git
USER node

# Ir al directorio donde n8n busca los nodos personalizados
WORKDIR /home/node/.n8n/

# Copiar el código de tu nodo personalizado (todo el proyecto) dentro de la imagen
COPY . .

# Instalar las dependencias de tu nodo personalizado
RUN npm install

# Vincular tu nodo para que n8n lo reconozca
RUN npm link

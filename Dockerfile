#########################################
# Multi-stage Dockerfile
# Stage 1: builder (instala deps y construye)
#########################################
FROM node:20 AS builder

WORKDIR /usr/src/app

# Copiar package.json primero para aprovechar cache
COPY package*.json ./

# Instalar dependencias (incluye dev para poder compilar)
RUN npm install --include=dev

# Copiar el resto del código y construir
COPY . .
RUN npm run build

#########################################
# Stage 2: runtime (imagen oficial de n8n)
#########################################
FROM n8nio/n8n:latest

USER root

# Crear el directorio custom donde n8n espera los nodos
RUN mkdir -p /home/node/.n8n/custom
WORKDIR /home/node/.n8n/custom

# Copiar solo los artefactos necesarios desde el builder
COPY --from=builder /usr/src/app/dist ./dist
COPY --from=builder /usr/src/app/package.json ./package.json
COPY --from=builder /usr/src/app/package-lock.json ./package-lock.json

# Instalar sólo dependencias de producción de forma determinista
# Usamos npm ci --omit=dev para que la imagen final no incluya devDependencies
RUN npm ci --omit=dev --no-audit --prefer-offline

# Ajustar permisos y volver a usuario node
RUN chown -R node:node /home/node/.n8n/
USER node

# Nota: la imagen final contiene dist/ y sólo dependencias de producción en /home/node/.n8n/custom

FROM node:18-alpine
WORKDIR /srv
COPY package.json package-lock.json* ./
RUN npm ci --omit=dev || npm i --omit=dev
COPY server.js ./
EXPOSE 3000
CMD ["node", "server.js"]

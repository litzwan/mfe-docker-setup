FROM node:20-alpine AS builder

ARG VITE_BASE_URL
ARG VITE_APP_ENV
ARG VITE_INTERNAL_ORIGIN_URL
ARG VITE_KEY_CLOACK_URL

ENV VITE_BASE_URL=$VITE_BASE_URL
ENV VITE_APP_ENV=$VITE_APP_ENV
ENV VITE_INTERNAL_ORIGIN_URL=$VITE_INTERNAL_ORIGIN_URL
ENV VITE_KEY_CLOACK_URL=$VITE_KEY_CLOACK_URL

WORKDIR /app

COPY package.json package-lock.json .npmrc ./
RUN npm ci

COPY . .
RUN npm run build:dev

FROM nginx:alpine
WORKDIR /usr/share/nginx/html

# Copy build artifacts from builder stage
COPY --from=builder /app/dist .

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
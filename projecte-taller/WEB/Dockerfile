# Usar la imagen oficial de Nginx
FROM nginx:latest

# Copiar los archivos de la aplicación web al directorio de Nginx
COPY ./html /usr/share/nginx/html
COPY ./css /usr/share/nginx/html/css
COPY ./img /usr/share/nginx/html/img
COPY ./js /usr/share/nginx/html/js

# Exponer el puerto 80
EXPOSE 80
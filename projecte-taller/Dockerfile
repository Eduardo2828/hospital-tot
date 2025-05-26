# Usar la imagen oficial de MySQL
FROM mysql:8.0

# Establecer variables de entorno para la configuración de MySQL
ENV MYSQL_ROOT_PASSWORD=Educem00.
ENV MYSQL_DATABASE=hospital-projecte

# Copiar el archivo SQL al contenedor
COPY db_schema.sql /docker-entrypoint-initdb.d/

# Exponer el puerto 3307 para conexiones MySQL
EXPOSE 3307

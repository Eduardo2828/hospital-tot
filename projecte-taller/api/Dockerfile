# Usar la imagen oficial de Python
FROM python:3.9

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el archivo requirements.txt al contenedor
COPY requirements.txt /app/requirements.txt

# Instalar las dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto de la aplicación al contenedor
COPY . /app

# Comando para ejecutar la aplicación
CMD ["python", "app.py"]

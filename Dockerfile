FROM python:3.12-slim

# Instalación de dependencias del sistema
RUN apt-get update && apt-get install -y \
    libpq-dev gcc python3-dev musl-dev zlib1g-dev libjpeg-dev \
    && rm -rf /var/lib/apt/lists/*

# Carpeta de trabajo estándar en contenedores
WORKDIR /app

# 1. Copia el archivo desde la raíz ECOMMERCE a /app/
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 2. Copia todo el contenido de ECOMMERCE a /app/
COPY . .

# 3. Moverse a la carpeta donde está manage.py (según tu foto)
WORKDIR /app/tienda

# 4. Preparar estáticos
RUN python manage.py collectstatic --no-input

EXPOSE 8000

# 5. Ejecutar. Nota: el primer 'tienda' es el nombre de la carpeta que contiene wsgi.py
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "tienda.wsgi:application"]
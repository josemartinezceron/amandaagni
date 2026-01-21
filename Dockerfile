FROM python:3.12-slim

# Instalar dependencias del sistema para psycopg2 (Postgres) y Pillow
RUN apt-get update && apt-get install -y libpq-dev gcc python3-dev musl-dev zlib1g-dev libjpeg-dev

WORKDIR /tienda

# Copiar requerimientos desde la raíz
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar todo el contenido del proyecto
COPY . .

# Entrar a la subcarpeta donde está manage.py para los comandos
WORKDIR /tienda/tiendaapp

RUN python manage.py collectstatic --no-input

# Exponer el puerto de Django
EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "tienda.wsgi:application"]
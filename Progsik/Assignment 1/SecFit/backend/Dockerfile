# We Use an official Python runtime as a parent image
FROM python:3.12-slim

# Allows docker to cache installed dependencies between builds
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Mounts the application code to the image
COPY . app
WORKDIR /app

EXPOSE 8000

# Runs migrations and starts the production server
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]
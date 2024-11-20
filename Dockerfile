# official Python image based on slim
FROM python:3.11-slim

RUN apt-get update && \
    apt-get install -y gcc python3-dev libpcre3-dev build-essential libpq-dev libjpeg-dev zlib1g-dev libtiff-dev  && \
    rm -rf /var/lib/apt/lists/*

# working directory
WORKDIR /app

# Copy the requirements file 
COPY requirements.txt ./

# system dependencies and Python packages
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt  && \
    pip install uwsgi


COPY --chown=app:app . ./

# Command to run uWSGI when starting the container
CMD ["sh", "-c", "python manage.py migrate && uwsgi --http 0.0.0.0:8000 --module parrotsite.wsgi:application"]
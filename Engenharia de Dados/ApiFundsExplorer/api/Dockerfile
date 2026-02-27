FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY api.py .

CMD exec gunicorn --bind :8080 --workers 1 --threads 8 api:app

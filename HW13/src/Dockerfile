FROM python:3.13-slim

WORKDIR /app

# Копируем файлы приложения в контейнер
COPY app.py .
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8000", "app:app"]

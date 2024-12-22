#!/bin/bash

# Запускаем Gunicorn для Flask-приложения
gunicorn --bind 0.0.0.0:5000 wsgi:app &  # Поднятие приложения на порту 5000
APP_PID=$!                               # Сохраняем PID приложения

# Даём приложению немного времени для запуска
sleep 5

# Запускаем ngrok для проброса порта 5000
./ngrok http 5000 > /dev/null &         # Запуск ngrok в фоне
NGROK_PID=$!

# Даём ngrok время для получения публичного URL
sleep 5

# Выводим публичный URL для доступа к приложению
curl --silent http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[0].public_url'

# Ожидаем завершения работы (опционально)
wait $APP_PID

# Очищаем ресурсы
kill -TERM $NGROK_PID
echo "Gunicorn и ngrok завершены."

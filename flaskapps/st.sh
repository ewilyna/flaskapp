#!/bin/bash

# Добавляем директорию с локальными пакетами в PATH
export PATH=$HOME/.local/bin:$PATH

# Запускаем Gunicorn
gunicorn --bind 0.0.0.0:5000 wsgi:app &
APP_PID=$!
sleep 5

if ! ps -p $APP_PID > /dev/null; then
  echo "Ошибка: Gunicorn не запустился."
  exit 1
fi

# Проверяем наличие ngrok и запускаем его
if [ ! -f ./ngrok ]; then
  echo "Ошибка: ngrok не найден."
  exit 1
fi

chmod +x ./ngrok
./ngrok http 5000 &
NGROK_PID=$!
sleep 5

if ! ps -p $NGROK_PID > /dev/null; then
  echo "Ошибка: ngrok не запустился."
  exit 1
fi

# Получаем URL ngrok
if ! command -v jq &> /dev/null; then
  echo "Ошибка: jq не установлен."
  exit 1
fi

NGROK_URL=$(curl --silent http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[0].public_url')
echo "Сайт доступен по адресу: $NGROK_URL"

# Ожидаем завершения
wait $APP_PID

# Завершаем ngrok
if ps -p $NGROK_PID > /dev/null; then
  kill $NGROK_PID
fi

echo "Gunicorn и ngrok завершены."


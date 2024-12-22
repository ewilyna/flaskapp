gunicorn --bind 0.0.0.0:5000 wsgi:app &  # Поднятие приложения на порту 5000
APP_PID=$!                               # Сохраняем PID приложения
sleep 5
echo $APP_PID
kill -TERM $APP_PID
echo process gunicorns kills
exit 0

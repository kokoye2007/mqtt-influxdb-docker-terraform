import time, os
from dotenv import load_dotenv
from random import randrange, randint
from paho.mqtt import client as mqtt


load_dotenv()

username = os.getenv('MQTT_USER')
password = os.getenv('MQTT_PASSWORD')
broker = os.getenv('MQTT_BROKER')
port = int(os.getenv('MQTT_PORT'))

topic = "RandomNumber"
client_id = f'app1'

def connect_mqtt():
    def on_connect(client, userdata, flags, rc):
        if rc == 0:
            print("Connected to MQTT Broker!")
        else:
            print("Failed to connect, return code %d\n", rc)

    client = mqtt.Client(client_id)
    client.username_pw_set(username, password)
    client.on_connect = on_connect
    client.connect(broker, port)
    return client


def publish(client):
    while True:
        time.sleep(randint(1,30))
        randNumber = randrange(1, 100)
        result = client.publish(topic, randNumber)

        status = result[0]
        if status == 0:
            print(f"Published `{randNumber}` to topic `{topic}`")
        else:
            print(f"Failed to send message to topic {topic}")


def run():
    client = connect_mqtt()
    client.loop_start()
    publish(client)


if __name__ == '__main__':
    run()

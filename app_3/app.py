import time, os, json
from prettytable import PrettyTable
from dotenv import load_dotenv
from random import randrange, randint
from paho.mqtt import client as mqtt


load_dotenv()

username = os.getenv('MQTT_USER')
password = os.getenv('MQTT_PASSWORD')
broker = os.getenv('MQTT_BROKER')
port = int(os.getenv('MQTT_PORT'))

topic = "Statistics"
client_id = "app3"

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


def subscribe(client: mqtt):
    def on_message(client, userdata, msg):
        data = msg.payload.decode()
        # print(f"Received `{data}` from `{msg.topic}` topic")
        result = json.loads(data)

        t = PrettyTable(["Average 1min", "Average 5mins", "Average 30mins"])
        t.add_row([ result["one"] , result["five"], result["thirty"]])
        print(t)


    client.subscribe(topic)
    client.on_message = on_message


def run():
    client = connect_mqtt()
    subscribe(client)
    client.loop_forever()


if __name__ == '__main__':
    run()

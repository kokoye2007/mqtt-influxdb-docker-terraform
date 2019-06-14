import paho.mqtt.client as mqtt
import time, json, os
from dotenv import load_dotenv
from influx_ops import *
from datetime import datetime

load_dotenv()

username = os.getenv('MQTT_USER')
password = os.getenv('MQTT_PASSWORD')
broker = os.getenv('MQTT_BROKER')
port = int(os.getenv('MQTT_PORT'))

sub_topic = "RandomNumber"
pub_topic = "Statistics"
client_id = "app2"

def Average(lst):
    return sum(lst) / len(lst)

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

    def on_message(client, userdata, message):
        print(f"Received `{message.payload.decode()}` from `{message.topic}` topic")
        num = int(message.payload)
        data = "random,host=app1 random_number={}".format(num)
        write_api.write(bucket, org, data)
        publish(client)

    client.subscribe(sub_topic)
    client.on_message = on_message


def publish(client):

    results_one = query('-1m')
    results_five = query('-5m')
    results_thirty = query('-30m')

    average_one=round(Average(results_one))
    average_five=round(Average(results_five))
    average_thirty=round(Average(results_thirty))

    send_msg = {
        'one': average_one,
        'five': average_five,
        'thirty': average_thirty
    }

    print(send_msg)
    # result = client.publish(topic, randNumber)
    result = client.publish(pub_topic, payload=json.dumps(send_msg))
    status = result[0]
    if status == 0:
        print(f"Published results to topic `{pub_topic}`")
    else:
        print(f"Failed to send message to topic {pub_topic}")


def run():
    client = connect_mqtt()
    subscribe(client)
    client.loop_forever()

if __name__ == '__main__':
    run()

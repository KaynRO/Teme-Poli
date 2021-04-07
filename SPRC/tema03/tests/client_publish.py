import paho.mqtt.client as mqtt
import sys
import time
import json
import datetime


BROKER = '0.0.0.0'
PORT = 1883


def on_connect(client, userdata, flags, rc):
	if rc == 0:
		print('[+] Connected to MQTT Broker')
	else:
		print('[+] Failed to connect')


def publish(TOPIC, data):
	stat = client.publish(TOPIC, json.dumps(data))[0]

	if stat == 0:
		print('[+] Message successfully sent')
	else:
		print('[+] Failed sending message')



data1 = { "BAT": 10000,
		  "HUMID": 10000,
		  "PRJ": "SPRC",
		  "IMP": 2.3,
		  "status": "OK"
}


data2 = { "Alarm": 10000,
		  "AQI": 10000,
		  "RSSI": 10000
}


client = mqtt.Client()
client.on_connect = on_connect
client.connect(BROKER)
publish('UPB/RPi_1', data1)
time.sleep(2)
publish('Andrei/Zeus', data2)
client.disconnect()

import paho.mqtt.client as mqtt
import time

NAME = 'sprc/chat/Andrei_Grigoras'
BROKER = 'broker.hivemq.com'
PORT = 1883

def on_connect(client, userdata, flags, rc):
	if rc == 0:
		print('[+] Connected to MQTT Broker')
	else:
		print('[+] Failed to connect')


client = mqtt.Client()
client.on_connect = on_connect

client.connect(BROKER)
client.loop_start()


while True:
	time.sleep(1)
	msg = raw_input('Enter message: ')
	
	if len(msg) > 0:
		stat = client.publish(NAME, msg)[0]

		if stat == 0:
			print('[+] Message successfully sent')
		else:
			print('[+] Failed sending message')




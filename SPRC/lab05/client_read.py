import paho.mqtt.client as mqtt

NAME = 'Andrei_Grigoras'
BROKER = 'broker.hivemq.com'
PORT = 1883

def on_connect(client, userdata, flags, rc):
	if rc == 0:
		print('[+] Connected to MQTT Broker')
		client.subscribe("sprc/chat/#")
		print('[+] Subscribed to sprc/chat/#\n')

	else:
		print('[+] Failed to connect')


def on_message(client, userdata, msg):
	print("Message topic: {}\nMessage body: {}\n".format(msg.topic, msg.payload))


client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect(BROKER, PORT)
client.loop_forever()

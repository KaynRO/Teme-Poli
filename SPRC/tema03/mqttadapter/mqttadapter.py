#!/usr/bin/env python3

import paho.mqtt.client as mqtt
from influxdb import InfluxDBClient
from dateutil.parser import parse
import time
import json
import datetime

INFLUXDB_ADDR = 'influxdb'
INFLUXDB_USER = 'root'
INFLUXDB_PASS = 'root'
INFLUXDB_DB = 'sprc'

MQTT_ADDR = 'mosquitto'
MQTT_TOPIC = '#'


influxdb_client = InfluxDBClient(INFLUXDB_ADDR, 8086, INFLUXDB_USER, INFLUXDB_PASS, None)


def convert_to_timestamp(msg):
	dt = datetime.datetime.strptime(msg, '%Y-%m-%d %H:%M:%S')
	return int(dt.timestamp())


def logger(msg):
	if msg.startswith('\n'):
		print(f'\n{datetime.datetime.fromtimestamp(time.time())} {msg}')
	else:
		print(f'{datetime.datetime.fromtimestamp(time.time())} {msg}')


def _init_influxdb():
	dbs = influxdb_client.get_list_database()
	if len(list(filter(lambda x: x['name'] == INFLUXDB_DB, dbs))) == 0:
		logger(f'Creating database {INFLUXDB_DB}')
		influxdb_client.create_database(INFLUXDB_DB)
	influxdb_client.switch_database(INFLUXDB_DB)


def _parse_mqtt_message(topic, payload):
	data = json.loads(payload.decode('utf-8'))
	location, station = topic.split('/')

	if "timestamp" in data.keys():
		ttime = parse(data['timestamp'])
		logger(f'Data timestamp is: {time}')
	else:
		ttime = int(time.time())
		logger(f'Data timestamp is: {datetime.datetime.fromtimestamp(int(ttime))}')

	json_body = [{'measurement': f'{station}.{key}',
				  'tags': {
						'location': location
						},
				  'fields': {
						'value': value
				   },
				   'time': ttime
				 }
				for key, value in data.items() if type(value) == int or type(value) == float]


	for key, value in data.items():
		if type(value) == int or type(value) == float and key != 'timestamp':
			logger(f'{location}.{station}.{key} {value}')

	return json_body


def on_connect(client, userdata, flags, rc):
	if rc == 0:
		logger('Connected to MQTT Broker')
		client.subscribe(MQTT_TOPIC)
	else:
		logger('Failed to connect to MQTT Broker')


def on_message(client, userdata, msg):
	print('\n')
	logger(f'Received a message by topic [{msg.topic}]')
	try:
		sensor_data = _parse_mqtt_message(msg.topic, msg.payload)
		if sensor_data:
			influxdb_client.write_points(points=sensor_data, database=INFLUXDB_DB, time_precision='s', protocol='json')
	except Exception as e:
		logger(f'Error {str(e)}')


def main():
	time.sleep(1)

	try:
		_init_influxdb()
		logger('Connected to the InfluxDB')

	except Exception as e:
		logger(f'Error while connecting to InfluxDB:\n{str(e)}')


	mqtt_client = mqtt.Client()
	mqtt_client.on_connect = on_connect
	mqtt_client.on_message = on_message

	mqtt_client.connect(MQTT_ADDR, 1883)
	mqtt_client.loop_forever()


if __name__ == '__main__':
	main()

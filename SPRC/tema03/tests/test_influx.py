from influxdb import InfluxDBClient, line_protocol
import json
import time
import sys
import datetime

INFLUXDB_ADDR = 'localhost'
INFLUXDB_USER = 'root'
INFLUXDB_PASS = 'root'
INFLUXDB_DB = 'sprc'

influxdb_client = InfluxDBClient(host=INFLUXDB_ADDR, port=8086, username=INFLUXDB_USER, password=INFLUXDB_PASS)


def get_timestamp():
	now = datetime.datetime.now()
	return time.time()


data1 = { "BAT": 59,
		  "HUMID": 40,
		  "PRJ": "SPRC",
		  "IMP": 25.3,
		  "status": "OK"
}

station, location = sys.argv[1].split('/')

json_body1 = [{'measurement': f'{location}.{key}',
			  'tags': {
					'location': location
					},
			  'fields': {
					'value': value
			   },
			   'time': int(get_timestamp())
			 }
			for key, value in data1.items() if type(value) == int or type(value) == float]


print(json_body1)
influxdb_client.write_points(points=json_body1, database=INFLUXDB_DB, time_precision='s', protocol='json')

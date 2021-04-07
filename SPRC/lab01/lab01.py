import requests

url = 'https://sprc.dfilip.xyz/lab1'


def ex1():
	url_data = {'nume': 'Andrei Grigoras',
			'grupa': '343C2'}
	post_data = {'secret': 'SPRCisNice'}
	header = {'secret2': 'SPRCisBest'}

	r = requests.post(url = url + '/task1/check',params = url_data, data = post_data, headers = header)
	print '[+] Exercitiul 1: {}'.format(r.text)


def ex2():
	data = {'username': 'sprc',
			'password': 'admin',
			'nume': 'Andrei Grigoras'}

	r = requests.post(url = url + '/task2', json = data)
	print '[+] Exercitiul 2: {}'.format(r.text)


def ex3():

	r = requests.Session()
	data = {'username': 'sprc',
			'password': 'admin',
			'nume': 'Andrei Grigoras'}

	s = r.post(url = url + '/task3/login', json = data)
	s = r.get(url = url + '/task3/check')
	print '[+] Exercitiul 3: {}'.format(s.text)


def main():
	ex1()
	ex2()
	ex3()

main()

from flask import Flask, jsonify, request, Response

app = Flask(__name__)
cnt = 0
movies = []


def create_movie1(name):
	global cnt
	cnt = cnt + 1
	return {"id": cnt, "nume": name}


def create_movie2(idd, name):
	return {"id": idd, "nume": name}


def movie_exists(idd):
	for elem in movies:
		if elem["id"] == idd:
			return True

	return False


def remove_movie(idd):
	for elem in movies:
		if elem["id"] == idd:
			break

	movies.remove(elem)


@app.route("/movies", methods=["GET"])
def get_movies():
	return jsonify(movies), 200


@app.route("/movies", methods=["POST"])
def post_movie():
	payload = request.get_json()

	if not payload or "nume" not in payload:
		return Response(status=400)

	movies.append(create_movie1(payload["nume"]))
	return Response(status=201)


@app.route("/movie/<int:idd>", methods=["PUT"])
def put_movie(idd):
	payload = request.get_json()
	
	if not payload or "nume" not in payload:
		return Response(status=400)

	if not movie_exists(idd):
		return Response(status=404)

	remove_movie(idd)
	movies.append(create_movie2(idd, payload["nume"]))
	return Response(status=200)


@app.route("/movie/<int:idd>")
def get_movie(idd):
	for elem in movies:
		if elem["id"] == idd:
			return jsonify(elem), 200

	return Response(404)


@app.route("/movie/<int:idd>", methods=["DELETE"])
def delete_movie(idd):
	payload = request.get_json()

	if not movie_exists(idd):
		return Response(status=404)

	remove_movie(idd)
	return Response(status=200)


@app.route("/reset", methods=["DELETE"])
def reset():
	global cnt, movies
	cnt = 0
	movies = []

	return Response(status=200)

if __name__ == '__main__':
	app.run('0.0.0.0', debug=True)
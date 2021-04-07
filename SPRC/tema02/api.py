from flask import Flask, Response, request, json
from sqlalchemy import create_engine, Column, String, Integer, Float, ForeignKey, TIMESTAMP
from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime
import os


COUNTRY = 0
CITY = 1
TEMPERATURE = 2

app = Flask(__name__)
engine = create_engine(os.environ['SQLALCHEMY_DATABASE_URI'])
db = scoped_session(sessionmaker(bind=engine))
base = declarative_base()


class Temperature(base):
    __tablename__ = 'temperaturi'

    id = Column(Integer, primary_key=True)
    valoare = Column(Float)
    ttimestamp = Column(TIMESTAMP)
    id_oras = Column(Integer, ForeignKey('orase.id'), unique=True)

    def get_json(self):
        return {"id": self.id, "valoare": self.valoare,
                "timestamp": datetime.strftime(self.ttimestamp, '%Y-%m-%d'), "idOras": self.id_oras}


class City(base):
    __tablename__ = 'orase'

    id = Column(Integer, primary_key=True)
    id_tara = Column(Integer, ForeignKey('tari.id'), unique=True)
    nume = Column(String, unique=True)
    latitudine = Column(Float)
    longitudine = Column(Float)

    def get_json(self):
        return {"id": self.id, "idTara": self.id_tara, "nume": self.nume,
                "lat": self.latitudine, "lon": self.longitudine}


class Country(base):
    __tablename__ = 'tari'

    id = Column(Integer, primary_key=True)
    nume = Column(String, unique=True)
    latitudine = Column(Float)
    longitudine = Column(Float)

    def get_json(self):
        return {"id": self.id, "nume": self.nume,
                "lat": self.latitudine, "lon": self.longitudine}


def check_json(type, payload):
    try:
        if type == COUNTRY or type == CITY:
            nume = payload['nume']
            latitudine = payload['lat']
            longitudine = payload['lon']

            if not isinstance(nume, str) or not isinstance(latitudine, float) or not isinstance(longitudine, float):
                raise Exception("Data in wrong format")

            if type == CITY:
                id_tara = payload['idTara']
                if not isinstance(id_tara, int):
                    raise Exception("Data in wrong format")

        if type == TEMPERATURE:
            id_oras = payload['idOras']
            valoare = payload['valoare']
            if not isinstance(id_oras, int) or not isinstance(valoare, float):
                raise Exception("Data in wrong format")

    except Exception as error:
        raise Exception(str(error))

    if type == COUNTRY:
        return nume, latitudine, longitudine
    if type == CITY:
        return nume, latitudine, longitudine, id_tara
    if type == TEMPERATURE:
        return id_oras, valoare


def delete_entry(type, idd):
    if type == COUNTRY:
        cities = db.query(City).filter_by(id_tara=idd)
        for city in cities:
            db.query(Temperature).filter_by(id_oras=city.id).delete()
            db.commit()
            db.delete(city)
            db.commit()
        resp = db.query(Country).filter_by(id=idd).delete()

    if type == CITY:
        db.query(Temperature).filter_by(id_oras=idd).delete()
        db.commit()
        resp = db.query(City).filter_by(id=idd).delete()

    if type == TEMPERATURE:
        resp = db.query(Temperature).filter_by(id=idd).delete()

    db.commit()
    if resp == 0:
        return Response(status=404, response='ID does not exists')

    return Response(status=200)


def add_entry(type, payload):
    try:
        if type == COUNTRY:
            tmp = Country(nume=payload[0], latitudine=payload[1], longitudine=payload[2])
        if type == CITY:
            tmp = City(nume=payload[0], latitudine=payload[1], longitudine=payload[2], id_tara=payload[3])
        if type == TEMPERATURE:
            tmp = Temperature(id_oras=payload[0], valoare=payload[1], ttimestamp=datetime.now())

        db_response = db.add(tmp)
        db.commit()
        return Response(status=201, response=json.dumps({'id': tmp.id}))

    except Exception as error:
        if type == COUNTRY:
            return Response(status=409)
        if type == CITY:
            return Response(status=404)
        if type == TEMPERATURE:
            return Response(status=404)


@app.route('/')
def get_home():
    return 'Tema 2 SPRC - Andrei Grigoras 343 C2'


@app.route('/api/countries', methods=['GET'])
def fetch_countries():
    return Response(status = 200, response = json.dumps([country.get_json() for country in db.query(Country)]))


@app.route('/api/countries', methods=['POST'])
def add_countries():
    payload = request.get_json()

    try:
        nume, latitudine, longitudine = check_json(COUNTRY, payload)
    except Exception as error:
        return Response(status=400)

    return add_entry(0, [nume, latitudine, longitudine])


@app.route('/api/countries/<int:idd>', methods=['PUT'])
def update_countries(idd):
    payload = request.get_json()

    try:
        nume, latitudine, longitudine = check_json(COUNTRY, payload)
    except Exception as error:
        return Response(status=400)

    res = db.query(Country).filter_by(id=idd).update({"nume":nume, "latitudine":latitudine, "longitudine":longitudine})
    db.commit()

    if res == 0:
        return Response(status=404)
    return Response(status=200)


@app.route('/api/countries/<int:id>', methods=['DELETE'])
def delete_countries(id):
    return delete_entry(COUNTRY, id)


@app.route('/api/cities', methods=['GET'])
def fetch_cities():
    return Response(status = 200, response = json.dumps([city.get_json() for city in db.query(City)]))


@app.route('/api/cities', methods=['POST'])
def add_cities():
    payload = request.get_json()

    try:
        nume, latitudine, longitudine, id_tara = check_json(CITY, payload)
    except Exception as error:
        return Response(status=400)

    tmp = [city for city in db.query(City).filter_by(id_tara=id_tara, nume=nume)]
    if len(tmp) > 0:
        return Response(status=409)

    return add_entry(1, [nume, latitudine, longitudine, id_tara])


@app.route('/api/cities/country/<int:idd>', methods=['GET'])
def get_city(idd):
    return Response(status = 200, response=json.dumps([city.get_json() for city in db.query(City).filter_by(id_tara=idd)]))


@app.route('/api/cities/<int:idd>', methods=['PUT'])
def update_cities(idd):
    payload = request.get_json()

    try:
        nume, latitudine, longitudine, id_tara = check_json(CITY, payload)
    except Exception as error:
        return Response(status=400)

    res = db.query(City).filter_by(id=idd).update({"id_tara": id_tara, "nume":nume, "latitudine":latitudine, "longitudine":longitudine})
    db.commit()

    if res == 0:
        return Response(status=404)
    return Response(status=200)


@app.route('/api/cities/<int:idd>', methods=['DELETE'])
def delete_cities(idd):
    return delete_entry(CITY, idd)


@app.route('/api/temperatures', methods=['GET'])
def fetch_temperature():
    lat = request.args.get('lat')
    lon = request.args.get('lon')
    fr = request.args.get('from')
    to = request.args.get('until')
    resp =  db.query(Temperature).all()

    try:
        if len(fr) > 0:
            resp = [r for r in resp if datetime.strftime(r.ttimestamp, '%Y-%m-%d') >= fr]
        if len(to) > 0:
            resp = [r for r in resp if datetime.strftime(r.ttimestamp, '%Y-%m-%d') <= to]

        if len(lat) > 0:
            resp = [r for r in resp if db.query(City).get(r.id_oras).latitudine == float(lat)]
        if len(lon) > 0:
            resp = [r for r in resp if db.query(City).get(r.id_oras).longitudine == float(lon)]
    except Exception:
        resp = []

    return Response(status=200, response=json.dumps([r.get_json() for r in resp]))


@app.route('/api/temperatures', methods=['POST'])
def add_temperature():
    payload = request.get_json()

    try:
        id_oras, valoare = check_json(TEMPERATURE, payload)
    except Exception as error:
        return Response(status=400)

    return add_entry(2, [id_oras, valoare])


@app.route('/api/temperatures/cities/<int:idd>', methods=['GET'])
def fetch_city(idd):
    fr = request.args.get('from')
    to = request.args.get('until')
    resp = db.query(Temperature).filter_by(id_oras=idd)

    try:
        if len(fr) != 0:
            resp = [r for r in resp if datetime.strftime(r.ttimestamp, '%Y-%m-%d') >= fr]
        if len(to) != 0:
            resp = [r for r in resp if datetime.strftime(r.ttimestamp, '%Y-%m-%d') <= to]

        return Response(status=200, response=json.dumps([r.get_json() for r in resp]))
    except Exception:
        ret = []
        return Response(status=200, response=json.dumps([r.get_json() for r in ret]))

@app.route('/api/temperatures/countries/<int:idd>', methods=['GET'])
def fetch_temperatures_country(idd):
    fr = request.args.get('from')
    to = request.args.get('until')
    resp = db.query(Temperature).all()

    try:
        if len(fr) != 0:
            resp = [r for r in resp if datetime.strftime(r.ttimestamp, '%Y-%m-%d') >= fr]
        if len(to) != 0:
            resp = [r for r in resp if datetime.strftime(r.ttimestamp, '%Y-%m-%d') <= to]

        ret = [city.id for city in db.query(City).all() if city.id_tara == idd]
        resp = [r for r in resp if r.id_oras in ret]
        return Response(status=200, response=json.dumps([r.get_json() for r in resp]))
    except Exception:
        ret = []
        return Response(status=200, response=json.dumps([r.get_json() for r in ret]))

@app.route('/api/temperatures/<int:idd>', methods=['PUT'])
def update_temperatures(idd):
    payload = request.get_json()

    try:
        id_oras, valoare = check_json(TEMPERATURE, payload)
    except Exception as error:
        return Response(status=400)

    try:
        db.query(Temperature).filter_by(id=idd).update({"id_oras": id_oras, "valoare": valoare})
        db.commit()
    except Exception as error:
        return Response(status=404)
    return Response(status=200)


@app.route('/api/temperatures/<int:idd>', methods=['DELETE'])
def delete_temperatures(idd):
    return delete_entry(TEMPERATURE, idd)


if __name__ == '__main__':
    app.run(host='0.0.0.0')

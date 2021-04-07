FROM python:3.7-alpine3.7
COPY . /mqttadapter
WORKDIR /mqttadapter
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install -r requirements.txt --no-cache-dir
EXPOSE 9001
ENTRYPOINT [ "python3" ]
CMD [ "-u", "mqttadapter.py" ]

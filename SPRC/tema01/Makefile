build:
	rpcgen -C db.x
	g++ -o server rpc_server.cpp db_svc.c db_xdr.c -lnsl -Wall
	g++ -o client rpc_client.cpp db_clnt.c db_xdr.c  -lnsl -Wall

clean:
	rm -f client server db.h db_svc.c db_clnt.c db_xdr.c
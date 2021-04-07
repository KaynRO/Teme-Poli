build:
	rpcgen -C sum.x
	gcc -o server rpc_server.c sum_svc.c sum_xdr.c -lnsl -Wall
	gcc -o client rpc_client.c sum_clnt.c sum_xdr.c  -lnsl -Wall

clean:
	rm -f client server sum.h sum_svc.c sum_clnt.c
build:
	rpcgen -C grade.x
	gcc -o client rpc_client.c grade_clnt.c grade_xdr.c  -lnsl -Wall

clean:
	rm -f client grade.h grade_svc.c grade_clnt.c grade_xdr.c
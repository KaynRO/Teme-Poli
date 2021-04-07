#include <cstdio>
#include <rpc/rpc.h>
#include <string>
#include "db.h"

#define RMACHINE "localhost"
#define CHR_MAX 100

using namespace std;

char *username = (char*) malloc (CHR_MAX * sizeof(char));
unsigned long session_key = 0;

//Send the struct to the RPC server and print the response
void send_command(cmd command, CLIENT *handle, FILE *fp){
	char **response = process_command_1(&command, handle);
	fprintf(fp, "--------------------------------\n%s", *response);

	if(strncmp(command.cmd_name, "login", 5) == 0 && strncmp(*response, "Session", 7) == 0)
		sscanf(*response, "Session key: %ld", &session_key);

	if(strcmp(command.cmd_name, "logout") == 0)
		session_key = 0;
}


//For each line read, split using ' ' as token and format the data to fit in the command struct. Do some sanity checks for invalid data.
void process_line(char *line, CLIENT *handle, FILE *fp){
	cmd command;
	command.cmd_name = (char*) malloc (CHR_MAX * sizeof(char));
	command.data.values.values_val = NULL;
	command.data.values.values_len = 0;
	command.data.data_id = 0;
	char *pch = strtok(line, " \n");
	char *pch2;

	if(strcmp(pch, "login") == 0){
		pch2 = strtok(NULL, "\n");

		if(session_key != 0)
			fprintf(fp, "--------------------------------\n[!] Can't have more than 1 active connections. Please log out first\n");
		else{
			sprintf(command.cmd_name, "%s %s", pch, pch2);
			command.session_key = 0;
			send_command(command, handle, fp);
		}

		return;
	}

	else if(strcmp(pch, "load") == 0 || strcmp(pch, "store") == 0 || strcmp(pch, "get_stat_all") == 0 || strcmp(pch, "logout") == 0);

	else if(strcmp(pch, "add") == 0 || strcmp(pch, "update") == 0){
		pch2 = strtok(NULL, " ");
		if(pch2 == NULL){
			fprintf(fp, "--------------------------------\n[!] Command has too few arguments\n");
			return;
		}
		sscanf(pch2, "%d", &command.data.data_id);

		pch2 = strtok(NULL, " ");
		if(pch2 == NULL){
			fprintf(fp, "--------------------------------\n[!] Command has too few arguments\n");
			return;
		}
		sscanf(pch2, "%d", &command.data.values.values_len);

		command.data.values.values_val = (float*) malloc (command.data.values.values_len * sizeof(float));
		for(u_int i = 0 ; i < command.data.values.values_len ; i++){
			pch2 = strtok(NULL, " ");
			if(pch2 == NULL){
				fprintf(fp, "--------------------------------\n[!] Command has too few arguments\n");
				return;
			}
			sscanf(pch2, "%f", &command.data.values.values_val[i]);
		}
	}

	else if(strcmp(pch, "del") == 0 || strcmp(pch, "read") == 0 || strcmp(pch, "get_stat") == 0){
		pch2 = strtok(NULL, " ");
		if(pch2 == NULL){
			fprintf(fp, "--------------------------------\n[!] Command has too few arguments\n");
			return;
		}
		sscanf(pch2, "%d", &command.data.data_id); 

	}
	else{
		fprintf(fp, "--------------------------------\n[!] Command format is wrong\n");
		return;
	}

	sprintf(command.cmd_name, "%s", pch);
	command.session_key = session_key;
	send_command(command, handle, fp);
}


int main(int argc, char *argv[]){
	CLIENT *handle;
	FILE* fpi, *fpo;

	char *line = NULL;
	size_t len = 0;
	ssize_t read;

	handle = clnt_create(
				RMACHINE,
				DB_PROG,
				DB_VERS,
				"tcp"
	);

	if (handle == NULL){
		perror("Handle creation returned NULL");
		return -1;
	}


	//We have 2 options: read from stdin which implies write to stdin for the commands and results
	//read from input file and write to output file where both filenames should be given as program parameters
	if(argc == 3)
		fpi = fopen(argv[1], "r"), fpo = fopen(argv[2], "w");
	else if(argc == 1)
		fpi = stdin, fpo = stdout;

	sprintf(username, "ERROR");
	if(fpo == stdout)
		fprintf(fpo, "--------------------------------\n");

	while((read = getline(&line, &len, fpi)) != -1){
		if(strcmp(line, "exit\n") == 0)
			return 0;

		process_line(line, handle, fpo);
		if(fpo == stdout)
			fprintf(fpo, "--------------------------------\n");
	}

	if(argc == 3)
		fclose(fpi), fclose(fpo);

	return 0;
}
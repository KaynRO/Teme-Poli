
#include <cstdio>
#include <cmath>
#include <cfloat>
#include <time.h>
#include <rpc/rpc.h>
#include <vector>
#include <algorithm>
#include <map>
#include <utility>
#include <numeric>
#include <fstream>
#include <fcntl.h>
#include "db.h"

#define CHR_MAX 1000

using namespace std;

struct data_stat{
	float minn;
	float maxx;
	float median;
};


//Define data structure that will hold every logged in user's data(data in memory after load)
map<string, pair<unsigned long, sensor_data*>> user_data;
map<string, short int> user_error;
typedef pair<unsigned long, sensor_data*> ppair;


string get_username(unsigned long session_key){
	for (map<string, ppair>::iterator it = user_data.begin() ; it != user_data.end() ; ++it)
		if(it->second.first == session_key)
			return it->first;

	return string("");
}

//Function that will load user data from the database
sensor_data* get_user_data(string username){
	sensor_data *data = (sensor_data*) malloc (CHR_MAX * sizeof(sensor_data));
	char filename[CHR_MAX];
	char *line = NULL;
	size_t len = 0;
	ssize_t read;
	unsigned int cnt = 0;

	for(int i = 0 ; i < CHR_MAX ; i++)
		data[i].values.values_len = 0;

	sprintf(filename, "db/%s.db", username.c_str());
	FILE* fp = fopen(filename, "r");

	if(fp == NULL){
		creat(filename, 0666);
		fp = fopen(filename, "r");
	}

	//Read line by line and create a vector of sensor_data
	while((read = getline(&line, &len, fp)) != -1){
		char *pch = strtok(line, " ");
		sscanf(pch, "%d", &data[cnt].data_id);

		pch = strtok(NULL, " ");
		sscanf(pch, "%d", &data[cnt].values.values_len);

		data[cnt].values.values_val = (float*) malloc (data[cnt].values.values_len * sizeof(float));
		for(u_int i = 0 ; i < data[cnt].values.values_len; i++){
			pch = strtok(NULL, " ");
			sscanf(pch, "%f", &data[cnt].values.values_val[i]);
		}
		
		cnt++;
	}

	fclose(fp);
	return data;
}


//Check if a user is logged in
short int is_user_logged(string username){
	if(user_data.find(username) == user_data.end())
		return 0;

	return 1;
}


//Log in a user only if he was not already. Generate session key based on current epochs
unsigned long login(string username){
	if(is_user_logged(username))
		return 1;

	ppair pp((unsigned long)time(NULL), NULL);
	user_data[username] = pp;
	return user_data[username].first;
}


//Remove username data from memory
unsigned long logout(string username){
	user_data.erase(username);
	return 1;
}


//Check if a specific user has a data where data_id = params[1]
short int user_has_data(int data_id, string username){
	sensor_data *data = user_data[username].second;
	for(int i = 0 ; i < CHR_MAX ; i++)
		if(data[i].data_id == data_id && data[i].values.values_len != 0)
			return 1;

	return 0;
}


//Create a new copy of a sensor_data to avoid overlapping
sensor_data* replicate_data(sensor_data data){
	sensor_data *temp = (sensor_data*) malloc (sizeof(sensor_data));
	temp->data_id = data.data_id;
	temp->values.values_len = data.values.values_len;
	temp->values.values_val = (float*) malloc (data.values.values_len * sizeof(float));

	for(u_int i = 0 ; i < data.values.values_len ; i++)
		temp->values.values_val[i] = data.values.values_val[i];

	return temp;
}


//If data_id does not exist, add a new entry
short int add(sensor_data data, string username){
	if(user_has_data(data.data_id, username)) 
		return 0;

	for(int i = 0 ; i < CHR_MAX ; i++)
		if(user_data[username].second[i].values.values_len == 0){
			user_data[username].second[i] = *replicate_data(data);
			break;
		}

	return 1;
}


//If data_id exists, delete the item by marking values_len = 0. If there is no values then the data is considered NULL
short int del(int data_id, string username){
	if(!user_has_data(data_id, username))
		return 0;

	for(int i = 0 ; i < CHR_MAX ; i++)
		if(user_data[username].second[i].values.values_len != 0 && user_data[username].second[i].data_id == data_id){
			user_data[username].second[i].values.values_len = 0;
			break;
		}

	return 1;    
}


//If data_id exists update it, otherwise call add function
short int update(sensor_data data, string username){
	if(!user_has_data(data.data_id, username))
		return add(data, username);

	for(int i = 0 ; i < CHR_MAX ; i++)
		if(user_data[username].second[i].values.values_len != 0 && user_data[username].second[i].data_id == data.data_id){
			user_data[username].second[i] = *replicate_data(data);
			break;
		}

	return 1;
}


//Return sensor_data struct that has data_id or a struct where values_len = 0 as an error.
sensor_data read(int data_id, string username){
	sensor_data error;
	error.values.values_len = 0;

	if(!user_has_data(data_id, username))
		return error;

	for(int i = 0 ; i < CHR_MAX ; i++)
		if(user_data[username].second[i].values.values_len != 0 && user_data[username].second[i].data_id == data_id)
			return user_data[username].second[i];

	return error;
}


//For the data_id, calculate the vector min, max element and vector_sum/vector_length
data_stat get_stat(int data_id, string username){
	data_stat error, stat;

	error.minn = FLT_MAX;
	error.maxx = FLT_MIN;
	if(!user_has_data(data_id, username))
		return error;

	for(int i = 0 ; i < CHR_MAX ; i++){
		sensor_data ddata = user_data[username].second[i];
		if(ddata.data_id == data_id && ddata.values.values_len != 0){
			stat.minn = *min_element(ddata.values.values_val, ddata.values.values_val + ddata.values.values_len);
			stat.maxx = *max_element(ddata.values.values_val, ddata.values.values_val + ddata.values.values_len);
			
			sort(ddata.values.values_val, ddata.values.values_val + ddata.values.values_len);
			if(ddata.values.values_len % 2 == 0)
				stat.median = (ddata.values.values_val[ddata.values.values_len / 2 - 1] + ddata.values.values_val[ddata.values.values_len / 2]) / (float) 2;
			else
				stat.median = ddata.values.values_val[ddata.values.values_len / 2];

			break;
		}
	}

	return stat;
}


//Return a list of data_stat for each database entry
data_stat *get_stat_all(string username){
	data_stat *stat = (data_stat*) malloc (CHR_MAX * sizeof(data_stat));

	for(int i = 0 ; i < CHR_MAX ; i++)
		stat[i] = get_stat(i, username);

	return stat;
}


//Call get_user_data and add map entry
short int load(string username){
	if(!user_error[username])
		return 0;

	user_data[username].second = (sensor_data*) malloc (CHR_MAX * sizeof(sensor_data));
	user_data[username].second = get_user_data(username);
	return 1;
}


//Copy all data from map(memory) to a file
short int store(string username){
	char filename[CHR_MAX];

	sprintf(filename, "db/%s.db", username.c_str());
	FILE* fp = fopen(filename, "w+");

	for(int i = 0 ; i < CHR_MAX ; i++){
		if(user_data[username].second[i].values.values_len != 0){
		fprintf(fp, "%d %d", user_data[username].second[i].data_id, user_data[username].second[i].values.values_len);
		for(u_int j = 0 ; j < user_data[username].second[i].values.values_len ; j++)
			fprintf(fp, " %f", user_data[username].second[i].values.values_val[j]);
		fprintf(fp, "\n");
		}
	}

	fclose(fp);
	return 1;
}


//Server handler function, receives a command struct and return a message based on the outcome of the operation on the DB
char **process_command_1_svc(cmd *command, svc_req *c1){
	static char *text = (char*) malloc (CHR_MAX * sizeof(char));
	char *pch;
	short int res1 = -1, res2 = -1, res3 = -1, res4 = -1, res5 = -1, res6 = -1;
	unsigned long key = 0;

	data_stat stat, *statt = NULL;
	sensor_data data;

	data.values.values_val = NULL;
	stat.minn = FLT_MIN;

	if(strncmp(command->cmd_name, "login", 5) == 0){
		pch = strtok(command->cmd_name, " ");
		pch = strtok(NULL, "\n");
		key = login(string(pch));
	}
	else if(strcmp(command->cmd_name, "logout") == 0)
		res1 = logout(get_username(command->session_key));
	else if(strcmp(command->cmd_name, "load") == 0)
		res6 = load(get_username(command->session_key));

	//If we have an operation that requires prior database load
	else {

		if(user_data.find(get_username(command->session_key)) == user_data.end() || user_data[get_username(command->session_key)].second == NULL){
			sprintf(text, "No database loaded into memory\n");
			user_error[get_username(command->session_key)] = 0;
			return &text;
		}

		else{
			if(strcmp(command->cmd_name, "add") == 0)
				res2 = add(command->data, get_username(command->session_key));
			else if(strcmp(command->cmd_name, "store") == 0)
				res3 = store(get_username(command->session_key));
			else if(strcmp(command->cmd_name, "read") == 0)
				data = read(command->data.data_id, get_username(command->session_key));
			else if(strcmp(command->cmd_name, "update") == 0)
				res4 = update(command->data, get_username(command->session_key));
			else if(strcmp(command->cmd_name, "del") == 0)
				res5 = del(command->data.data_id, get_username(command->session_key));
			else if(strcmp(command->cmd_name, "get_stat") == 0)
				stat = get_stat(command->data.data_id, get_username(command->session_key));
			else if(strcmp(command->cmd_name, "get_stat_all") == 0)
				statt = get_stat_all(get_username(command->session_key));
		}
	}

	//If we just had a login, send back the session key
	if(key == 1)
		sprintf(text, "User already authenticated\n");
	else if(key > 1){
		sprintf(text, "Session key: %ld\n", key);
		user_error[get_username(key)] = 1;
	}

	//If the session key provided is not a valid entry
	else if(get_username(command->session_key) == "" && strcmp(command->cmd_name, "logout") != 0)
		sprintf(text, "Login in first\n");

	else if(res1 == 0 || res2 == 0 || res3 == 0 || res4 == 0 || res5 == 0)
		sprintf(text, "Data ID does not/already exists\n");
	else if(res6 == 0)
		sprintf(text, "Load command should only follow a login\n");
	else if(res1 == 1)
		sprintf(text, "Logout successfully\n");
	else if(res2 == 1)
		sprintf(text, "Data Add successfull\n");
	else if(res3 == 1)
		sprintf(text, "Store successfull\n");
	else if(res4 == 1)
		sprintf(text, "Update successfull\n");
	else if(res5 == 1)
		sprintf(text, "Delete successfull\n");
	else if(res6 == 1)
		sprintf(text, "Load successfull\n");

	else if(stat.minn != FLT_MAX && stat.minn != FLT_MIN)
		sprintf(text, "Min: %f, Max: %f, Median: %f\n", stat.minn, stat.maxx, stat.median);
	else if(stat.minn == FLT_MAX)
		sprintf(text, "Incorrect Data ID\n");

	else if(data.values.values_val != NULL && data.values.values_len != 0){
		sprintf(text, "Data ID: %d\nNo Values: %d\nValues:", data.data_id, data.values.values_len);
		for(u_int i = 0 ; i < data.values.values_len ; i++){
			char *tmp = (char*) malloc (CHR_MAX * sizeof(char));
			sprintf(tmp, " %f", data.values.values_val[i]);
			strcat(text, tmp);
		}
		sprintf(text + strlen(text), "\n");
	}
	else if(data.values.values_len == 0 && data.values.values_val != NULL)
		sprintf(text, "Data ID does not exists\n");

	else if(statt != NULL){
		sprintf(text, "");
		for(int i = 0 ; i < CHR_MAX ; i++)
			if(statt[i].maxx != FLT_MIN && statt[i].minn != FLT_MAX)
				sprintf(text + strlen(text), "Min: %f, Max: %f, Median: %f\n", statt[i].minn, statt[i].maxx, statt[i].median);
	}

	return &text;
}
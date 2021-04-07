struct sensor_data{
    int data_id;
    float values<>;
};

struct cmd{
	string cmd_name<>;
	unsigned long session_key;
	sensor_data data;
};

program DB_PROG{
	version DB_VERS{
		string PROCESS_COMMAND(cmd) = 1;
	} = 1;
} = 94733;
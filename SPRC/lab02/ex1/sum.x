struct sum_req{
    int a;
    int b;
};

program SUM_PROG{
    version SUM_VERS{
        int GET_SUM(sum_req) = 1;
    } = 1;
} = 0x31234567;

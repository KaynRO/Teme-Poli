const TEXT_LENGTH = 100;

struct student{
    string nume<>;
    string grupa<>;
};

program CHECK_PROG{
    version CHECK_VERS{
        string GRADE(student) = 1;
    } = 1;
} = 0x31234567;
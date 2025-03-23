#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
    if(argc < 2) {
        printf("Usage: vatopa virtual_address [pid]\n");
        exit(1);
    }

    uint64 va = atoi(argv[1]);
    int pid = (argc > 2) ? atoi(argv[2]) : 0;

    uint64 pa = va2pa(va, pid);
    if(pa == 0) {
        printf("0x0\n");
    } else {
        printf("0x%x\n", pa);
    }
    exit(0);
}

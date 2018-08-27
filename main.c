#include <stdio.h>
#include <dlfcn.h>

#include "libhello.h"

int main(void) {
    void* libhello_handle = dlopen("./libhello.so", RTLD_NOW | RTLD_GLOBAL);
    // Look ma! No dlsym() or anything

    if (libhello_handle) {
        dynamic_hello_world();
	int result = dynamic_mul(10, 20);
	printf("Dynamic result of dynamic_mul(10,20): %i\n", result);
	printf("\n");
    	printf("It is safe to delete libhello.so, try it and run me again!\n");
    } else {
        printf("Could not load library, not crashing!\n");
    }

    return 0;
}

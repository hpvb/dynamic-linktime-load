# Small demo of loading dependent .so files at runtime

This project shows how to load a .so file at runtime without linking to it at compile time. This allows for a program to have optional runtime dependencies without generating a full stub for the library using `dlopen()` and then using `dlsym()` for each used symbol.

We achieve this by exploiting several mechanisms:

  * Weak symbol linkage
  * GCC's `#pragma weak`
  * GCC's `-fpie` (Position Independent Executable) flag

We use a `readelf` to generate a .c file with a `#pragma weak` for each of the exported symbols of a particular .so file. This means that the software author does not have to keep track of what symbols are in use (such as with the `dlsym()` approach) nor does a complicated generator have to be written.

Instead we *only* `dlopen()` the target library with `RTLD_NOW` and `RTLD_GLOBAL` to overwrite the weak (non-existant!) symbols in the position independent executable.

From the demo project:

```c
void* libhello_handle = dlopen("./libhello.so", RTLD_NOW | RTLD_GLOBAL);
if (libhello_handle) {
    puts("We loaded our library");
} else {
    puts("We failed to load our library");
}

```

To get a feel for how little the programmer has to think about this try adding a function to libhello.c/h and call it from main.c.

# Have your PIE and eat it too

Dissassembly comparison:

PIE:
```
  4006ba:	b8 00 00 00 00       	mov    $0x0,%eax
  4006bf:	e8 cc fe ff ff       	callq  400590 <dynamic_hello_world@plt>
```

Regular linkage (non-PIE):
```
  400788:	b8 00 00 00 00       	mov    $0x0,%eax
  40078d:	e8 ce fe ff ff       	callq  400660 <dynamic_hello_world@plt>
```

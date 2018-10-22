all: main libhello.so

main: main.c libhello-weak.c
	$(CC) main.c -include libhello-weak.c -o main -ldl -no-pie -fpie

libhello-weak.c: libhello.so
	./make-stub.sh libhello.so > libhello-weak.c

libhello.so: libhello.c
	$(CC) libhello.c -shared -fpic -o libhello.so

clean:
	rm -f main libhello-weak.c libhello.so

all: main libhello.so

main: main.c libhello-weak.c
	gcc main.c -include libhello-weak.c -o main -ldl -fpie

libhello-weak.c: libhello.so
	python make-stub.py libhello.so > libhello-weak.c

libhello.so: libhello.c
	gcc libhello.c -shared -fpic -o libhello.so

clean:
	rm -f main libhello-weak.c libhello.so

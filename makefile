all: main.exe
	

main.exe: main.o
	gcc -o main.exe main.o 

main.o: main.c
	gcc -c main.c

clean:
	rm main.o main.c

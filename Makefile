.PHONY: all
all: main

main: main.o
	gcc -Wall -Wextra -z noexecstack -o main main.o ./raylib/lib/libraylib.a -lm

main.o: main.asm
	fasm main.asm

.PHONY: clean
clean:
	rm -f main.o main

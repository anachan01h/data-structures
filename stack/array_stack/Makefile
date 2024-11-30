NAME = main

all: clean bin/$(NAME)

bin/$(NAME): bin/$(NAME).o
	gcc -o bin/$(NAME) bin/$(NAME).o -no-pie

bin/$(NAME).o: $(NAME).asm bin/
	nasm -f elf64 -o bin/$(NAME).o $(NAME).asm

bin/:
	mkdir bin

.PHONY: clean

clean:
	rm -rf bin

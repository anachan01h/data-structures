.PHONY: tests clean

bin/:
	mkdir bin

bin/lib.o: src/lib.asm include/def.inc | bin/
	nasm -f elf64 src/lib.asm -o bin/lib.o

bin/on_stack.o: tests/on_stack.asm include/def.inc | bin/
	nasm -f elf64 tests/on_stack.asm -o bin/on_stack.o

bin/on_stack: bin/lib.o bin/on_stack.o
	gcc bin/lib.o bin/on_stack.o -o bin/on_stack -no-pie

clean: rm -rf bin

.PHONY: clean

bin/lib.o: src/lib.asm include/utils.inc | bin/
	nasm -f elf64 src/lib.asm -o bin/lib.o

bin/:
	mkdir bin

clean:
	rm -rf bin

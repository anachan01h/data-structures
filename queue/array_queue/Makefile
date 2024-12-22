.PHONY: tests clean

tests: bin/test
	./bin/test

bin/lib.o: src/lib.asm include/utils.inc | bin/
	nasm -f elf64 src/lib.asm -o bin/lib.o

bin/test.o: tests/test.asm include/utils.inc | bin/
	nasm -f elf64 tests/test.asm -o bin/test.o

bin/test: bin/lib.o bin/test.o
	gcc bin/lib.o bin/test.o -o bin/test -no-pie

bin/:
	mkdir bin

clean:
	rm -rf bin

# Directory with dynamic array implementation
DIR = ../../concrete/dynamic_array

.PHONY: tests clean

tests: bin/test
	./bin/test

$(DIR)/bin/lib.o:
	@$(MAKE) -C $(DIR)

bin/lib.o: src/lib.asm include/utils.inc | bin/
	nasm -f elf64 src/lib.asm -o bin/lib.o

bin/test.o: tests/test.asm include/utils.inc | bin/
	nasm -f elf64 tests/test.asm -o bin/test.o

bin/test: $(DIR)/bin/lib.o bin/lib.o bin/test.o
	gcc $(DIR)/bin/lib.o bin/lib.o bin/test.o -o bin/test -no-pie

bin/:
	mkdir bin

clean:
	rm -rf bin

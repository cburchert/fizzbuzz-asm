all:
	nasm -f elf64 -o fizz.o fizz.s
	ld -o fizz fizz.o

clean:
	rm -f fizz.o

distclean: clean
	rm fizz

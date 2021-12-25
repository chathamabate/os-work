
kernel.bin: kernel.o entry.o
	i386-elf-ld -o kernel.bin -Ttext 0x1000 --oformat binary $^

kernel.o: kernel.c
	i386-elf-gcc -ffreestanding -c $< -o $@
 
entry.o: entry.asm
	nasm $< -f elf -o $@

clean:
	rm *.o *.bin



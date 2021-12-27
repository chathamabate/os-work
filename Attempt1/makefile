

C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS =  $(wildcard kernel/*.h drivers/*.h)

OBJ = ${C_SOURCES:.c=.o}

all: os-image

run: all
	qemu-system-x86_64 -drive format=raw,file=os-image

os-image: boot/boot_sector.bin kernel.bin 
	cat $^ > os-image

kernel.bin: kernel/entry.o ${OBJ}
	i386-elf-ld -o $@ -Ttext 0x1000 --oformat binary $^

boot/boot_sector.bin: boot/*.asm boot/*/*.asm
	nasm $< -f bin -I './boot/' -o $@

kernel/entry.o: kernel/entry.asm
	nasm $< -f elf -o $@

%.o: %.c ${HEADERS}
	i386-elf-gcc  -ffreestanding -c $< -o $@

clean:
	rm ./*/*.o *.bin ./*/*.bin os-image



# First Attempt
# os-image: boot_sector.bin kernel.bin
# 	cat $^ > os-image   

# kernel.bin: entry.o kernel.o
# 	i386-elf-ld -o kernel.bin -Ttext 0x1000 --oformat binary $^

# kernel.o: kernel.c
# 	i386-elf-gcc -ffreestanding -c $< -o $@
 
# entry.o: entry.asm
# 	nasm $< -f elf -o $@

# boot_sector.bin: lib16/*.asm g32.asm gdt.asm boot_sector.asm
# 	nasm boot_sector.asm -f bin -o boot_sector.bin 

# # Utility commands :

# run: os-image
# 	qemu-system-x86_64 -drive format=raw,file=os-image

# clean:
# 	rm *.o *.bin



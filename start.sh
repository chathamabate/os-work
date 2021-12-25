nasm entry.asm -f elf -o entry.o

nasm boot_sector.asm -f bin -o boot_sector.bin 
i386-elf-gcc  -ffreestanding -c ./c/main.c -o ./c/main.o

i386-elf-ld -o ./c/main.bin -Ttext 0x1000 --oformat binary entry.o ./c/main.o

cat boot_sector.bin ./c/main.bin > os-image   
qemu-system-x86_64 -drive format=raw,file=os-image

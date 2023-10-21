
ASM 		:= nasm

SRC_DIR		:= src
BUILD_DIR	:= build

# Insert Path to mkfs.fat
MKFSFAT 	:= /usr/local/Cellar/dosfstools/4.2/sbin/mkfs.fat

.PHONY: all clean subdirs

all: subdirs $(BUILD_DIR)/main_floppy.img

# Create The build directory.
subdirs:
	mkdir -p build

# Create the bootloader.
$(BUILD_DIR)/bootloader.bin: $(SRC_DIR)/bootloader/main.asm
	$(ASM) $(SRC_DIR)/bootloader/main.asm -f bin -o $(BUILD_DIR)/bootloader.bin

# Create the kernel.
# $(BUILD_DIR)/kernel.bin: $(SRC_DIR)/kernel/main.asm
#	$(ASM) $(SRC_DIR)/kernel/main.asm -f bin -o $(BUILD_DIR)/kernel.bin

# Create the floppy disk image.
$(BUILD_DIR)/main_floppy.img: $(BUILD_DIR)/bootloader.bin
	dd if=/dev/zero of=$(BUILD_DIR)/main_floppy.img bs=512 count=2880
	$(MKFSFAT) -F 12 -n "MYOS" $(BUILD_DIR)/main_floppy.img
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/main_floppy.img conv=notrunc

# Delete the build folder.
clean:
	rm -r build

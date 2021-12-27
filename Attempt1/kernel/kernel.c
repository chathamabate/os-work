

#include "../drivers/display.h"

void main() {
    clear_screen(0x0F);
    display_string(0, 0, 0x0F, "OS Has Started!");
    display_string(1, 0, 0x03, "Welcome!");
}
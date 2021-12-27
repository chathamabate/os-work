
#include "display.h"
#include "../kernel/low_level.h"

void clear_screen(u8 attr) {
    u8 *iter;

    for (iter = (u8 *)VIDEO_MEMORY; iter < (u8 *)VIDEO_MEMORY_END; iter += 2) {
        iter[0] = 0x00;
        iter[1] = attr;
    }
}

void display_string(u8 row, u8 col, u8 attr, u8 *str) {
    u8 *iter = ((u8 *)VIDEO_MEMORY) + ((row * MAX_COLS) + col) * 2;
    u8 *s_iter = str;

    for (; iter < (u8 *)VIDEO_MEMORY_END && *s_iter; s_iter++) {
        if (*s_iter == '\n') {
            u32 offset = (u32)iter - VIDEO_MEMORY;
            u32 row_number = offset / (MAX_COLS * 2);

            iter = (u8 *)VIDEO_MEMORY + (MAX_COLS * 2 * (row_number + 1));
        } else {
            iter[0] = *s_iter;
            iter[1] = attr;

            iter += 2;
        }
    }
}


// int get_cursor() {
//     // First get the cursor offset.
//     port_byte_out(REG_SCREEN_CTRL, 14);
//     unsigned short offset = port_byte_in(REG_SCREEN_DATA) << 8;

//     port_byte_out(REG_SCREEN_CTRL, 15);
//     offset += port_byte_in(REG_SCREEN_DATA);

//     return offset * 2;
// }

// void set_cursor(int offset) {
//     offset /= 2;

//     port_byte_out(REG_SCREEN_CTRL, 14);
//     port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
//     port_byte_out(REG_SCREEN_CTRL, 15);
//     port_byte_out(REG_SCREEN_DATA, (unsigned char)offset);
// }

// void append_character(char character, char attrs) {
//     int cursor = get_cursor();

//     if (cursor >= SPACES * 2) {
//         cursor = 0;
//     }

//     unsigned char *vm = (unsigned char *)VIDEO_MEMORY;

//     vm[cursor] = character;
//     vm[cursor + 1] = attrs;
// }
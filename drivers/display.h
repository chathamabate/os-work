
#ifndef DISPLAY_H
#define DISPLAY_H

#include "../kernel/types.h"

#define MAX_ROWS 25
#define MAX_COLS 80
#define SPACES MAX_ROWS * MAX_COLS

#define VIDEO_MEMORY 0xb8000
#define VIDEO_MEMORY_END VIDEO_MEMORY + (SPACES * 2)

#define WHITE 0xF
#define BLACK 0x0

// Display control ports.
#define REG_SCREEN_CTRL 0x3DA
#define REG_SCREEN_DATA 0x3D5

// Clear the screen into the given attribute.
void clear_screen(u8 attr);

// Display a string to the screen at the given row and column.
void display_string(u8 row, u8 col, u8 attr, u8 *str);

// // Get the byte offset of the cursor in video memory.
// int get_cursor();

// // Set the byte offset of the cursor in video memory.
// void set_cursor(int offset);

// // Append a character to the screen.
// // The character will be placed wherever the cursor is.
// // The cursor will be advanced.
// void append_character(char character, char attrs);

#endif


void bleh() {
    int a = 10;
}

void main() {
    char *video_memory = (char *)0xb8000;

    int i;
    for (i = 0; i < 5; i++) {
        video_memory[i * 2] = 'A';
        video_memory[(i * 2) + 1] = 0x1E;
    }
}
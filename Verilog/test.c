#include <stdio.h>
#include <stdint.h>

int8_t absi(int8_t a) {
	return a < 0 ? -a : a;
}

void main(void) {
	int8_t x0 = 57;
	int8_t y0 = 5;
	int8_t x1 = 4;
	int8_t y1 = 6;
	
	int8_t dx =  absi(x1-x0), sx = x0<x1 ? 1 : -1;
	int8_t dy = -absi(y1-y0), sy = y0<y1 ? 1 : -1; 
	int8_t err = dx+dy;
	int8_t e2;
	int ctr = 0;
	for(;;) {
		ctr++;
		if (x0==x1 && y0==y1) break;
		if(err >= 64) {
			err += dy;
			x0 += sx;
			continue;
		}
		if(err <= -64) {
			err += dx;
			y0 += sx;
			continue;
		}
		e2 = 2*err;
		printf("%d,%d\r\n", e2, err);
		if (e2 >= dy) { err += dy; x0 += sx; }
		if (e2 <= dx) { err += dx; y0 += sy; }
	}
	printf("%d %d %d\r\n", ctr, ctr, ctr);
}

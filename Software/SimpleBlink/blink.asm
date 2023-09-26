mem_start equ 2048

org 0
programentry:
	nop
	lodi,r0 0
	lpsl
	lodi,r0 32
	lpsu
	
	lodi,r0 4
	wrtc,r0
	lodi,r0 16
	wrtd,r0
loop:
	eorz,r0
	wrtc,r0
io_read_safe:
	redd,r0
	redd,r1
	comz,r1
	bcfr,eq io_read_safe
	andi,r0 16
	eori,r0 16
	lodi,r1 4
	wrtc,r1
	nop
	wrtd,r0

	lodi,r1 4
	lodi,r2 255
	lodi,r3 255
	tpsu 0b01000000
	cpsu 0b01000000
	bctr,eq delay
	ppsu 0b01000000
delay:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bdrr,r2 delay
	bdrr,r3 delay
	bdrr,r1 delay
	bcta,un loop

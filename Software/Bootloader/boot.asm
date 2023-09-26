mem_start equ 2048

org 0
programentry:
	nop
	lodi,r0 0
	lpsl
	lodi,r0 32
	lpsu
	
	bsta,un periph_init
	
	lodi,r3 255
copy_the_copy_loop:
	loda,r0 copy_loop_start,r3+
	stra,r0 7936,r3
	
	lodz,r3
	eori,r0 copy_loop_end-copy_loop_start
	bcfr,eq copy_the_copy_loop
	
	bsta,un rom_sel
	lodi,r0 0x03
	wrtd,r0
	bsta,un spi_wait
	eorz,r0
	wrtd,r0
	bsta,un spi_wait
	eorz,r0
	wrtd,r0
	bsta,un spi_wait
	eorz,r0
	wrtd,r0
	bsta,un spi_wait
	
	bcta,un 7937
	
error:
	lodi,r0 4
	wrtc,r0
	lodi,r0 6
	wrtd,r0
	lodi,r1 12
	lodi,r2 255
	lodi,r3 255
	tpsu 0b01000000
	cpsu 0b01000000
	bctr,eq error_delay
	ppsu 0b01000000
error_delay:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bdrr,r2 error_delay
	bdrr,r3 error_delay
	bdrr,r1 error_delay
	bctr,un error

spi_wait:
	eorz,r0
	wrtc,r0
spi_wait_loop:
	redd,r0
	tmi,r0 1
	bctr,eq spi_wait_loop
	lodi,r0 3
	wrtc,r0
	retc,un

rom_sel:
	lodi,r0 4
	wrtc,r0
	eorz,r0
	wrtd,r0
	lodi,r0 3
	wrtc,r0
	retc,un

rom_desel:
	lodi,r0 4
	wrtc,r0
	lodi,r0 1
	wrtd,r0
	retc,un

fb_write:
	lodi,r1 7
	wrtc,r1
fb_write_wait_loop:
	redd,r1
	tmi,r1 8
	bctr,eq fb_write_wait_loop
	wrtd,r0
	retc,un

periph_init:
	; Reset paging and SPI
	eorz,r0
	wrtc,r0
	wrtd,r0
	lodi,r2 2
	wrtc,r2
	wrtd,r0
	lodi,r2 5
	wrtc,r2
	wrtd,r0
	wrtd,r0
	bstr,un rom_desel
	
	; Clear FB
	lodi,r3 16
clear_fb_outer:
	lodi,r2 0
clear_fb_inner:
	eorz,r0
	bsta,un fb_write
	bdrr,r2 clear_fb_inner
	bdrr,r3 clear_fb_outer

	bsta,un rom_sel
	lodi,r0 0xFF
	wrtd,r0
	bsta,un spi_wait
	bsta,un rom_desel
	nop
	nop
	nop
	nop
	bsta,un rom_sel
	lodi,r0 0xAB
	wrtd,r0
	bsta,un spi_wait
	bsta,un rom_desel
	nop
	nop
	nop
	nop
	
	bsta,un rom_sel
	lodi,r0 0x90
	wrtd,r0
	bsta,un spi_wait
	eorz,r0
	wrtd,r0
	bsta,un spi_wait
	eorz,r0
	wrtd,r0
	bsta,un spi_wait
	eorz,r0
	wrtd,r0
	bsta,un spi_wait
	eorz,r0
	wrtd,r0
	bsta,un spi_wait
	lodi,r0 2
	wrtc,r0
	redd,r1
	bsta,un rom_desel
	nop
	
	comi,r1 0xAB
	retc,eq
	comi,r1 0xEF
	retc,eq
	comi,r1 0xC2
	retc,eq
	bcta,un error

copy_loop_start:
	db 0
	ppsl 8
copy_loop:
	lodi,r0 1
	andr,r0 copy_loop_ptr_lo
	bctr,eq clr_a
	cpsu 64
	bctr,un clr_b
clr_a:
	ppsu 64
clr_b:
	lodi,r0 3
	wrtc,r0
	eorz,r0
	wrtd,r0
copy_spi_wait_loop:
	redd,r0
	tmi,r0 1
	bctr,eq copy_spi_wait_loop
	lodi,r0 2
	wrtc,r0
	redd,r1
	
	strr,r1 *copy_loop_ptr_hi
	cpsl 1
	lodr,r0 copy_loop_ptr_lo
	addi,r0 1
	strr,r0 copy_loop_ptr_lo
	lodr,r0 copy_loop_ptr_hi
	addi,r0 0
	strr,r0 copy_loop_ptr_hi
	eori,r0 31
	bcfr,eq copy_loop
	
	lodi,r0 4
	wrtc,r0
	lodi,r0 1
	wrtd,r0
	
	cpsu 64
	bcta,un 0
copy_loop_ptr_hi:
	db 0
copy_loop_ptr_lo:
	db 0
	db 0
copy_loop_end:
	db 0

PSL_CC1          equ 0b10000000
PSL_CC0          equ 0b01000000
PSL_IDC          equ 0b00100000
PSL_BANK         equ 0b00010000
PSL_WITH_CARRY   equ 0b00001000
PSL_OVERFLOW     equ 0b00000100
PSL_LOGICAL_COMP equ 0b00000010
PSL_CARRY_FLAG   equ 0b00000001

root_mem_start equ 3840
mem_start equ 7900

CURR_ROW       equ mem_start+3
CURR_COL       equ mem_start+4
CURR_FRAME     equ mem_start+5

; Settings & graphics routine args
; All values 1 byte unless stated otherwise
APP_INDEX        equ root_mem_start+0
IO4_SHADOW       equ root_mem_start+1
CURR_VRAM_PAGE   equ root_mem_start+2
CURR_APP_DAT     equ root_mem_start+34 ; 3 bytes, pointer to current app’s data area

funct_table_begin equ 8
F_WAIT_NEXT_FRAME equ funct_table_begin+0
F_BEGIN_ROM_READ  equ funct_table_begin+6
F_SWAP_BUFFERS    equ funct_table_begin+14
F_NES_READ        equ funct_table_begin+38
F_ROM_DESEL       equ funct_table_begin+42
F_RUN_APP         equ funct_table_begin+44

TOTAL_FRAMES   equ 4383

org 4096
programentry:
	nop
	bsta,un *F_WAIT_NEXT_FRAME
	
	loda,r1 CURR_APP_DAT
	loda,r2 CURR_APP_DAT+1
	loda,r3 CURR_APP_DAT+2
	bsta,un *F_BEGIN_ROM_READ
	lodi,r0 3
	wrtc,r0
	wrtd,r0
	
ba_play_loop:
	bsta,un *F_NES_READ
	eorz,r0
	lodi,r2 5
	wrtc,r2
	wrtd,r0
	loda,r0 CURR_VRAM_PAGE
	wrtd,r0
	lodi,r0 0b01001001
	lodi,r1 7
	wrtc,r1
	lodi,r3 8
fill_fb_outer:
	lodi,r2 0
fill_fb_inner:
	redd,r1
	tmi,r1 8
	bctr,eq fill_fb_inner
	wrtd,r0
	bdrr,r2 fill_fb_inner
	bdrr,r3 fill_fb_outer
	
	eorz,r0
	stra,r0 CURR_ROW
ba_play_loop_rows:
	lodi,r0 5
	wrtc,r0
	loda,r0 CURR_ROW
	lodi,r1 64
	mul
	addi,r2 10
	ppsl PSL_WITH_CARRY
	adda,r3 CURR_VRAM_PAGE
	cpsl PSL_WITH_CARRY
	wrtd,r2
	wrtd,r3
	eorz,r0
	stra,r0 CURR_COL
ba_play_loop_cols:
	lodi,r0 2
	wrtc,r0
	redd,r2
	lodi,r0 3
	wrtc,r0
	wrtd,r0
	lodi,r3 8
ba_play_loop_pixels:
	lodi,r0 7
	wrtc,r0
	eorz,r0
	rrr,r2
	tmi,r2 128
	bcfr,eq ba_pixel_black
	subi,r0 1
ba_pixel_black:
	wrtd,r0
	loda,r0 CURR_COL
	addi,r0 1
	stra,r0 CURR_COL
	comi,r0 43
	bctr,eq ba_play_loop_col_done
	bdrr,r3 ba_play_loop_pixels
	bctr,un ba_play_loop_cols
ba_play_loop_col_done:
	loda,r0 CURR_ROW
	addi,r0 1
	stra,r0 CURR_ROW
	comi,r0 32
	bcfa,eq ba_play_loop_rows
	
	bsta,un *F_SWAP_BUFFERS
	bsta,un *F_WAIT_NEXT_FRAME
	loda,r0 CURR_FRAME
	addi,r0 1
	stra,r0 CURR_FRAME
	ppsl PSL_WITH_CARRY
	loda,r2 CURR_FRAME+1
	addi,r2 0
	stra,r2 CURR_FRAME+1
	cpsl PSL_WITH_CARRY
	eori,r0 TOTAL_FRAMES%256
	bcfa,eq ba_play_loop
	eori,r2 TOTAL_FRAMES>>8
	bcfa,eq ba_play_loop
	bsta,un *F_ROM_DESEL

halt:
	lodi,r0 4
	wrtc,r0
	loda,r0 IO4_SHADOW
	iori,r0 1+8+16
	stra,r0 IO4_SHADOW
	wrtd,r0
	lodi,r2 25
abcd:
	bsta,un *F_WAIT_NEXT_FRAME
	bdrr,r2 abcd
	eorz,r0
	stra,r0 APP_INDEX
	bcta,un *F_RUN_APP

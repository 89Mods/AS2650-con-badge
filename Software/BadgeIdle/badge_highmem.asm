PSL_CC1          equ 0b10000000
PSL_CC0          equ 0b01000000
PSL_IDC          equ 0b00100000
PSL_BANK         equ 0b00010000
PSL_WITH_CARRY   equ 0b00001000
PSL_OVERFLOW     equ 0b00000100
PSL_LOGICAL_COMP equ 0b00000010
PSL_CARRY_FLAG   equ 0b00000001

mem_start equ 7936
root_mem_start equ 3840

CURR_VRAM_PAGE   equ root_mem_start+2
FOREGROUND_COLOR equ root_mem_start+3
TRANSPARENT      equ root_mem_start+23

; Multiplication/division routine arguments
M32_A1       equ root_mem_start+42
M32_A2       equ root_mem_start+43
M32_A3       equ root_mem_start+44
M32_A4       equ root_mem_start+45
M32_B1       equ root_mem_start+46
M32_B2       equ root_mem_start+47
M32_B3       equ root_mem_start+48
M32_B4       equ root_mem_start+49
M32_RB1      equ root_mem_start+50
M32_RB2      equ root_mem_start+51
M32_RB3      equ root_mem_start+52
M32_RB4      equ root_mem_start+53
M32_RB5      equ root_mem_start+54
M32_RB6      equ root_mem_start+55
M32_RB7      equ root_mem_start+56
M32_RB8      equ root_mem_start+57
M32_UNSIGNED equ root_mem_start+59
ARITH_A1     equ root_mem_start+61
ARITH_A2     equ root_mem_start+62
ARITH_A3     equ root_mem_start+63
ARITH_A4     equ root_mem_start+64
ARITH_RB1    equ root_mem_start+65
ARITH_RB2    equ root_mem_start+66
ARITH_RB3    equ root_mem_start+67
ARITH_RB4    equ root_mem_start+68

funct_table_begin equ 8
F_WAIT_NEXT_FRAME equ funct_table_begin+0
F_FB_WRITE        equ funct_table_begin+2
F_FILL_FB         equ funct_table_begin+4
F_BEGIN_ROM_READ  equ funct_table_begin+6
F_BEGIN_MAP_READ  equ funct_table_begin+8
F_DRAW_BITMAP     equ funct_table_begin+10
F_DRAW_BYTEMAP    equ funct_table_begin+12
F_SWAP_BUFFERS    equ funct_table_begin+14
F_DRAW_RECT       equ funct_table_begin+16
F_DRAW_CHAR       equ funct_table_begin+18
F_DRAW_STR        equ funct_table_begin+20
F_DRAW_LINE       equ funct_table_begin+22
F_XORSHIFT        equ funct_table_begin+24
F_LOAD_APP_DATA   equ funct_table_begin+26
F_TRANS_PAGE_CALL equ funct_table_begin+28
F_MUL_32X32       equ funct_table_begin+30
F_FIXED_DIV       equ funct_table_begin+32
F_SINE            equ funct_table_begin+34
F_COS             equ funct_table_begin+36
F_NES_READ        equ funct_table_begin+38

; Mandel renderer vars
C1               equ mem_start+132
C2               equ mem_start+136
C3               equ mem_start+140
C4               equ mem_start+144
CURR_ROW         equ mem_start+148
CURR_COL         equ mem_start+149
C_IM             equ mem_start+150
C_RE             equ mem_start+154
MAN_X            equ mem_start+158
MAN_Y            equ mem_start+162
MAN_XX           equ mem_start+166
MAN_YY           equ mem_start+180
ITERATION        equ mem_start+184
M32_R1           equ mem_start+186
M32_R2           equ mem_start+187
M32_R3           equ mem_start+188
M32_R4           equ mem_start+189

; Pre-computed constants for w=64, h=32
M_WIDTH          equ 64
M_HEIGHT         equ 32
C1_PRE           equ 4096 ; 4 / w
C4_PRE           equ 4096 ; 2 / h
W_D2             equ 32
H_D2             equ 16

ZOOM equ 16000000
RE equ 0
IMAG equ 0
MAX_ITER equ 64

org 4096
funct_table:
	db mandel_demo%256
	db mandel_demo>>8
mandel_demo:
	spsl
	stra,r0 mandel_psl_back
	eorz,r0
	stra,r0 FOREGROUND_COLOR
	stra,r0 TRANSPARENT
	bsta,un *F_FILL_FB
	bsta,un *F_SWAP_BUFFERS
	bsta,un *F_FILL_FB
	bsta,un *F_WAIT_NEXT_FRAME
	eorz,r0
	stra,r0 CURR_VRAM_PAGE
	lodi,r1 2
	wrtc,r1
	wrtd,r0
	
	eorz r0
	stra,r0 M32_UNSIGNED
	
	; c1 = C1_PRE * ZOOM
	; c2 = W_D2 * c1
	eorz r0
	stra,r0 M32_A1
	stra,r0 M32_A4
	lodi,r0 C1_PRE%256
	stra,r0 M32_A2
	lodi,r0 C1_PRE>>8
	stra,r0 M32_A3
	lodi,r0 ZOOM%256
	stra,r0 M32_B1
	lodi,r0 ZOOM>>8%256
	stra,r0 M32_B2
	lodi,r0 ZOOM>>16%256
	stra,r0 M32_B3
	lodi,r0 ZOOM>>24%256
	stra,r0 M32_B4
	bsta,3 fixed_mul
	loda,r0 M32_R1
	stra,r0 C1+0
	stra,r0 M32_A1
	loda,r0 M32_R2
	stra,r0 C1+1
	stra,r0 M32_A2
	loda,r0 M32_R3
	stra,r0 C1+2
	stra,r0 M32_A3
	loda,r0 M32_R4
	stra,r0 C1+3
	stra,r0 M32_A4
	lodi,r0 W_D2
	stra,r0 M32_B4
	eorz r0
	stra,r0 M32_B1
	stra,r0 M32_B2
	stra,r0 M32_B3
	bsta,3 fixed_mul
	loda,r0 M32_R1
	stra,r0 C2+0
	loda,r0 M32_R2
	stra,r0 C2+1
	loda,r0 M32_R3
	stra,r0 C2+2
	loda,r0 M32_R4
	stra,r0 C2+3

	; c4 = C4_PRE * ZOOM
	; c3 = H_D2 * c4
	eorz r0
	stra,r0 M32_A1
	stra,r0 M32_A4
	lodi,r0 C4_PRE%256
	stra,r0 M32_A2
	lodi,r0 C4_PRE>>8
	stra,r0 M32_A3
	lodi,r0 ZOOM%256
	stra,r0 M32_B1
	lodi,r0 ZOOM>>8%256
	stra,r0 M32_B2
	lodi,r0 ZOOM>>16%256
	stra,r0 M32_B3
	lodi,r0 ZOOM>>24%256
	stra,r0 M32_B4
	bsta,3 fixed_mul
	loda,r0 M32_R1
	stra,r0 C4+0
	stra,r0 M32_A1
	loda,r0 M32_R2
	stra,r0 C4+1
	stra,r0 M32_A2
	loda,r0 M32_R3
	stra,r0 C4+2
	stra,r0 M32_A3
	loda,r0 M32_R4
	stra,r0 C4+3
	stra,r0 M32_A4
	lodi,r0 H_D2
	stra,r0 M32_B4
	eorz r0
	stra,r0 M32_B1
	stra,r0 M32_B2
	stra,r0 M32_B3
	bsta,3 fixed_mul
	loda,r0 M32_R1
	stra,r0 C3+0
	loda,r0 M32_R2
	stra,r0 C3+1
	loda,r0 M32_R3
	stra,r0 C3+2
	loda,r0 M32_R4
	stra,r0 C3+3
	
	ppsl PSL_WITH_CARRY
	lodi,r0 M_HEIGHT-1
mandel_loop_rows:
	stra,r0 CURR_ROW
	lodi,r0 M_HEIGHT-1
	ppsl PSL_CARRY_FLAG
	suba,r0 CURR_ROW
	lodi,r1 64
	mul
	lodi,r0 5
	wrtc,r0
	wrtd,r2
	wrtd,r3
	
	loda,r0 CURR_ROW
	; res = row * c4
	stra,r0 M32_B4
	loda,r0 C4+0
	stra,r0 M32_A1
	loda,r0 C4+1
	stra,r0 M32_A2
	loda,r0 C4+2
	stra,r0 M32_A3
	loda,r0 C4+3
	stra,r0 M32_A4
	eorz r0
	stra,r0 M32_B1
	stra,r0 M32_B2
	stra,r0 M32_B3
	bsta,3 fixed_mul
	; c_im = res + IMAG
	cpsl PSL_CARRY_FLAG
	loda,r0 M32_R1
	addi,r0 IMAG%256
	stra,r0 C_IM+0
	loda,r0 M32_R2
	addi,r0 IMAG>>8%256
	stra,r0 C_IM+1
	loda,r0 M32_R3
	addi,r0 IMAG>>16%256
	stra,r0 C_IM+2
	loda,r0 M32_R4
	addi,r0 IMAG>>24%256
	stra,r0 C_IM+3
	; c_im = c_im - c3
	lodi,r1 C_IM-mem_start
	lodi,r2 C_IM-mem_start
	lodi,r3 C3-mem_start
	bsta,un safe_sub
	
	eorz r0
	; Toggle LED
	tpsu 64
	cpsu 64
	bctr,eq mandel_loop_cols
	ppsu 64
mandel_loop_cols:
	stra,r0 CURR_COL
	; res = col * C1
	stra,r0 M32_B4
	loda,r0 C1+0
	stra,r0 M32_A1
	loda,r0 C1+1
	stra,r0 M32_A2
	loda,r0 C1+2
	stra,r0 M32_A3
	loda,r0 C1+3
	stra,r0 M32_A4
	eorz r0
	stra,r0 M32_B1
	stra,r0 M32_B2
	stra,r0 M32_B3
	lodi,r0 1
	stra,r0 M32_UNSIGNED
	bsta,3 fixed_mul
	eorz r0
	stra,r0 M32_UNSIGNED
	; c_re = res + RE
	cpsl PSL_CARRY_FLAG
	lodi,r0 RE%256
	eori,r0 255
	adda,r0 M32_R1
	stra,r0 C_RE+0
	lodi,r1 RE>>8%256
	eori,r1 255
	adda,r1 M32_R2
	stra,r1 C_RE+1
	lodi,r2 RE>>16%256
	eori,r2 255
	adda,r2 M32_R3
	stra,r2 C_RE+2
	lodi,r3 RE>>24%256
	eori,r3 255
	adda,r3 M32_R4
	stra,r3 C_RE+3
	; c_re = x = c_re - c2
	lodi,r1 C_RE-mem_start
	lodi,r2 C_RE-mem_start
	lodi,r3 C2-mem_start
	bsta,un safe_sub
	loda,r0 C_RE+0
	stra,r0 MAN_X+0
	loda,r0 C_RE+1
	stra,r0 MAN_X+1
	loda,r0 C_RE+2
	stra,r0 MAN_X+2
	loda,r0 C_RE+3
	stra,r0 MAN_X+3

	; y = c_im
	loda,r0 C_IM+0
	stra,r0 MAN_Y+0
	loda,r0 C_IM+1
	stra,r0 MAN_Y+1
	loda,r0 C_IM+2
	stra,r0 MAN_Y+2
	loda,r0 C_IM+3
	stra,r0 MAN_Y+3
	
	; iteration = 0
	eorz r0
	stra,r0 ITERATION+0
	stra,r0 ITERATION+1
mandel_calc_loop:
	; yy = y * y
	loda,r0 MAN_Y+0
	stra,r0 M32_A1
	stra,r0 M32_B1
	loda,r0 MAN_Y+1
	stra,r0 M32_A2
	stra,r0 M32_B2
	loda,r0 MAN_Y+2
	stra,r0 M32_A3
	stra,r0 M32_B3
	loda,r0 MAN_Y+3
	stra,r0 M32_A4
	stra,r0 M32_B4
	bsta,un fixed_mul
	loda,r0 M32_R1
	stra,r0 MAN_YY+0
	loda,r0 M32_R2
	stra,r0 MAN_YY+1
	loda,r0 M32_R3
	stra,r0 MAN_YY+2
	loda,r0 M32_R4
	stra,r0 MAN_YY+3
	; res = x * y
	loda,r0 MAN_X+0
	stra,r0 M32_A1
	loda,r0 MAN_Y+0
	stra,r0 M32_B1
	loda,r0 MAN_X+1
	stra,r0 M32_A2
	loda,r0 MAN_Y+1
	stra,r0 M32_B2
	loda,r0 MAN_X+2
	stra,r0 M32_A3
	loda,r0 MAN_Y+2
	stra,r0 M32_B3
	loda,r0 MAN_X+3
	stra,r0 M32_A4
	loda,r0 MAN_Y+3
	stra,r0 M32_B4
	bsta,un fixed_mul
	; regs = res << 1
	cpsl PSL_CARRY_FLAG
	loda,r0 M32_R1
	loda,r1 M32_R2
	loda,r2 M32_R3
	loda,r3 M32_R4
	rrl,r0
	rrl,r1
	rrl,r2
	rrl,r3
	; y = regs + c_im
	cpsl PSL_CARRY_FLAG
	; 1
	adda,r0 C_IM+0
	stra,r0 MAN_Y+0
	
	; 2
	loda,r0 C_IM+1
	tpsl 1
	bcfr,eq nofix407
	comi,r1 255
	bctr,eq fixed412
nofix407:
	addz,r1
fixed412:
	stra,r0 MAN_Y+1
	
	; 3
	loda,r0 C_IM+2
	tpsl 1
	bcfr,eq nofix419
	comi,r2 255
	bctr,eq fixed421
nofix419:
	addz,r2
fixed421:
	stra,r0 MAN_Y+2
	
	; 4
	adda,r3 C_IM+3
	stra,r3 MAN_Y+3
	; res = xx = x * x
	loda,r0 MAN_X+0
	stra,r0 M32_A1
	stra,r0 M32_B1
	loda,r0 MAN_X+1
	stra,r0 M32_A2
	stra,r0 M32_B2
	loda,r0 MAN_X+2
	stra,r0 M32_A3
	stra,r0 M32_B3
	loda,r0 MAN_X+3
	stra,r0 M32_A4
	stra,r0 M32_B4
	bsta,un fixed_mul
	loda,r0 M32_R1
	loda,r1 M32_R2
	loda,r2 M32_R3
	loda,r3 M32_R4
	stra,r0 MAN_XX+0
	stra,r1 MAN_XX+1
	stra,r2 MAN_XX+2
	stra,r3 MAN_XX+3
	; x = res - yy
	ppsl PSL_CARRY_FLAG
	loda,r1 MAN_YY+0
	eori,r1 0xFF
	comi,r0 255
	bcfr,eq nofix462
	loda,r0 M32_R1
	bctr,un fixed465
nofix462:
	loda,r0 M32_R1
	addz,r1
fixed465:
	stra,r0 MAN_X+0
	
	loda,r1 M32_R2
	tpsl 1
	bcfr,eq nofix474
	comi,r1 255
	bcfr,eq nofix474
	loda,r0 MAN_YY+1
	eori,r0 0xFF
	bctr,un fixed479
nofix474:
	loda,r0 MAN_YY+1
	eori,r0 0xFF
	addz,r1
fixed479:
	stra,r0 MAN_X+1
	
	loda,r1 M32_R3
	tpsl 1
	bcfr,eq nofix489
	comi,r1 255
	bcfr,eq nofix489
	loda,r0 MAN_YY+2
	eori,r0 0xFF
	bctr,un fixed494
nofix489:
	loda,r0 MAN_YY+2
	eori,r0 0xFF
	addz,r1
fixed494:
	stra,r0 MAN_X+2
	
	loda,r0 M32_R4
	suba,r0 MAN_YY+3
	stra,r0 MAN_X+3
	
	; x = x + c_re
	cpsl PSL_CARRY_FLAG
	; 1
	loda,r0 MAN_X+0
	adda,r0 C_RE+0
	stra,r0 MAN_X+0

	; 2
	tpsl 1
	bcfr,eq nofix496
	loda,r0 C_RE+1
	comi,r0 255
	bctr,eq fixed472
nofix496:
	loda,r0 MAN_X+1
	adda,r0 C_RE+1
	stra,r0 MAN_X+1
fixed472:

	; 3
	tpsl 1
	bcfr,eq nofix481
	loda,r0 C_RE+2
	comi,r0 255
	bctr,eq fixed484
nofix481:
	loda,r0 MAN_X+2
	adda,r0 C_RE+2
	stra,r0 MAN_X+2
fixed484:

	; 4
	loda,r0 MAN_X+3
	adda,r0 C_RE+3
	stra,r0 MAN_X+3
	
	; check if xx + yy <= 4
	cpsl PSL_CARRY_FLAG
	loda,r0 MAN_XX+0
	adda,r0 MAN_YY+0
	loda,r0 MAN_XX+1
	adda,r0 MAN_YY+1
	loda,r0 MAN_XX+2
	adda,r0 MAN_YY+2
	loda,r0 MAN_XX+3
	adda,r0 MAN_YY+3
	andi,r0 0b01111100
	bcfr,eq mandel_calc_loop_overflow

	; iteration++
	cpsl PSL_CARRY_FLAG
	loda,r0 ITERATION+0
	addi,r0 1
	stra,r0 ITERATION+0
	loda,r1 ITERATION+1
	addi,r1 0
	stra,r1 ITERATION+1
	comi,r1 MAX_ITER>>8
	bcfa,eq mandel_calc_loop
	comi,r0 MAX_ITER%256
	bcfa,eq mandel_calc_loop
	; Max iters exit
mandel_max_iters:
	lodi,r0 7
	wrtc,r0
	lodi,r0 0
	wrtd,r0
	bcta,un mandel_calc_loop_exit
mandel_calc_loop_overflow:
	lodi,r0 7
	wrtc,r0
	loda,r3 ITERATION
	andi,r3 0b00111111
	loda,r0 mandel_iter_colors,r3
	wrtd,r0
mandel_calc_loop_exit:
	; End col loop
	loda,r0 CURR_COL
	cpsl PSL_CARRY_FLAG
	addi,r0 1
	comi,r0 M_WIDTH
	bcfa,eq mandel_loop_cols
	
	bsta,un *F_WAIT_NEXT_FRAME

	; End row loop
	loda,r0 CURR_ROW
	ppsl PSL_CARRY_FLAG
	subi,r0 1
	comi,r0 255
	bcfa,eq mandel_loop_rows
	
	lodi,r2 40
end_delay:
	bsta,un *F_WAIT_NEXT_FRAME
	bdrr,r2 end_delay
	
	eorz,r0
	stra,r0 FOREGROUND_COLOR
	stra,r0 TRANSPARENT
	bsta,un *F_FILL_FB
	bsta,un *F_SWAP_BUFFERS
	bsta,un *F_FILL_FB
	bsta,un *F_SWAP_BUFFERS
	bsta,un *F_WAIT_NEXT_FRAME
	
	loda,r0 mandel_psl_back
	lpsl
	nop
	cpsu 64
	retc,un
mandel_psl_back:
	db 0
	
ret_workaround:
	db 0,0,0
fixed_mul:
	strr,r1 ret_workaround+2
	pop
	strr,r0 ret_workaround
	strr,r1 ret_workaround+1
	lodr,r1 ret_workaround+2
	bsta,un *F_MUL_32X32
	loda,r0 M32_RB4
	stra,r0 M32_R1
	loda,r0 M32_RB5
	stra,r0 M32_R2
	loda,r0 M32_RB6
	stra,r0 M32_R3
	loda,r0 M32_RB7
	stra,r0 M32_R4
	bcta,un *ret_workaround

safe_sub_temp:
	db 0
safe_sub:
	strr,r1 ret_workaround+2
	pop
	strr,r0 ret_workaround
	strr,r1 ret_workaround+1
	lodr,r1 ret_workaround+2
	ppsl PSL_CARRY_FLAG
	loda,r0 mem_start,r2
	comi,r0 255
	bcfr,eq nofix507
	loda,r0 mem_start,r3
	eori,r0 0xFF
	bctr,un fixed513
nofix507:
	loda,r0 mem_start,r3
	eori,r0 0xFF
	stra,r1 safe_sub_temp
	strz,r1
	loda,r0 mem_start,r2
	xchg
	addz,r1
	loda,r1 safe_sub_temp
fixed513:
	stra,r0 mem_start,r1

	loda,r0 mem_start,r2+
	comi,r0 255
	bcfr,eq nofix523
	tpsl 1
	bcfr,eq nofix523
	loda,r0 mem_start,r3+
	eori,r0 0xFF
	bctr,un fixed527
nofix523:
	loda,r0 mem_start,r3+
	eori,r0 0xFF
	stra,r1 safe_sub_temp
	strz,r1
	loda,r0 mem_start,r2
	xchg
	addz,r1
	loda,r1 safe_sub_temp
fixed527:
	stra,r0 mem_start,r1+
	
	loda,r0 mem_start,r2+
	comi,r0 255
	bcfr,eq nofix537
	tpsl 1
	bcfr,eq nofix537
	loda,r0 mem_start,r3+
	eori,r0 0xFF
	bctr,un fixed543
nofix537:
	loda,r0 mem_start,r3+
	eori,r0 0xFF
	stra,r1 safe_sub_temp
	strz,r1
	loda,r0 mem_start,r2
	xchg
	addz,r1
	loda,r1 safe_sub_temp
fixed543:
	stra,r0 mem_start,r1+
	
	loda,r0 mem_start,r3+
	eori,r0 0xFF
	stra,r1 safe_sub_temp
	strz,r1
	loda,r0 mem_start,r2+
	xchg
	addz,r1
	loda,r1 safe_sub_temp
	stra,r0 mem_start,r1+
	
	bcta,un *ret_workaround

mandel_iter_colors:
	db 0x40
	db 0x80
	db 0x84
	db 0xa8
	db 0xa8
	db 0xac
	db 0xd0
	db 0xd0
	db 0xd4
	db 0xd8
	db 0xd8
	db 0xb8
	db 0xb8
	db 0x98
	db 0x9c
	db 0x7c
	db 0x5c
	db 0x5c
	db 0x3c
	db 0x1c
	db 0x1c
	db 0x1c
	db 0x1c
	db 0x1c
	db 0x1d
	db 0x1d
	db 0x1d
	db 0x1e
	db 0x1e
	db 0x1f
	db 0x1f
	db 0x1f
	db 0x1b
	db 0x1b
	db 0x17
	db 0x13
	db 0x13
	db 0xf
	db 0xb
	db 0x7
	db 0x7
	db 0x3
	db 0x3
	db 0x3
	db 0x23
	db 0x43
	db 0x63
	db 0x63
	db 0x83
	db 0xa3
	db 0xc3
	db 0xc3
	db 0xe3
	db 0xe3
	db 0xe3
	db 0xe2
	db 0xe2
	db 0xe2
	db 0xe1
	db 0xe1
	db 0xe1
	db 0xe0
	db 0xe0
	db 0xe0

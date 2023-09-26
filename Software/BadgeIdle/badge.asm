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

; Settings & graphics routine args
; All values 1 byte unless stated otherwise
APP_INDEX        equ root_mem_start+0
IO4_SHADOW       equ root_mem_start+1
CURR_VRAM_PAGE   equ root_mem_start+2
FOREGROUND_COLOR equ root_mem_start+3
BITMAP_INDEX     equ root_mem_start+4
DRAW_X           equ root_mem_start+5
DRAW_Y           equ root_mem_start+6
BITMAP_WIDTH     equ root_mem_start+8
BITMAP_HEIGHT    equ root_mem_start+9
BACKGROUND_COLOR equ root_mem_start+10
STR_PTR          equ root_mem_start+11 ; 2 bytes
DRAW_WIDTH       equ root_mem_start+21
DRAW_HEIGHT      equ root_mem_start+22
TRANSPARENT      equ root_mem_start+23
DRAW_X2          equ root_mem_start+24
DRAW_Y2          equ root_mem_start+25
XS_STATE_1       equ root_mem_start+26
XS_STATE_2       equ root_mem_start+27
XS_STATE_3       equ root_mem_start+28
XS_STATE_4       equ root_mem_start+29
TARG_PAGE        equ root_mem_start+30
TARG_ADDR        equ root_mem_start+31 ; 3 bytes
CURR_APP_DAT     equ root_mem_start+34 ; 3 bytes, pointer to current app’s data area
DATA_LEN         equ root_mem_start+37 ; 2 bytes
NES_DATA         equ root_mem_start+39

; Uptime counter in BCD
UPTIME_SECS_1S   equ root_mem_start+14
UPTIME_SECS_10S  equ root_mem_start+15
UPTIME_MINS_1S   equ root_mem_start+16
UPTIME_MINS_10S  equ root_mem_start+17
UPTIME_HRS_1S    equ root_mem_start+18
UPTIME_HRS_10S   equ root_mem_start+19

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
M32_SIGN     equ root_mem_start+58
M32_UNSIGNED equ root_mem_start+59
M32_TMP      equ root_mem_start+60
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
F_ROM_READ_NEXT   equ funct_table_begin+40
F_ROM_DESEL       equ funct_table_begin+42
F_RUN_APP         equ funct_table_begin+44

; Controller data bit assignments
NES_RIGHT  equ 1
NES_LEFT   equ 2
NES_DOWN   equ 4
NES_UP     equ 8
NES_START  equ 16
NES_SELECT equ 32
NES_B      equ 64
NES_A      equ 128

BLACK        equ 0b00000000
WHITE        equ 0b11111111
RED          equ 0b11100000
GREEN        equ 0b00011100
BLUE         equ 0b00000011
YELLOW       equ 0b11111100
PURPLE       equ 0b11100011
CYAN         equ 0b00011111
PINK         equ 0b11110011
AVALI_ORANGE equ 0b11110000

LOOP_COUNTER equ mem_start+202

org 4096
programentry:
	nop
	bsta,un *F_WAIT_NEXT_FRAME
	eorz,r0
	stra,r0 LOOP_COUNTER
main_loop:
	cpsl PSL_WITH_CARRY
	loda,r0 LOOP_COUNTER
	addi,r0 1
	stra,r0 LOOP_COUNTER
	loda,r0 IO4_SHADOW
	iori,r0 32
	eori,r0 16
	stra,r0 IO4_SHADOW
	lodi,r3 4
	wrtc,r3
	wrtd,r0
	
	eorz,r0
	stra,r0 DATA_LEN
	lodi,r0 0x20
	stra,r0 DATA_LEN+1
	eorz,r0
	stra,r0 TARG_ADDR
	stra,r0 TARG_ADDR+1
	stra,r0 TARG_ADDR+2
	lodi,r0 2
	stra,r0 TARG_PAGE
	bsta,un *F_LOAD_APP_DATA
	
	eorz,r0
	stra,r0 DATA_LEN
	lodi,r0 0x20
	stra,r0 DATA_LEN+1
	eorz,r0
	stra,r0 TARG_ADDR
	lodi,r0 0x10
	stra,r0 TARG_ADDR+1
	eorz,r0
	stra,r0 TARG_ADDR+2
	lodi,r0 3
	stra,r0 TARG_PAGE
	bsta,un *F_LOAD_APP_DATA
	
	eorz,r0
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_FILL_FB
	bsta,un *F_SWAP_BUFFERS
	;bcta,un testitest
	;bsta,un render_menu
	
	lodi,r3 0
logo_anim_loop:
	eorz,r0
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_FILL_FB
	
	lodi,r0 0
	stra,r0 DRAW_X
	lodi,r0 0
	stra,r0 DRAW_Y
	lodi,r0 4
	stra,r0 BITMAP_INDEX
	bsta,un *F_DRAW_BYTEMAP
	
	lodi,r0 0b11100100
	stra,r0 FOREGROUND_COLOR
	stra,r0 TRANSPARENT
	lodi,r0 name_text>>8
	stra,r0 STR_PTR
	lodi,r0 name_text%256
	stra,r0 STR_PTR+1
	eorz,r0
	stra,r0 DRAW_Y
	lodi,r0 63
	subz,r3
	comi,r3 35
	bctr,lt first_text
	lodi,r0 63-35
first_text:
	stra,r0 DRAW_X
	bsta,un *F_DRAW_STR
	
	comi,r3 35
	bctr,lt no_second_text_yet
		lodi,r0 avali_text>>8
		stra,r0 STR_PTR
		lodi,r0 avali_text%256
		stra,r0 STR_PTR+1
		lodi,r0 9
		stra,r0 DRAW_Y
		lodi,r0 63+35
		subz,r3
		stra,r0 DRAW_X
		bsta,un *F_DRAW_STR
no_second_text_yet:
	bsta,un *F_SWAP_BUFFERS
	bsta,un *F_WAIT_NEXT_FRAME
	addi,r3 1
	comi,r3 71
	bcfa,eq logo_anim_loop
	
	lodi,r2 64
	bsta,un frame_delay
	
	eorz,r0
	stra,r0 FOREGROUND_COLOR
	stra,r0 BACKGROUND_COLOR
	stra,r0 DRAW_X
	stra,r0 DRAW_Y
	stra,r0 BITMAP_INDEX
	stra,r0 TRANSPARENT
	bsta,un *F_FILL_FB
	lodi,r0 AVALI_ORANGE
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_DRAW_BITMAP
	bsta,un *F_SWAP_BUFFERS
	lodi,r2 15
	bsta,un frame_delay
	eorz,r0
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_FILL_FB
	bsta,un *F_SWAP_BUFFERS
	lodi,r2 5
	bsta,un frame_delay
	lodi,r3 5
avali_logo_blink_loop:
	bsta,un *F_SWAP_BUFFERS
	lodi,r2 15
	bsta,un frame_delay
	bsta,un *F_SWAP_BUFFERS
	lodi,r2 5
	bsta,un frame_delay
	bdrr,r3 avali_logo_blink_loop
	
	eorz,r0
	stra,r0 DRAW_Y
	cpsl PSL_LOGICAL_COMP
	lodi,r3 63
	lodi,r2 63+67
flags_loop:
	eorz,r0
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_FILL_FB
	
	lodz,r3
	comi,r0 191
	bctr,lt no_bi_flag
	stra,r0 DRAW_X
	subi,r3 1
	lodi,r0 2
	stra,r0 BITMAP_INDEX
	bsta,un *F_DRAW_BYTEMAP
no_bi_flag:
	lodz,r2
	comi,r2 63
	bctr,gt no_fluid_flag
	comi,r2 140
	bctr,lt no_fluid_flag
	comi,r0 191
	bctr,lt flag_loop_exit
	stra,r0 DRAW_X
	lodi,r0 3
	stra,r0 BITMAP_INDEX
	bsta,un *F_DRAW_BYTEMAP
no_fluid_flag_but_sub:
	subi,r2 1
no_fluid_flag:
	subi,r2 1
	bsta,un *F_SWAP_BUFFERS
	bsta,un *F_WAIT_NEXT_FRAME
	bsta,un check_controller_input
	bctr,un flags_loop
flag_loop_exit:

	bctr,un vr_logo_cont
vr_logo_draw:
	lodi,r3 2
vr_logo:
	lodi,r0 0
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_FILL_FB
	lodi,r0 5
	stra,r0 BITMAP_INDEX
	eorz,r0
	stra,r0 DRAW_X
	stra,r0 DRAW_Y
	bsta,un *F_DRAW_BYTEMAP
	bsta,un *F_SWAP_BUFFERS
	lodz,r1
	strz,r2
	bsta,un frame_delay
	bdrr,r3 vr_logo
	retc,un
vr_logo_cont:
	lodi,r1 15
	bstr,un vr_logo_draw
	
	lodi,r3 2
vr_logo_2:
	lodi,r0 WHITE
	stra,r0 FOREGROUND_COLOR
	addi,r0 5
	stra,r0 TRANSPARENT
	lodi,r0 world_text>>8
	stra,r0 STR_PTR
	lodi,r0 world_text%256
	stra,r0 STR_PTR+1
	lodi,r0 32
	stra,r0 DRAW_X
	bsta,un *F_DRAW_STR
	bsta,un *F_SWAP_BUFFERS
	lodi,r2 11
	bsta,un frame_delay
	bdrr,r3 vr_logo_2
	
	lodi,r0 dev_text>>8
	stra,r0 STR_PTR
	lodi,r0 dev_text%256
	stra,r0 STR_PTR+1
	lodi,r0 10
	stra,r0 DRAW_Y
	lodi,r0 32
	stra,r0 DRAW_X
	bsta,un *F_DRAW_STR
	bsta,un *F_SWAP_BUFFERS
	lodi,r2 61
	bsta,un frame_delay
	
	bsta,un vr_logo_draw
	lodi,r1 1
	stra,r0 TRANSPARENT
	lodi,r0 WHITE
	stra,r0 FOREGROUND_COLOR
	lodi,r0 ign_text>>8
	stra,r0 STR_PTR
	lodi,r0 ign_text%256
	stra,r0 STR_PTR+1
	eorz,r0
	stra,r0 DRAW_Y
	lodi,r0 29
	stra,r0 DRAW_X
	bsta,un *F_DRAW_STR
	bsta,un *F_SWAP_BUFFERS
	lodi,r2 57
	bsta,un frame_delay
	
	lodi,r3 2
cvr_text:
	eorz,r0
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_FILL_FB
	lodi,r0 RED
	stra,r0 FOREGROUND_COLOR
	lodi,r0 also_on_text>>8
	stra,r0 STR_PTR
	lodi,r0 also_on_text%256
	stra,r0 STR_PTR+1
	eorz,r0
	stra,r0 DRAW_Y
	lodi,r0 9
	stra,r0 DRAW_X
	bsta,un *F_DRAW_STR
	bsta,un *F_SWAP_BUFFERS
	bdrr,r3 cvr_text
	lodi,r2 5
	bsta,un frame_delay
	
	lodi,r3 31
cvr_logo_scroll:
	eorz,r0
	stra,r0 DRAW_X
	lodz,r3
	comi,r0 255
	bcfr,eq cvr_logo_not_neg
	eorz,r0
cvr_logo_not_neg:
	stra,r0 DRAW_Y
	lodi,r0 6
	stra,r0 BITMAP_INDEX
	lodi,r0 0b11100100
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_DRAW_BITMAP
	bsta,un *F_SWAP_BUFFERS
	bsta,un *F_WAIT_NEXT_FRAME
	bsta,un *F_WAIT_NEXT_FRAME
	bsta,un check_controller_input
	subi,r3 1
	comi,r3 254
	bcfr,eq cvr_logo_scroll
	lodi,r2 20
	bsta,un frame_delay
	
	lodi,r0 0b01001011
	stra,r0 FOREGROUND_COLOR
	stra,r0 TRANSPARENT
	lodi,r0 ign_text>>8
	stra,r0 STR_PTR
	lodi,r0 ign_text%256
	stra,r0 STR_PTR+1
	lodi,r0 8
	stra,r0 DRAW_Y
	lodi,r0 14
	stra,r0 DRAW_X
	bsta,un *F_DRAW_STR
	bsta,un *F_SWAP_BUFFERS
	lodi,r2 40
	bsta,un frame_delay
	
	lodi,r3 31
tltp_loop:
	eorz,r0
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_FILL_FB
	eorz,r0
	subz,r3
	stra,r0 DRAW_X
	eorz,r0
	stra,r0 DRAW_Y
	lodi,r0 7
	stra,r0 BITMAP_INDEX
	bsta,un *F_DRAW_BYTEMAP
	lodi,r0 32
	addz,r3
	stra,r0 DRAW_X
	lodi,r0 8
	stra,r0 BITMAP_INDEX
	lodi,r0 AVALI_ORANGE
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_DRAW_BITMAP
	
	bsta,un *F_SWAP_BUFFERS
	bsta,un *F_WAIT_NEXT_FRAME
	subi,r3 1
	comi,r3 255
	bcfr,eq tltp_loop
	lodi,r2 61
	bsta,un frame_delay
	
	lodi,r2 101
	bsta,un website_ad
	
	lodi,r1 1
asdfgsfg:
	lodi,r3 2
this_badge:
	eorz,r0
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_FILL_FB
	lodi,r0 PINK
	stra,r0 FOREGROUND_COLOR
	eorz,r0
	stra,r0 DRAW_X
	stra,r0 DRAW_Y
	comi,r1 0
	bctr,eq this_badge_other_text
	lodi,r0 this_badge_text>>8
	stra,r0 STR_PTR
	lodi,r0 this_badge_text%256
	stra,r0 STR_PTR+1
	bctr,un this_badge_first_text
this_badge_other_text:
	lodi,r0 gfmpw_text>>8
	stra,r0 STR_PTR
	lodi,r0 gfmpw_text%256
	stra,r0 STR_PTR+1
this_badge_first_text:
	bsta,un *F_DRAW_STR
	bsta,un *F_SWAP_BUFFERS
	lodi,r2 10
	bsta,un frame_delay
	bdrr,r3 this_badge
	
	eorz,r0
	strr,r0 other_text_repeat
	bctr,un other_text_repeat+1
other_text_repeat:
	eorz,r0
	stra,r0 DRAW_X
	lodi,r0 9
	stra,r0 DRAW_Y
	comi,r1 0
	bctr,eq powered_by_other_text
	lodi,r0 powered_by_text>>8
	stra,r0 STR_PTR
	lodi,r0 powered_by_text%256
	stra,r0 STR_PTR+1
	bctr,un powered_by_first_text
powered_by_other_text:
	lodi,r0 custom_text>>8
	stra,r0 STR_PTR
	lodi,r0 custom_text%256
	stra,r0 STR_PTR+1
powered_by_first_text:
	bsta,un *F_DRAW_STR
	bsta,un *F_SWAP_BUFFERS
	lodi,r2 10
	bsta,un frame_delay
	lodr,r0 other_text_repeat
	eori,r0 1
	strr,r0 other_text_repeat
	bcfr,eq other_text_repeat+1
	eori,r1 1
	bcta,eq asdfgsfg
	
	eorz,r0
	stra,r0 DRAW_X
	lodi,r0 18
	stra,r0 DRAW_Y
	lodi,r0 silicon_text>>8
	stra,r0 STR_PTR
	lodi,r0 silicon_text%256
	stra,r0 STR_PTR+1
	bsta,un *F_DRAW_STR
	bsta,un *F_SWAP_BUFFERS
	lodi,r2 20
	bsta,un frame_delay
	
	; Finally something fun! Line demo!
	eorz,r0
	stra,r0 FOREGROUND_COLOR
	stra,r0 TRANSPARENT
	bsta,un *F_FILL_FB
	bsta,un *F_SWAP_BUFFERS
	bsta,un *F_FILL_FB
	eorz,r0
	stra,r0 CURR_VRAM_PAGE
	lodi,r1 2
	wrtc,r1
	wrtd,r0
	lodi,r0 AVALI_ORANGE
	stra,r0 FOREGROUND_COLOR
	eorz,r0
	stra,r0 DRAW_X
	stra,r0 DRAW_Y
	lodi,r0 32
	stra,r0 DRAW_HEIGHT
	lodi,r0 64
	stra,r0 DRAW_WIDTH
	bsta,un *F_DRAW_RECT
	lodi,r3 250
	cpsl PSL_LOGICAL_COMP
line_demo:
	bsta,un *F_XORSHIFT
	
	lodi,r1 2
line_random_x:
	loda,r0 XS_STATE_1,r1-
	rrr,r0
	rrr,r0
	andi,r0 63
	comi,r0 1
	bctr,gt line_x_greater
	lodi,r0 2
line_x_greater:
	comi,r0 62
	bctr,lt line_x_lesser
	lodi,r0 61
line_x_lesser:
	stra,r0 DRAW_X,r1
	brnr,r1 line_random_x
	loda,r0 DRAW_X+1
	stra,r0 DRAW_X2
	
	lodi,r1 2
line_random_y:
	loda,r0 XS_STATE_3,r1-
	rrr,r0
	rrr,r0
	andi,r0 31
	comi,r0 1
	bctr,gt line_y_greater
	lodi,r0 2
line_y_greater:
	comi,r0 30
	bctr,lt line_y_lesser
	lodi,r0 29
line_y_lesser:
	stra,r0 DRAW_Y,r1
	brnr,r1 line_random_y
	loda,r0 DRAW_Y+1
	stra,r0 DRAW_Y2
	
	loda,r0 DRAW_X
	coma,r0 DRAW_X2
	bcta,eq line_demo
	loda,r0 DRAW_Y
	coma,r0 DRAW_Y2
	bsta,eq line_demo
	
	loda,r0 XS_STATE_2
	rrl,r0
	rrl,r0
	rrl,r0
	rrl,r0
	andi,r0 0b11110000
	loda,r1 XS_STATE_4
	andi,r1 0b00001111
	iorz,r1
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_DRAW_LINE
	
	comi,r3 0
	bctr,lt line_demo_no_text_yet
	eorz,r0
	stra,r0 BACKGROUND_COLOR
	lodi,r0 AVALI_ORANGE
	stra,r0 FOREGROUND_COLOR
	lodi,r0 as2650_text>>8
	stra,r0 STR_PTR
	lodi,r0 as2650_text%256
	stra,r0 STR_PTR+1
	lodi,r0 14
	stra,r0 DRAW_X
	lodi,r0 2
	stra,r0 DRAW_Y
	bsta,un *F_DRAW_STR
line_demo_no_text_yet:
	tmi,r3 1
	bctr,eq line_demo_no_wait
	bsta,un *F_WAIT_NEXT_FRAME
line_demo_no_wait:
	bdra,r3 line_demo
	
	; Mandelbrot demo is large enough to require its own RAM page!
	lodi,r0 2
	stra,r0 TARG_PAGE
	lodi,r0 0
	stra,r0 TARG_ADDR
	bsta,un *F_TRANS_PAGE_CALL
	
	lodi,r3 12
uptime_loop:
	eorz,r0
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_FILL_FB
	eorz,r0
	stra,r0 BACKGROUND_COLOR
	lodi,r0 0b00111110
	stra,r0 FOREGROUND_COLOR
	lodi,r0 uptime_text>>8
	stra,r0 STR_PTR
	lodi,r0 uptime_text%256
	stra,r0 STR_PTR+1
	lodi,r0 0
	stra,r0 DRAW_X
	lodi,r0 0
	stra,r0 DRAW_Y
	bsta,un *F_DRAW_STR
	
	cpsl PSL_WITH_CARRY
	loda,r2 UPTIME_SECS_1S
	addi,r2 '0'
	stra,r2 uptime_str+7
	loda,r2 UPTIME_SECS_10S
	addi,r2 '0'
	stra,r2 uptime_str+6
	loda,r2 UPTIME_MINS_1S
	addi,r2 '0'
	stra,r2 uptime_str+4
	loda,r2 UPTIME_MINS_10S
	addi,r2 '0'
	stra,r2 uptime_str+3
	loda,r2 UPTIME_HRS_1S
	addi,r2 '0'
	stra,r2 uptime_str+1
	loda,r2 UPTIME_HRS_10S
	addi,r2 '0'
	stra,r2 uptime_str+0
	
	lodi,r1 uptime_str>>8
	stra,r1 STR_PTR
	lodi,r1 uptime_str%256
	stra,r1 STR_PTR+1
	lodi,r1 0
	stra,r1 DRAW_X
	lodi,r1 9
	stra,r1 DRAW_Y
	bsta,un *F_DRAW_STR
	
	bsta,un *F_SWAP_BUFFERS
	lodi,r2 10
	bsta,un frame_delay
	bdra,r3 uptime_loop
	bctr,un past_uptime_str
uptime_str:
	db "00:00:00"
	db 0
past_uptime_str:

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

	lodi,r3 PURPLE
sine_rep:
	stra,r3 DRAW_Y
	lodi,r3 0
sine_draw_loop:
	stra,r3 DRAW_X
	stra,r3 M32_A3
	eorz,r0
	stra,r0 M32_A1
	stra,r0 M32_A2
	stra,r0 M32_A4
	stra,r0 M32_B1
	stra,r0 M32_B2
	stra,r0 M32_B4
	lodi,r0 19
	stra,r0 M32_B3
	bsta,un *F_FIXED_DIV
	loda,r0 M32_RB1
	stra,r0 ARITH_A1
	loda,r0 M32_RB2
	stra,r0 ARITH_A2
	loda,r0 M32_RB3
	stra,r0 ARITH_A3
	loda,r0 M32_RB4
	stra,r0 ARITH_A4
	lodi,r0 PURPLE
	coma,r0 DRAW_Y
	bcfr,eq sine_use_cos
	bsta,un *F_SINE
	bctr,un sine_use_cos+3
sine_use_cos:
	bsta,un *F_COS
	
	ppsl PSL_WITH_CARRY
	cpsl PSL_CARRY_FLAG
	loda,r0 ARITH_RB1
	addi,r0 0
	stra,r0 ARITH_RB1
	loda,r0 ARITH_RB2
	addi,r0 0
	stra,r0 ARITH_RB2
	loda,r0 ARITH_RB3
	addi,r0 1
	stra,r0 ARITH_RB3
	loda,r0 ARITH_RB4
	addi,r0 0
	stra,r0 ARITH_RB4
	cpsl PSL_CARRY_FLAG
	loda,r0 ARITH_RB4
	rrr,r0
	stra,r0 ARITH_RB4
	loda,r0 ARITH_RB3
	rrr,r0
	stra,r0 ARITH_RB3
	loda,r0 ARITH_RB2
	rrr,r0
	stra,r0 ARITH_RB2
	loda,r0 ARITH_RB1
	rrr,r0
	stra,r0 ARITH_RB1
	cpsl PSL_WITH_CARRY
	
	loda,r0 ARITH_RB3
	comi,r0 1
	bcfr,eq sine_not_one
sine_is_one:
	lodi,r0 255
	stra,r0 ARITH_RB2
sine_not_one:
	loda,r0 ARITH_RB2
	rrr,r0
	rrr,r0
	rrr,r0
	andi,r0 0b00011111
	strz,r1
	lodi,r0 31
	subz,r1
	lodi,r1 64
	mul
	loda,r0 DRAW_X
	rrr,r0
	rrr,r0
	andi,r0 0b00111111
	addz,r2
	ppsl PSL_WITH_CARRY
	adda,r3 CURR_VRAM_PAGE
	cpsl PSL_WITH_CARRY
	lodi,r1 5
	wrtc,r1
	wrtd,r0
	wrtd,r3
	loda,r0 DRAW_Y
	lodi,r1 7
	wrtc,r1
	wrtd,r0
	
	loda,r3 DRAW_X
	tmi,r3 3
	bcfr,eq sine_no_frame_del
	bsta,un *F_WAIT_NEXT_FRAME
sine_no_frame_del:
	addi,r3 1
	comi,r3 0
	bcfa,eq sine_draw_loop
	
	loda,r3 DRAW_Y
	comi,r3 PURPLE
	bcfr,eq sine_done
	lodi,r3 GREEN
	bcta,un sine_rep
sine_done:
	
	lodi,r2 45
	bsta,un frame_delay
	bsta,un *F_SWAP_BUFFERS
	eorz,r0
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_FILL_FB
	bsta,un *F_SWAP_BUFFERS
	bsta,un *F_WAIT_NEXT_FRAME
	
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
	
	ppsl PSL_LOGICAL_COMP
	cpsl PSL_WITH_CARRY
	bctr,un rule_110
	db 0xFF
rule_110_state:
	db 0x47,0x3F,0x59,0x66,0x31,0x9A,0xBD,0xAA,0xFF
rule_110_rules:
	db 0,1,1,1,0,1,1,0
rule_110_ctr:
	db 0
rule_110:
	lodi,r0 255
	stra,r0 rule_110_state-1
	stra,r0 rule_110_state+8
	lodi,r2 255
	lodi,r3 8
rule_110_init_loop:
	bsta,un *F_XORSHIFT
	loda,r0 XS_STATE_1
	;stra,r0 rule_110_state,r2+
	bdrr,r3 rule_110_init_loop

	lodi,r3 0
rule_110_outer:
	stra,r3 DRAW_X
	lodz,r3
	lodi,r1 64
	mul
	lodi,r0 5
	wrtc,r0
	wrtd,r2
	wrtd,r3
	
rule_110_update:
	ppsl PSL_WITH_CARRY+PSL_LOGICAL_COMP
	cpsl PSL_BANK+PSL_CARRY_FLAG
	lodi,r3 8
	lodi,r2 7
rule_110_byte_loop:
	lodz,r2
	ppsl PSL_BANK
	strz,r1
	loda,r0 rule_110_state,r1-
	strz,r2
	loda,r0 rule_110_state,r1+
	strz,r3
	loda,r0 rule_110_state,r1+
	strz,r1
	rrl,r1
	lodz,r3
	rrl,r0
	andi,r0 7
	loda,r0 rule_110_rules,r0
	
	lodi,r1 8
	stra,r1 rule_110_ctr
	lodi,r1 0
	bctr,un rule_110_update_loop_entry
rule_110_update_loop:
	stra,r0 rule_110_ctr
	cpsl PSL_CARRY_FLAG
	rrr,r2
	rrr,r3
	lodz,r3
	andi,r0 7
	loda,r0 rule_110_rules,r0
rule_110_update_loop_entry:
	iorz,r1
	strz,r1
	cpsl PSL_CARRY_FLAG
	rrl,r1
	loda,r0 rule_110_ctr
	bdrr,r0 rule_110_update_loop
	
	lodz,r1
	cpsl PSL_BANK
	stra,r0 rule_110_state,r2
	
	ppsl PSL_CARRY_FLAG
	subi,r2 1
	bdra,r3 rule_110_byte_loop
	
	cpsl PSL_BANK

	lodi,r0 7
	wrtc,r0
rule_110_draw:
	lodi,r1 8
	lodi,r2 255
rule_110_draw_byte_loop:
		loda,r0 rule_110_state,r2+
		ppsl PSL_BANK
		lodi,r1 8
		strz,r2
rule_110_draw_bit_loop:
			eorz,r0
			rrl,r2
			rrl,r0
			bctr,eq rule_110_pix_black
			lodi,r0 255
			bctr,un rule_110_pix_white
rule_110_pix_black:
			lodi,r0 0
rule_110_pix_white:
			wrtd,r0
rule_110_write_wait_loop:
			redd,r0
			tmi,r0 8
			bctr,eq rule_110_write_wait_loop
		bdrr,r1 rule_110_draw_bit_loop
		cpsl PSL_BANK
	bdrr,r1 rule_110_draw_byte_loop
	bsta,un *F_WAIT_NEXT_FRAME
	
	cpsl PSL_WITH_CARRY+PSL_BANK
	loda,r3 DRAW_X
	addi,r3 1
	comi,r3 31
	bcfa,gt rule_110_outer
	
	db 0
	lodi,r2 44
	bsta,un frame_delay
	bsta,un *F_SWAP_BUFFERS
	eorz,r0
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_FILL_FB
	bsta,un *F_SWAP_BUFFERS
	bsta,un *F_WAIT_NEXT_FRAME
	
	lodi,r2 180
	bsta,un website_ad
	
	loda,r0 LOOP_COUNTER
	andi,r0 0b00000001
	bctr,eq render_avali
spin_cube:
	lodi,r0 3
	stra,r0 TARG_PAGE
	lodi,r0 0
	stra,r0 TARG_ADDR
	bsta,un *F_TRANS_PAGE_CALL
	lodz,r0
	bcta,un main_loop
	
render_avali:
testitest:
	lodi,r0 3
	stra,r0 TARG_PAGE
	lodi,r0 2
	stra,r0 TARG_ADDR
	bsta,un *F_TRANS_PAGE_CALL
	lodz,r0
	bcta,un main_loop
	
halt:
	ppsu 64
	lodz,r0
	bctr,un halt

website_ad_delay:
	db 0
website_ad:
	strr,r2 website_ad_delay
	eorz,r0
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_FILL_FB
	lodi,r0 9
	stra,r0 BITMAP_INDEX
	lodi,r0 0
	stra,r0 DRAW_X
	lodi,r0 0
	stra,r0 DRAW_Y
	lodi,r0 0xFF
	stra,r0 FOREGROUND_COLOR
	eorz,r0
	stra,r0 BACKGROUND_COLOR
	stra,r0 TRANSPARENT
	bsta,un *F_DRAW_BITMAP
	
	lodi,r0 0xFF
	stra,r0 TRANSPARENT
	lodi,r0 0xFF
	stra,r0 FOREGROUND_COLOR
	lodi,r0 https_text>>8
	stra,r0 STR_PTR
	lodi,r0 https_text%256
	stra,r0 STR_PTR+1
	lodi,r0 27
	stra,r0 DRAW_X
	lodi,r0 2
	stra,r0 DRAW_Y
	bsta,un *F_DRAW_STR
	
	lodi,r0 tholin_text>>8
	stra,r0 STR_PTR
	lodi,r0 tholin_text%256
	stra,r0 STR_PTR+1
	lodi,r0 27
	stra,r0 DRAW_X
	lodi,r0 11
	stra,r0 DRAW_Y
	bsta,un *F_DRAW_STR
	
	lodi,r0 dot_dev_text>>8
	stra,r0 STR_PTR
	lodi,r0 dot_dev_text%256
	stra,r0 STR_PTR+1
	lodi,r0 27
	stra,r0 DRAW_X
	lodi,r0 20
	stra,r0 DRAW_Y
	bsta,un *F_DRAW_STR
	
	bsta,un *F_SWAP_BUFFERS
	loda,r2 website_ad_delay
	bsta,un frame_delay
	
	retc,un

frame_delay_back:
	db 0,0
frame_delay:
	strr,r0 frame_delay_back
	strr,r1 frame_delay_back+1
	pop
	stra,r0 ret_workaround
	stra,r1 ret_workaround+1
frame_delay_loop:
	bsta,un *F_WAIT_NEXT_FRAME
	bsta,un check_controller_input
	bdrr,r2 frame_delay_loop
	lodr,r0 frame_delay_back
	lodr,r1 frame_delay_back+1
	bcta,un *ret_workaround

check_controller_input_reg_backs:
	db 0,0,0,0,0
check_controller_input:
	strr,r1 check_controller_input_reg_backs
	strr,r2 check_controller_input_reg_backs+1
	strr,r3 check_controller_input_reg_backs+2
	bsta,un *F_NES_READ
	
	loda,r0 NES_DATA
	comi,r0 0
	bctr,eq no_start_press
	andi,r0 NES_START
	bcfr,eq no_start_press
	bctr,un render_menu
no_start_press:
	pop
	stra,r0 check_controller_input_reg_backs+3
	stra,r1 check_controller_input_reg_backs+4
	loda,r1 check_controller_input_reg_backs
	loda,r2 check_controller_input_reg_backs+1
	loda,r3 check_controller_input_reg_backs+2
	bcta,un *check_controller_input_reg_backs+3

app_desc_tbl_start  equ 0x12200

render_menu:
	loda,r0 BACKGROUND_COLOR
	stra,r0 render_menu_stuff_backups
	loda,r0 TRANSPARENT
	stra,r0 render_menu_stuff_backups+1
	loda,r0 FOREGROUND_COLOR
	stra,r0 render_menu_stuff_backups+2
	loda,r0 DRAW_X
	stra,r0 render_menu_stuff_backups+3
	loda,r0 DRAW_Y
	stra,r0 render_menu_stuff_backups+4
	loda,r0 DRAW_WIDTH
	stra,r0 render_menu_stuff_backups+5
	loda,r0 DRAW_HEIGHT
	stra,r0 render_menu_stuff_backups+6
	cpsl PSL_WITH_CARRY
	
	lodi,r3 0
get_app_names:
	stra,r3 render_menu_stuff_backups+7
	lodz,r3
	rrl,r0
	rrl,r0
	rrl,r0
	rrl,r0
	rrl,r0
	strz,r1
	andi,r1 0b11100000
	andi,r0 0b00011111
	ppsl PSL_WITH_CARRY
	cpsl PSL_CARRY_FLAG
	addi,r0 app_desc_tbl_start>>8%256
	strz,r2
	eorz,r0
	addi,r0 app_desc_tbl_start>>16
	strz,r3
	cpsl PSL_CARRY_FLAG
	addi,r1 0x0B
	addi,r2 0
	addi,r3 0
	bsta,un *F_BEGIN_ROM_READ

	lodi,r0 3
	wrtc,r0
	wrtd,r0
	nop
	nop
	nop
	lodi,r0 2
	wrtc,r0
	redd,r0
	lodi,r1 3
	wrtc,r1
	wrtd,r1
	stra,r0 render_menu_stuff_backups+8
	cpsl PSL_WITH_CARRY
	
	loda,r0 render_menu_stuff_backups+7
	lodi,r1 6
	mul
	lodz,r2
	subi,r0 1
	strz,r1
	lodi,r2 0
read_app_name_loop:
	lodi,r0 2
	wrtc,r0
	redd,r0
	lodi,r3 3
	wrtc,r3
	wrtd,r3
	
	comi,r0 0
	bctr,eq read_app_name_done
	comi,r0 255
	bctr,eq read_app_name_done
	stra,r0 title1,r1+
	addi,r2 1
	coma,r2 render_menu_stuff_backups+8
	bctr,eq read_app_name_done
	comi,r2 5
	bcfr,eq read_app_name_loop
read_app_name_done:
	comi,r2 0
	bctr,eq name_error
	eorz,r0
	stra,r0 title1,r1+
	bctr,un no_name_error
name_error:
	lodi,r0 'E'
	stra,r0 title1,r1+
	lodi,r0 'r'
	stra,r0 title1,r1+
	lodi,r0 'r'
	stra,r0 title1,r1+
	lodi,r0 'o'
	stra,r0 title1,r1+
	lodi,r0 'r'
	stra,r0 title1,r1+
	lodi,r0 0
	stra,r0 title1,r1+
no_name_error:
	bsta,un *F_ROM_DESEL
	
	loda,r3 render_menu_stuff_backups+7
	addi,r3 1
	comi,r3 3
	bcfa,eq get_app_names
	
	eorz,r0
	stra,r0 menu_scroll
	stra,r0 menu_selected
menu_loop:
	eorz,r0
	stra,r0 TRANSPARENT
	lodi,r0 0b01001001
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_FILL_FB
	lodi,r0 PURPLE
	stra,r0 FOREGROUND_COLOR
	eorz,r0
	stra,r0 DRAW_X
	stra,r0 DRAW_Y
	lodi,r0 64
	stra,r0 DRAW_WIDTH
	lodi,r0 32
	stra,r0 DRAW_HEIGHT
	bsta,un *F_DRAW_RECT
	
	lodi,r3 0
menu_options_loop:
		stra,r3 render_menu_stuff_backups+7
		lodi,r0 3
		stra,r0 DRAW_X
		lodz,r3
		lodi,r1 9
		mul
		addi,r2 3
		stra,r2 DRAW_Y
		lodi,r0 title1>>8
		stra,r0 STR_PTR
		lodi,r0 title1%256
		stra,r0 STR_PTR+1
		
		loda,r0 menu_selected
		suba,r0 menu_scroll
		coma,r0 render_menu_stuff_backups+7
		bcfr,eq menu_opt_normal_color
		lodi,r0 AVALI_ORANGE
		stra,r0 BACKGROUND_COLOR
		eorz,r0
		stra,r0 FOREGROUND_COLOR
		bctr,un menu_opt_selected_color
menu_opt_normal_color:
		eorz,r0
		stra,r0 BACKGROUND_COLOR
		lodi,r0 AVALI_ORANGE
		stra,r0 FOREGROUND_COLOR
menu_opt_selected_color:
		
		loda,r0 render_menu_stuff_backups+7
		adda,r0 menu_scroll
		lodi,r1 6
		mul
		adda,r2 STR_PTR+1
		stra,r2 STR_PTR+1
		ppsl PSL_WITH_CARRY
		adda,r3 STR_PTR
		cpsl PSL_WITH_CARRY
		stra,r3 STR_PTR
		bsta,un *F_DRAW_STR
		
		loda,r3 render_menu_stuff_backups+7
		addi,r3 1
		comi,r3 3
	bcfa,eq menu_options_loop
	
	bsta,un *F_SWAP_BUFFERS
	bsta,un *F_WAIT_NEXT_FRAME
	bsta,un *F_NES_READ
	
	loda,r0 NES_DATA
	tmi,r0 NES_DOWN
	bsfr,eq menu_down
	loda,r0 NES_DATA
	andi,r0 NES_DOWN
	stra,r0 menu_down_held

	loda,r0 NES_DATA
	tmi,r0 NES_UP
	bsfr,eq menu_up
	loda,r0 NES_DATA
	andi,r0 NES_DOWN
	stra,r0 menu_up_held

	loda,r0 NES_DATA
	tmi,r0 NES_SELECT
	bcfa,eq menu_use_selected
	
	bcta,un menu_loop
menu_down:
	loda,r0 menu_down_held
	comi,r0 0
	retc,eq
	lodi,r0 3
	coma,r0 menu_selected
	retc,eq
	lodi,r0 1
	adda,r0 menu_selected
	stra,r0 menu_selected
	comi,r0 3
	retc,lt
	lodi,r0 1
	adda,r0 menu_scroll
	stra,r0 menu_scroll
	retc,un
menu_up:
	loda,r0 menu_up_held
	comi,r0 0
	retc,eq
	lodi,r0 0
	coma,r0 menu_selected
	retc,eq
	coma,r0 menu_scroll
	bctr,eq menu_up_noscroll
	loda,r0 menu_scroll
	subi,r0 1
	stra,r0 menu_scroll
menu_up_noscroll:
	loda,r0 menu_selected
	subi,r0 1
	stra,r0 menu_selected
	retc,un
menu_use_selected:
	loda,r0 menu_selected
	comi,r0 3
	bctr,eq menu_exit
	stra,r0 APP_INDEX
	bcta,un *F_RUN_APP
	
menu_exit:
	eorz,r0
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_FILL_FB
	bsta,un *F_SWAP_BUFFERS
	bsta,un *F_WAIT_NEXT_FRAME
	loda,r0 render_menu_stuff_backups+6
	stra,r0 DRAW_HEIGHT
	loda,r0 render_menu_stuff_backups+5
	stra,r0 DRAW_WIDTH
	loda,r0 render_menu_stuff_backups+4
	stra,r0 DRAW_Y
	loda,r0 render_menu_stuff_backups+3
	stra,r0 DRAW_X
	loda,r0 render_menu_stuff_backups+2
	stra,r0 FOREGROUND_COLOR
	loda,r0 render_menu_stuff_backups+1
	stra,r0 TRANSPARENT
	loda,r0 render_menu_stuff_backups
	stra,r0 BACKGROUND_COLOR
	bcta,un no_start_press
render_menu_stuff_backups:
	db 0,0,0,0,0,0,0,0,0
title1:
	db "ERROR"
	db 0
title2:
	db "ERROR"
	db 0
title3:
	db "ERROR"
	db 0
title4:
	db "CONTINUE"
	db 0
menu_scroll:
	db 0
menu_selected:
	db 0
menu_up_held:
	db 0
menu_down_held:
	db 0

ret_workaround:
	db 0,0

controller_test:
	bsta,un *F_NES_READ
	eorz,r0
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_FILL_FB
	
	loda,r2 NES_DATA
	lodi,r1 0
controller_test_renders:
	lodz,r1
	addi,r0 2
	stra,r0 DRAW_X
	lodi,r0 1
	stra,r0 DRAW_Y
	lodi,r0 8
	stra,r0 DRAW_WIDTH
	stra,r0 DRAW_HEIGHT
	lodi,r0 WHITE
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_DRAW_RECT
	
	tmi,r2 1
	bctr,eq controller_test_bit_clear
	lodz,r1
	addi,r0 4
	stra,r0 DRAW_X
	lodi,r0 3
	stra,r0 DRAW_Y
	lodi,r0 4
	stra,r0 DRAW_WIDTH
	stra,r0 DRAW_HEIGHT
	lodi,r0 AVALI_ORANGE
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_DRAW_RECT
controller_test_bit_clear:
	rrr,r2
	addi,r1 7
	comi,r1 56
	bcfa,eq controller_test_renders
	
	cpsu 64
	loda,r0 NES_DATA
	comi,r0 0xFF
	bctr,eq controller_test_no_light
	ppsu 64
controller_test_no_light:
	
	bsta,un *F_SWAP_BUFFERS
	bsta,un *F_WAIT_NEXT_FRAME
	loda,r0 NES_DATA
	comi,r0 0
	bcfa,eq controller_test
	cpsu 64
	retc,un

name_text:
	db "Tholin"
	db 0
avali_text:
	db " Avali"
	db 0
world_text:
	db "World"
	db 0
dev_text:
	db "dev"
	db 0
ign_text:
	db "IGN:"
	db 10
	db "Tholin"
	db 0
also_on_text:
	db "Also on:"
	db 0
this_badge_text:
	db "This badge"
	db 0
powered_by_text:
	db "Powered by"
	db 0
gfmpw_text:
	db "GFMPW-0"
	db 0
custom_text:
	db "Custom"
	db 0
silicon_text:
	db "Silicon"
	db 0
as2650_text:
	db "AS2650"
	db 0
uptime_text:
	db "Uptime:"
	db 0
https_text:
	db "https:/"
	db 0
tholin_text:
	db "tholin"
	db 0
dot_dev_text:
	db ".dev/"
	db 0

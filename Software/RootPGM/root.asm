PSL_CC1          equ 0b10000000
PSL_CC0          equ 0b01000000
PSL_IDC          equ 0b00100000
PSL_BANK         equ 0b00010000
PSL_WITH_CARRY   equ 0b00001000
PSL_OVERFLOW     equ 0b00000100
PSL_LOGICAL_COMP equ 0b00000010
PSL_CARRY_FLAG   equ 0b00000001

mem_start equ 3840

; Addresses of important parts in ROM
bitmap_tbl_loc_hi   equ 0x20
bitmap_dat_start_hi equ 0x22
app_desc_tbl_start  equ 0x12200

; Settings & graphics routine args
; All values 1 byte unless stated otherwise
APP_INDEX        equ mem_start+0
IO4_SHADOW       equ mem_start+1
CURR_VRAM_PAGE   equ mem_start+2
FOREGROUND_COLOR equ mem_start+3
BITMAP_INDEX     equ mem_start+4
DRAW_X           equ mem_start+5
DRAW_Y           equ mem_start+6
PSL_BACK         equ mem_start+7
BITMAP_WIDTH     equ mem_start+8
BITMAP_HEIGHT    equ mem_start+9
BACKGROUND_COLOR equ mem_start+10
STR_PTR          equ mem_start+11 ; 2 bytes
LAST_TIMER_VAL   equ mem_start+13
UPTIME_SECS_1S   equ mem_start+14
UPTIME_SECS_10S  equ mem_start+15
UPTIME_MINS_1S   equ mem_start+16
UPTIME_MINS_10S  equ mem_start+17
UPTIME_HRS_1S    equ mem_start+18
UPTIME_HRS_10S   equ mem_start+19
TIMER_COUNT_FRAC equ mem_start+20
DRAW_WIDTH       equ mem_start+21
DRAW_HEIGHT      equ mem_start+22
TRANSPARENT      equ mem_start+23
DRAW_X2          equ mem_start+24
DRAW_Y2          equ mem_start+25
XS_STATE_1       equ mem_start+26
XS_STATE_2       equ mem_start+27
XS_STATE_3       equ mem_start+28
XS_STATE_4       equ mem_start+29
TARG_PAGE        equ mem_start+30
TARG_ADDR        equ mem_start+31 ; 3 bytes
CURR_APP_DAT     equ mem_start+34 ; 3 bytes, pointer to current app’s data area
DATA_LEN         equ mem_start+37 ; 2 bytes
NES_DATA         equ mem_start+39

; Multiplication/division routine arguments
M32_A1       equ mem_start+42
M32_A2       equ mem_start+43
M32_A3       equ mem_start+44
M32_A4       equ mem_start+45
M32_B1       equ mem_start+46
M32_B2       equ mem_start+47
M32_B3       equ mem_start+48
M32_B4       equ mem_start+49
M32_RB1      equ mem_start+50
M32_RB2      equ mem_start+51
M32_RB3      equ mem_start+52
M32_RB4      equ mem_start+53
M32_RB5      equ mem_start+54
M32_RB6      equ mem_start+55
M32_RB7      equ mem_start+56
M32_RB8      equ mem_start+57
M32_SIGN     equ mem_start+58
M32_UNSIGNED equ mem_start+59
M32_TMP      equ mem_start+60
ARITH_A1     equ mem_start+61
ARITH_A2     equ mem_start+62
ARITH_A3     equ mem_start+63
ARITH_A4     equ mem_start+64
ARITH_RB1    equ mem_start+65
ARITH_RB2    equ mem_start+66
ARITH_RB3    equ mem_start+67
ARITH_RB4    equ mem_start+68

org 0
programentry:
	nop
	eorz,r0
	lpsl
	lodi,r0 32
	lpsu
	bctr,un past_table
function_index:
	db wait_next_frame%256
	db wait_next_frame>>8
	db fb_write%256
	db fb_write>>8
	db fill_fb%256
	db fill_fb>>8
	db begin_rom_read%256
	db begin_rom_read>>8
	db get_map_info%256
	db get_map_info>>8
	db draw_bitmap%256
	db draw_bitmap>>8
	db draw_bytemap%256
	db draw_bytemap>>8
	db swap_buffers%256
	db swap_buffers>>8
	db draw_rect%256
	db draw_rect>>8
	db draw_char%256
	db draw_char>>8
	db draw_str%256
	db draw_str>>8
	db draw_line%256
	db draw_line>>8
	db xorshift%256
	db xorshift>>8
	db load_app_data%256
	db load_app_data>>8
	db trans_page_call%256
	db trans_page_call>>8
	db mul_32x32%256
	db mul_32x32>>8
	db fixed_div%256
	db fixed_div>>8
	db sine%256
	db sine>>8
	db cos%256
	db cos>>8
	db nes_read%256
	db nes_read>>8
	db rom_read_next%256
	db rom_read_next>>8
	db rom_desel%256
	db rom_desel>>8
	db run_app%256
	db run_app>>8
past_table:
	lodi,r0 0x67
	stra,r0 XS_STATE_1
	lodi,r0 0x88
	stra,r0 XS_STATE_2
	lodi,r0 0x06
	stra,r0 XS_STATE_3
	lodi,r0 0x19
	stra,r0 XS_STATE_4
	lodi,r0 4
	wrtc,r0
	lodi,r0 0b00000001
	stra,r0 IO4_SHADOW
	iori,r0 8
	wrtd,r0
	eorz,r0
	stra,r0 CURR_VRAM_PAGE
	stra,r0 LAST_TIMER_VAL
	stra,r0 UPTIME_SECS_1S
	stra,r0 UPTIME_SECS_10S
	stra,r0 UPTIME_MINS_1S
	stra,r0 UPTIME_MINS_10S
	stra,r0 UPTIME_HRS_1S
	stra,r0 UPTIME_HRS_10S
	stra,r0 TRANSPARENT
	lodi,r1 2
	wrtc,r1
	wrtd,r0
	
	eorz,r0
	stra,r0 BACKGROUND_COLOR
	lodi,r0 8
	stra,r0 CURR_VRAM_PAGE
	lodi,r0 0b11110000 ; Closest thing to "Avali Orange"
	stra,r0 FOREGROUND_COLOR
	eorz,r0
	stra,r0 DRAW_X
	stra,r0 DRAW_Y
	stra,r0 BITMAP_INDEX
	bsta,un draw_bitmap
	
	eorz,r0
	stra,r0 CURR_VRAM_PAGE
	lodi,r0 2
	wrtc,r0
	lodi,r0 1
	wrtd,r0
	
	bsta,un xorshift
	
	lodi,r2 40
logo_delay:
	bsta,un wait_next_frame
	bdrr,r2 logo_delay
	
	eorz,r0
	;lodi,r0 1
	stra,r0 APP_INDEX
run_app:
	cpsl PSL_WITH_CARRY
	ppsu 64
	eorz,r0
	stra,r0 CURR_VRAM_PAGE
	stra,r0 FOREGROUND_COLOR
	bsta,un fill_fb
	lodi,r0 2
	wrtc,r0
	eorz,r0
	wrtd,r0
	lodi,r0 8
	stra,r0 CURR_VRAM_PAGE
	bsta,un load_app
	cpsu 64
	comi,r0 0
	bcfr,eq error
	; Clear stack pointer and IO4, clean slate
	lodi,r0 4
	wrtc,r0
	lodi,r0 0b00000001
	stra,r0 IO4_SHADOW
	iori,r0 8
	wrtd,r0
	spsu
	andi,r0 0b11111000
	lpsu
	bsta,un 4096

error:
	lodi,r2 255
	lodi,r3 255
	eorz,r0
	wrtc,r0
	redd,r1
	andi,r1 16
	eori,r1 16
	iori,r1 1
	lodi,r0 4
	wrtc,r0
	wrtd,r1
error_delay:
	nop
	nop
	lodz,r0
	nop
	nop
	nop
	nop
	nop
	bdrr,r2 error_delay
	bdrr,r3 error_delay
	bctr,un error

swap_buffers_reg_back:
	db 0
swap_buffers:
	strr,r0 swap_buffers_reg_back
	eorz,r0
	coma,r0 CURR_VRAM_PAGE
	bcfr,eq swap_buffers_1
swap_buffers_0:
	lodi,r0 8
	stra,r0 CURR_VRAM_PAGE
	lodi,r0 2
	wrtc,r0
	eorz,r0
	wrtd,r0
	retc,un
swap_buffers_1:
	eorz,r0
	stra,r0 CURR_VRAM_PAGE
	lodi,r0 2
	wrtc,r0
	lodi,r0 1
	wrtd,r0
	strr,r1 ret_workaround+2
	pop
	strr,r0 ret_workaround
	strr,r1 ret_workaround+1
	lodr,r1 ret_workaround+2
	lodr,r0 swap_buffers_reg_back
	bcta,un *ret_workaround

ret_workaround:
	db 0,0,0
wait_next_frame_reg_back:
	db 0
wait_next_frame:
	spsl
	stra,r0 wait_frame_psl_back
	strr,r1 wait_next_frame_reg_back
	pop
	stra,r0 ret_workaround
	stra,r1 ret_workaround+1
	cpsl PSL_WITH_CARRY
	ppsl PSL_LOGICAL_COMP
	lodi,r0 1
	wrtc,r0
wait_next_frame_wait_loop:
	redd,r0
	coma,r0 LAST_TIMER_VAL
	bctr,eq wait_next_frame_wait_loop
	strz,r1
	coma,r0 LAST_TIMER_VAL
	bcfr,gt wn_timer_overflow
	suba,r0 LAST_TIMER_VAL
	bctr,un wn_apply_timediff
wn_timer_overflow:
	loda,r0 LAST_TIMER_VAL
	subz,r1
wn_apply_timediff: ; With diff in R0, and curr timer val in R1
	stra,r1 LAST_TIMER_VAL
	adda,r0 TIMER_COUNT_FRAC
	stra,r0 TIMER_COUNT_FRAC
	ppsl PSL_LOGICAL_COMP
wn_inc_uptime:
	comi,r0 20
	bcta,lt wait_next_frame_finish
	loda,r0 UPTIME_SECS_1S
	addi,r0 1
	comi,r0 10
	bcfr,eq wn_secs_1_lt
	loda,r0 UPTIME_SECS_10S
	addi,r0 1
	comi,r0 6
	bcfr,eq wn_secs_10_lt
	loda,r0 UPTIME_MINS_1S
	addi,r0 1
	comi,r0 10
	bcfr,eq wn_mins_1_lt
	loda,r0 UPTIME_MINS_10S
	addi,r0 1
	comi,r0 6
	bcfr,eq wn_mins_10_lt
	loda,r0 UPTIME_HRS_1S
	addi,r0 1
	comi,r0 10
	bcfr,eq wn_hrs_1_lt
	loda,r0 UPTIME_HRS_10S
	addi,r0 1
	stra,r0 UPTIME_HRS_10S
	eorz,r0
wn_hrs_1_lt:
	stra,r0 UPTIME_HRS_1S
	eorz,r0
wn_mins_10_lt:
	stra,r0 UPTIME_MINS_10S
	eorz,r0
wn_mins_1_lt:
	stra,r0 UPTIME_MINS_1S
	eorz,r0
wn_secs_10_lt:
	stra,r0 UPTIME_SECS_10S
	eorz,r0
wn_secs_1_lt:
	stra,r0 UPTIME_SECS_1S
	loda,r0 TIMER_COUNT_FRAC
	subi,r0 20
	stra,r0 TIMER_COUNT_FRAC
	bcta,un wn_inc_uptime
wait_next_frame_finish:
	loda,r1 wait_next_frame_reg_back
	loda,r0 wait_frame_psl_back
	lpsl
	bcta,un *ret_workaround
wait_frame_psl_back:
	db 0

load_app:
	spsl
	stra,r0 PSL_BACK
	loda,r0 APP_INDEX
	cpsl PSL_WITH_CARRY
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
	bsta,un begin_rom_read
	bsta,un rom_read_next
	strz,r1
	bsta,un rom_read_next
	strz,r2
	bsta,un rom_read_next
	strz,r3
	bsta,un rom_read_next
	stra,r0 load_app_data_len
	bsta,un rom_read_next
	stra,r0 load_app_data_len+1
	bsta,un rom_read_next
	stra,r0 CURR_APP_DAT
	bsta,un rom_read_next
	stra,r0 CURR_APP_DAT+1
	bsta,un rom_read_next
	stra,r0 CURR_APP_DAT+2
	bsta,un rom_desel
	nop
	bsta,un begin_rom_read
	
	lodi,r0 3
	wrtc,r0
	wrtd,r0
	lodi,r0 0x10
	coma,r0 load_app_data_len+1
	bctr,gt load_app_len_safe
	bsta,un rom_desel
	lodi,r0 1
	retc,un
load_app_len_safe:
	eorz,r0
	wrtc,r0
	lodi,r0 1
	wrtd,r0
	lodi,r0 0x10
	strr,r0 load_app_ptr
	eorz,r0
	strr,r0 load_app_ptr+1
	strz,r2
	strz,r3
load_app_copy_loop:
	lodz,r2
	eorr,r0 load_app_data_len
	bcfr,eq load_app_copy_continue
	lodz,r3
	eorr,r0 load_app_data_len+1
	bctr,eq load_app_finish
load_app_copy_continue:
	lodi,r0 2
	wrtc,r0
	redd,r0
	stra,r0 *load_app_ptr
	lodi,r0 3
	wrtc,r0
	wrtd,r0
	cpsl PSL_CARRY_FLAG
	lodr,r0 load_app_ptr+1
	addi,r0 1
	strr,r0 load_app_ptr+1
	lodr,r0 load_app_ptr
	addi,r0 0
	strr,r0 load_app_ptr
	cpsl PSL_CARRY_FLAG
	addi,r2 1
	addi,r3 0
	bctr,un load_app_copy_loop
load_app_finish:
	bsta,un rom_desel
	loda,r0 PSL_BACK
	lpsl
	eorz,r0
	retc,un
load_app_ptr:
	db 0,0
load_app_data_len:
	db 0,0

	; Copies data from SPI ROM into the specified RAM page
	; Address relative to current app's data area
	; Assumes its being called from page 1
load_app_data:
	spsl
	stra,r0 PSL_BACK
	eorz,r0
	wrtc,r0
	loda,r0 TARG_PAGE
	wrtd,r0
	
	; Compute absolute address, and begin reading there
	ppsl PSL_WITH_CARRY
	cpsl PSL_CARRY_FLAG
	loda,r1 CURR_APP_DAT
	adda,r1 TARG_ADDR
	
	loda,r0 CURR_APP_DAT+1
	loda,r3 TARG_ADDR+1
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix421
	comi,r3 0xFF
	bctr,eq fixed425
nofix421:
	addz,r3
fixed425:
	strz,r2
	loda,r3 CURR_APP_DAT+2
	adda,r3 TARG_ADDR+2
	bsta,un begin_rom_read
	lodi,r0 3
	wrtc,r0
	wrtd,r0
	lodi,r0 0x10
	strr,r0 load_app_data_ptr
	eorz,r0
	strr,r0 load_app_data_ptr+1
load_app_data_loop:
	lodi,r0 2
	wrtc,r0
	redd,r0
	strr,r0 *load_app_data_ptr
	lodi,r0 3
	wrtc,r0
	wrtd,r0
	cpsl PSL_CARRY_FLAG
	lodr,r0 load_app_data_ptr+1
	addi,r0 1
	strr,r0 load_app_data_ptr+1
	lodr,r1 load_app_data_ptr
	addi,r1 0
	strr,r1 load_app_data_ptr
	coma,r0 DATA_LEN
	bcfr,eq load_app_data_loop
	coma,r1 DATA_LEN+1
	bcfr,eq load_app_data_loop
	bctr,un load_app_data_finished
load_app_data_ptr:
	db 0,0
load_app_data_finished:
	bsta,un rom_desel
	eorz,r0
	wrtc,r0
	lodi,r0 1
	wrtd,r0
	loda,r0 PSL_BACK
	lpsl
	retc,un

	; TODO: Make this a stack
trans_page_call_page_back:
	db 0
trans_page_call:
	spsl
	stra,r0 trans_page_psl_back
	
	cpsl PSL_WITH_CARRY
	stra,r1 trans_page_call_ret_backups
	eorz,r0
	wrtc,r0
	redd,r1
	rrl,r1
	rrl,r1
	andi,r1 3
	stra,r1 trans_page_call_page_back
	wrtd,r0
	
	eorz,r0
	wrtc,r0
	loda,r0 TARG_PAGE
	wrtd,r0
	pop
	stra,r1 trans_page_call_ret_backups+1
	loda,r1 trans_page_call_ret_backups
	stra,r0 trans_page_call_ret_backups
	
	; Beautiful self-modifying code
	loda,r0 TARG_ADDR
	strr,r0 trans_page_call_self_mod+2
trans_page_call_self_mod:
	bsta,un *4096
	
	eorz,r0
	wrtc,r0
	loda,r0 trans_page_call_page_back
	wrtd,r0
	loda,r0 trans_page_psl_back
	lpsl
	bcta,un *trans_page_call_ret_backups
trans_page_call_ret_backups:
	db 0,0
trans_page_psl_back:
	db 0

fb_write:
	lodi,r1 7
	wrtc,r1
fb_write_wait_loop:
	redd,r1
	tmi,r1 8
	bctr,eq fb_write_wait_loop
	wrtd,r0
	pop
	strr,r0 fb_write_ret+2
	strr,r1 fb_write_ret+1
fb_write_ret:
	bcta,un 0

fill_fb:
	stra,r1 fill_fb_backs
	stra,r2 fill_fb_backs+1
	stra,r3 fill_fb_backs+2
	eorz,r0
	lodi,r2 5
	wrtc,r2
	wrtd,r0
	loda,r0 CURR_VRAM_PAGE
	wrtd,r0
	loda,r0 FOREGROUND_COLOR
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
	lodr,r1 fill_fb_backs
	lodr,r2 fill_fb_backs+1
	lodr,r3 fill_fb_backs+2
	retc,un
fill_fb_backs:
	db 0,0,0

	; Addr in R1, R2, R3
begin_rom_read:
	lodi,r0 4
	wrtc,r0
	loda,r0 IO4_SHADOW
	andi,r0 254
	stra,r0 IO4_SHADOW
	wrtd,r0
	lodi,r0 3
	wrtc,r0
	lodi,r0 0x03
	wrtd,r0
rom_read_wait_1:
	redd,r0
	andi,r0 1
	bcfr,eq rom_read_wait_1
	lodz,r3
	wrtd,r0
rom_read_wait_2:
	redd,r0
	andi,r0 1
	bcfr,eq rom_read_wait_2
	lodz,r2
	wrtd,r0
rom_read_wait_3:
	redd,r0
	andi,r0 1
	bcfr,eq rom_read_wait_3
	lodz,r1
	wrtd,r0
rom_read_wait_4:
	redd,r0
	andi,r0 1
	bcfr,eq rom_read_wait_4
	retc,un

rom_desel:
	lodi,r0 4
	wrtc,r0
	loda,r0 IO4_SHADOW
	iori,r0 1
	stra,r0 IO4_SHADOW
	wrtd,r0
	retc,un

rom_read_next:
	lodi,r0 3
	wrtc,r0
	eorz,r0
	wrtd,r0
	nop
	lodi,r0 2
	wrtc,r0
	strr,r1 rom_read_next_ret+3
	pop
	strr,r0 rom_read_next_ret+2
	strr,r1 rom_read_next_ret+1
	lodr,r1 rom_read_next_ret+3
	redd,r0
rom_read_next_ret:
	bcta,un 0
	db 0

get_map_info:
	pop
	stra,r0 begin_map_read_ret_backups
	stra,r1 begin_map_read_ret_backups+1
	cpsl PSL_WITH_CARRY
	loda,r0 BITMAP_INDEX
	rrl,r0
	rrl,r0
	strz,r2
	andi,r0 0b11111100
	strz,r1
	lodz,r2
	andi,r0 0b00000011
	addi,r0 bitmap_tbl_loc_hi
	strz,r2
	eorz,r0
	strz,r3
	bsta,un begin_rom_read
	bstr,un rom_read_next
	strz,r1
	bstr,un rom_read_next
	strz,r2
	bstr,un rom_read_next
	stra,r0 BITMAP_WIDTH
	bsta,un rom_read_next
	stra,r0 BITMAP_HEIGHT
	bsta,un rom_desel
	addi,r2 bitmap_dat_start_hi
	lodi,r3 0
	ppsl PSL_WITH_CARRY
	addi,r3 0
	bcta,un *begin_map_read_ret_backups
begin_map_read_ret_backups:
	db 0,0

draw_bytemap_reg_backs:
	db 0,0,0
draw_bytemap:
	spsl
	stra,r0 PSL_BACK
	cpsl PSL_WITH_CARRY
	strr,r1 draw_bytemap_reg_backs
	strr,r2 draw_bytemap_reg_backs+1
	strr,r3 draw_bytemap_reg_backs+2
	bsta,un get_map_info
	loda,r0 DRAW_Y
	bcfr,lt draw_bytemap_y_not_neg
	stra,r1 dbi_curr_y
	stra,r2 dbi_end_y
	stra,r3 dbi_end_x
	eori,r0 0xFF
	addi,r0 1
	loda,r1 BITMAP_WIDTH
	mul
	loda,r0 dbi_curr_y
	addz,r2
	strz,r1
	ppsl PSL_WITH_CARRY
	loda,r0 dbi_end_y
	addz,r3
	strz,r2
	loda,r3 dbi_end_x
	addi,r3 0
	cpsl PSL_WITH_CARRY
draw_bytemap_y_not_neg:
	bsta,un begin_rom_read
	lodi,r1 3
	wrtc,r1
	wrtd,r1
	loda,r3 DRAW_Y
	bcfr,lt draw_bytemap_y_not_neg_2
	lodi,r3 0
draw_bytemap_y_not_neg_2:
	stra,r3 dbi_curr_y
	loda,r3 DRAW_Y
	adda,r3 BITMAP_HEIGHT
	stra,r3 dbi_end_y
	loda,r2 DRAW_X
	adda,r2 BITMAP_WIDTH
	stra,r2 dbi_end_x
draw_bytemap_outer:
	lodi,r0 5
	wrtc,r0
	ppsl PSL_WITH_CARRY
	cpsl PSL_CARRY_FLAG
 	loda,r0 dbi_curr_y
	lodi,r1 64
	mul
	loda,r0 DRAW_X
	bcfr,lt draw_bytemap_x_not_neg
	eorz,r0
draw_bytemap_x_not_neg:
	addz,r2
	adda,r3 CURR_VRAM_PAGE
	wrtd,r0
	wrtd,r3
	cpsl PSL_WITH_CARRY
	
	loda,r2 DRAW_X
draw_bytemap_inner:
	; Get value in SPI receive buffer, and start a new transfer
	; No wait loops, as SPI transfer happens in parallel to draw operation
	lodi,r1 2
	wrtc,r1
	redd,r0
	lodi,r1 3
	wrtc,r1
	wrtd,r1
	tmi,r2 128
	bctr,eq no_write
	lodi,r1 7
	wrtc,r1
	wrtd,r0
no_write:
	addi,r2 1
	coma,r2 dbi_end_x
	bctr,eq draw_bytemap_row_end
	comi,r2 64
	bctr,eq draw_bytemap_skip_row
	bctr,un draw_bytemap_inner
draw_bytemap_skip_row:
	lodi,r0 3
	wrtc,r0
	wrtd,r0
	addi,r2 1
	coma,r2 dbi_end_x
	bcfr,eq draw_bytemap_skip_row
draw_bytemap_row_end:
	loda,r0 dbi_curr_y
	addi,r0 1
	stra,r0 dbi_curr_y
	coma,r0 dbi_end_y
	bctr,eq draw_bytemap_finish
	comi,r0 32
	bcfa,eq draw_bytemap_outer
draw_bytemap_finish:
	bsta,un rom_desel
	loda,r1 draw_bytemap_reg_backs
	loda,r2 draw_bytemap_reg_backs+1
	loda,r3 draw_bytemap_reg_backs+2
	loda,r0 PSL_BACK
	lpsl
	retc,un

draw_bitmap_reg_backs:
	db 0,0,0
	; Draw bitmap stored at INDEX, with top-left corner at X and Y
draw_bitmap:
	spsl
	stra,r0 PSL_BACK
	strr,r1 draw_bitmap_reg_backs
	strr,r2 draw_bitmap_reg_backs+1
	strr,r3 draw_bitmap_reg_backs+2
	bsta,un get_map_info
	cpsl PSL_WITH_CARRY
	loda,r0 DRAW_Y
	bcfr,lt draw_bitmap_y_coord_not_neg
	; Increase ROM address to point at the first non-zero row
	; First, we need to know the width of a row in bytes
	stra,r1 dbi_end_x
	stra,r2 dbi_curr_y
	stra,r3 dbi_end_y
	loda,r0 BITMAP_WIDTH
	strz,r1
	rrr,r0
	rrr,r0
	rrr,r0
	andi,r0 0b00011111
	; Need to round the division UP
	andi,r1 0b00000111
	bctr,eq draw_bitmap_no_round_up
	addi,r0 1
draw_bitmap_no_round_up:
	loda,r1 DRAW_Y
	eori,r1 0xFF
	addi,r1 1
	mul
	loda,r0 dbi_end_x
	addz,r2
	strz,r1
	ppsl PSL_WITH_CARRY
	loda,r0 dbi_curr_y
	addz,r3
	strz,r2
	loda,r3 dbi_end_y
	addi,r3 0
	cpsl PSL_WITH_CARRY
draw_bitmap_y_coord_not_neg:
	bsta,un begin_rom_read
	
	lodi,r1 3
	wrtc,r1
	wrtd,r1
	loda,r3 DRAW_Y
	bcfr,lt draw_bitmap_y_coord_not_neg_2
	lodi,r3 0
draw_bitmap_y_coord_not_neg_2:
	stra,r3 dbi_curr_y
	loda,r3 DRAW_Y
	adda,r3 BITMAP_HEIGHT
	ppsl PSL_LOGICAL_COMP
	comi,r3 32
	bctr,lt draw_bitmap_no_clamp_y
	lodi,r3 32
draw_bitmap_no_clamp_y:
	stra,r3 dbi_end_y
	
	loda,r2 DRAW_X
	adda,r2 BITMAP_WIDTH
	stra,r2 dbi_end_x
	
draw_bitmap_outerer:
	lodi,r0 5
	wrtc,r0
	ppsl PSL_WITH_CARRY
	cpsl PSL_CARRY_FLAG
 	loda,r0 dbi_curr_y
	lodi,r1 64
	mul
	loda,r0 DRAW_X
	bcfr,lt draw_bitmap_x_not_neg
	eorz,r0
draw_bitmap_x_not_neg:
	addz,r2
	adda,r3 CURR_VRAM_PAGE
	wrtd,r0
	wrtd,r3
	cpsl PSL_WITH_CARRY
	
	loda,r2 DRAW_X
draw_bitmap_outer:
	; Get value in SPI receive buffer, and start a new transfer
	; No wait loops, as SPI transfer happens in parallel to draw operation
	lodi,r1 2
	wrtc,r1
	redd,r0
	lodi,r1 3
	wrtc,r1
	wrtd,r1
	stra,r0 dbi_curr_byte
	lodi,r3 8
draw_bitmap_inner:
	loda,r1 dbi_curr_byte
	rrr,r1
	stra,r1 dbi_curr_byte
	tmi,r2 128
	bctr,eq draw_bitmap_skip_write
	loda,r0 BACKGROUND_COLOR
	tmi,r1 128
	bcfr,eq draw_bitmap_pixel_black
	loda,r0 FOREGROUND_COLOR
draw_bitmap_pixel_black:
	lodi,r1 7
	wrtc,r1
	wrtd,r0
draw_bitmap_skip_write:
	addi,r2 1
	coma,r2 dbi_end_x
	bctr,eq draw_bitmap_row_end
	comi,r2 64
	bctr,eq draw_bitmap_skip_row
	bdrr,r3 draw_bitmap_inner
	bctr,un draw_bitmap_outer
draw_bitmap_skip_row:
	comi,r3 1
	bctr,eq draw_bitmap_skip_read_next
draw_bitmap_skip_loop:
	addi,r2 1
	coma,r2 dbi_end_x
	bctr,eq draw_bitmap_row_end
	bdrr,r3 draw_bitmap_skip_loop
draw_bitmap_skip_read_next:
	lodi,r0 3
	wrtc,r0
	wrtd,r0
	lodi,r3 8
	bctr,un draw_bitmap_skip_loop
draw_bitmap_row_end:
	lodr,r0 dbi_curr_y
	addi,r0 1
	strr,r0 dbi_curr_y
	coma,r0 dbi_end_y
	bcfa,eq draw_bitmap_outerer
draw_bitmap_finish:
	bsta,un rom_desel
	loda,r1 draw_bitmap_reg_backs
	loda,r2 draw_bitmap_reg_backs+1
	loda,r3 draw_bitmap_reg_backs+2
	loda,r0 PSL_BACK
	lpsl
	retc,un
draw_bitmap_localvars:
dbi_curr_y:
	db 0
dbi_end_y:
	db 0
dbi_curr_byte:
	db 0
dbi_end_x:
	db 0

draw_char_page_back:
	db 0
draw_char_num_rows:
	db 0
draw_char_curr_ptr:
	db 0,0
draw_char_font_ptr:
	db 0,0
draw_char_reg_backs:
	db 0,0,0
	; Draws ASCII char in BITMAP_INDEX with top-left corner at DRAW_X and DRAW_Y
	; X and Y may be negative
draw_char:
	spsl
	stra,r0 PSL_BACK
	cpsl PSL_WITH_CARRY
	ppsl PSL_LOGICAL_COMP
	strr,r1 draw_char_reg_backs
	strr,r2 draw_char_reg_backs+1
	strr,r3 draw_char_reg_backs+2
	pop
	stra,r0 ret_workaround
	stra,r1 ret_workaround+1
	
	eorz,r0
	wrtc,r0
	redd,r1
	rrl,r1
	rrl,r1
	andi,r1 3
	stra,r1 draw_char_page_back
	wrtd,r0
	
	; Defaults for font pointer offset, number of rows & number of cols skipped
	eorz,r0
	strr,r0 draw_char_font_ptr+1
	lodi,r0 7
	stra,r0 draw_char_start_col
	lodi,r0 7
	strr,r0 draw_char_num_rows
	; if Y < 0
	loda,r0 DRAW_Y
	bcfr,lt draw_char_y_not_neg
		; adjust pointer and number of rows
		; to make the text appear displaced upwards
		eori,r0 0xFF
		addi,r0 1
		strr,r0 draw_char_font_ptr+1
		lodi,r0 7
		subr,r0 draw_char_font_ptr+1
		stra,r0 draw_char_num_rows
		eorz,r0 ; So computation below results in 0 on Y
draw_char_y_not_neg:
	; Compute initial framebuffer pointer
	lodi,r1 64
	mul
	; if X < 0
	loda,r0 DRAW_X
	bcfr,lt draw_char_x_not_neg
		; adjust start column
		; to make the text appear displaced to the left
		eori,r0 0xFF
		addi,r0 1
		strz,r1
		lodi,r0 7
		subz,r1
		stra,r0 draw_char_start_col
		eorz,r0 ; So computation below adds 0
draw_char_x_not_neg:
	ppsl PSL_WITH_CARRY
	cpsl PSL_CARRY_FLAG
	addz,r2
	adda,r3 CURR_VRAM_PAGE
	stra,r0 draw_char_curr_ptr
	stra,r3 draw_char_curr_ptr+1
	
	; Limit width of char from 6 pixels if it would
	; extend past the right edge of the screen
	lodi,r1 6
	loda,r0 DRAW_X
	bctr,lt draw_char_write_limit
	comi,r0 58
	bcfr,gt draw_char_write_limit
	lodi,r1 64
	ppsl PSL_CARRY_FLAG
	suba,r1 DRAW_X
draw_char_write_limit:
	stra,r1 draw_char_x_limit
	
	ppsl PSL_CARRY_FLAG
	loda,r0 BITMAP_INDEX
	subi,r0 32
	cpsl PSL_WITH_CARRY
	rrl,r0
	rrl,r0
	rrl,r0
	ppsl PSL_WITH_CARRY
	cpsl PSL_CARRY_FLAG
	strz,r1
	andi,r0 0b11111000
	iora,r0 draw_char_font_ptr+1
	addi,r0 font%256
	stra,r0 draw_char_font_ptr+1
	lodz,r1
	andi,r0 0b00000111
	addi,r0 font>>8
	stra,r0 draw_char_font_ptr
	lodi,r2 255
draw_char_loop_outer:
	lodi,r0 5
	wrtc,r0
	loda,r0 draw_char_curr_ptr
	loda,r1 draw_char_curr_ptr+1
	wrtd,r0
	wrtd,r1
	cpsl PSL_CARRY_FLAG
	addi,r0 64
	addi,r1 0
	stra,r0 draw_char_curr_ptr
	stra,r1 draw_char_curr_ptr+1
	loda,r0 *draw_char_font_ptr,r2+
	stra,r0 draw_char_curr_byte
	loda,r3 draw_char_x_limit
	cpsl PSL_WITH_CARRY
draw_char_loop_inner:
	loda,r1 draw_char_curr_byte
	rrr,r1
	strr,r1 draw_char_curr_byte
	comr,r3 draw_char_start_col
	bctr,lt draw_char_col_active
	bctr,un draw_char_col_inactive
draw_char_col_active:
	loda,r0 FOREGROUND_COLOR
	tmi,r1 128
	bctr,eq draw_char_pixel_set
	loda,r0 BACKGROUND_COLOR
	loda,r1 TRANSPARENT
	bctr,eq draw_char_pixel_set
	lodi,r1 1
	wrtc,r1
	wrtd,r1
	bctr,un draw_char_col_inactive
draw_char_pixel_set:
	lodi,r1 7
	wrtc,r1
	wrtd,r0
draw_char_col_inactive:
	bdrr,r3 draw_char_loop_inner
	ppsl PSL_WITH_CARRY
draw_char_row_end:
	coma,r2 draw_char_num_rows
	bcfa,eq draw_char_loop_outer
	
	eorz,r0
	wrtc,r0
	loda,r0 draw_char_page_back
	wrtd,r0
	
	loda,r1 draw_char_reg_backs
	loda,r2 draw_char_reg_backs+1
	loda,r3 draw_char_reg_backs+2
	loda,r0 PSL_BACK
	lpsl
	bcta,un *ret_workaround
draw_char_curr_byte:
	db 0
draw_char_x_limit:
	db 0
draw_char_start_col:
	db 0

	; Draw string in STR_PTR at given X and Y
draw_str_origx:
	db 0
draw_str:
	loda,r0 DRAW_X
	strr,r0 draw_str_origx
	lodi,r2 255
draw_str_loop:
	loda,r0 *STR_PTR,r2+
	comi,r0 0
	retc,eq
	comi,r0 10
	bctr,eq draw_str_newl
	stra,r0 BITMAP_INDEX
	bsta,un draw_char
	cpsl PSL_CARRY_FLAG
	loda,r0 DRAW_X
	addi,r0 6
	stra,r0 DRAW_X
	ppsl PSL_CARRY_FLAG
	comi,r0 64
	retc,gt
	retc,eq
	bctr,un draw_str_loop
draw_str_newl:
	lodr,r0 draw_str_origx
	stra,r0 DRAW_X
	loda,r0 DRAW_Y
	cpsl PSL_CARRY_FLAG
	addi,r0 9
	stra,r0 DRAW_Y
	comi,r0 32
	bctr,lt draw_str_loop
	retc,un

draw_rect:
	spsl
	stra,r0 PSL_BACK
	ppsl PSL_WITH_CARRY
	stra,r1 draw_char_reg_backs
	stra,r2 draw_char_reg_backs+1
	stra,r3 draw_char_reg_backs+2
	
	lodi,r0 5
	wrtc,r0
	loda,r0 DRAW_Y
	lodi,r1 64
	mul
	cpsl PSL_CARRY_FLAG
	adda,r2 DRAW_X
	adda,r3 CURR_VRAM_PAGE
	wrtd,r2
	wrtd,r3
	loda,r2 DRAW_WIDTH
draw_rect_line1:
	loda,r0 FOREGROUND_COLOR
	bsta,un fb_write
	bdrr,r2 draw_rect_line1
	
	lodi,r0 5
	wrtc,r0
	loda,r0 DRAW_Y
	cpsl PSL_CARRY_FLAG
	adda,r0 DRAW_HEIGHT
	ppsl PSL_CARRY_FLAG
	subi,r0 1
	lodi,r1 64
	mul
	cpsl PSL_CARRY_FLAG
	adda,r2 DRAW_X
	adda,r3 CURR_VRAM_PAGE
	wrtd,r2
	wrtd,r3
	loda,r2 DRAW_WIDTH
draw_rect_line2:
	loda,r0 FOREGROUND_COLOR
	bsta,un fb_write
	bdrr,r2 draw_rect_line2
	
	loda,r3 DRAW_HEIGHT
	ppsl PSL_CARRY_FLAG
	subi,r3 1
draw_rect_line3:
	stra,r3 draw_str_origx
	; Left
	lodi,r0 5
	wrtc,r0
	loda,r0 DRAW_Y
	cpsl PSL_CARRY_FLAG
	adda,r0 draw_str_origx
	lodi,r1 64
	mul
	cpsl PSL_CARRY_FLAG
	adda,r2 DRAW_X
	adda,r3 CURR_VRAM_PAGE
	wrtd,r2
	wrtd,r3
	strr,r2 draw_rect_ptr
	strr,r3 draw_rect_ptr+1
	loda,r0 FOREGROUND_COLOR
	bsta,un fb_write
	; Right
	lodi,r0 5
	wrtc,r0
	lodr,r2 draw_rect_ptr
	lodr,r3 draw_rect_ptr+1
	cpsl PSL_CARRY_FLAG
	adda,r2 DRAW_WIDTH
	addi,r3 0
	cpsl PSL_CARRY_FLAG
	addi,r2 0xFF
	addi,r3 0xFF
	wrtd,r2
	wrtd,r3
	loda,r0 FOREGROUND_COLOR
	bsta,un fb_write
	loda,r3 draw_str_origx
	bdra,r3 draw_rect_line3
	
	loda,r1 draw_char_reg_backs
	loda,r2 draw_char_reg_backs+1
	loda,r3 draw_char_reg_backs+2
	loda,r0 PSL_BACK
	lpsl
	retc,un
draw_rect_ptr:
	db 0,0

	; https://zingl.github.io/bresenham.html
draw_line_reg_backs:
	db 0,0,0
draw_line_dx:
	db 0
draw_line_dy:
	db 0
draw_line_sx:
	db 0
draw_line_sy:
	db 0
draw_line:
	spsl
	stra,r0 PSL_BACK
	strr,r1 draw_line_reg_backs
	strr,r2 draw_line_reg_backs+1
	strr,r3 draw_line_reg_backs+2
	
	cpsl PSL_WITH_CARRY+PSL_LOGICAL_COMP
	loda,r0 DRAW_X2
	suba,r0 DRAW_X
	bcfr,lt dx_not_neg
	eori,r0 0xFF
	addi,r0 1
dx_not_neg:
	strr,r0 draw_line_dx
	
	loda,r0 DRAW_Y2
	suba,r0 DRAW_Y
	bctr,lt dy_neg
	eori,r0 0xFF
	addi,r0 1
dy_neg:
	strr,r0 draw_line_dy
	
	lodi,r1 1
	loda,r0 DRAW_X
	coma,r0 DRAW_X2
	bctr,lt x1_less_x2
	lodi,r1 0xFF
x1_less_x2:
	strr,r1 draw_line_sx
	
	lodi,r1 1
	loda,r0 DRAW_Y
	coma,r0 DRAW_Y2
	bctr,lt y1_less_y2
	lodi,r1 0xFF
y1_less_y2:
	stra,r1 draw_line_sy
	
	loda,r3 draw_line_dx
	adda,r3 draw_line_dy
	stra,r3 draw_line_error
	loda,r0 DRAW_X
 	stra,r0 draw_line_x
	loda,r0 DRAW_Y
	stra,r0 draw_line_y
draw_line_loop:
	; Set pixel at x, y
	loda,r0 draw_line_y
	lodi,r1 64
	mul
	adda,r2 draw_line_x
	ppsl PSL_WITH_CARRY
	adda,r3 CURR_VRAM_PAGE
	cpsl PSL_WITH_CARRY
	lodi,r0 5
	wrtc,r0
	wrtd,r2
	wrtd,r3
	loda,r0 FOREGROUND_COLOR
	lodi,r1 7
	wrtc,r1
	wrtd,r0
	loda,r0 draw_line_x
	coma,r0 DRAW_X2
	bctr,lt draw_line_continue
	loda,r0 DRAW_Y2
	coma,r0 draw_line_y
	bcfa,gt draw_line_finish
draw_line_continue:
	
	loda,r3 draw_line_error
	comi,r3 63
	bcfr,gt draw_line_no_pos_overflow
		adda,r3 draw_line_dy
		stra,r3 draw_line_error
		loda,r0 draw_line_x
		adda,r0 draw_line_sx
		stra,r0 draw_line_x
		bcta,un draw_line_loop
draw_line_no_pos_overflow:
	comi,r3 255-62 ; -62
	bcfr,lt draw_line_no_neg_underflow
		adda,r3 draw_line_dx
		strr,r3 draw_line_error
		lodr,r0 draw_line_y
		adda,r0 draw_line_sy
		strr,r0 draw_line_y
		bcta,un draw_line_loop
draw_line_no_neg_underflow:
	lodz,r3
	addz,r3
	strz,r2
	coma,r0 draw_line_dy
	bctr,lt draw_line_e2_lt_dy
		adda,r3 draw_line_dy
		lodr,r0 draw_line_x
		adda,r0 draw_line_sx
		strr,r0 draw_line_x
draw_line_e2_lt_dy:
	coma,r2 draw_line_dx
	bctr,gt draw_line_e2_gt_dx
		adda,r3 draw_line_dx
		lodr,r0 draw_line_y
		adda,r0 draw_line_sy
		strr,r0 draw_line_y
draw_line_e2_gt_dx:
	strr,r3 draw_line_error
	bcta,un draw_line_loop
draw_line_finish:
	loda,r1 draw_line_reg_backs
	loda,r2 draw_line_reg_backs+1
	loda,r3 draw_line_reg_backs+2
	loda,r0 PSL_BACK
	lpsl
	retc,un
draw_line_x:
	db 0
draw_line_y:
	db 0
draw_line_error:
	db 0

nes_read_reg_backs:
	db 0,0,0
nes_read:
	stra,r1 nes_read_reg_backs
	stra,r2 nes_read_reg_backs+1
	stra,r3 nes_read_reg_backs+2
	
	lodi,r1 4
	wrtc,r1
	loda,r1 IO4_SHADOW
	andi,r1 0b11111001
	wrtd,r1
	nop
	nop
	
	; Pulse latch
	iori,r1 4
	wrtd,r1
	nop
	nop
	nop
	nop
	eori,r1 4
	wrtd,r1
	
	lodi,r3 0
	lodi,r2 8
nes_receive_loop:
	rrl,r3
	andi,r3 0b11111110
	redd,r0
	iori,r1 2
	wrtd,r1
	rrr,r0
	rrr,r0
	andi,r0 1
	eori,r1 2
	wrtd,r1
	iorz,r3
	strz,r3
	bdrr,r2 nes_receive_loop
	stra,r3 NES_DATA
	
	pop
	stra,r0 nes_read_return+2
	stra,r1 nes_read_return+1
	loda,r1 nes_read_reg_backs
	loda,r2 nes_read_reg_backs+1
	loda,r3 nes_read_reg_backs+2
nes_read_return:
	bcta,un 0

	; Warning: destroys contents of other register bank
xorshift_reg_backs:
	db 0,0,0,0,0,0
xorshift:
	spsl
	stra,r0 PSL_BACK
	ppsl PSL_WITH_CARRY
	cpsl PSL_BANK
	strr,r1 xorshift_reg_backs
	strr,r2 xorshift_reg_backs+1
	strr,r3 xorshift_reg_backs+2
	ppsl PSL_BANK
	strr,r1 xorshift_reg_backs+3
	strr,r2 xorshift_reg_backs+4
	strr,r3 xorshift_reg_backs+5
	cpsl PSL_BANK
	
	lodi,r0 5
	loda,r1 XS_STATE_1
	loda,r2 XS_STATE_2
	loda,r3 XS_STATE_3
xorshift_loop_1:
	cpsl PSL_CARRY_FLAG
	rrl,r1
	rrl,r2
	rrl,r3
	bdrr,r0 xorshift_loop_1

	eora,r0 XS_STATE_1
	eora,r1 XS_STATE_2
	eora,r2 XS_STATE_3
	eora,r3 XS_STATE_4
	lodz r3
	strz r1
	lodz r2
	lodi,r2 0
	lodi,r3 0
	cpsl PSL_CARRY_FLAG
	rrr,r1
	rrr,r0
	eora,r0 XS_STATE_1
	eora,r1 XS_STATE_2
	eora,r2 XS_STATE_3
	eora,r3 XS_STATE_4

	ppsl PSL_BANK
	lodi,r1 5
xorshift_loop_2:
	cpsl PSL_CARRY_FLAG+PSL_BANK
	rrl,r0
	rrl,r1
	rrl,r2
	rrl,r3
	ppsl PSL_BANK
	bdrr,r1 xorshift_loop_2
	cpsl PSL_BANK

	eora,r0 XS_STATE_1
	eora,r1 XS_STATE_2
	eora,r2 XS_STATE_3
	eora,r3 XS_STATE_4
	stra,r0 XS_STATE_1
	stra,r1 XS_STATE_2
	stra,r2 XS_STATE_3
	stra,r3 XS_STATE_4
	loda,r1 xorshift_reg_backs
	loda,r2 xorshift_reg_backs+1
	loda,r3 xorshift_reg_backs+2
	ppsl PSL_BANK
	loda,r1 xorshift_reg_backs+3
	loda,r2 xorshift_reg_backs+4
	loda,r3 xorshift_reg_backs+5
	cpsl PSL_BANK
	loda,r0 PSL_BACK
	lpsl
	retc,un

muldiv_correct_in_signs:
	eorz,r0
	stra,r0 M32_SIGN
	coma,r0 M32_UNSIGNED
	bcfa,eq muldiv_correct_done
	
	loda,r1 M32_A4
	tmi,r1 128
	bcfr,eq muldiv_correct_not_neg_a
	cpsl PSL_CARRY_FLAG
	lodi,r1 255
	lodi,r2 0
	loda,r0 M32_A1
	eorz r1
	addi,r0 1
	stra,r0 M32_A1
	loda,r0 M32_A2
	eorz r1
	addz r2
	stra,r0 M32_A2
	loda,r0 M32_A3
	eorz r1
	addz r2
	stra,r0 M32_A3
	loda,r0 M32_A4
	eorz r1
	addz r2
	stra,r0 M32_A4
	lodi,r2 1
	stra,r2 M32_SIGN
muldiv_correct_not_neg_a:
	loda,r1 M32_B4
	tmi,r1 128
	bcfr,eq muldiv_correct_done
	cpsl PSL_CARRY_FLAG
	lodi,r1 255
	lodi,r2 0
	loda,r0 M32_B1
	eorz r1
	addi,r0 1
	stra,r0 M32_B1
	loda,r0 M32_B2
	eorz r1
	addz r2
	stra,r0 M32_B2
	loda,r0 M32_B3
	eorz r1
	addz r2
	stra,r0 M32_B3
	loda,r0 M32_B4
	eorz r1
	addz r2
	stra,r0 M32_B4
	loda,r2 M32_SIGN
	eori,r2 1
	stra,r2 M32_SIGN
muldiv_correct_done:
	pop
	stra,r0 muldiv_correct_return+2
	stra,r1 muldiv_correct_return+1
muldiv_correct_return:
	bcta,un 0

mul_32x32:
	spsl
	stra,r0 PSL_BACK
	stra,r1 mul_32x32_reg_backs
	stra,r2 mul_32x32_reg_backs+1
	stra,r3 mul_32x32_reg_backs+2
	ppsl PSL_WITH_CARRY+PSL_LOGICAL_COMP
	eorz,r0
	stra,r0 M32_RB1
	stra,r0 M32_RB2
	stra,r0 M32_RB3
	stra,r0 M32_RB4
	stra,r0 M32_RB5
	stra,r0 M32_RB6
	stra,r0 M32_RB7
	stra,r0 M32_RB8
	
	bsta,un muldiv_correct_in_signs

	lodi,r2 255
mul_32x32_loop:
	loda,r0 M32_A1,r2+
	stra,r0 M32_TMP
	stra,r2 mul_32x32_counter
	
	; Begin mul_8x32_hw
	; 1
	loda,r0 M32_TMP
	loda,r1 M32_B1
	mul
	cpsl PSL_CARRY_FLAG
	adda,r2 M32_RB4
	stra,r2 M32_RB4
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix469
	comi,r3 255
	bctr,eq fixed471
nofix469:
	loda,r0 M32_RB5
	addz,r3
	stra,r0 M32_RB5
fixed471:
	loda,r3 M32_RB6
	addi,r3 0
	stra,r3 M32_RB6
	loda,r3 M32_RB7
	addi,r3 0
	stra,r3 M32_RB7
	loda,r3 M32_RB8
	addi,r3 0
	stra,r3 M32_RB8
	
	; 2
	loda,r0 M32_TMP
	loda,r1 M32_B2
	mul
	cpsl PSL_CARRY_FLAG
	adda,r2 M32_RB5
	stra,r2 M32_RB5
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix488
	comi,r3 255
	bctr,eq fixed490
nofix488:
	loda,r0 M32_RB6
	addz,r3
	stra,r0 M32_RB6
fixed490:
	loda,r3 M32_RB7
	addi,r3 0
	stra,r3 M32_RB7
	loda,r3 M32_RB8
	addi,r3 0
	stra,r3 M32_RB8
	
	; 3
	loda,r0 M32_TMP
	loda,r1 M32_B3
	mul
	cpsl PSL_CARRY_FLAG
	adda,r2 M32_RB6
	stra,r2 M32_RB6
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix518
	comi,r3 255
	bctr,eq fixed520
nofix518:
	loda,r0 M32_RB7
	addz,r3
	stra,r0 M32_RB7
fixed520:
	loda,r3 M32_RB8
	addi,r3 0
	stra,r3 M32_RB8
	
	; 4
	loda,r0 M32_TMP
	loda,r1 M32_B4
	mul
	cpsl PSL_CARRY_FLAG
	adda,r2 M32_RB7
	stra,r2 M32_RB7
	adda,r3 M32_RB8
	stra,r3 M32_RB8
	
	; End mul_8x32_hw
	lodr,r2 mul_32x32_counter
	comi,r2 3
	bcta,eq mul_32x32_end
	
	loda,r0 M32_RB2
	stra,r0 M32_RB1
	loda,r0 M32_RB3
	stra,r0 M32_RB2
	loda,r0 M32_RB4
	stra,r0 M32_RB3
	loda,r0 M32_RB5
	stra,r0 M32_RB4
	loda,r0 M32_RB6
	stra,r0 M32_RB5
	loda,r0 M32_RB7
	stra,r0 M32_RB6
	loda,r0 M32_RB8
	stra,r0 M32_RB7
	eorz,r0
	stra,r0 M32_RB8
	bcta,un mul_32x32_loop
mul_32x32_counter:
	db 0
mul_32x32_end:
	loda,r0 M32_SIGN
	comi,r0 0
	bcta,eq mul_32x32_no_negate_res
	lodi,r2 255
	lodi,r3 0
	cpsl PSL_CARRY_FLAG
	loda,r0 M32_RB1
	eorz r2
	addi,r0 1
	stra,r0 M32_RB1
	loda,r0 M32_RB2
	eorz r2
	addz r3
	stra,r0 M32_RB2
	loda,r0 M32_RB3
	eorz r2
	addz r3
	stra,r0 M32_RB3
	loda,r0 M32_RB4
	eorz r2
	addz r3
	stra,r0 M32_RB4
	loda,r0 M32_RB5
	eorz r2
	addz r3
	stra,r0 M32_RB5
	loda,r0 M32_RB6
	eorz r2
	addz r3
	stra,r0 M32_RB6
	loda,r0 M32_RB7
	eorz r2
	addz r3
	stra,r0 M32_RB7
	loda,r0 M32_RB8
	eorz r2
	addz r3
	stra,r0 M32_RB8
mul_32x32_no_negate_res:
	pop
	stra,r0 mul_32x32_return+2
	stra,r1 mul_32x32_return+1
	lodr,r1 mul_32x32_reg_backs
	lodr,r2 mul_32x32_reg_backs+1
	lodr,r3 mul_32x32_reg_backs+2
	loda,r0 PSL_BACK
	lpsl
mul_32x32_return:
	bcta,un 0
mul_32x32_reg_backs:
	db 0,0,0

fixed_div_counter:
	db 0
fixed_div:
	spsl
	stra,r0 PSL_BACK
	ppsl PSL_WITH_CARRY+PSL_LOGICAL_COMP+PSL_IDC
	stra,r1 fixed_div_reg_backs
	stra,r2 fixed_div_reg_backs+1
	stra,r3 fixed_div_reg_backs+2
	
	eorz,r0
	stra,r0 M32_RB1
	stra,r0 M32_RB2
	stra,r0 M32_RB3
	stra,r0 M32_RB4
	stra,r0 fixed_div_shifts
	stra,r0 fixed_div_shifts+1
	stra,r0 fixed_div_shifts+2
	stra,r0 fixed_div_shifts+3
	stra,r0 fixed_div_shifts+4
	bsta,un muldiv_correct_in_signs
	
	lodi,r3 48 ; Replace with 56 for 8.24 fixed-point TODO: make this a subroutine arg
fixed_div_loop:
	strr,r3 fixed_div_counter
	
	cpsl PSL_CARRY_FLAG
	loda,r0 M32_RB1
	loda,r1 M32_RB2
	loda,r2 M32_RB3
	loda,r3 M32_RB4
	rrl,r0
	rrl,r1
	rrl,r2
	rrl,r3
	stra,r0 M32_RB1
	stra,r1 M32_RB2
	stra,r2 M32_RB3
	stra,r3 M32_RB4
	
	loda,r0 M32_A1
	loda,r1 M32_A2
	loda,r2 M32_A3
	loda,r3 M32_A4
	cpsl PSL_CARRY_FLAG
	rrl,r0
	rrl,r1
	rrl,r2
	rrl,r3
	stra,r0 M32_A1
	stra,r1 M32_A2
	stra,r2 M32_A3
	stra,r3 M32_A4
	loda,r0 fixed_div_shifts
	rrl,r0
	stra,r0 fixed_div_shifts
	loda,r0 fixed_div_shifts+1
	loda,r1 fixed_div_shifts+2
	loda,r2 fixed_div_shifts+3
	loda,r3 fixed_div_shifts+4
	rrl,r0
	rrl,r1
	rrl,r2
	rrl,r3
	stra,r0 fixed_div_shifts+1
	stra,r1 fixed_div_shifts+2
	stra,r2 fixed_div_shifts+3
	stra,r3 fixed_div_shifts+4
	
	ppsl PSL_CARRY_FLAG
	loda,r0 fixed_div_shifts+0
	loda,r1 M32_B1
	bctr,eq fixed1746
	subz,r1
fixed1746:
	stra,r0 fixed_div_subs+0
	
	loda,r0 fixed_div_shifts+1
	loda,r1 M32_B2
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix1752
	comi,r1 0
	bctr,eq fixed1754
nofix1752:
	subz,r1
fixed1754:
	stra,r0 fixed_div_subs+1
	
	loda,r0 fixed_div_shifts+2
	loda,r1 M32_B3
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix1763
	comi,r1 0
	bctr,eq fixed1765
nofix1763:
	subz,r1
fixed1765:
	stra,r0 fixed_div_subs+2
	
	lodz,r2
	loda,r1 M32_B4
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix1774
	comi,r1 0
	bctr,eq fixed1776
nofix1774:
	subz,r1
fixed1776:
	stra,r0 fixed_div_subs+3
	
	subi,r3 0
	stra,r3 fixed_div_subs+4
	andi,r3 128
	bcfr,eq fixed_div_continue
	loda,r0 M32_RB1
	iori,r0 1
	stra,r0 M32_RB1
	loda,r0 fixed_div_subs+0
	stra,r0 fixed_div_shifts+0
	loda,r0 fixed_div_subs+1
	stra,r0 fixed_div_shifts+1
	loda,r0 fixed_div_subs+2
	stra,r0 fixed_div_shifts+2
	loda,r0 fixed_div_subs+3
	stra,r0 fixed_div_shifts+3
	loda,r0 fixed_div_subs+4
	stra,r0 fixed_div_shifts+4
fixed_div_continue:
	loda,r3 fixed_div_counter
	bdra,r3 fixed_div_loop
	
fixed_div_done: ;lirz.de/lf9
	loda,r0 M32_SIGN
	comi,r0 0
	bcta,eq fixed_div_no_negate_res
	lodi,r2 255
	lodi,r3 0
	cpsl PSL_CARRY_FLAG
	loda,r0 M32_RB1
	eorz r2
	addi,r0 1
	stra,r0 M32_RB1
	loda,r0 M32_RB2
	eorz r2
	addz r3
	stra,r0 M32_RB2
	loda,r0 M32_RB3
	eorz r2
	addz r3
	stra,r0 M32_RB3
	loda,r0 M32_RB4
	eorz r2
	addz r3
	stra,r0 M32_RB4
fixed_div_no_negate_res:
	pop
	stra,r0 ret_workaround
	stra,r1 ret_workaround+1
	loda,r0 PSL_BACK
	lpsl
	loda,r1 fixed_div_reg_backs
	loda,r2 fixed_div_reg_backs+1
	loda,r3 fixed_div_reg_backs+2
	bcta,un *ret_workaround
fixed_div_reg_backs:
	db 0,0,0
fixed_div_shifts:
	db 0,0,0,0,0
fixed_div_subs:
	db 0,0,0,0,0

sine_reg_backs:
	db 0,0,0
sine_ret:
	db 0,0
sine_psl:
	db 0
sine:
	spsl
	strr,r0 sine_psl
	strr,r1 sine_reg_backs
	strr,r2 sine_reg_backs+1
	strr,r3 sine_reg_backs+2
sine_entry:
	cpsl PSL_WITH_CARRY
	eorz,r0
	wrtc,r0
	redd,r1
	rrl,r1
	rrl,r1
	andi,r1 3
	stra,r1 draw_char_page_back
	wrtd,r0
	ppsl PSL_WITH_CARRY
	
	loda,r3 ARITH_A4
	tmi,r3 128
	bcfr,eq sine_in_not_neg
	cpsl PSL_CARRY_FLAG
	lodi,r1 255
	lodi,r2 0
	loda,r0 ARITH_A1
	eorz r1
	addi,r0 1
	stra,r0 ARITH_A1
	loda,r0 ARITH_A2
	eorz r1
	addz r2
	stra,r0 ARITH_A2
	loda,r0 ARITH_A3
	eorz r1
	addz r2
	stra,r0 ARITH_A3
	loda,r0 ARITH_A4
	eorz r1
	addz r2
	stra,r0 ARITH_A4
	lodi,r2 1
	stra,r2 M32_SIGN
sine_in_not_neg:
	; Divide by 2pi
	loda,r0 ARITH_A1
	stra,r0 M32_A1
	loda,r0 ARITH_A2
	stra,r0 M32_A2
	loda,r0 ARITH_A3
	stra,r0 M32_A3
	loda,r0 ARITH_A4
	stra,r0 M32_A4
	eorz,r0
	stra,r0 M32_B4
	lodi,r0 0x06
	stra,r0 M32_B3
	lodi,r0 0x48
	stra,r0 M32_B2
	lodi,r0 0x7F
	stra,r0 M32_B1
	bsta,un fixed_div
	loda,r0 M32_RB2
	strz,r1
	strz,r3
	andi,r0 0b01000000 ; Inverse or not?
	strz,r2
	rrl,r1
	andi,r1 0b01111110 ; LUT Index
	andi,r3 0b10000000 ; Negative or not
	stra,r3 sine_should_neg
	
	lodz,r2
	bctr,eq sine_not_inverse
	lodi,r0 0b01111110
	ppsl PSL_CARRY_FLAG
	subz,r1
	strz,r1
sine_not_inverse:
	
	eorz,r0
	stra,r0 ARITH_RB4
	comi,r1 0b01111110
	bcfr,eq sine_not_one
		lodi,r0 1
		stra,r0 ARITH_RB3
		eorz,r0
		stra,r0 ARITH_RB1
		stra,r0 ARITH_RB1
		bctr,un sine_lut_done
sine_not_one:
	eorz,r0
	stra,r0 ARITH_RB3
	loda,r0 sine_lut,r1
	stra,r0 ARITH_RB1
	loda,r0 sine_lut,r1+
	stra,r0 ARITH_RB2
sine_lut_done:
	loda,r1 ARITH_RB1
	loda,r2 ARITH_RB2
	loda,r3 ARITH_RB3
	loda,r0 sine_should_neg
	comi,r0 0
	bctr,eq sine_not_negative
	
	; sine = -sine
	ppsl PSL_CARRY_FLAG
	eori,r1 0xFF
	addi,r1 0
	eori,r2 0xFF
	addi,r2 0
	eori,r3 0xFF
	addi,r3 0
	lodi,r0 0xFF
	addi,r0 0
	stra,r0 ARITH_RB4
	
sine_not_negative:
	stra,r1 ARITH_RB1
	stra,r2 ARITH_RB2
	stra,r3 ARITH_RB3
	
	eorz,r0
	wrtc,r0
	loda,r0 draw_char_page_back
	wrtd,r0
	
	pop
	stra,r0 sine_ret
	stra,r1 sine_ret+1
	loda,r0 sine_reg_backs
	loda,r1 sine_reg_backs+1
	loda,r2 sine_reg_backs+2
	loda,r0 sine_psl
	lpsl
	bcta,un *sine_ret
sine_should_neg:
	db 0

cos:
	spsl
	stra,r0 sine_psl
	stra,r1 sine_reg_backs
	stra,r2 sine_reg_backs+1
	stra,r3 sine_reg_backs+2
	ppsl PSL_WITH_CARRY
	cpsl PSL_CARRY_FLAG
	loda,r0 ARITH_A1
	addi,r0 0x20
	stra,r0 ARITH_A1
	loda,r0 ARITH_A2
	addi,r0 0x92
	stra,r0 ARITH_A2
	loda,r0 ARITH_A3
	addi,r0 1
	stra,r0 ARITH_A3
	loda,r0 ARITH_A4
	addi,r0 0
	stra,r0 ARITH_A4
	bcta,un sine_entry

org 6000
sine_lut:
	db 0x00,0x00
	db 0x61,0x06
	db 0xc2,0x0c
	db 0x21,0x13
	db 0x7d,0x19
	db 0xd4,0x1f
	db 0x27,0x26
	db 0x74,0x2c
	db 0xb9,0x32
	db 0xf7,0x38
	db 0x2b,0x3f
	db 0x55,0x45
	db 0x75,0x4b
	db 0x88,0x51
	db 0x8e,0x57
	db 0x86,0x5d
	db 0x70,0x63
	db 0x4a,0x69
	db 0x13,0x6f
	db 0xca,0x74
	db 0x6e,0x7a
	db 0xff,0x7f
	db 0x7c,0x85
	db 0xe4,0x8a
	db 0x35,0x90
	db 0x70,0x95
	db 0x92,0x9a
	db 0x9d,0x9f
	db 0x8d,0xa4
	db 0x64,0xa9
	db 0x1f,0xae
	db 0xbf,0xb2
	db 0x43,0xb7
	db 0xa9,0xbb
	db 0xf1,0xbf
	db 0x1b,0xc4
	db 0x26,0xc8
	db 0x10,0xcc
	db 0xdb,0xcf
	db 0x84,0xd3
	db 0x0b,0xd7
	db 0x71,0xda
	db 0xb3,0xdd
	db 0xd3,0xe0
	db 0xce,0xe3
	db 0xa5,0xe6
	db 0x58,0xe9
	db 0xe5,0xeb
	db 0x4d,0xee
	db 0x8f,0xf0
	db 0xab,0xf2
	db 0xa0,0xf4
	db 0x6e,0xf6
	db 0x15,0xf8
	db 0x94,0xf9
	db 0xec,0xfa
	db 0x1c,0xfc
	db 0x24,0xfd
	db 0x03,0xfe
	db 0xba,0xfe
	db 0x48,0xff
	db 0xae,0xff
	db 0xeb,0xff

font:
	db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	db 0x04,0x04,0x04,0x04,0x04,0x04,0x00,0x04
	db 0x0a,0x0a,0x0a,0x00,0x00,0x00,0x00,0x00
	db 0x0a,0x0a,0x1f,0x0a,0x0a,0x1f,0x0a,0x0a
	db 0x04,0x1e,0x05,0x05,0x0e,0x14,0x0f,0x04
	db 0x00,0x00,0x12,0x08,0x04,0x02,0x09,0x00
	db 0x06,0x09,0x09,0x09,0x06,0x16,0x09,0x16
	db 0x02,0x02,0x00,0x00,0x00,0x00,0x00,0x00
	db 0x04,0x02,0x01,0x01,0x01,0x01,0x02,0x04
	db 0x04,0x08,0x10,0x10,0x10,0x10,0x08,0x04
	db 0x00,0x04,0x15,0x0e,0x15,0x04,0x00,0x00
	db 0x00,0x04,0x04,0x1f,0x04,0x04,0x00,0x00
	db 0x00,0x00,0x00,0x00,0x00,0x04,0x04,0x04
	db 0x00,0x00,0x00,0x0e,0x00,0x00,0x00,0x00
	db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x04
	db 0x00,0x00,0x10,0x08,0x04,0x02,0x01,0x00
	db 0x0e,0x11,0x19,0x15,0x15,0x13,0x11,0x0e
	db 0x18,0x14,0x10,0x10,0x10,0x10,0x10,0x10
	db 0x0e,0x11,0x10,0x08,0x04,0x02,0x01,0x1f
	db 0x0e,0x11,0x10,0x0e,0x10,0x10,0x11,0x0e
	db 0x18,0x14,0x12,0x11,0x1f,0x10,0x10,0x10
	db 0x1f,0x01,0x01,0x0e,0x10,0x10,0x11,0x0e
	db 0x0e,0x11,0x01,0x0f,0x11,0x11,0x11,0x0e
	db 0x1f,0x10,0x10,0x08,0x04,0x04,0x04,0x04
	db 0x0e,0x11,0x11,0x0e,0x11,0x11,0x11,0x0e
	db 0x0e,0x11,0x11,0x1e,0x10,0x10,0x11,0x0e
	db 0x00,0x04,0x00,0x00,0x00,0x00,0x04,0x00
	db 0x00,0x04,0x00,0x00,0x00,0x00,0x04,0x04
	db 0x00,0x08,0x04,0x02,0x01,0x02,0x04,0x08
	db 0x00,0x00,0x1f,0x00,0x00,0x1f,0x00,0x00
	db 0x00,0x02,0x04,0x08,0x10,0x08,0x04,0x02
	db 0x0e,0x11,0x10,0x08,0x04,0x04,0x00,0x04
	db 0x0e,0x11,0x10,0x10,0x16,0x15,0x15,0x0e
	db 0x0e,0x11,0x11,0x11,0x1f,0x11,0x11,0x11
	db 0x0f,0x11,0x11,0x0f,0x11,0x11,0x11,0x0f
	db 0x0e,0x01,0x01,0x01,0x01,0x01,0x01,0x0e
	db 0x0f,0x11,0x11,0x11,0x11,0x11,0x11,0x0f
	db 0x1f,0x01,0x01,0x1f,0x01,0x01,0x01,0x1f
	db 0x1f,0x01,0x01,0x1f,0x01,0x01,0x01,0x01
	db 0x0e,0x11,0x11,0x01,0x1d,0x11,0x11,0x0e
	db 0x11,0x11,0x11,0x1f,0x11,0x11,0x11,0x11
	db 0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04
	db 0x08,0x08,0x08,0x08,0x08,0x08,0x0a,0x04
	db 0x11,0x09,0x05,0x03,0x03,0x05,0x09,0x11
	db 0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x0f
	db 0x11,0x1b,0x15,0x11,0x11,0x11,0x11,0x11
	db 0x11,0x11,0x13,0x15,0x19,0x11,0x11,0x11
	db 0x0e,0x11,0x11,0x11,0x11,0x11,0x11,0x0e
	db 0x0f,0x11,0x11,0x0f,0x01,0x01,0x01,0x01
	db 0x0e,0x11,0x11,0x11,0x11,0x15,0x19,0x1e
	db 0x0f,0x11,0x11,0x0f,0x11,0x11,0x11,0x11
	db 0x0e,0x11,0x01,0x0e,0x10,0x10,0x11,0x0e
	db 0x1f,0x04,0x04,0x04,0x04,0x04,0x04,0x04
	db 0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x0e
	db 0x11,0x11,0x11,0x11,0x11,0x11,0x0a,0x04
	db 0x11,0x11,0x11,0x11,0x11,0x15,0x1b,0x11
	db 0x11,0x11,0x11,0x0a,0x04,0x0a,0x11,0x11
	db 0x11,0x11,0x11,0x0a,0x04,0x04,0x04,0x04
	db 0x1f,0x10,0x08,0x04,0x04,0x02,0x01,0x1f
	db 0x0e,0x02,0x02,0x02,0x02,0x02,0x02,0x0e
	db 0x00,0x00,0x01,0x02,0x04,0x08,0x10,0x00
	db 0x0e,0x08,0x08,0x08,0x08,0x08,0x08,0x0e
	db 0x04,0x0a,0x11,0x00,0x00,0x00,0x00,0x00
	db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x1f
	db 0x02,0x04,0x00,0x00,0x00,0x00,0x00,0x00
	db 0x00,0x00,0x00,0x0e,0x10,0x1e,0x11,0x1e
	db 0x01,0x01,0x01,0x01,0x0d,0x13,0x11,0x0f
	db 0x00,0x00,0x00,0x0e,0x01,0x01,0x01,0x0e
	db 0x10,0x10,0x10,0x16,0x19,0x11,0x11,0x1e
	db 0x00,0x00,0x00,0x0e,0x11,0x1f,0x01,0x0e
	db 0x0c,0x12,0x02,0x02,0x07,0x02,0x02,0x02
	db 0x00,0x00,0x00,0x1e,0x11,0x1e,0x10,0x0e
	db 0x00,0x01,0x01,0x01,0x0d,0x13,0x11,0x11
	db 0x00,0x04,0x00,0x06,0x04,0x04,0x04,0x0e
	db 0x00,0x08,0x00,0x0c,0x08,0x08,0x0a,0x04
	db 0x00,0x01,0x01,0x09,0x05,0x03,0x05,0x09
	db 0x00,0x06,0x04,0x04,0x04,0x04,0x04,0x0e
	db 0x00,0x00,0x00,0x00,0x0b,0x15,0x15,0x11
	db 0x00,0x00,0x00,0x0d,0x13,0x11,0x11,0x11
	db 0x00,0x00,0x00,0x0e,0x11,0x11,0x11,0x0e
	db 0x00,0x00,0x00,0x0f,0x11,0x0f,0x01,0x01
	db 0x00,0x00,0x00,0x16,0x19,0x16,0x10,0x10
	db 0x00,0x00,0x00,0x0d,0x13,0x01,0x01,0x01
	db 0x00,0x00,0x00,0x0e,0x01,0x0e,0x10,0x0f
	db 0x00,0x02,0x02,0x07,0x02,0x02,0x12,0x0c
	db 0x00,0x00,0x00,0x11,0x11,0x11,0x19,0x16
	db 0x00,0x00,0x00,0x11,0x11,0x11,0x0a,0x04
	db 0x00,0x00,0x00,0x11,0x11,0x15,0x15,0x0a
	db 0x00,0x00,0x00,0x11,0x0a,0x04,0x0a,0x11
	db 0x00,0x00,0x00,0x11,0x11,0x1e,0x10,0x0e
	db 0x00,0x00,0x00,0x1f,0x08,0x04,0x02,0x1f
	db 0x00,0x04,0x02,0x02,0x01,0x02,0x02,0x04
	db 0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04
	db 0x00,0x04,0x08,0x08,0x10,0x08,0x08,0x04
	db 0x00,0x00,0x00,0x12,0x15,0x09,0x00,0x00

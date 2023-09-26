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

org 4096
programentry:
	nop
	bsta,un *F_WAIT_NEXT_FRAME
	
	eorz,r0
	stra,r0 APP_INDEX
	bcta,un *F_RUN_APP

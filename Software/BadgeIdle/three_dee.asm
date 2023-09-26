PSL_CC1          equ 0b10000000
PSL_CC0          equ 0b01000000
PSL_IDC          equ 0b00100000
PSL_BANK         equ 0b00010000
PSL_WITH_CARRY   equ 0b00001000
PSL_OVERFLOW     equ 0b00000100
PSL_LOGICAL_COMP equ 0b00000010
PSL_CARRY_FLAG   equ 0b00000001

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
M32_FB1      equ root_mem_start+52
M32_FB2      equ root_mem_start+53
M32_FB3      equ root_mem_start+54
M32_FB4      equ root_mem_start+55

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

; Constants
CONST_A equ 0x00008000 ; width over height of 2D screen (64 / 32)
; For reference: FOV is 35°
CONST_F equ 0x00032BEE ; 1 / tan(phi / 2), where phi is the FOV angle
; For reference: Zfar is 16, Znear is 0.0625
CONST_Q equ 0x00010101 ; Zfar / (Zfar - Znear)
CONST_NEAR_Q equ 0x00001010 ; (Zfar * Znear) / (Zfar - Znear)
CONST_AF equ 0x000195F7 ; a * f 0x000657DC
CONST_FRUSTUM_DEPTH_CEIL equ 16

;(a*f*x)/z, (f*y)/z

mem_start equ 7936
POINT_X equ mem_start
POINT_Y equ mem_start+4
POINT_Z equ mem_start+8
POINT_CAM_X equ mem_start+12
POINT_CAM_Y equ mem_start+16
POINT_CAM_Z equ mem_start+20
BOUNDING_MINX equ mem_start+24
BOUNDING_MAXX equ mem_start+25
BOUNDING_MINY equ mem_start+26
BOUNDING_MAXY equ mem_start+27
VERT1_CAM_X equ mem_start+28
VERT1_CAM_Y equ mem_start+32
VERT1_CAM_Z equ mem_start+36
VERT2_CAM_X equ mem_start+40
VERT2_CAM_Y equ mem_start+44
VERT2_CAM_Z equ mem_start+48
VERT3_CAM_X equ mem_start+52
VERT3_CAM_Y equ mem_start+56
VERT3_CAM_Z equ mem_start+60
EDGE_POINT_X equ mem_start+64
EDGE_POINT_Y equ mem_start+65
EDGE_VERT1_X equ mem_start+66
EDGE_VERT1_Y equ mem_start+70
EDGE_VERT2_X equ mem_start+74
EDGE_VERT2_Y equ mem_start+78
EDGE_RES1 equ mem_start+82
EDGE_RES2 equ mem_start+83
EDGE_RES3 equ mem_start+84
EDGE_RES4 equ mem_start+85
LAMBD0 equ mem_start+86
LAMBD1 equ mem_start+90
LAMBD2 equ mem_start+94
TOTAL_AREA equ mem_start+98
DB_COL_PTR equ mem_start+102
DB_ROW_ADDR equ mem_start+103 ; 2 bytes
POINT_DEPTH equ mem_start+105 ; 4 bytes
NORMAL_X equ mem_start+109
NORMAL_Y equ mem_start+113
NORMAL_Z equ mem_start+117
TO_ROTATE_X equ mem_start+121
TO_ROTATE_Z equ mem_start+125
COS_THETA equ mem_start+129
SINE_THETA equ mem_start+133
NEG_SINE_THETA equ mem_start+137
THETA equ mem_start+141
Z_OFFSET equ mem_start+145

AVALI_POLY_BUFF equ mem_start+200

org 4096
funct_table:
	db spinning_cube%256
	db spinning_cube>>8
	db avali_head%256
	db avali_head>>8
test_polygon:
	db 0xff,0xfe,0xca
	db 0x00,0x49,0x21
	db 0xff,0x60,0xef

	db 0x00,0x06,0xf6
	db 0x00,0xa9,0x77
	db 0x00,0x5a,0xc9

	db 0x00,0x88,0xb4
	db 0x00,0x74,0x09
	db 0xff,0xdb,0x83

	db 0x00,0x04,0x40
	db 0x00,0x82,0xb1
	db 0xff,0xcd,0x79
	db 0xfc
	db 0x00,0x88,0xb4
	db 0x00,0x74,0x09
	db 0xff,0xdb,0x83

	db 0x00,0x01,0x36
	db 0xff,0xf8,0xdb
	db 0x00,0x9f,0x11

	db 0x00,0x82,0xf4
	db 0xff,0xc3,0x6d
	db 0x00,0x1f,0xca

	db 0x00,0x66,0x0f
	db 0x00,0x1f,0xbf
	db 0x00,0x5a,0xb5
	db 0xff
	db 0x00,0x01,0x36
	db 0xff,0xf8,0xdb
	db 0x00,0x9f,0x11

	db 0xff,0x7d,0x0c
	db 0x00,0x7e,0x90
	db 0xff,0xe0,0x36

	db 0xff,0x77,0x4c
	db 0xff,0xcd,0xf4
	db 0x00,0x24,0x7d

	db 0xff,0x9f,0xfe
	db 0x00,0x27,0x89
	db 0x00,0x5e,0x2f
	db 0x1f
	db 0xff,0xf9,0x0a
	db 0xff,0x98,0x86
	db 0xff,0xa5,0x37

	db 0x00,0x01,0x36
	db 0xff,0xf8,0xdb
	db 0x00,0x9f,0x11

	db 0xff,0x77,0x4c
	db 0xff,0xcd,0xf4
	db 0x00,0x24,0x7d

	db 0xff,0xfb,0xc0
	db 0xff,0x7d,0x4f
	db 0x00,0x32,0x87
	db 0x83
	db 0xff,0xfe,0xca
	db 0x00,0x49,0x21
	db 0xff,0x60,0xef

	db 0x00,0x82,0xf4
	db 0xff,0xc3,0x6d
	db 0x00,0x1f,0xca

	db 0xff,0xf9,0x0a
	db 0xff,0x98,0x86
	db 0xff,0xa5,0x37

	db 0x00,0x60,0x02
	db 0xff,0xd8,0x77
	db 0xff,0xa1,0xd1
	db 0xe8
	db 0xff,0x7d,0x0c
	db 0x00,0x7e,0x90
	db 0xff,0xe0,0x36

	db 0xff,0xf9,0x0a
	db 0xff,0x98,0x86
	db 0xff,0xa5,0x37

	db 0xff,0x77,0x4c
	db 0xff,0xcd,0xf4
	db 0x00,0x24,0x7d

	db 0xff,0x99,0xf1
	db 0xff,0xe0,0x41
	db 0xff,0xa5,0x4b
	db 0x71
	db 0xff,0xfe,0xca
	db 0x00,0x49,0x21
	db 0xff,0x60,0xef

	db 0xff,0x7d,0x0c
	db 0x00,0x7e,0x90
	db 0xff,0xe0,0x36

	db 0x00,0x06,0xf6
	db 0x00,0xa9,0x77
	db 0x00,0x5a,0xc9

	db 0x00,0x04,0x40
	db 0x00,0x82,0xb1
	db 0xff,0xcd,0x79
	db 0xfc
	db 0x00,0x88,0xb4
	db 0x00,0x74,0x09
	db 0xff,0xdb,0x83

	db 0x00,0x06,0xf6
	db 0x00,0xa9,0x77
	db 0x00,0x5a,0xc9

	db 0x00,0x01,0x36
	db 0xff,0xf8,0xdb
	db 0x00,0x9f,0x11

	db 0x00,0x66,0x0f
	db 0x00,0x1f,0xbf
	db 0x00,0x5a,0xb5
	db 0xff
	db 0x00,0x01,0x36
	db 0xff,0xf8,0xdb
	db 0x00,0x9f,0x11

	db 0x00,0x06,0xf6
	db 0x00,0xa9,0x77
	db 0x00,0x5a,0xc9

	db 0xff,0x7d,0x0c
	db 0x00,0x7e,0x90
	db 0xff,0xe0,0x36

	db 0xff,0x9f,0xfe
	db 0x00,0x27,0x89
	db 0x00,0x5e,0x2f
	db 0x1f
	db 0xff,0xf9,0x0a
	db 0xff,0x98,0x86
	db 0xff,0xa5,0x37

	db 0x00,0x82,0xf4
	db 0xff,0xc3,0x6d
	db 0x00,0x1f,0xca

	db 0x00,0x01,0x36
	db 0xff,0xf8,0xdb
	db 0x00,0x9f,0x11

	db 0xff,0xfb,0xc0
	db 0xff,0x7d,0x4f
	db 0x00,0x32,0x87
	db 0x83
	db 0xff,0xfe,0xca
	db 0x00,0x49,0x21
	db 0xff,0x60,0xef

	db 0x00,0x88,0xb4
	db 0x00,0x74,0x09
	db 0xff,0xdb,0x83

	db 0x00,0x82,0xf4
	db 0xff,0xc3,0x6d
	db 0x00,0x1f,0xca

	db 0x00,0x60,0x02
	db 0xff,0xd8,0x77
	db 0xff,0xa1,0xd1
	db 0xe8
	db 0xff,0x7d,0x0c
	db 0x00,0x7e,0x90
	db 0xff,0xe0,0x36

	db 0xff,0xfe,0xca
	db 0x00,0x49,0x21
	db 0xff,0x60,0xef

	db 0xff,0xf9,0x0a
	db 0xff,0x98,0x86
	db 0xff,0xa5,0x37

	db 0xff,0x99,0xf1
	db 0xff,0xe0,0x41
	db 0xff,0xa5,0x4b
	db 0x71
polygon_ptr:
	db 0,0
psl_back:
	db 0
vars:
	db 0,0
bb_loop_counters:
	db 0,0,0
face_counter:
	db 0
cube_rots:
	db 0x00,0x20,0x40,0x60,0xFF
spinning_cube:
	spsl
	strr,r0 psl_back
	
	lodi,r0 0
	stra,r0 Z_OFFSET+3
	lodi,r0 2
	stra,r0 Z_OFFSET+2
	lodi,r0 0x99
	stra,r0 Z_OFFSET+1
	lodi,r0 0x98
	stra,r0 Z_OFFSET+0
	
	;eorz,r0
	;stra,r0 CURR_VRAM_PAGE
	;lodi,r1 2
	;wrtc,r1
	;wrtd,r0
	
	ppsl PSL_BANK
	lodi,r3 255
	cpsl PSL_BANK
spinning_cube_loop:
	cpsl PSL_WITH_CARRY
	ppsl PSL_LOGICAL_COMP
	
	eorz,r0
	stra,r0 THETA+0
	stra,r0 THETA+2
	stra,r0 THETA+3
	ppsl PSL_BANK
	loda,r0 cube_rots,r3+
	stra,r0 THETA+1
	andi,r0 128
	bctr,eq rot_not_neg
	lodi,r0 0xFF
	stra,r0 THETA+2
	stra,r0 THETA+3
rot_not_neg:
	cpsl PSL_BANK
	lodi,r0 0xFF
	coma,r0 THETA+1
	bcta,eq spinning_cube_done
	
	eorz,r0
	stra,r0 FOREGROUND_COLOR
	bsta,un *F_FILL_FB
	bsta,un clear_depth
	
	lodi,r0 test_polygon%256
	stra,r0 polygon_ptr+1
	lodi,r0 test_polygon>>8%256
	stra,r0 polygon_ptr
	eorz,r0
	stra,r0 face_counter
	
cube_render_loop:
	bsta,un render_polygon
	cpsl PSL_WITH_CARRY
	loda,r0 polygon_ptr+1
	addi,r0 37
	stra,r0 polygon_ptr+1
	ppsl PSL_WITH_CARRY
	loda,r0 polygon_ptr
	addi,r0 0
	stra,r0 polygon_ptr
	cpsl PSL_WITH_CARRY
	loda,r0 face_counter
	addi,r0 1
	stra,r0 face_counter
	comi,r0 12
	bcfr,eq cube_render_loop
	
	;bsta,un debug_show_depth

	bsta,un *F_SWAP_BUFFERS
	bsta,un *F_WAIT_NEXT_FRAME
	;db 0
	bcta,un spinning_cube_loop
spinning_cube_done:
	lodi,r2 64
aaaaa:
	bsta,un *F_WAIT_NEXT_FRAME
	bdrr,r2 aaaaa
	
	loda,r0 psl_back
	lpsl
	retc,un

avali_head_face_count equ 1449
avali_head:
	spsl
	stra,r0 psl_back
	
	lodi,r0 0
	stra,r0 THETA+0
	stra,r0 THETA+2
	stra,r0 THETA+3
	stra,r0 THETA+1
	eorz,r0
	stra,r0 Z_OFFSET+3
	lodi,r0 1
	stra,r0 Z_OFFSET+2
	lodi,r0 0x33
	stra,r0 Z_OFFSET+1
	stra,r0 Z_OFFSET+0
	
	loda,r1 CURR_APP_DAT
	loda,r2 CURR_APP_DAT+1
	loda,r3 CURR_APP_DAT+2
	cpsl PSL_WITH_CARRY
	addi,r2 0x20
	ppsl PSL_WITH_CARRY
	addi,r3 0
	cpsl PSL_WITH_CARRY
	bsta,un *F_BEGIN_ROM_READ
	
	lodi,r0 0
	stra,r0 FOREGROUND_COLOR
	stra,r0 CURR_VRAM_PAGE
	bsta,un *F_FILL_FB
	lodi,r2 2
	wrtc,r2
	eorz,r0
	wrtd,r0
	bsta,un clear_depth
	
	lodi,r0 AVALI_POLY_BUFF%256
	stra,r0 polygon_ptr+1
	lodi,r0 AVALI_POLY_BUFF>>8%256
	stra,r0 polygon_ptr
	
	ppsl PSL_BANK
	lodi,r2 0
	lodi,r3 0
avali_render_loop:
	cpsl PSL_BANK+PSL_WITH_CARRY
	
	lodi,r1 0
poly_read_loop:
	bsta,un *F_ROM_READ_NEXT
	stra,r0 AVALI_POLY_BUFF,r1
	addi,r1 1
	comi,r1 37
	bcfr,eq poly_read_loop
	bsta,un render_polygon
	
	ppsl PSL_BANK
	lodz,r2
	cpsl PSL_BANK
	andi,r0 0b00000011
	bsta,eq *F_WAIT_NEXT_FRAME
	
	tpsu 64
	cpsu 64
	bctr,eq ajdiwwd
	ppsu 64
ajdiwwd:
	
	ppsl PSL_BANK+PSL_WITH_CARRY+PSL_CARRY_FLAG
	addi,r2 0
	addi,r3 0
	comi,r2 avali_head_face_count%256
	bcfa,eq avali_render_loop
	comi,r3 avali_head_face_count>>8
	bcfa,eq avali_render_loop
	cpsl PSL_BANK+PSL_WITH_CARRY
	lodi,r2 88
abcde:
	bsta,un *F_WAIT_NEXT_FRAME
	bdrr,r2 abcde
	
	cpsu 64
	lodz,r0
	;halt
	
	bsta,un *F_ROM_DESEL
	loda,r0 psl_back
	lpsl
	retc,un

render_polygon:
	bsta,un prepare_rot_params
	
	lodi,r3 27
	lodi,r2 3
cpy_12:
	loda,r0 *polygon_ptr,r3
	stra,r0 NORMAL_X,r2-
	addi,r3 3
	loda,r0 *polygon_ptr,r3
	stra,r0 NORMAL_Y,r2
	addi,r3 3
	loda,r0 *polygon_ptr,r3
	stra,r0 NORMAL_Z,r2
	subi,r3 6
	addi,r3 1
	brnr,r2 cpy_12
	
	lodi,r1 0
	loda,r0 NORMAL_X+2
	andi,r0 128
	bctr,eq nx_pos
	lodi,r1 0xFF
nx_pos:
	stra,r1 NORMAL_X+3
	lodi,r1 0
	loda,r0 NORMAL_Y+2
	andi,r0 128
	bctr,eq ny_pos
	lodi,r1 0xFF
ny_pos:
	stra,r1 NORMAL_Y+3
	lodi,r1 0
	loda,r0 NORMAL_Z+2
	andi,r0 128
	bctr,eq nz_pos
	lodi,r1 0xFF
nz_pos:
	stra,r1 NORMAL_Z+3
	
	lodi,r3 4
cpy_14:
	loda,r0 NORMAL_X,r3-
	stra,r0 TO_ROTATE_X,r3
	loda,r0 NORMAL_Z,r3
	stra,r0 TO_ROTATE_Z,r3
	nop
	brnr,r3 cpy_14
	
	bsta,un rotate_vector_y
	
	lodi,r3 4
cpy_15:
	loda,r0 TO_ROTATE_X,r3-
	stra,r0 NORMAL_X,r3
	loda,r0 TO_ROTATE_Z,r3
	stra,r0 NORMAL_Z,r3
	nop
	brnr,r3 cpy_15
	
	loda,r0 NORMAL_Z+3
	andi,r0 128
	bcfa,eq skip_triangle
	
	eorz,r0
	stra,r0 vars
	lodi,r2 3
triangle_loop:
	stra,r2 vars+1	
	
	eorz,r0
	stra,r0 POINT_X+3
	stra,r0 POINT_Y+3
	stra,r0 POINT_Z+3
	lodi,r2 3
	loda,r3 vars
cpy_5:
	loda,r0 *polygon_ptr,r3
	stra,r0 POINT_X,r2-
	addi,r3 3
	loda,r0 *polygon_ptr,r3
	stra,r0 POINT_Y,r2
	addi,r3 3
	loda,r0 *polygon_ptr,r3
	stra,r0 POINT_Z,r2
	subi,r3 6
	addi,r3 1
	brnr,r2 cpy_5
	loda,r3 vars
	addi,r3 9
	stra,r3 vars

	lodi,r1 0xFF
	loda,r0 POINT_X+2
	andi,r0 128
	bctr,eq px_pos
	stra,r1 POINT_X+3
px_pos:
	loda,r0 POINT_Y+2
	andi,r0 128
	bctr,eq py_pos
	stra,r1 POINT_Y+3
py_pos:
	loda,r0 POINT_Z+2
	andi,r0 128
	bctr,eq pz_pos
	stra,r1 POINT_Z+3
pz_pos:
	
	lodi,r3 4
cpy_16:
	loda,r0 POINT_X,r3-
	stra,r0 TO_ROTATE_X,r3
	loda,r0 POINT_Z,r3
	stra,r0 TO_ROTATE_Z,r3
	nop
	brnr,r3 cpy_16
	
	bsta,un rotate_vector_y
	
	lodi,r3 4
cpy_17:
	loda,r0 TO_ROTATE_X,r3-
	stra,r0 POINT_X,r3
	loda,r0 TO_ROTATE_Z,r3
	stra,r0 POINT_Z,r3
	nop
	brnr,r3 cpy_17
	
	ppsl PSL_WITH_CARRY
	cpsl PSL_CARRY_FLAG
	
	; 1
	loda,r0 Z_OFFSET+0
	adda,r0 POINT_Z+0
	stra,r0 POINT_Z+0
	
	; 2
	loda,r0 Z_OFFSET+1
	loda,r1 POINT_Z+1
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix615
	comi,r1 0xFF
	bctr,eq fixed617
nofix615:
	addz,r1
fixed617:
	stra,r0 POINT_Z+1
	
	; 3
	loda,r0 Z_OFFSET+2
	loda,r1 POINT_Z+2
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix627
	comi,r1 0xFF
	bctr,eq fixed629
nofix627:
	addz,r1
fixed629:
	stra,r0 POINT_Z+2
	
	; 4
	loda,r0 Z_OFFSET+3
	adda,r0 POINT_Z+3
	stra,r0 POINT_Z+3
	
	cpsl PSL_WITH_CARRY
	
	bsta,un project_point
	bsta,un cam_point_to_screenspace
	
	cpsl PSL_WITH_CARRY
	lodi,r0 3
	suba,r0 vars+1
	lodi,r1 12
	mul
	lodz,r2
	strz,r3
	addi,r3 4
	lodi,r2 4
cpy_6:
	loda,r0 POINT_CAM_X,r2-
	stra,r0 VERT1_CAM_X,r3-
	loda,r0 POINT_CAM_Y,r2
	stra,r0 VERT1_CAM_Y,r3
	loda,r0 POINT_CAM_Z,r2
	stra,r0 VERT1_CAM_Z,r3
	brnr,r2 cpy_6
	
	loda,r2 vars+1
	comi,r2 3
	bctr,eq first_iter

	loda,r0 POINT_CAM_X+2
	coma,r0 BOUNDING_MAXX
	bcfr,gt maxx_ng
	stra,r0 BOUNDING_MAXX
maxx_ng:
	coma,r0 BOUNDING_MINX
	bcfr,lt minx_ng
	stra,r0 BOUNDING_MINX
minx_ng:
	loda,r0 POINT_CAM_Y+2
	coma,r0 BOUNDING_MAXY
	bcfr,gt maxy_ng
	stra,r0 BOUNDING_MAXY
maxy_ng:
	coma,r0 BOUNDING_MINY
	bcfr,lt miny_ng
	stra,r0 BOUNDING_MINY
minY_ng:

	bctr,un not_first_iter
first_iter:
	loda,r0 POINT_CAM_X+2
	stra,r0 BOUNDING_MAXX
	stra,r0 BOUNDING_MINX
	loda,r0 POINT_CAM_Y+2
	stra,r0 BOUNDING_MAXY
	stra,r0 BOUNDING_MINY
not_first_iter:

	loda,r2 vars+1
	bdra,r2 triangle_loop
	
	ppsl PSL_LOGICAL_COMP
	loda,r3 BOUNDING_MAXY
	comi,r3 30
	bcta,gt bounding_y_okay
	loda,r3 BOUNDING_MAXY
	addi,r3 1
	stra,r3 BOUNDING_MAXY
bounding_y_okay:
	loda,r3 BOUNDING_MAXX
	comi,r3 62
	bcta,gt bounding_x_ok
	loda,r3 BOUNDING_MAXX
	addi,r3 1
	stra,r3 BOUNDING_MAXX
bounding_x_ok:

	loda,r3 BOUNDING_MINX
	subi,r3 1
	stra,r3 BOUNDING_MINX
	loda,r3 BOUNDING_MINY
	subi,r3 1
	stra,r3 BOUNDING_MINY

	loda,r3 BOUNDING_MINY
	stra,r3 bb_loop_counters+1
bb_loop_y:
	loda,r1 bb_loop_counters+1
	bsta,un set_depth_row
	loda,r1 bb_loop_counters+1
	lodi,r0 64
	mul
	adda,r2 BOUNDING_MINX
	ppsl PSL_WITH_CARRY
	adda,r3 CURR_VRAM_PAGE
	cpsl PSL_WITH_CARRY
	lodi,r0 5
	wrtc,r0
	wrtd,r2
	wrtd,r3
	loda,r2 BOUNDING_MINX
	lodz,r2
	addz,r0
	stra,r0 DB_COL_PTR
bb_loop_x:
	stra,r2 bb_loop_counters+2
	stra,r2 EDGE_POINT_X
	loda,r0 bb_loop_counters+1
	stra,r0 EDGE_POINT_Y

	; First side
	lodi,r3 4
cpy_9:
	loda,r0 VERT2_CAM_X,r3-
	stra,r0 EDGE_VERT1_X,r3
	loda,r0 VERT2_CAM_Y,r3
	stra,r0 EDGE_VERT1_Y,r3
	loda,r0 VERT3_CAM_X,r3
	stra,r0 EDGE_VERT2_X,r3
	loda,r0 VERT3_CAM_Y,r3
	stra,r0 EDGE_VERT2_Y,r3
	brnr,r3 cpy_9
	bsta,un edge_function
	loda,r0 EDGE_RES4
	andi,r0 128
	bcta,eq skip_pix
	ppsl PSL_WITH_CARRY+PSL_CARRY_FLAG
	loda,r0 EDGE_RES1
	eori,r0 0xFF
	addi,r0 0
	stra,r0 LAMBD0+0
	loda,r0 EDGE_RES2
	eori,r0 0xFF
	addi,r0 0
	stra,r0 LAMBD0+1
	loda,r0 EDGE_RES3
	eori,r0 0xFF
	addi,r0 0
	stra,r0 LAMBD0+2
	loda,r0 EDGE_RES4
	eori,r0 0xFF
	addi,r0 0
	stra,r0 LAMBD0+3
	cpsl PSL_WITH_CARRY

	; Second side
	lodi,r3 4
cpy_10:
	loda,r0 VERT3_CAM_X,r3-
	stra,r0 EDGE_VERT1_X,r3
	loda,r0 VERT3_CAM_Y,r3
	stra,r0 EDGE_VERT1_Y,r3
	loda,r0 VERT1_CAM_X,r3
	stra,r0 EDGE_VERT2_X,r3
	loda,r0 VERT1_CAM_Y,r3
	stra,r0 EDGE_VERT2_Y,r3
	brnr,r3 cpy_10
	bsta,un edge_function
	loda,r0 EDGE_RES4
	andi,r0 128
	bcta,eq skip_pix
	ppsl PSL_WITH_CARRY+PSL_CARRY_FLAG
	loda,r0 EDGE_RES1
	eori,r0 0xFF
	addi,r0 0
	stra,r0 LAMBD1+0
	loda,r0 EDGE_RES2
	eori,r0 0xFF
	addi,r0 0
	stra,r0 LAMBD1+1
	loda,r0 EDGE_RES3
	eori,r0 0xFF
	addi,r0 0
	stra,r0 LAMBD1+2
	loda,r0 EDGE_RES4
	eori,r0 0xFF
	addi,r0 0
	stra,r0 LAMBD1+3
	cpsl PSL_WITH_CARRY
	
	; Third side
	lodi,r3 4
cpy_11:
	loda,r0 VERT1_CAM_X,r3-
	stra,r0 EDGE_VERT1_X,r3
	loda,r0 VERT1_CAM_Y,r3
	stra,r0 EDGE_VERT1_Y,r3
	loda,r0 VERT2_CAM_X,r3
	stra,r0 EDGE_VERT2_X,r3
	loda,r0 VERT2_CAM_Y,r3
	stra,r0 EDGE_VERT2_Y,r3
	brnr,r3 cpy_11
	bsta,un edge_function
	loda,r0 EDGE_RES4
	andi,r0 128
	bcta,eq skip_pix
	ppsl PSL_WITH_CARRY+PSL_CARRY_FLAG
	loda,r0 EDGE_RES1
	eori,r0 0xFF
	addi,r0 0
	stra,r0 LAMBD2+0
	loda,r0 EDGE_RES2
	eori,r0 0xFF
	addi,r0 0
	stra,r0 LAMBD2+1
	loda,r0 EDGE_RES3
	eori,r0 0xFF
	addi,r0 0
	stra,r0 LAMBD2+2
	loda,r0 EDGE_RES4
	eori,r0 0xFF
	addi,r0 0
	stra,r0 LAMBD2+3
	cpsl PSL_WITH_CARRY
	bctr,un pix_not_skipped
skip_pix:
	lodi,r0 1
	wrtc,r0
	wrtd,r0
	bcta,un bb_loop_continue
pix_not_skipped:
	; Compute total surface area, by summing component areas
	ppsl PSL_WITH_CARRY
	
	loda,r0 LAMBD0+0
	stra,r0 TOTAL_AREA+0
	loda,r0 LAMBD0+1
	stra,r0 TOTAL_AREA+1
	loda,r0 LAMBD0+2
	stra,r0 TOTAL_AREA+2
	loda,r0 LAMBD0+3
	stra,r0 TOTAL_AREA+3
	lodi,r3 255
area_sum_loop:
	cpsl PSL_CARRY_FLAG
	
	; 1
	loda,r0 LAMBD1,r3+
	adda,r0 TOTAL_AREA+0
	stra,r0 TOTAL_AREA+0

	; 2
	loda,r0 LAMBD1,r3+
	loda,r1 TOTAL_AREA+1
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix399
	comi,r1 0xFF
	bctr,eq fixed401
nofix399:
	addz,r1
fixed401:
	stra,r0 TOTAL_AREA+1

	; 3
	loda,r0 LAMBD1,r3+
	loda,r1 TOTAL_AREA+2
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix410
	comi,r1 0xFF
	bctr,eq fixed412
nofix410:
	addz,r1
fixed412:
	stra,r0 TOTAL_AREA+2

	; 4
	loda,r0 LAMBD1,r3+
	adda,r0 TOTAL_AREA+3
	stra,r0 TOTAL_AREA+3

	comi,r3 7
	bcfr,eq area_sum_loop
	cpsl PSL_WITH_CARRY

	; Calculate lambdas by dividing each edge_function result by the total area
	loda,r0 TOTAL_AREA+0
	stra,r0 M32_B1
	loda,r0 TOTAL_AREA+1
	stra,r0 M32_B2
	loda,r0 TOTAL_AREA+2
	stra,r0 M32_B3
	loda,r0 TOTAL_AREA+3
	stra,r0 M32_B4
	lodi,r3 255
	lodi,r2 255
lambda_div_loop:
	loda,r0 LAMBD0,r3+
	stra,r0 M32_A1
	loda,r0 LAMBD0,r3+
	stra,r0 M32_A2
	loda,r0 LAMBD0,r3+
	stra,r0 M32_A3
	loda,r0 LAMBD0,r3+
	stra,r0 M32_A4
	bsta,un *F_FIXED_DIV
	loda,r0 M32_RB1
	stra,r0 LAMBD0,r2+
	loda,r0 M32_RB2
	stra,r0 LAMBD0,r2+
	loda,r0 M32_RB3
	stra,r0 LAMBD0,r2+
	loda,r0 M32_RB4
	stra,r0 LAMBD0,r2+
	comi,r3 11
	bcfr,eq lambda_div_loop
	
	; Interpolate vertex depths to obtain point depth
	; depth = 1/(lamb0 * (1/v0.z) + lamb1 * (1/v1.z) + lamb2 * (1/v2.z))
	eorz,r0
	stra,r0 POINT_DEPTH+0
	stra,r0 POINT_DEPTH+1
	stra,r0 POINT_DEPTH+2
	stra,r0 POINT_DEPTH+3
	lodi,r3 0
	lodi,r2 255
	cpsl PSL_WITH_CARRY
interpolate_loop:
	; 1 / z
	lodi,r0 1
	stra,r0 M32_A3
	eorz,r0
	stra,r0 M32_A4
	stra,r0 M32_A1
	stra,r0 M32_A2
	loda,r0 VERT1_CAM_Z+0,r3
	stra,r0 M32_B1
	loda,r0 VERT1_CAM_Z+1,r3
	stra,r0 M32_B2
	loda,r0 VERT1_CAM_Z+2,r3
	stra,r0 M32_B3
	loda,r0 VERT1_CAM_Z+3,r3
	stra,r0 M32_B4
	addi,r3 12
	bsta,un *F_FIXED_DIV
	; res * lambda
	loda,r0 M32_RB1
	stra,r0 M32_A1
	loda,r0 M32_RB2
	stra,r0 M32_A2
	loda,r0 M32_RB3
	stra,r0 M32_A3
	loda,r0 M32_RB4
	stra,r0 M32_A4
	loda,r0 LAMBD0,r2+
	stra,r0 M32_B1
	loda,r0 LAMBD0,r2+
	stra,r0 M32_B2
	loda,r0 LAMBD0,r2+
	stra,r0 M32_B3
	loda,r0 LAMBD0,r2+
	stra,r0 M32_B4
	bsta,un *F_MUL_32X32
	
	; depth += res
	loda,r0 M32_FB1
	adda,r0 POINT_DEPTH+0
	stra,r0 POINT_DEPTH+0
	ppsl PSL_WITH_CARRY
	loda,r0 M32_FB2
	loda,r1 POINT_DEPTH+1
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix564
	comi,r1 0xFF
	bctr,eq fixed566
nofix564:
	addz,r1
fixed566:
	stra,r0 POINT_DEPTH+1
	loda,r0 M32_FB3
	loda,r1 POINT_DEPTH+2
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix574
	comi,r1 0xFF
	bctr,eq fixed576
nofix574:
	addz,r1
fixed576:
	stra,r0 POINT_DEPTH+2
	loda,r0 POINT_DEPTH+3
	adda,r0 M32_FB4
	stra,r0 POINT_DEPTH+3
	
	cpsl PSL_WITH_CARRY
	comi,r2 11
	bcfa,eq interpolate_loop
	
	; depth = 1 / depth
	lodi,r1 1
	stra,r1 M32_A3
	subi,r1 1
	stra,r1 M32_A1
	stra,r1 M32_A4
	stra,r1 M32_A2
	loda,r0 POINT_DEPTH+0
	stra,r0 M32_B1
	loda,r0 POINT_DEPTH+1
	stra,r0 M32_B2
	loda,r0 POINT_DEPTH+2
	stra,r0 M32_B3
	loda,r0 POINT_DEPTH+3
	stra,r0 M32_B4
	bsta,un *F_FIXED_DIV
	
	; depth = depth / CONST_FRUSTUM_DEPTH_CEIL
	; To force the value between 0 and 1, so I can compress the depth buffer
	; Every value in depth buffer is only 2 bytes, representing only the
	; fraction half of a fixed-point number
	loda,r0 M32_RB1
	stra,r0 M32_A1
	loda,r0 M32_RB2
	stra,r0 M32_A2
	loda,r0 M32_RB3
	stra,r0 M32_A3
	loda,r0 M32_RB4
	stra,r0 M32_A4
	eorz,r0
	stra,r0 M32_B1
	stra,r0 M32_B2
	stra,r0 M32_B4
	lodi,r0 CONST_FRUSTUM_DEPTH_CEIL
	;lodi,r0 2 ; Debug temp
	stra,r0 M32_B3
	bsta,un *F_FIXED_DIV
	loda,r0 M32_RB1
	stra,r0 POINT_DEPTH+0
	loda,r0 M32_RB2
	stra,r0 POINT_DEPTH+1
	loda,r0 M32_RB3
	stra,r0 POINT_DEPTH+2
	loda,r0 M32_RB4
	stra,r0 POINT_DEPTH+3

	; Debug: visualize lambdas
	;loda,r0 LAMBD0+1
	;andi,r0 0b11100000
	;strz,r1
	;loda,r0 LAMBD1+1
	;rrr,r0
	;rrr,r0
	;rrr,r0
	;andi,r0 0b00011100
	;iorz,r1
	;strz,r1
	;loda,r0 LAMBD2+1
	;rrl,r0
	;rrl,r0
	;andi,r0 0b00000011
	;iorz,r1
	;strz,r1
	
	; Depth test time!
	ppsl PSL_LOGICAL_COMP
	eorz,r0
	wrtc,r0
	redd,r0
	rrr,r0
	rrr,r0
	rrr,r0
	rrr,r0
	rrr,r0
	rrr,r0
	andi,r0 0b00000011
	stra,r0 page_ptr_back
	iori,r0 0b00000100
	wrtd,r0
	
	loda,r3 DB_COL_PTR
	loda,r0 *DB_ROW_ADDR,r3
	strz,r1
	loda,r0 *DB_ROW_ADDR,r3+
	strz,r2
	
	comi,r1 0xFF
	bcfr,eq depth_test_continue
	comi,r2 0xFF
	bctr,eq depth_test_pass
depth_test_continue:
	coma,r2 POINT_DEPTH+1
	bcta,lt depth_test_fail
	bctr,gt depth_test_pass
	coma,r1 POINT_DEPTH
	bcta,lt depth_test_fail
	bcta,eq depth_test_fail
depth_test_pass:
	lodi,r0 7
	wrtc,r0
	;loda,r1 POINT_DEPTH+1
	;rrr,r1
	;rrr,r1
	;rrr,r1
	;andi,r1 0b00011100
	;wrtd,r1

	lodi,r1 36
	loda,r0 *polygon_ptr,r1
	wrtd,r0
	
	loda,r1 DB_ROW_ADDR+1
	adda,r1 DB_COL_PTR
	stra,r1 tmp_pointer+1
	loda,r1 DB_ROW_ADDR
	ppsl PSL_WITH_CARRY
	addi,r1 0
	cpsl PSL_WITH_CARRY
	stra,r1 tmp_pointer
	loda,r0 POINT_DEPTH
	stra,r0 *tmp_pointer
	
	loda,r1 tmp_pointer+1
	addi,r1 1
	stra,r1 tmp_pointer+1
	loda,r1 tmp_pointer
	ppsl PSL_WITH_CARRY
	addi,r1 0
	cpsl PSL_WITH_CARRY
	stra,r1 tmp_pointer
	loda,r0 POINT_DEPTH+1
	stra,r0 *tmp_pointer
	
	bctr,un depth_test_finally
depth_test_fail:
	lodi,r1 1
	wrtc,r1
	wrtd,r1
depth_test_finally:
	eorz,r0
	wrtc,r0
	loda,r0 page_ptr_back
	wrtd,r0
bb_loop_continue:
	cpsl PSL_WITH_CARRY
	loda,r0 DB_COL_PTR
	addi,r0 2
	stra,r0 DB_COL_PTR
	loda,r2 bb_loop_counters+2
	addi,r2 1
	coma,r2 BOUNDING_MAXX
	bcfa,gt bb_loop_x
	
	loda,r2 bb_loop_counters+1
	addi,r2 1
	stra,r2 bb_loop_counters+1
	coma,r2 BOUNDING_MAXY
	bcfa,gt bb_loop_y
	
skip_triangle:
	pop
	strr,r1 render_polygon_ret+1
	strr,r0 render_polygon_ret+2
render_polygon_ret:
	bcta,un 0
tmp_pointer:
	db 0,0

rotate_psl_back:
	db 0
rotate_temp:
	db 0,0,0,0
rotate_temp2:
	db 0,0,0,0
rotate_vector_y:
	spsl
	strr,r0 rotate_psl_back
	
	; New X value
	lodi,r3 4
cpy_18:
	loda,r0 TO_ROTATE_X,r3-
	stra,r0 M32_A1,r3
	loda,r0 COS_THETA,r3
	stra,r0 M32_B1,r3
	brnr,r3 cpy_18
	bsta,un *F_MUL_32X32
	loda,r0 M32_FB1
	stra,r0 rotate_temp+0
	loda,r0 M32_FB2
	stra,r0 rotate_temp+1
	loda,r0 M32_FB3
	stra,r0 rotate_temp+2
	loda,r0 M32_FB4
	stra,r0 rotate_temp+3
	
	lodi,r3 4
cpy_19:
	loda,r0 TO_ROTATE_Z,r3-
	stra,r0 M32_A1,r3
	loda,r0 NEG_SINE_THETA,r3
	stra,r0 M32_B1,r3
	brnr,r3 cpy_19
	bsta,un *F_MUL_32X32
	
	ppsl PSL_WITH_CARRY
	cpsl PSL_CARRY_FLAG
	loda,r0 rotate_temp+0
	adda,r0 M32_FB1
	stra,r0 rotate_temp+0
	
	loda,r0 rotate_temp+1
	loda,r1 M32_FB2
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix1153
	comi,r1 0xFF
	bctr,eq fixed1155
nofix1153:
	addz,r1
fixed1155:
	stra,r0 rotate_temp+1
	
	loda,r0 rotate_temp+2
	loda,r1 M32_FB3
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix1164
	comi,r1 0xFF
	bctr,eq fixed1166
nofix1164:
	addz,r1
fixed1166:
	stra,r0 rotate_temp+2
	
	loda,r0 rotate_temp+3
	adda,r0 M32_FB4
	stra,r0 rotate_temp+3
	
	; New Y value
	lodi,r3 4
cpy_20:
	loda,r0 TO_ROTATE_X,r3-
	stra,r0 M32_A1,r3
	loda,r0 SINE_THETA,r3
	stra,r0 M32_B1,r3
	brnr,r3 cpy_20
	bsta,un *F_MUL_32X32
	loda,r0 M32_FB1
	stra,r0 rotate_temp2+0
	loda,r0 M32_FB2
	stra,r0 rotate_temp2+1
	loda,r0 M32_FB3
	stra,r0 rotate_temp2+2
	loda,r0 M32_FB4
	stra,r0 rotate_temp2+3
	
	lodi,r3 4
cpy_21:
	loda,r0 TO_ROTATE_Z,r3-
	stra,r0 M32_A1,r3
	loda,r0 COS_THETA,r3
	stra,r0 M32_B1,r3
	brnr,r3 cpy_21
	bsta,un *F_MUL_32X32
	
	ppsl PSL_WITH_CARRY
	cpsl PSL_CARRY_FLAG
	loda,r0 rotate_temp2+0
	adda,r0 M32_FB1
	stra,r0 TO_ROTATE_Z+0
	
	loda,r0 rotate_temp2+1
	loda,r1 M32_FB2
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix1213
	comi,r1 0xFF
	bctr,eq fixed1215
nofix1213:
	addz,r1
fixed1215:
	stra,r0 TO_ROTATE_Z+1
	
	loda,r0 rotate_temp2+2
	loda,r1 M32_FB3
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix1224
	comi,r1 0xFF
	bctr,eq fixed1226
nofix1224:
	addz,r1
fixed1226:
	stra,r0 TO_ROTATE_Z+2
	
	loda,r0 rotate_temp2+3
	adda,r0 M32_FB4
	stra,r0 TO_ROTATE_Z+3
	
	loda,r0 rotate_temp+0
	stra,r0 TO_ROTATE_X+0
	loda,r0 rotate_temp+1
	stra,r0 TO_ROTATE_X+1
	loda,r0 rotate_temp+2
	stra,r0 TO_ROTATE_X+2
	loda,r0 rotate_temp+3
	stra,r0 TO_ROTATE_X+3
	pop
	strr,r1 rotate_vector_y_ret+1
	strr,r0 rotate_vector_y_ret+2
	loda,r0 rotate_psl_back
	lpsl
rotate_vector_y_ret:
	bcta,un 0

prepare_rot_params_psl_back:
	db 0
prepare_rot_params:
	spsl
	strr,r0 prepare_rot_params_psl_back
	loda,r0 THETA+0
	stra,r0 ARITH_A1
	loda,r0 THETA+1
	stra,r0 ARITH_A2
	loda,r0 THETA+2
	stra,r0 ARITH_A3
	loda,r0 THETA+3
	stra,r0 ARITH_A4
	bsta,un *F_SINE
	loda,r0 ARITH_RB1
	stra,r0 SINE_THETA+0
	loda,r0 ARITH_RB2
	stra,r0 SINE_THETA+1
	loda,r0 ARITH_RB3
	stra,r0 SINE_THETA+2
	loda,r0 ARITH_RB4
	stra,r0 SINE_THETA+3
	
	ppsl PSL_WITH_CARRY+PSL_CARRY_FLAG
	lodi,r1 255
inv_loop0:
	loda,r0 SINE_THETA,r1+
	eori,r0 0xFF
	addi,r0 0
	stra,r0 NEG_SINE_THETA,r1
	comi,r1 3
	bcfr,eq inv_loop0
	cpsl PSL_WITH_CARRY+PSL_CARRY_FLAG+PSL_IDC
	
	loda,r0 THETA+0
	stra,r0 ARITH_A1
	loda,r0 THETA+1
	stra,r0 ARITH_A2
	loda,r0 THETA+2
	stra,r0 ARITH_A3
	loda,r0 THETA+3
	stra,r0 ARITH_A4
	bsta,un *F_COS
	loda,r0 ARITH_RB1
	stra,r0 COS_THETA+0
	loda,r0 ARITH_RB2
	stra,r0 COS_THETA+1
	loda,r0 ARITH_RB3
	stra,r0 COS_THETA+2
	loda,r0 ARITH_RB4
	stra,r0 COS_THETA+3
	
	pop
	strr,r1 prepare_rot_params_ret+1
	strr,r0 prepare_rot_params_ret+2
	loda,r0 prepare_rot_params_psl_back
	lpsl
prepare_rot_params_ret:
	bcta,un 0

debug_show_depth_ptr:
	db 0,0
	; Show the depth buffer contents on-screen, overriding the color output
debug_show_depth:
	eorz,r0
	wrtc,r0
	redd,r0
	rrr,r0
	rrr,r0
	rrr,r0
	rrr,r0
	rrr,r0
	rrr,r0
	andi,r0 0b00000011
	stra,r0 page_ptr_back
	iori,r0 0b00000100
	wrtd,r0
	
	lodi,r0 5
	wrtc,r0
	eorz,r0
	wrtd,r0
	loda,r0 CURR_VRAM_PAGE
	wrtd,r0
	
	eorz,r0
	stra,r0 debug_show_depth_ptr
	stra,r0 debug_show_depth_ptr+1
	
debug_show_depth_loop:
	lodi,r0 5
	wrtc,r0
	ppsl PSL_WITH_CARRY
	cpsl PSL_CARRY_FLAG
	loda,r0 debug_show_depth_ptr
	rrr,r0
	strz,r1
	loda,r0 debug_show_depth_ptr+1
	rrr,r0
	strz,r2
	wrtd,r2
	wrtd,r1
	lodi,r0 7
	wrtc,r0
	
	lodi,r1 1
	loda,r0 *debug_show_depth_ptr,r1
	comi,r0 0xFF
	bctr,eq put_zero
	rrr,r0
	rrr,r0
	;rrr,r0
	andi,r0 0b00011100
	bctr,un put_data
put_zero:
	eorz,r0
put_data:
	wrtd,r0
	
	cpsl PSL_CARRY_FLAG
	loda,r0 debug_show_depth_ptr+1
	addi,r0 2
	stra,r0 debug_show_depth_ptr+1
	loda,r0 debug_show_depth_ptr
	addi,r0 0
	stra,r0 debug_show_depth_ptr
	cpsl PSL_WITH_CARRY
	comi,r0 0x10
	bcfa,eq debug_show_depth_loop
	
	eorz,r0
	wrtc,r0
	loda,r0 page_ptr_back
	wrtd,r0
	retc,un

	; arg in r1
	; Sets up the pointer pointing to the first byte of the current row of pixels
	; in the depth buffer
	; equal to r1 * 128, as each entry in the map is two bytes, and the screen is 64 pixels wide
set_depth_row_psl_back:
	db 0
set_depth_row:
	spsl
	strr,r0 set_depth_row_psl_back
	cpsl PSL_WITH_CARRY
	rrl,r1
	rrl,r1
	rrl,r1
	rrl,r1
	rrl,r1
	rrl,r1
	rrl,r1
	lodz,r1
	andi,r1 0b10000000
	stra,r1 DB_ROW_ADDR+1
	andi,r0 0b01111111
	stra,r0 DB_ROW_ADDR
	pop
	strr,r1 set_depth_row_ret+1
	strr,r0 set_depth_row_ret+2
	loda,r0 set_depth_row_psl_back
	lpsl
set_depth_row_ret:
	bcta,un 0

page_ptr_back:
	db 0
clear_depth_ptr:
	db 0,0
clear_depth_psl_back:
	db 0
	; Clear depth buffer with 0xFF
clear_depth:
	spsl
	strr,r0 clear_depth_psl_back
	eorz,r0
	wrtc,r0
	redd,r0
	rrr,r0
	rrr,r0
	rrr,r0
	rrr,r0
	rrr,r0
	rrr,r0
	andi,r0 0b00000011
	strr,r0 page_ptr_back
	iori,r0 0b00000100
	wrtd,r0
	eorz,r0
	stra,r0 clear_depth_ptr
	stra,r0 clear_depth_ptr+1
	ppsl PSL_WITH_CARRY
clear_depth_loop:
	lodi,r0 0xFF
	stra,r0 *clear_depth_ptr
	cpsl PSL_CARRY_FLAG
	loda,r0 clear_depth_ptr+1
	addi,r0 1
	stra,r0 clear_depth_ptr+1
	eorz,r0
	adda,r0 clear_depth_ptr
	stra,r0 clear_depth_ptr
	eori,r0 0x10
	bcfr,eq clear_depth_loop

	eorz,r0
	wrtc,r0
	loda,r0 page_ptr_back
	wrtd,r0
	loda,r0 clear_depth_psl_back
	lpsl
	retc,un

edge_reg_backs:
	db 0,0,0
edge_psl_back:
	db 0
	; Computes screen-space edge function for given point (EDGE_POINT_X, EDGE_POINT_Y)
	; And using the last-computed screen-space vertex coordinates (VERT1_CAM_X/Y/Z, etc.)
	; (P_X - V0_X) * (V1_Y - V0_Y) - (P_Y - V0_Y) * (V1_X - V0_X)
edge_function:
	spsl
	strr,r0 edge_psl_back
	cpsl PSL_WITH_CARRY
	strr,r1 edge_reg_backs+0
	strr,r2 edge_reg_backs+1
	strr,r3 edge_reg_backs+2
	
	lodi,r3 4
cpy_7:
	loda,r0 EDGE_VERT1_X,r3-
	stra,r0 edge_mul_v0_x,r3
	loda,r0 EDGE_VERT2_Y,r3
	stra,r0 edge_mul_v1_y,r3
	loda,r0 EDGE_VERT1_Y,r3
	stra,r0 edge_mul_v0_y,r3
	brnr,r3 cpy_7
	loda,r0 EDGE_POINT_X
	stra,r0 edge_point

	eorz,r0
	stra,r0 edge_loop_ctrs+1
	ppsl PSL_WITH_CARRY
	lodi,r0 2
edge_function_repeat:
	stra,r0 edge_loop_ctrs

	; First subtraction
	ppsl PSL_CARRY_FLAG
	eorz,r0
	loda,r1 edge_mul_v0_x+0
	bctr,eq fixed357
	subz,r1
fixed357:
	stra,r0 M32_A1

	eorz,r0
	loda,r1 edge_mul_v0_x+1
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix365
	comi,r1 0
	bctr,eq fixed367
nofix365:
	subz,r1
fixed367:
	stra,r0 M32_A2

	loda,r0 edge_point
	loda,r1 edge_mul_v0_x+2
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix378
	comi,r1 0
	bctr,eq fixed380
nofix378:
	subz,r1
fixed380:
	stra,r0 M32_A3

	eorz,r0
	suba,r0 edge_mul_v0_x+3
	stra,r0 M32_A4

	; Second subtraction
	ppsl PSL_CARRY_FLAG
	loda,r0 edge_mul_v1_y+0
	loda,r1 edge_mul_v0_y+0
	bctr,eq fixed395
	subz,r1
fixed395:
	stra,r0 M32_B1

	loda,r0 edge_mul_v1_y+1
	loda,r1 edge_mul_v0_y+1
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix403
	comi,r1 0
	bctr,eq fixed405
nofix403:
	subz,r1
fixed405:
	stra,r0 M32_B2

	loda,r0 edge_mul_v1_y+2
	loda,r1 edge_mul_v0_y+2
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix414
	comi,r1 0
	bctr,eq fixed416
nofix414:
	subz,r1
fixed416:
	stra,r0 M32_B3

	loda,r0 edge_mul_v1_y+3
	suba,r0 edge_mul_v0_y+3
	stra,r0 M32_B4

	; Multiply!
	bsta,un *F_MUL_32X32

	loda,r1 edge_loop_ctrs+1
	loda,r0 M32_FB1
	stra,r0 edge_mul_res,r1
	loda,r0 M32_FB2
	stra,r0 edge_mul_res+1,r1
	loda,r0 M32_FB3
	stra,r0 edge_mul_res+2,r1
	loda,r0 M32_FB4
	stra,r0 edge_mul_res+3,r1
	cpsl PSL_CARRY_FLAG
	addi,r1 4
	stra,r1 edge_loop_ctrs+1

	lodi,r3 4
cpy_8:
	loda,r0 EDGE_VERT1_Y,r3-
	stra,r0 edge_mul_v0_x,r3
	loda,r0 EDGE_VERT2_X,r3
	stra,r0 edge_mul_v1_y,r3
	loda,r0 EDGE_VERT1_X,r3
	stra,r0 edge_mul_v0_y,r3
	brnr,r3 cpy_8
	loda,r0 EDGE_POINT_Y
	stra,r0 edge_point
	loda,r0 edge_loop_ctrs
	bdra,r0 edge_function_repeat
	
	; Multiplication results are hot ’n ready
	; One last (annoying) subtraction

	ppsl PSL_CARRY_FLAG
	loda,r0 edge_mul_res+0
	loda,r1 edge_mul_res+4
	bctr,eq fixed464
	subz,r1
fixed464:
	stra,r0 EDGE_RES1

	loda,r0 edge_mul_res+1
	loda,r1 edge_mul_res+5
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix472
	comi,r1 0
	bctr,eq fixed474
nofix472:
	subz,r1
fixed474:
	stra,r0 EDGE_RES2

	loda,r0 edge_mul_res+2
	loda,r1 edge_mul_res+6
	tpsl PSL_CARRY_FLAG
	bcfr,eq nofix483
	comi,r1 0
	bctr,eq fixed485
nofix483:
	subz,r1
fixed485:
	stra,r0 EDGE_RES3

	loda,r0 edge_mul_res+3
	suba,r0 edge_mul_res+7
	stra,r0 EDGE_RES4
	
	loda,r0 edge_psl_back
	lpsl
	pop
	strr,r0 edge_ret_workaround
	strr,r1 edge_ret_workaround+1
	loda,r1 edge_reg_backs+0
	loda,r2 edge_reg_backs+1
	loda,r3 edge_reg_backs+2
	bcta,un *edge_ret_workaround
edge_ret_workaround:
	db 0,0
edge_loop_ctrs:
	db 0,0
edge_mul_res:
	db 0,0,0,0
	db 0,0,0,0
edge_mul_v0_x:
	db 0,0,0,0
edge_mul_v1_y:
	db 0,0,0,0
edge_mul_v0_y:
	db 0,0,0,0
edge_point:
	db 0

	; Add 1,1 to cam space X,Y then multiply by screen dimensions, so 64 and 32
	; Optimized by using bitshifts, as screen dimensions are powers of 2
cam_point_to_screenspace:
	spsl
	stra,r0 project_point_psl
	
	loda,r0 POINT_CAM_X
	loda,r1 POINT_CAM_X+1
	loda,r2 POINT_CAM_X+2
	loda,r3 POINT_CAM_X+3
	ppsl PSL_WITH_CARRY
	cpsl PSL_CARRY_FLAG
	addi,r2 1
	addi,r3 0
	cpsl PSL_CARRY_FLAG
	rrl,r0
	rrl,r1
	rrl,r2
	rrl,r3
	rrl,r0
	rrl,r1
	rrl,r2
	rrl,r3
	rrl,r0
	rrl,r1
	rrl,r2
	rrl,r3
	rrl,r0
	rrl,r1
	rrl,r2
	rrl,r3
	rrl,r0
	rrl,r1
	rrl,r2
	rrl,r3
	stra,r0 POINT_CAM_X
	stra,r1 POINT_CAM_X+1
	stra,r2 POINT_CAM_X+2
	stra,r3 POINT_CAM_X+3
	
	loda,r0 POINT_CAM_Y
	loda,r1 POINT_CAM_Y+1
	loda,r2 POINT_CAM_Y+2
	loda,r3 POINT_CAM_Y+3
	cpsl PSL_CARRY_FLAG
	addi,r2 1
	addi,r3 0
	cpsl PSL_CARRY_FLAG
	rrl,r0
	rrl,r1
	rrl,r2
	rrl,r3
	rrl,r0
	rrl,r1
	rrl,r2
	rrl,r3
	rrl,r0
	rrl,r1
	rrl,r2
	rrl,r3
	rrl,r0
	rrl,r1
	rrl,r2
	rrl,r3
	stra,r0 POINT_CAM_Y
	stra,r1 POINT_CAM_Y+1
	stra,r2 POINT_CAM_Y+2
	stra,r3 POINT_CAM_Y+3
	
	loda,r0 project_point_psl
	lpsl
	pop
	strr,r0 cam_point_to_screenspace_ret+2
	strr,r1 cam_point_to_screenspace_ret+1
cam_point_to_screenspace_ret:
	bcta,un 0

project_point_psl:
	db 0
	; Projects a point from 3D space onto the screen
	; Uses the formula p2 = [(a*f*x)/z, (f*y)/z, z*q - near_q]
project_point:
	spsl
	strr,r0 project_point_psl
	; (af*x)/z
	lodi,r3 4
cpy_0:
	loda,r0 POINT_X,r3-
	stra,r0 M32_A1,r3
	brnr,r3 cpy_0
	lodi,r0 CONST_AF%256
	stra,r0 M32_B1
	lodi,r0 CONST_AF>>8%256
	stra,r0 M32_B2
	lodi,r0 CONST_AF>>16%256
	stra,r0 M32_B3
	lodi,r0 CONST_AF>>24%256
	stra,r0 M32_B4
	bsta,un *F_MUL_32X32
	lodi,r3 4
cpy_1:
	loda,r0 POINT_Z,r3-
	stra,r0 M32_B1,r3
	loda,r0 M32_FB1,r3
	stra,r0 M32_A1,r3
	brnr,r3 cpy_1
	bsta,un *F_FIXED_DIV
	lodi,r3 4
cpy_2:
	loda,r0 M32_RB1,r3-
	stra,r0 POINT_CAM_X,r3
	loda,r0 POINT_Y,r3
	stra,r0 M32_A1,r3
	brnr,r3 cpy_2
	
	; (f*y)/z
	lodi,r0 CONST_F%256
	stra,r0 M32_B1
	lodi,r0 CONST_F>>8%256
	stra,r0 M32_B2
	lodi,r0 CONST_F>>16%256
	stra,r0 M32_B3
	lodi,r0 CONST_F>>24%256
	stra,r0 M32_B4
	bsta,un *F_MUL_32X32
	lodi,r3 4
cpy_3:
	loda,r0 POINT_Z,r3-
	stra,r0 M32_B1,r3
	loda,r0 M32_FB1,r3
	stra,r0 M32_A1,r3
	brnr,r3 cpy_3
	bsta,un *F_FIXED_DIV
	lodi,r3 4
cpy_4:
	loda,r0 M32_RB1,r3-
	stra,r0 POINT_CAM_Y,r3
	loda,r0 POINT_Z,r3
	stra,r0 M32_B1,r3
	brnr,r3 cpy_4
	
	; z*q - near_q
	lodi,r0 CONST_Q%256
	stra,r0 M32_A1
	lodi,r0 CONST_Q>>8%256
	stra,r0 M32_A2
	lodi,r0 CONST_Q>>16%256
	stra,r0 M32_A3
	lodi,r0 CONST_Q>>24%256
	stra,r0 M32_A4
	bsta,un *F_MUL_32X32
	
	; Warning: this code will break if CONST_NEAR_Q is not 0x00_00_xx_xx, where every xx != 0
	ppsl PSL_WITH_CARRY+PSL_CARRY_FLAG
	loda,r0 M32_FB1
	subi,r0 CONST_NEAR_Q%256
	stra,r0 POINT_CAM_Z+0
	loda,r0 M32_FB2
	subi,r0 CONST_NEAR_Q>>8%256
	stra,r0 POINT_CAM_Z+1
	loda,r0 M32_FB3
	subi,r0 CONST_NEAR_Q>>16%256
	stra,r0 POINT_CAM_Z+2
	loda,r0 M32_FB4
	stra,r0 POINT_CAM_Z+3

	loda,r0 project_point_psl
	lpsl
	pop
	strr,r0 project_point_ret+2
	strr,r1 project_point_ret+1
project_point_ret:
	bcta,un 0

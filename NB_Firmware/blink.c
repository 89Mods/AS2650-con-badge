#include <defs.h>
//#include <stub.h>

uint32_t *magic_loc = (uint32_t *)128;

#define SIG_DC (1 << 14)
#define SIG_MIO (1 << 15)
#define SIG_WRP (1 << 16)
#define SIG_OPREQ (1 << 17)
#define SIG_RW (1 << 18)
#define SIG_FLAG (1 << 19)

void io_conf_mgmt(const char bus_dir) {
    reg_mprj_io_0 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_1 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_2 = GPIO_MODE_MGMT_STD_INPUT_NOPULL;
    reg_mprj_io_3 = GPIO_MODE_MGMT_STD_INPUT_NOPULL;
    reg_mprj_io_4 = GPIO_MODE_MGMT_STD_INPUT_NOPULL;
	reg_mprj_io_5 = bus_dir ? GPIO_MODE_MGMT_STD_OUTPUT : GPIO_MODE_MGMT_STD_INPUT_NOPULL;
	reg_mprj_io_6 = bus_dir ? GPIO_MODE_MGMT_STD_OUTPUT : GPIO_MODE_MGMT_STD_INPUT_NOPULL;
	reg_mprj_io_7 = bus_dir ? GPIO_MODE_MGMT_STD_OUTPUT : GPIO_MODE_MGMT_STD_INPUT_NOPULL;
	reg_mprj_io_8 = bus_dir ? GPIO_MODE_MGMT_STD_OUTPUT : GPIO_MODE_MGMT_STD_INPUT_NOPULL;
	reg_mprj_io_9 = bus_dir ? GPIO_MODE_MGMT_STD_OUTPUT : GPIO_MODE_MGMT_STD_INPUT_NOPULL;
	reg_mprj_io_10 = bus_dir ? GPIO_MODE_MGMT_STD_OUTPUT : GPIO_MODE_MGMT_STD_INPUT_NOPULL;
	reg_mprj_io_11 = bus_dir ? GPIO_MODE_MGMT_STD_OUTPUT : GPIO_MODE_MGMT_STD_INPUT_NOPULL;
	reg_mprj_io_12 = bus_dir ? GPIO_MODE_MGMT_STD_OUTPUT : GPIO_MODE_MGMT_STD_INPUT_NOPULL;
	reg_mprj_io_13 = GPIO_MODE_MGMT_STD_INPUT_NOPULL;
	reg_mprj_io_14 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_15 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_16 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_17 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_18 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_19 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_20 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_21 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_22 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_23 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_24 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_25 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_26 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_27 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_28 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_29 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_30 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_31 = GPIO_MODE_MGMT_STD_OUTPUT;
	
	reg_mprj_io_32 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_33 = GPIO_MODE_MGMT_STD_INPUT_PULLUP;
    reg_mprj_io_34 = GPIO_MODE_MGMT_STD_INPUT_PULLUP;
    reg_mprj_io_35 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_36 = GPIO_MODE_MGMT_STD_INPUT_PULLUP;
    reg_mprj_io_37 = GPIO_MODE_MGMT_STD_INPUT_PULLUP;
	
	reg_mprj_xfer = 1;
	while(reg_mprj_xfer == 1);
}

void io_conf_as2650() {

//  ======= Useful GPIO mode values =============

//      GPIO_MODE_MGMT_STD_INPUT_NOPULL
//      GPIO_MODE_MGMT_STD_INPUT_PULLDOWN
//      GPIO_MODE_MGMT_STD_INPUT_PULLUP
//      GPIO_MODE_MGMT_STD_OUTPUT
//      GPIO_MODE_MGMT_STD_BIDIRECTIONAL
//      GPIO_MODE_MGMT_STD_ANALOG

//      GPIO_MODE_USER_STD_INPUT_NOPULL
//      GPIO_MODE_USER_STD_INPUT_PULLDOWN
//      GPIO_MODE_USER_STD_INPUT_PULLUP
//      GPIO_MODE_USER_STD_OUTPUT
//      GPIO_MODE_USER_STD_BIDIRECTIONAL
//      GPIO_MODE_USER_STD_ANALOG
    reg_mprj_io_0 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_1 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_2 = GPIO_MODE_MGMT_STD_INPUT_NOPULL;
    reg_mprj_io_3 = GPIO_MODE_MGMT_STD_INPUT_NOPULL;
    reg_mprj_io_4 = GPIO_MODE_MGMT_STD_INPUT_NOPULL;

    reg_mprj_io_5 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_6 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_7 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_8 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_9 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_10 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_11 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_12 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_13 = GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_14 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_15 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_16 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_17 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_18 = GPIO_MODE_USER_STD_OUTPUT;

    reg_mprj_io_19 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_20 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_21 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_22 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_23 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_24 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_25 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_26 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_27 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_28 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_29 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_30 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_31 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_32 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_33 = GPIO_MODE_MGMT_STD_INPUT_PULLUP;
    reg_mprj_io_34 = GPIO_MODE_MGMT_STD_INPUT_PULLUP;
    reg_mprj_io_35 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_36 = GPIO_MODE_MGMT_STD_INPUT_PULLUP;
    reg_mprj_io_37 = GPIO_MODE_MGMT_STD_INPUT_PULLUP;

    // Initiate the serial transfer to configure IO
    reg_mprj_xfer = 1;
    while (reg_mprj_xfer == 1);
}

void delay(const int d) {
    /* Configure timer for a single-shot countdown */
	reg_timer0_config = 0;
	reg_timer0_data = d;
    reg_timer0_config = 1;

    // Loop, waiting for value to reach zero
   reg_timer0_update = 1;  // latch current value
   while (reg_timer0_value > 0) reg_timer0_update = 1;
}

void self_reset() {
    reg_gpio_mode1 = 1;
    reg_gpio_mode0 = 0;
    reg_gpio_ien = 1;
    reg_gpio_oeb = 0;
    reg_gpio_out = 1;
}

uint32_t reg_mprj_datal_mirror = 0;
uint32_t reg_mprj_datah_mirror = 0;

void crvl_ok(const char state) {
	if(state) {
		reg_mprj_datal_mirror = reg_mprj_datal = reg_mprj_datal_mirror | 1;
	}else {
		reg_mprj_datal_mirror &= ~1;
		reg_mprj_datal = reg_mprj_datal_mirror;
	}
}

void cpld_rst(const char state) {
	if(state) {
		reg_mprj_datah_mirror = reg_mprj_datah = reg_mprj_datah_mirror | (1 << 3);
	}else {
		reg_mprj_datah_mirror &= ~(1 << 3);
		reg_mprj_datah = reg_mprj_datah_mirror;
	}
}

void error_out() {
	while(1) {
		delay(4000000);
		crvl_ok(1);
		delay(4000000);
		crvl_ok(0);
	}
}

const uint32_t pgm[] = {
	0xc0,0x04,0x00,0x93,0x04,0x20,0x92,0x3f,0x00,0x7b,0x07,0xff,0x0f,0x20,0xe6,
	0xcf,0x7f,0x00,0x03,0x24,0x3f,0x98,0x75,0x3f,0x00,0x61,0x04,0x03,0xf0,0x3f,0x00,
	0x56,0x20,0xf0,0x3f,0x00,0x56,0x20,0xf0,0x3f,0x00,0x56,0x20,0xf0,0x3f,0x00,0x56,
	0x1f,0x1f,0x01,0x04,0x04,0xb0,0x04,0x06,0xf0,0x05,0x0c,0x06,0xff,0x07,0xff,0xb4,
	0x40,0x74,0x40,0x18,0x02,0x76,0x40,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xfa,
	0x76,0xfb,0x74,0xf9,0x72,0x1b,0x5c,0x20,0xb0,0x70,0xf4,0x01,0x18,0x7b,0x04,0x03,
	0xb0,0x17,0x04,0x04,0xb0,0x20,0xf0,0x04,0x03,0xb0,0x17,0x04,0x04,0xb0,0x04,0x01,
	0xf0,0x17,0x05,0x07,0xb1,0x71,0xf5,0x08,0x18,0x7b,0xf0,0x17,0x20,0xb0,0xf0,0x06,
	0x02,0xb2,0xf0,0x06,0x05,0xb2,0xf0,0xf0,0x3b,0x61,0x07,0x10,0x06,0x00,0x20,0x3f,
	0x00,0x71,0xfa,0x7a,0xfb,0x76,0x3f,0x00,0x61,0x04,0xff,0xf0,0x3f,0x00,0x56,0x3f,
	0x00,0x6a,0xc0,0xc0,0xc0,0xc0,0x3f,0x00,0x61,0x04,0xab,0xf0,0x3f,0x00,0x56,0x3f,
	0x00,0x6a,0xc0,0xc0,0xc0,0xc0,0x3f,0x00,0x61,0x04,0x90,0xf0,0x3f,0x00,0x56,0x20,
	0xf0,0x3f,0x00,0x56,0x20,0xf0,0x3f,0x00,0x56,0x20,0xf0,0x3f,0x00,0x56,0x20,0xf0,
	0x3f,0x00,0x56,0x04,0x02,0xb0,0x71,0x3f,0x00,0x6a,0xc0,0xe5,0xab,0x14,0xe5,0xef,
	0x14,0xe5,0xc2,0x14,0x1f,0x00,0x32,0x00,0x77,0x08,0x04,0x01,0x48,0x35,0x18,0x04,
	0x74,0x40,0x1b,0x02,0x76,0x40,0x04,0x03,0xb0,0x20,0xf0,0x70,0xf4,0x01,0x18,0x7b,
	0x04,0x02,0xb0,0x71,0xc9,0x9c,0x75,0x01,0x08,0x19,0x84,0x01,0xc8,0x15,0x08,0x12,
	0x84,0x00,0xc8,0x0e,0x24,0x1f,0x98,0x52,0x04,0x04,0xb0,0x04,0x01,0xf0,0x74,0x40,
	0x1f,0x00,0x00,0x00,0x00,0x00,0x00,
	'C','h','i','r','p','!'
};
const uint32_t pgm_len = 300;

#define MEM_LENGTH 8192

void main() {
    // Configure All LA probes as inputs to the cpu
	reg_la0_oenb = reg_la0_iena = 0x00000000;    // [31:0]
	reg_la1_oenb = reg_la1_iena = 0x00000000;    // [63:32]
	reg_la2_oenb = reg_la2_iena = 0x00000000;    // [95:64]
	reg_la3_oenb = reg_la3_iena = 0x00000000;    // [127:96]
	reg_mprj_datal = reg_mprj_datal_mirror = 0;
	reg_mprj_datah_mirror = reg_mprj_datah = 0;
	
	if(*magic_loc != 0x5708CDAB) {
		io_conf_mgmt(0);
		cpld_rst(0);
		crvl_ok(0);
		delay(10000000); //Allow other board components time to power-up
	}else {
		*magic_loc = 0;
		crvl_ok(1);
		while(1);
	}
	
	reg_mprj_datal = reg_mprj_datal_mirror = SIG_MIO | SIG_RW | SIG_WRP | (reg_mprj_datal_mirror & 1);
	io_conf_mgmt(0);
	delay(200);
	cpld_rst(0);
	cpld_rst(1);
	cpld_rst(0);
	cpld_rst(1);
	cpld_rst(0);
	cpld_rst(1);
	cpld_rst(0);
	cpld_rst(1);
	cpld_rst(0);
	cpld_rst(1);
	cpld_rst(0);
	io_conf_mgmt(1);
	delay(200);
	uint16_t pos = 0;
	uint32_t val_a_i;
	for(uint16_t i = 0; i < MEM_LENGTH; i++) {
		crvl_ok((i >> 5) & 1);
		if(pos >= pgm_len) break;
		uint8_t val = pgm[pos];
		pos++;
		val_a_i = (uint32_t)val << 5;
		val_a_i |= (uint32_t)i << 20;
		reg_mprj_datal = SIG_MIO | SIG_RW | val_a_i | SIG_WRP | (reg_mprj_datal_mirror & 1);
		reg_mprj_datah_mirror &= 0xFFFFFFFE;
		reg_mprj_datah_mirror |= (i >> 12) & 1;
		reg_mprj_datah = reg_mprj_datah_mirror;
		reg_mprj_datal = SIG_MIO | SIG_RW | val_a_i | (reg_mprj_datal_mirror & 1);
		for(uint8_t j = 0; j < 3; j++);
		reg_mprj_datal = reg_mprj_datal_mirror = SIG_MIO | SIG_RW | val_a_i | SIG_WRP | (reg_mprj_datal_mirror & 1);
	}
	crvl_ok(0);
	
	io_conf_mgmt(0);
	delay(200);
	pos = 0;
	reg_mprj_datal = reg_mprj_datal_mirror = SIG_MIO | (reg_mprj_datal_mirror & 1);
	for(uint16_t i = 0; i < MEM_LENGTH; i++) {
		if(pos >= pgm_len) break;
		uint8_t expected = pgm[pos];
		pos++;
		reg_mprj_datal = reg_mprj_datal_mirror = SIG_MIO | SIG_OPREQ | ((uint32_t)i << 20) | (reg_mprj_datal_mirror & 1);
		reg_mprj_datah_mirror &= 0xFFFFFFFE;
		reg_mprj_datah_mirror |= (i >> 12) & 1;
		reg_mprj_datah = reg_mprj_datah_mirror;
		for(uint8_t j = 0; j < 3; j++);
		uint8_t read = (reg_mprj_datal >> 5) & 0xFF;
		if(read != expected) {
			error_out();
		}
	}
	reg_mprj_datal = reg_mprj_datal_mirror = SIG_MIO | (reg_mprj_datal_mirror & 1);
	
	*magic_loc = 0x5708CDAB;
	io_conf_mgmt(0);
	crvl_ok(1);
	delay(4000000);
	io_conf_as2650();
	delay(200);
	self_reset();
	while(1) {}
}


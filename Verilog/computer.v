module computer(
	input clk,
	input rst,
	input [7:0] tb_controller_state
);

wire reset;
wire reset_b;

MCP1319MT por_gen(
	.MRb(rst),
	.RST(reset),
	.RSTb(reset_b)
);

tri0 [7:0] dbus;
wire [12:0] addr_bus;
wire A13;
wire A14;
wire rw;
wire opreq;
wire wrp;
wire m_io;
wire d_c;
wire sense;
wire FLAG;

wire [7:0] dbus_out;
wire oeb;
as2650 as2650(
	.reset(reset),
	.adr(addr_bus),
	.dbus_in(dbus),
	.dbus_out(dbus_out),
	.oeb(oeb),
	.rw(rw),
	.opreq(opreq),
	.wrp(wrp),
	.m_io(m_io),
	.d_c(d_c),
	.sense(sense),
	.flag(FLAG),
	.clk(clk)
);
assign dbus = oeb ? 8'hzz : dbus_out;

wire RAM_CEb;
wire RAM_OEb;
wire RAM_WEb;
AS7C256 RAM(
	.A({A14, A13, addr_bus}),
	.IO(dbus),
	.CEb(RAM_CEb),
	.OEb(RAM_OEb),
	.WEb(RAM_WEb)
);

wire bus_dir;
wire lvl_shift_enb;
wire [7:0] dbus_3v3;
wire [7:0] test;
SN74LVC8T245 shifter1(
	.A(dbus_3v3),
	.B(dbus),
	.DIR(bus_dir),
	.OEb(lvl_shift_enb)
);

wire cpld_rst_3v3;
wire por_3v3;
wire A12_3v3;
wire rw_3v3;
wire opreq_3v3;
wire wrp_3v3;
wire m_io_3v3;
wire d_c_3v3;
wire aaa = ~rst;
SN74LVC8T245 shifter2(
	.A({cpld_rst_3v3, por_3v3, A12_3v3, rw_3v3, opreq_3v3, wrp_3v3, m_io_3v3, d_c_3v3}),
	.B({aaa, reset_b, addr_bus[12], rw, opreq, wrp, m_io, d_c}),
	.DIR(1'b0),
	.OEb(1'b0)
);

wire NES_clk;
wire NES_latch;
wire NES_data;
wire SPI_csb;
wire SPI_sck;
wire SPI_di;
wire SPI_do;
wire [14:0] VRAM_addr;
tri1 [7:0] VRAM_data;
wire VRAM_web;
wire VRAM_oeb;
wire DISP_stb;
wire DISP_clk;
wire DISP_oeb;
wire [3:0] DISP_addr;
CPLD cpld(
	.cpld_rst(cpld_rst_3v3),
	.POR(por_3v3),
	.A12(A12_3v3),
	.rw(rw_3v3),
	.opreq(opreq_3v3),
	.wrp(wrp_3v3),
	.m_io(m_io_3v3),
	.d_c(d_c_3v3),
	.sense(sense),
	
	.clk(clk),
	
	.SPI_csb(SPI_csb),
	.SPI_sck(SPI_sck),
	.SPI_si(SPI_di),
	.SPI_so(SPI_do),
	
	.dbus(dbus_3v3),
	.bus_dir(bus_dir),
	.lvl_shift_enb(lvl_shift_enb),
	
	.RAM_ceb(RAM_CEb),
	.RAM_oeb(RAM_OEb),
	.RAM_web(RAM_WEb),
	.A13(A13),
	.A14(A14),
	
	.VRAM_addr(VRAM_addr),
	.VRAM_data(VRAM_data),
	.VRAM_web(VRAM_web),
	.VRAM_oeb(VRAM_oeb),
	
	.NES_clk(NES_clk),
	.NES_latch(NES_latch),
	.NES_data(NES_data),
	
	.DISP_stb(DISP_stb),
	.DISP_clk(DISP_clk),
	.DISP_oeb(DISP_oeb),
	.DISP_addr(DISP_addr)
);

nes_controller nes_controller(
	.latch_clk(NES_latch),
	.clock(NES_clk),
	.data(NES_data),
	.tb_controller_state(tb_controller_state)
);

spiflash #(.FILENAME("../compiled.txt")) spiflash(
	.csb(SPI_csb),
	.clk(SPI_sck),
	.io0(SPI_do),
	.io1(SPI_di),
	.io2(),
	.io3()
);

IS61LV256 vram(
	.A(VRAM_addr),
	.IO(VRAM_data),
	.CEb(1'b0),
	.OEb(VRAM_oeb),
	.WEb(VRAM_web)
);
/*
LED_Panel LED_Panel(
	.R1(VRAM_data[0]),
	.G1(VRAM_data[1]),
	.B1(VRAM_data[2]),
	.R2(VRAM_data[3]),
	.G2(VRAM_data[4]),
	.B2(VRAM_data[5]),
	.addr(DISP_addr),
	.CLK(DISP_clk),
	.STB(DISP_stb),
	.OEb(DISP_oeb)
);*/

endmodule

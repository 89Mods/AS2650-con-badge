`define IO_ADDR_WIDTH 2
`define TIMER_WIDTH 19
`default_nettype none

module CPLD(
	input cpld_rst,
	input POR,
	input A12,
	input rw,
	input opreq,
	input wrp,
	input m_io,
	input d_c,
	output sense,
	
	input clk,
	
	inout [7:0] dbus,
	output bus_dir,
	output lvl_shift_enb,
	
	output reg NES_clk,
	output reg NES_latch,
	input NES_data,
	
	output reg SPI_csb,
	input SPI_si,
	output reg SPI_sck,
	output reg SPI_so,
	
	output reg [14:0] VRAM_addr,
	inout [7:0] VRAM_data,
	output reg VRAM_web,
	output VRAM_oeb,
	
	output reg DISP_stb,
	output DISP_clk,
	output DISP_oeb,
	output reg [3:0] DISP_addr,
	
	output RAM_ceb,
	output RAM_oeb,
	output RAM_web,
	output A13,
	output A14,
	
	output LED
);

assign RAM_ceb = !m_io;
assign RAM_oeb = !(!rw && m_io);
assign RAM_web = !(rw && m_io && !wrp);

reg [`TIMER_WIDTH:0] timer;
reg [7:0] timer2;
reg vram_page;
reg [1:0] lowpage;
reg [1:0] page;
wire nA12 = ~A12;
assign A13 = (A12 & page[0]) | (nA12 & lowpage[0]);
assign A14 = (A12 & page[1]) | (nA12 & lowpage[1]);

reg LED_latch;
assign LED = LED_latch;

/*
 * SPI
 */
reg [7:0] spi_outbuff;
reg [7:0] spi_inbuff;
reg [4:0] spi_step;
wire spi_active = spi_step != 0;

/*
 * Display driver
 */
reg [2:0] frame_count = 0;
reg [5:0] column_pos = 0;
reg [3:0] cycle = 0;
reg [5:0] disp_dout;
reg disp_bright = 0;

reg [14:0] write_addr = 0;
reg [7:0] write_data = 0;
reg write_pending = 0;
reg write_busy = 0;
assign sense = write_busy | write_pending | spi_active;

wire [14:0] vram_addr_1 = {3'b000, vram_page, 1'b0, DISP_addr, column_pos};
wire [14:0] vram_addr_2 = {3'b000, vram_page, 1'b1, DISP_addr, column_pos};

wire pix_red = frame_count < VRAM_data[7:5];
wire pix_green = frame_count < VRAM_data[4:2];
wire pix_blue = frame_count[2:1] < VRAM_data[1:0];

assign VRAM_oeb = ~(cycle < 3);
assign VRAM_data = VRAM_oeb ? (write_busy && cycle > 4 ? write_data : {2'b00, disp_dout}) : 8'hzz;
assign DISP_clk = cycle == 4;
assign DISP_oeb = ~(cycle > 4 && column_pos == 0);
wire last_line = column_pos == 6'h3F;

wire [7:0] status = {page, disp_bright, LED_latch, write_busy | write_pending, NES_data, SPI_csb, spi_active};
reg [`IO_ADDR_WIDTH:0] io_addr = 0;
reg [7:0] io_readval_d;
always @(*) begin
	case(io_addr)
		default: io_readval_d = status;
		1: io_readval_d = timer2;
		2: io_readval_d = spi_inbuff;
	endcase
end

wire io_read = !m_io && !rw;
wire io_write = !m_io && rw && wrp;
assign bus_dir = io_read;
assign dbus = io_read ? io_readval_d : 8'hzz;
assign lvl_shift_enb = !POR;

always @(posedge clk) begin
	if(!POR) begin
		page <= 2'b00;
		lowpage <= 2'b00;
		timer <= 0;
		timer2 <= 0;
		SPI_csb <= 1'b1;
		disp_bright <= 1'b0;
		spi_step <= 0;
		LED_latch <= 1'b0;
		NES_clk <= 1'b0;
		NES_latch <= 1'b0;
	end else begin
		timer <= timer + 1;
`ifdef BENCH
		if(timer == 100000) begin
`else
		if(timer == 750000) begin
`endif
			timer2 <= timer2 + 1;
			timer <= 0;
		end
		if(io_write) begin
			if(d_c) begin
				case(io_addr)
					0: begin
						page <= dbus[1:0];
						lowpage <= dbus[3:2];
					end
					1: write_addr <= write_addr + dbus;
					2: vram_page <= dbus[0];
					3: begin
						spi_step <= 1;
						spi_outbuff <= dbus;
					end
					4: begin
						SPI_csb <= dbus[0];
						NES_clk <= dbus[1];
						NES_latch <= dbus[2];
						LED_latch <= dbus[4];
						disp_bright <= dbus[5];
					end
					5: begin
						write_addr[7:0] <= dbus;
						io_addr <= 6;
					end
					6: begin
						write_addr[14:8] <= dbus[6:0];
						io_addr <= 7;
					end
					7: begin
						write_data <= dbus;
						write_pending <= 1'b1;
					end
				endcase
			end else begin
				io_addr <= dbus[`IO_ADDR_WIDTH:0];
			end
		end
		
		/*
		 * SPI
		 */
		
		if(spi_active) begin
			spi_step <= spi_step == 5'b10001 ? 5'h00 : spi_step + 1;
			if(spi_step[0]) begin
				SPI_sck <= 1'b0;
				SPI_so <= spi_outbuff[7];
				spi_outbuff <= {spi_outbuff[6:0], 1'b0};
			end else begin
				SPI_sck <= 1'b1;
				spi_inbuff <= {spi_inbuff[6:0], SPI_si};
			end
		end
		
		/*
		 * Display driver
		 */
		DISP_stb <= 1'b0;
		VRAM_web <= 1'b1;
		cycle <= cycle + 1;
		case(cycle)
			0: begin
				VRAM_addr <= vram_addr_1;
				write_busy <= write_pending;
			end
			1: begin
				VRAM_addr <= vram_addr_2;
				disp_dout[2:0] <= {pix_green, pix_blue, pix_red};
			end
			2: begin
				disp_dout[5:3] <= {pix_green, pix_blue, pix_red};
			end
			4: begin
				column_pos <= column_pos + 1;
				if(last_line || write_busy) begin
					DISP_stb <= last_line;
					cycle <= disp_bright && last_line ? 9 : 13;
					VRAM_addr <= write_addr;
				end else begin
					cycle <= 1'b0;
				end
			end
			13: begin
				if(write_busy) begin
					VRAM_web <= 1'b0;
				end
			end
			15: begin
				write_busy <= 1'b0;
				if(write_busy) begin
					write_addr <= write_addr + 1;
					write_pending <= 1'b0;
				end
				if(column_pos == 0) begin
					DISP_addr <= DISP_addr + 1;
					if(DISP_addr == 4'hF) begin
						frame_count <= frame_count + 1;
					end
				end
			end
		endcase
	end
end

endmodule

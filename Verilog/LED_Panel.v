module LED_Panel(
	input R1,
	input G1,
	input B1,
	input R2,
	input G2,
	input B2,
	input [3:0] addr,
	input CLK,
	input STB,
	input OEb
);

reg [63:0] frame_r [31:0];
reg [63:0] frame_g [31:0];
reg [63:0] frame_b [31:0];

reg [63:0] sreg1r;
reg [63:0] sreg1g;
reg [63:0] sreg1b;
reg [63:0] sreg2r;
reg [63:0] sreg2g;
reg [63:0] sreg2b;

reg [63:0] latch1r;
reg [63:0] latch1g;
reg [63:0] latch1b;
reg [63:0] latch2r;
reg [63:0] latch2g;
reg [63:0] latch2b;

always @(posedge CLK) begin
	sreg1r <= {sreg1r[62:0], R1};
	sreg1g <= {sreg1g[62:0], G1};
	sreg1b <= {sreg1b[62:0], B1};
	sreg2r <= {sreg2r[62:0], R2};
	sreg2g <= {sreg2g[62:0], G2};
	sreg2b <= {sreg2b[62:0], B2};
end

always @(posedge STB) begin
	latch1r <= sreg1r;
	latch1g <= sreg2g;
	latch1b <= sreg2b;
	latch2r <= sreg2r;
	latch2g <= sreg2g;
	latch2b <= sreg2b;
end

always @(negedge OEb) begin
	frame_r[addr] <= latch1r;
	frame_g[addr] <= latch1g;
	frame_b[addr] <= latch1b;
	frame_r[addr + 16] <= latch2r;
	frame_g[addr + 16] <= latch2g;
	frame_b[addr + 16] <= latch2b;
end

endmodule

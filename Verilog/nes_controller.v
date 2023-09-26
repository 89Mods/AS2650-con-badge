module nes_controller(
	input latch_clk,
	input clock,
	output data,
	input [7:0] tb_controller_state
);

reg [7:0] latch = 0;
assign data = latch[7];

always @(posedge latch_clk) begin
	latch <= tb_controller_state;
end

always @(posedge clock) begin
	latch <= {latch[6:0], 1'b0};
end

endmodule

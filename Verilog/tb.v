module tb(
	input clk,
	input rst,
	input [7:0] tb_controller_state
);

`ifdef TRACE_ON
initial begin
	$dumpfile("tb.vcd");
	//$dumpvars();
end
`endif

computer computer(
	.clk(clk),
	.rst(rst),
	.tb_controller_state(tb_controller_state)
);

endmodule

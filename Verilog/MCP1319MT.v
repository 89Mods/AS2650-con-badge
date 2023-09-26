module MCP1319MT(
	input MRb,
	output RST,
	output RSTb
);

reg res;
wire reset = res | ~MRb;
assign RST = reset;
assign RSTb = ~reset;

initial begin
	res = 1;
	#4;
	res = 0;
end

endmodule

module SN74LVC8T245(
	inout [7:0] A,
	inout [7:0] B,
	input DIR,
	input OEb
);

assign A = OEb || DIR ? 8'hzz : B;
assign B = OEb || !DIR ? 8'hzz : A;

endmodule

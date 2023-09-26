module IS61LV256(
	input [14:0] A,
	inout [7:0] IO,
	input CEb,
	input OEb,
	input WEb
);

reg [7:0] memory [32767:0];

initial begin
	for(integer i = 0; i < 32768; i++) begin
		memory[i] = $random();
	end
end

assign IO = !CEb && !OEb && WEb ? memory[A] : 8'hzz;

always @(posedge WEb or posedge CEb) begin
	if((CEb && !WEb) || (!CEb && WEb)) begin
		memory[A] <= IO;
	end
end

endmodule

module extensor(sinal, sinal_ext);

	input [15:0]sinal;
	output reg [31:0]sinal_ext;

always @(*)begin
	
	if(sinal[15] == 0)
		sinal_ext <= {16'd0,sinal};
	else
		sinal_ext <= {16'b1111111111111111,sinal};
	
end
endmodule


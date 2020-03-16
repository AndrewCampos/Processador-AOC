module shiftL2(entrada, saida);
	input [31:0] entrada;
	output reg [31:0] saida;
	
always @(entrada) begin
	
	saida = {entrada[29:0],2'b00};
	
end
endmodule

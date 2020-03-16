module mux2_32b(seletor, entrada1, entrada2, saida);
	input seletor;
	input [31:0]entrada1, entrada2;
	output reg [31:0]saida;
	
always @(*) begin
	if(seletor == 1'b0)
		saida = entrada1;
	else
		saida = entrada2;
	
end
endmodule
	
module mux2_5b(seletor, entrada1, entrada2, saida);
	input seletor;
	input [4:0]entrada1, entrada2;
	output reg [4:0]saida;
	
always @(*) begin
	if(seletor == 1'b0)
		saida = entrada1;
	else
		saida = entrada2;
	
end
endmodule

module mux4_32b(seletor, entrada1, entrada2, entrada3, entrada4, saida);
	input [1:0] seletor;
	input [31:0] entrada1, entrada2, entrada3, entrada4;
	output reg [31:0]saida;
	
always @(*) begin
	case (seletor)
		2'b00:
			saida = entrada1;
		2'b01:
			saida = entrada2;
		2'b10:
			saida = entrada3;
		2'b11:
			saida = entrada4;
	endcase
end
endmodule
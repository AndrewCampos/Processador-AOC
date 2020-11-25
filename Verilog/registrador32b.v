module registrador32b(controle, clk, entrada, saida);
		input [31:0] entrada;
		input controle, clk;
		output reg [31:0] saida;
		
always @(posedge clk)begin

	if(controle == 1'b1) saida <= entrada;
		
end

endmodule

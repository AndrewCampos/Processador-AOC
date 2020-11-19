module registradorPC(controle, led, reset, clk, entrada, saida);
		input [31:0] entrada;
		input controle, clk, reset;
		output reg [31:0] saida;
		output reg [9:0] led;
		
always @(posedge clk)begin
	
	if(reset == 1'b1) saida <= 32'd0;
	else begin
		if(controle == 1'b1) saida <= entrada;
	end
		led <= saida[9:0];
end

endmodule

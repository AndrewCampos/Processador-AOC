module usart(controle, Rx, clk, dado, habilitar, dado_pronto);
	input controle;
	input Rx;
	input clk;
	output reg [31:0] dado;
	output reg habilitar;
	output reg dado_pronto;
	reg [4:0] index;

always @(negedge clk) begin
	if (controle == 1'b0) begin
		habilitar <= 1'd0;
		dado_pronto <= 1'd0;
		index <= 5'd0;
	end
	else begin

		if (habilitar == 1'd0) begin
			habilitar <= 1'b1;
		end else if (index < 5'd31) begin
			dado[index] <= Rx;
			index <= index + 5'd1;
		end
		else begin
			dado_pronto <= 1'd1;
		end
	end
end
endmodule

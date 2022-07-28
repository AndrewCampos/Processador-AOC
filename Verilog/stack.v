module stack(dado, pop, push, wclk, rclk, saida, ovrflw, undrflw, led);

	input [31:0] dado;
	input pop, push, wclk, rclk;
	output reg [31:0] saida;
	output reg [9:0]led;
	reg [31:0]stack[9:0];
	reg [3:0] pointer;
	output reg ovrflw, undrflw;
	
	initial pointer = 4'd0;			
	
	always @ (posedge wclk)
	begin
		if(pointer < 4'd10) begin
			if(push == 1'b1 && dado != 32'd0) begin 
				stack[pointer] <= dado;
				pointer <= pointer + 4'd1;
				ovrflw <= 1'b0;
			end
		end else ovrflw <= 1'b1;
		
		if(pointer > 4'd0) begin
			if(pop == 1'b1) pointer <= pointer - 4'd1;
		end else undrflw <= 4'd1;
	end
	
always @ (negedge rclk) begin
	saida <= stack[pointer-4'd1];
	led <= {6'd0, pointer};
end
	
endmodule

module pwm(clock, atualiza, dutyCicleIn, sinal);

	input atualiza, clock;
	input [31:0] dutyCicleIn;
	output reg sinal;
	reg [31:0] dutyCicle;
	reg [7:0] counter;
	reg esperaDC;


initial begin
	dutyCicle <= 32'd0;
	counter <= 7'd0;
end


always @(posedge clock) begin

	if (atualiza == 1'b1) esperaDC <= 1'b1;

	if (esperaDC == 1'd1 && dutyCicle != dutyCicleIn) begin
		dutyCicle <= dutyCicleIn;
		esperaDC <= 1'b0;
	end
	
	if (counter >= dutyCicle) sinal <= 1'b0;
	else sinal <= 1'b1;
	
	counter <= counter + 8'd1;
	
	if (counter >= 8'd100) counter <= 8'd0;
	
end

endmodule

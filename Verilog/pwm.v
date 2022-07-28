module pwm(clock, atualiza, dutyCicleIn, sinal, counter);

	input atualiza, clock;
	input [31:0] dutyCicleIn;
	output reg sinal;
	reg [31:0] dutyCicle;
	output reg [7:0] counter;


initial begin
	dutyCicle <= 32'd0;
	counter <= 7'd0;
end


always @(posedge clock) begin
	
	if (counter >= dutyCicle) sinal <= 1'b0;
	else sinal <= 1'b1;
	
	counter <= counter + 8'd1;
	
	if (counter >= 8'd100) counter <= 8'd0;
	
end


always @(posedge atualiza) begin
	dutyCicle <= dutyCicleIn;
end

endmodule

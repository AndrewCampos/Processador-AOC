module sigEnter(clk, enter, sig);
		input clk,enter;
		output reg sig;
		
always @(negedge clk)begin
	sig <= 1'b0;		
end

always @(negedge enter)begin
	sig <= 1'b1;
end

endmodule

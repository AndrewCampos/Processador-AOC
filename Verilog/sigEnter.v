module sigEnter(enter, clk, sig);
	input enter, clk;
	output reg sig;
	reg flag;
	
always @(posedge clk)begin

	if(enter && !flag) begin
		flag <= 1'b1;
		sig <= 1'b1;
	
	end else begin
		sig <= 1'b0;
		if(!enter && flag) flag <= 1'b0;
	end		
end

endmodule

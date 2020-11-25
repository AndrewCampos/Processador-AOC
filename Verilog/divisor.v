module divisor (clk , div_clk );

input clk ;
output reg div_clk ;
reg [26:0] cont ;

always @( posedge clk ) begin
	if(cont == 26'd10) begin
		div_clk = 1'b1;
		cont = 26'd0;
	end else begin
		cont = cont + 26'd1;
		div_clk = 1'b0;
	end
end
endmodule 
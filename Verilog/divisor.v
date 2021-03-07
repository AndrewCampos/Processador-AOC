module divisor (clk , enter, div_clk );

input clk, enter;
output reg div_clk;
reg [26:0] cont;

always @( posedge clk ) begin
	if(cont >= 26'd1000000) begin
		div_clk = 1'b1;
		cont = 26'd0;
	end else begin
		cont = cont + 26'd1;
		div_clk = 1'b0;
	end
end
endmodule 
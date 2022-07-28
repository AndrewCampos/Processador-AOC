module divisor (clk , enter, div_clk );

input clk, enter;
output reg div_clk;
reg [26:0] cont;

parameter periodo = 27'd50_000;

always @( posedge clk ) begin
	if (cont >= (periodo/27'd2)) div_clk <= 1'b0;
	else div_clk <= 1'b1;

	cont <= cont + 27'd1;
	
	if (cont >= periodo) cont <= 27'd0;
end
endmodule 
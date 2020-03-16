module bancoReg(escreve, out, clk, reg1, reg2, regF, dados, A, B, toOUT);

	input clk, escreve, out;
	input [4:0] reg1, reg2, regF;
	input	[31:0]dados;
	output [31:0] A, B;
	output reg [31:0] toOUT;
	reg [31:0]registradores[31:0];
	
	initial 
	begin : INIT
		integer i;
		for(i=0;i<32;i=i+1) registradores[i] = 32'b0;
	end 
	
always @(posedge clk) begin
	if(escreve == 1'b1)
		registradores[regF] <= dados;
end 

assign A = registradores[reg1];
assign B = registradores[reg2];

always @(posedge out) toOUT <= registradores[reg2];

endmodule

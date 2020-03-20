module memoria(dado, endereco, write, wclk, rclk, saida);

	input [31:0] dado;
	input [6:0] endereco;
	input write, wclk, rclk;
	output reg [31:0] saida;
	reg [31:0]ram[127:0];
	
	initial begin	
	
			//INSTRUCOES
			ram[7'd0]  = {6'b000111,5'd0,5'd1,16'd55}; //lw $1 55
			
			ram[7'd1]  = {6'b000111,5'd0,5'd2,16'd56}; //lw $2 56
			
			ram[7'd2]  = {6'b111101,26'd17}; //jal &17
			
			ram[7'd3]  = {6'b100001,5'd0,5'd2,16'd0}; //out $2
			
			ram[7'd4]  = {6'b111111,26'd0}; //hlt
			
			ram[7'd17] = {6'b100001,5'd0,5'd1,16'd0}; //out $1
			
			ram[7'd18] = {6'b111100,26'd17}; //jst
			
			ram[7'd55] = 32'd1;
			
			ram[7'd56] = 32'd2;
			
			
	end 
	always @ (posedge wclk)
	begin
		if (write == 1'b1)
			ram[endereco] <= dado;
	end
	
always @ (negedge rclk) saida <= ram[endereco];
	
endmodule

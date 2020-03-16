module memoria(dado, endereco, write, wclk, rclk, saida);

	input [21:0] dado;
	input [6:0] endereco;
	input write, wclk, rclk;
	output reg [31:0] saida;
	reg [31:0]ram[127:0];
	
	initial begin	
	
			//INSTRUCOES
			ram[7'd0]  = {6'b101000,5'd0,5'd3,16'd0}; //in $3
			
			ram[7'd1]  = {6'b100001,5'd0,5'd3,16'd0}; //out $3
			
			ram[7'd2]  = {6'b101000,5'd0,5'd0,16'd0}; //in $0
			
			ram[7'd3]  = {6'b000111,5'd0,5'd1,16'd55}; //lw $1 55
			
			ram[7'd4]  = {6'b000111,5'd0,5'd2,16'd56}; //lw $2 56
			
			ram[7'd5]  = {6'b110000,5'd0,5'd1,16'd10}; //beq $0 $1 &10
		
			ram[7'd6]  = {6'b110000,5'd0,5'd2,16'd13}; //beq $0 $2 &14
			
			ram[7'd7]  = {6'b000010,5'd1,5'd5,16'd5}; //subi $1 $5 123456
			
			ram[7'd8]  = {6'b100001,5'd0,5'd5,16'd0}; //out $5
			
			ram[7'd9]  = {6'b111110,26'd17}; //jmp &17
		
			//CELCIUS PARA KELVIN			
			ram[7'd10] = {6'b000001,5'd3,5'd4,16'd273}; //addi $3 $4 273
			
			ram[7'd11] = {6'b100001,5'd0,5'd4,16'd0}; //out $1
		
			ram[7'd12] = {6'b111110,26'd17}; //jmp &17
			
			//CELCIUS PARA FAHRENHEIT			
			ram[7'd13] = {6'b000100,5'd3,5'd6,16'd9}; //multi $3 $4 9
			
			ram[7'd14] = {6'b000011,5'd6,5'd7,16'd5}; //divi $4 $5 5
			
			ram[7'd15] = {6'b0000001,5'd7,5'd8,16'd32}; //addi $5 $6 32
			
			ram[7'd16] = {6'b100001,5'd0,5'd8,16'd0}; //out $5
		
			ram[7'd17] = {6'b111111,26'd0}; //hlt
			
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

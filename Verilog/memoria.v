module memoria(dado, endereco, write, wclk, rclk, saida);

	input [31:0] dado;
	input [9:0] endereco;
	input write, wclk, rclk;
	output reg [31:0] saida;
	reg [31:0]ram[127:0];
	
	initial begin	
  
ram[0] = {6'b000001, 5'd0, 5'd31, 16'd461};   // addi
ram[1] = {6'b010101, 26'd26};   // jmp
// fatorial
ram[2] = {6'b010000, 5'd31, 5'd20, 16'd1};   // str
ram[3] = {6'b010001, 5'd31, 5'd1, 16'd1};   // ldr
ram[4] = {6'b000001, 5'd0, 5'd2, 16'd1};   // addi
ram[5] = {6'b001101, 5'd1, 5'd2, 16'd10};   // bgt
ram[6] = {6'b000001, 5'd0, 5'd4, 16'd1};   // addi
ram[7] = {6'b000001, 5'd4, 5'd30, 16'd0};   // addi
ram[8] = {6'b010111, 26'd0};   // jst
ram[9] = {6'b010101, 26'd25};   // jmp
// L0
ram[10] = {6'b010001, 5'd31, 5'd5, 16'd2};   // ldr
ram[11] = {6'b010001, 5'd31, 5'd6, 16'd1};   // ldr
ram[12] = {6'b000001, 5'd0, 5'd7, 16'd1};   // addi
ram[13] = {6'b000000, 5'd6, 5'd7, 5'd8, 5'd0, 6'b000001};   // sub
ram[14] = {6'b000001, 5'd8, 5'd20, 16'd0};   // addi
ram[15] = {6'b000001, 5'd31, 5'd31, 16'd2};   // addi
ram[16] = {6'b010110, 26'd2};   // jal
ram[17] = {6'b000010, 5'd31, 5'd31, 16'd2};   // subi
ram[18] = {6'b010001, 5'd31, 5'd9, 16'd1};   // ldr
ram[19] = {6'b000000, 5'd30, 5'd9, 5'd10, 5'd0, 6'b000010};   // mult
ram[20] = {6'b000001, 5'd10, 5'd5, 16'd0};   // addi
ram[21] = {6'b010000, 5'd31, 5'd5, 16'd2};   // str
ram[22] = {6'b010001, 5'd31, 5'd11, 16'd2};   // ldr
ram[23] = {6'b000001, 5'd11, 5'd30, 16'd0};   // addi
ram[24] = {6'b010111, 26'd0};   // jst
// L1
ram[25] = {6'b010111, 26'd0};   // jst
// main
ram[26] = {6'b010011, 5'd0, 5'd30, 16'd0};   // in
ram[27] = {6'b000001, 5'd30, 5'd20, 16'd0};   // addi
ram[28] = {6'b010100, 5'd0, 5'd20, 16'd0};   // out
ram[29] = {6'b010001, 5'd31, 5'd12, 16'd1};   // ldr
ram[30] = {6'b010011, 5'd0, 5'd30, 16'd0};   // in
ram[31] = {6'b000001, 5'd30, 5'd20, 16'd0};   // addi
ram[32] = {6'b010100, 5'd0, 5'd20, 16'd0};   // out
ram[33] = {6'b000001, 5'd30, 5'd12, 16'd0};   // addi
ram[34] = {6'b010000, 5'd31, 5'd12, 16'd1};   // str
ram[35] = {6'b010001, 5'd31, 5'd13, 16'd2};   // ldr
ram[36] = {6'b010001, 5'd31, 5'd14, 16'd1};   // ldr
ram[37] = {6'b000001, 5'd14, 5'd20, 16'd0};   // addi
ram[38] = {6'b000001, 5'd31, 5'd31, 16'd2};   // addi
ram[39] = {6'b010110, 26'd2};   // jal
ram[40] = {6'b000010, 5'd31, 5'd31, 16'd2};   // subi
ram[41] = {6'b000001, 5'd30, 5'd13, 16'd0};   // addi
ram[42] = {6'b010000, 5'd31, 5'd13, 16'd2};   // str
ram[43] = {6'b010001, 5'd31, 5'd15, 16'd2};   // ldr
ram[44] = {6'b000001, 5'd15, 5'd20, 16'd0};   // addi
ram[45] = {6'b010100, 5'd0, 5'd20, 16'd0};   // out
ram[46] = {6'b000001, 5'd0, 5'd16, 16'd0};   // addi
ram[47] = {6'b000001, 5'd16, 5'd30, 16'd0};   // addi
ram[48] = {6'b010101, 26'd50};   // jmp
ram[49] = {6'b010101, 26'd50};   // jmp
// end
ram[50] = {6'b010010, 26'd0};   // hlt


			
			
	end 
	always @ (posedge wclk)
	begin
		if (write == 1'b1)
			ram[endereco] <= dado;
	end
	
always @ (negedge rclk) saida <= ram[endereco];
	
endmodule

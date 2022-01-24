module memoria(dado, endereco, write, wclk, rclk, saida);

input [31:0] dado;
input [9:0] endereco;
input write, wclk, rclk;
output reg [31:0] saida;
reg [31:0]ram[511:0];
/*
R=6'b000000, addi=6'b000001, subi=6'b000010, divi=6'b000011, multi=6'b000100, andi=6'b000101,
ori=6'b000110, nori=6'b000111, slei=6'b001000, slti=6'b001001,   beq=6'b001010,  bne=6'b001011,
blt=6'b001100,  bgt=6'b001101,  sti=6'b001110,  ldi=6'b001111,   str=6'b010000,  ldr=6'b010001,
hlt=6'b010010,   in=6'b010011,  out=6'b010100,  jmp=6'b010101,   jal=6'b010110,  jst=6'b010111,
sdisk=6'b011000, ldisk=6'b011001, sleep=6'b011010, wake=6'b011011, lstk=6'b011100, sstk=6'b011101;
*/
initial begin
ram[0] = {6'b000001, 5'd0, 5'd31, 16'd300};   // addi
ram[1] = {6'b010101, 26'd34};   // jmp
// savePC
ram[2] = {6'b010011, 5'd0, 5'd30, 16'd0};   // in
ram[3] = {6'b010001, 5'd31, 5'd1, 16'd2};   // ldr
ram[4] = {6'b000001, 5'd0, 5'd2, 16'd100};   // put
ram[5] = {6'b000001, 5'd2, 5'd20, 16'd0};   // mov
ram[6] = {6'b010001, 5'd20, 5'd30, 16'd0};   // ldr
ram[7] = {6'b000001, 5'd30, 5'd1, 16'd0};   // mov
ram[8] = {6'b010000, 5'd31, 5'd1, 16'd2};   // str
ram[9] = {6'b010001, 5'd31, 5'd3, 16'd2};   // ldr
ram[10] = {6'b000001, 5'd3, 5'd20, 16'd0};   // mov
ram[11] = {6'b011100, 5'd0, 5'd20, 16'd0};   // lstk
ram[12] = {6'b010111, 26'd0};   // jst
// printPC
ram[13] = {6'b010011, 5'd0, 5'd30, 16'd0};   // in
ram[14] = {6'b010001, 5'd31, 5'd4, 16'd1};   // ldr
ram[15] = {6'b000001, 5'd0, 5'd5, 16'd100};   // put
ram[16] = {6'b000001, 5'd5, 5'd4, 16'd0};   // mov
ram[17] = {6'b010000, 5'd31, 5'd4, 16'd1};   // str
ram[18] = {6'b010001, 5'd31, 5'd6, 16'd1};   // ldr
ram[19] = {6'b000001, 5'd6, 5'd20, 16'd0};   // mov
ram[20] = {6'b011101, 5'd0, 5'd20, 16'd0};   // sstk
ram[21] = {6'b010001, 5'd31, 5'd7, 16'd2};   // ldr
ram[22] = {6'b010001, 5'd31, 5'd8, 16'd1};   // ldr
ram[23] = {6'b000001, 5'd8, 5'd20, 16'd0};   // mov
ram[24] = {6'b010001, 5'd20, 5'd30, 16'd0};   // ldr
ram[25] = {6'b000001, 5'd30, 5'd7, 16'd0};   // mov
ram[26] = {6'b010000, 5'd31, 5'd7, 16'd2};   // str
ram[27] = {6'b010001, 5'd31, 5'd9, 16'd2};   // ldr
ram[28] = {6'b000001, 5'd9, 5'd20, 16'd0};   // mov
ram[29] = {6'b010100, 5'd0, 5'd20, 16'd0};   // out
ram[30] = {6'b000001, 5'd31, 5'd31, 16'd2};   // addi
ram[31] = {6'b010110, 26'd2};   // jal
ram[32] = {6'b000010, 5'd31, 5'd31, 16'd2};   // subi
ram[33] = {6'b010111, 26'd0};   // jst
// main
ram[34] = {6'b000001, 5'd31, 5'd31, 16'd0};   // addi
ram[35] = {6'b010110, 26'd13};   // jal
ram[36] = {6'b000010, 5'd31, 5'd31, 16'd0};   // subi
ram[37] = {6'b000001, 5'd0, 5'd10, 16'd0};   // put
ram[38] = {6'b000001, 5'd10, 5'd30, 16'd0};   // mov
ram[39] = {6'b010101, 26'd41};   // jmp
ram[40] = {6'b010101, 26'd41};   // jmp
// end
ram[41] = {6'b010010, 26'd0};   // hlt

end 
always @ (posedge wclk)
begin
	if (write == 1'b1)
		ram[endereco] <= dado;
end
	
always @ (negedge rclk) saida <= ram[endereco];
	
endmodule

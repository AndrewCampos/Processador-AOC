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
ram[0] = {6'b010110, 26'd15}; // jal
ram[1] = {6'b000001, 5'd0, 5'd1, 16'd20}; // put
ram[2] = {6'b010100, 5'd0, 5'd1, 16'd0}; // out
ram[3] = {6'b011100, 5'd0, 5'd1, 16'd0}; // lstk
ram[4] = {6'b010111, 26'd0}; // jst
ram[15] = {6'b000001, 5'd0, 5'd4, 16'd100}; // put
ram[16] = {6'b011101, 5'd0, 5'd4, 16'd0}; // sstk
ram[17] = {6'b010001, 5'd0, 5'd20, 16'd100}; // ldr
ram[18] = {6'b010100, 5'd0, 5'd20, 16'd0}; // out
ram[19] = {6'b010101, 26'd1}; // jmp
ram[20] = {6'b010010, 26'd0}; // hlt

end 
always @ (posedge wclk)
begin
	if (write == 1'b1)
		ram[endereco] <= dado;
end
	
always @ (negedge rclk) saida <= ram[endereco];
	
endmodule

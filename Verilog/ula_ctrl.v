module ULA_ctrl(opcode,funct,opULA,controle,clk);

input [5:0] funct, opcode;
input [1:0] opULA;
input clk;
output reg [4:0] controle;

// Opcdode
parameter   R=6'b000000, addi=6'b000001, subi=6'b000010, divi=6'b000011, multi=6'b000100, andi=6'b000101,
			 ori=6'b000110, nori=6'b000111, slei=6'b001000, slti=6'b001001,   beq=6'b001010,  bne=6'b001011,
			 blt=6'b001100,  bgt=6'b001101,  sti=6'b001110,  ldi=6'b001111,   str=6'b010000,  ldr=6'b010001,
			 hlt=6'b010010,   in=6'b010011,  out=6'b010100,  jmp=6'b010101,   jal=6'b010110,  jst=6'b010111;

// Funct 
parameter add=6'b000000,  sub=6'b000001, mult=6'b000010,  div=6'b000011,   AND=6'b000100,   OR=6'b000101,
			NAND=6'b000110,  NOR=6'b000111,  sle=6'b001000,  slt=6'b001001,   sge=6'b001010;
	
always @(*) begin
	
	if(opcode == R) begin
		case (funct)
			add:  controle =  5'd0;
			sub:  controle =  5'd1; 
			mult: controle =  5'd2; 
			div:  controle =  5'd3; 
			AND:  controle =  5'd4; 
			OR:   controle =  5'd5; 
			NAND: controle =  5'd6; 
			NOR:  controle =  5'd7; 
			slt:  controle = 5'd12;
			sle:  controle = 5'd13;
			sge:  controle = 5'd14;
			default: controle = controle;
		endcase
	end 
	if(opcode != 6'd0) begin
		case (opcode)
			addi:  controle =  5'd0;
			subi:  controle =  5'd1;
			divi:  controle =  5'd3;
			multi: controle =  5'd2;
			nori:  controle =  5'd7;
			ori:   controle =  5'd5; 
			andi:  controle =  5'd4; 
			beq:   controle =  5'd8;  
			bne:   controle =  5'd9; 
			bgt:   controle = 5'd10;
			blt:   controle = 5'd11; 
			slti:  controle = 5'd12;
			slei:  controle = 5'd13;
			default: controle = controle;
		endcase
	end//else
	
	if(opULA != 2'b00) begin
		case(opULA)
			2'b01: controle =  5'd0;
			2'b10: controle = 5'd33;
			2'b11: controle = 5'd31;
			default: controle = controle;
		endcase
	end
end//always
endmodule 
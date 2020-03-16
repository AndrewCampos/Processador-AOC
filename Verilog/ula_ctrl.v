module ULA_ctrl(opcode,funct,opULA,controle,clk);
	input [5:0] funct, opcode;
	input [1:0] opULA;
	input clk;
	output reg [4:0] controle;
	
always @(*) begin
	
	if(opcode == 6'd0) begin
		case (funct)
			6'b000000: controle = 5'd0; // add
			6'b000001: controle = 5'd1; // sub
			6'b000010: controle = 5'd2; // mult
			6'b000011: controle = 5'd3; // div
			6'b100000: controle = 5'd4; // and
			6'b100001: controle = 5'd5; // or
			6'b100010: controle = 5'd6; // nand
			6'b100011: controle = 5'd7; // nor
			6'b110000: controle = 5'd12;// sle
			6'b110001: controle = 5'd11;// slt
			default: controle = controle;
		endcase
	end 
	if(opcode != 6'd0) begin
		case (opcode)
			6'b000001: controle = 5'd0;  // addi
			6'b000010: controle = 5'd1;  // subi
			6'b000011: controle = 5'd3;  //divi
			6'b000100: controle = 5'd2;  //multi
			6'b001001: controle = 5'd7;  //nori
			6'b001010: controle = 5'd5;  //ori
			6'b001011: controle = 5'd4;  //andi
			6'b010000: controle = 5'd13; // blt
			6'b011100: controle = 5'd12; // slei
			6'b011110: controle = 5'd11; // slti
			6'b100000: controle = 5'd13; // bgt
			6'b110000: controle = 5'd8;  // beq
			6'b111000: controle = 5'd9;  // bne
			default: controle = controle;
		endcase
	end//else
	
	if(opULA != 2'b00) begin
		case(opULA)
			2'b01: controle = 5'd0;
			2'b10: controle = 5'd33;
			2'b11: controle = 5'd31;
			default: controle = controle;
		endcase
	end
end//always
endmodule 
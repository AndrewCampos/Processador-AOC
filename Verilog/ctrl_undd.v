module ctrl_undd(opcode,
					  funct,
					  enter,
					  clk,
					  estado,
					  EscrevePC,
					  EscreveRI,
					  EscreveReg,
					  EscreveMem,
					  SelMuxMem,
					  SelMuxReg1,
					  SelMuxReg2,
					  SelMuxUlaA,
					  SelMuxUlaB,
					  SelMuxPC,
					  zero,
					  controleULA,
					  controleOUT,
					  SelMuxIn,
					  pop,
					  push);

	input clk, zero, enter;
	input [5:0] opcode;
	input [5:0] funct;
	output reg [3:0] estado;
	reg [3:0] prox_estado;
	 
	//sinais de controle de memoria
	output reg pop, push, EscrevePC, EscreveRI, EscreveReg, EscreveMem, controleOUT;

	//seletores de multiplexadores
	output reg SelMuxMem, SelMuxReg1, SelMuxReg2, SelMuxUlaA, SelMuxIn;
	output reg [1:0] SelMuxUlaB, SelMuxPC;
	
	//sinal de controle da ULA
	reg [1:0]OpULA;
	output [4:0] controleULA;
	
	parameter ESTADO0=4'b0000,  ESTADO1=4'b0001,  ESTADO2=4'b0010,  ESTADO3=4'b0011,
				 ESTADO4=4'b0100,  ESTADO5=4'b0101,  ESTADO6=4'b0110,  ESTADO7=4'b0111, 
				 ESTADO8=4'b1000,  ESTADO9=4'b1001,  ESTADO10=4'b1010, ESTADO11=4'b1011,
				 ESTADO12=4'b1100, ESTADO13=4'b1101, ESTADO14=4'b1110, ESTADO15=4'b1111;
	
	ULA_ctrl ctrlULA(.opcode(opcode),
						  .funct(funct),
						  .opULA(OpULA),
						  .controle(controleULA),
						  .clk(clk));
	
	always @(negedge clk) begin
		
		case(estado)
		ESTADO0: begin //carrega RI
		// controle
			EscrevePC   <=  1'b0;
			EscreveRI   <=  1'b1;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b0;
			controleOUT <=  1'b0;
			OpULA       <= 2'b01;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxMem   <=  1'b0;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxUlaA  <=  1'b0;
			SelMuxUlaB  <= 2'b01;
			SelMuxIn    <=  1'b1;
			prox_estado <= ESTADO1;
		end	
		
		ESTADO1: begin //decodifica instrucao
		// controle
			if(opcode == 6'b111111) EscrevePC <= 1'b0;
			else EscrevePC   <=  1'b1;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b0;
			if(opcode == 6'b100001) controleOUT <=  1'b1;
			else controleOUT <=  1'b0;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxMem   <=  1'b0;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxUlaA  <=  1'b0;
			SelMuxUlaB  <= 2'b01;
			SelMuxIn    <=  1'b0;
			
			case(opcode)
				6'b000110: begin
					prox_estado <= ESTADO2; //sw
				end
				6'b000111: begin
					prox_estado <= ESTADO2; //lw
				end
				6'b000000: begin
					prox_estado <= ESTADO6; //R
				end
				6'b010000: begin
					prox_estado <= ESTADO8; //btl
				end
				6'b100000: begin
					prox_estado <= ESTADO8; //bgt
				end
				6'b110000: begin
					prox_estado <= ESTADO8; ///beq   
				end
				6'b111000: begin
					prox_estado <= ESTADO8; //bne
				end
				
				6'b111110: begin
					prox_estado <= ESTADO9; //jmp
				end
				
				6'b111101: begin
					prox_estado <= ESTADO9; //jal
				end
				
				6'b111100: begin
					prox_estado <= ESTADO10; //jst
				end
				
				6'b101000: begin
					prox_estado <= ESTADO12; //in
				end
				
				6'b100001: begin
					prox_estado <= ESTADO0; //out
				end
				
				6'b111111: begin
					prox_estado <= ESTADO14; //hlt
				end
				
				default: begin 
					prox_estado <= ESTADO11; // I
				end
			endcase
		end
		
		ESTADO2: begin //carrega B na saida da ULA (lw)
		// controle
			EscrevePC   <=  1'b0;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b0;
			controleOUT <=  1'b0;
			OpULA       <= 2'b11;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxMem   <=  1'b1;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxUlaA  <=  1'b1;
			SelMuxUlaB  <= 2'b11;
			SelMuxIn    <=  1'b0;
		
			case(opcode)
				6'b000111: prox_estado <= ESTADO3; //lw
				
				6'b000110: prox_estado <= ESTADO5; //sw
				
				default: prox_estado <= ESTADO0;
			endcase
		end
		
		ESTADO3: begin //busca valor de dado dentro da memoria
		// controle
			EscrevePC   <=  1'b0;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b0;
			controleOUT <=  1'b0;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxMem   <=  1'b1;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b1;
			SelMuxUlaA  <=  1'b0;
			SelMuxUlaB  <= 2'b00;
			SelMuxIn    <=  1'b0;
			prox_estado <= ESTADO4;
		end
		
		ESTADO4: begin //salva dado do registrador de dados no banco
		// controle
			EscrevePC   <=  1'b0;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b1;
			EscreveMem  <=  1'b0;
			controleOUT <=  1'b0;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxMem   <=  1'b1;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b1;
			SelMuxUlaA  <=  1'b0;
			SelMuxUlaB  <= 2'b00;
			SelMuxIn    <=  1'b0;
			prox_estado <= ESTADO13;
		end
		
		ESTADO5: begin //salva valor na memoria
		// controle
			EscrevePC   <=  1'b0;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b1; // salva valor na memoria
			controleOUT <=  1'b0;
			OpULA       <= 2'b11;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxMem   <=  1'b1;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxUlaA  <=  1'b1;
			SelMuxUlaB  <= 2'b00;
			SelMuxIn    <=  1'b0;
			prox_estado <= ESTADO15;
		end
		
		ESTADO6: begin //faz operacao entre A e B
			EscrevePC   <=  1'b0;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b0;
			controleOUT <=  1'b0;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxMem   <=  1'b0;
			SelMuxReg1  <=  1'b1;
			SelMuxReg2  <=  1'b0;
			SelMuxUlaA  <=  1'b1;
			SelMuxUlaB  <= 2'b00;
			SelMuxIn    <=  1'b0;
			prox_estado <= ESTADO7;
		end
		
		ESTADO7: begin //salva o resultado no banco
			EscrevePC   <=  1'b0;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b1;
			EscreveMem  <=  1'b0;
			controleOUT <=  1'b0;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxMem   <=  1'b0;
			if(opcode == 6'b000000)SelMuxReg1  <=  1'b1;
			else SelMuxReg1 <= 1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxUlaA  <=  1'b1;
			if(opcode == 6'b000000)SelMuxUlaB  <= 2'b00;
			else SelMuxUlaB <= 2'b11;
			SelMuxIn    <=  1'b0;
			prox_estado <= ESTADO0;
		end
		
		ESTADO8: begin //calcula endereco de branch
			prox_estado <= ESTADO10;
			EscrevePC <= 1'b0;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b0;
			controleOUT <=  1'b0;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b01;
			SelMuxMem   <=  1'b0;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxUlaA  <=  1'b1;
			SelMuxUlaB  <= 2'b00;
			SelMuxIn    <=  1'b0;
		end
		
		ESTADO9: begin //faz o jump
			EscrevePC   <=  1'b1;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b0;
			controleOUT <=  1'b0;
			OpULA       <= 2'b11;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxMem   <=  1'b0;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxUlaA  <=  1'b1;
			SelMuxUlaB  <= 2'b11;
			SelMuxIn    <=  1'b0;
			prox_estado <= ESTADO13;
		end		
		
		ESTADO10: begin //atualiza pc
			if(zero == 1'b1) EscrevePC   <=  1'b1; // faz o branch?
			else if (opcode == 6'b111100) EscrevePC   <=  1'b1; //jst
			else EscrevePC   <=  1'b0;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b0;
			controleOUT <=  1'b0;
			OpULA       <= 2'b11;
			if (opcode == 6'b111100) pop <=  1'b1; //jst
			else pop    <=  1'b0;
			push        <=  1'b0;
		// mux
			if (opcode == 6'b111100) SelMuxPC <= 2'b11; //jst
			else SelMuxPC <= 2'b10;
			SelMuxMem   <=  1'b0;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxUlaA  <=  1'b0;
			SelMuxUlaB  <= 2'b00;
			SelMuxIn    <=  1'b0;
			prox_estado <= ESTADO0;
		end		
		
		ESTADO11:begin //faz operacao entre A e Imm
			EscrevePC   <=  1'b0;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b0;
			controleOUT <=  1'b0;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxMem   <=  1'b0;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxUlaA  <=  1'b1;
			SelMuxUlaB  <= 2'b11;
			SelMuxIn    <=  1'b0;
			prox_estado <= ESTADO7;
		end
		
		ESTADO12: begin //aguarda entrada de dados
			EscrevePC   <=  1'b0;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b1;
			EscreveMem  <=  1'b0;
			controleOUT <=  1'b0;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxMem   <=  1'b0;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxUlaA  <=  1'b0;
			SelMuxUlaB  <= 2'b00;
			SelMuxIn    <=  1'b1;
			if(enter) prox_estado <= ESTADO15;
			else prox_estado <= prox_estado;
		end
		
		ESTADO13: begin // finaliza jmp, sw e lw
			if(opcode == 6'b111110) EscrevePC   <=  1'b1; //jmp
			else if(opcode == 6'b111101) EscrevePC <= 1'b1; //jal
			else EscrevePC <= 1'b0;
			EscreveRI   <=  1'b0;
			if(opcode == 6'b000111) EscreveReg  <=  1'b1; //lw
			else EscreveReg <= 1'b0;
			EscreveMem <= 1'b0;
			controleOUT <=  1'b0;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			if(opcode == 6'b111101) push <=  1'b1;// jal
			else push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxMem   <=  1'b0;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b1;
			SelMuxUlaA  <=  1'b0;
			SelMuxUlaB  <= 2'b00;
			SelMuxIn    <=  1'b0;
			prox_estado <= ESTADO0;
		end
		
		ESTADO14: begin //paraliza o processador
			EscrevePC   <=   1'b0;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b0;
			controleOUT <=  1'b0;
			OpULA       <=  2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxMem   <=  1'b0;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxIn    <=  1'b0;
			SelMuxUlaA  <=   1'b0;
			SelMuxUlaB  <=  2'b00;
			prox_estado <= ESTADO14;
			
		end
		
		ESTADO15: begin
		// controle
			EscrevePC   <=  1'b0;
			EscreveRI   <=  1'b0;
			if(opcode == 6'b000110) EscreveReg  <=  1'b0;
			else EscreveReg  <=  1'b1;
			EscreveMem  <=  1'b0;
			controleOUT <=  1'b0;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxMem   <=  1'b0;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b1;
			SelMuxUlaA  <=  1'b0;
			SelMuxUlaB  <= 2'b00;
			SelMuxIn    <=  1'b1;
			prox_estado <= ESTADO0;
		end
		endcase
	end //fim always
	
always @(posedge clk) begin
	
		estado <= prox_estado;
	
	end//fim always
endmodule

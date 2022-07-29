module ctrl_undd(opcode, funct, reset, enter, clk, estado, EscrevePC, EscreveRI, EscreveReg,
	EscreveMem, SelMuxEndMem, SelMuxDadoMem, SelMuxPilha, SelMuxReg1, SelMuxReg2, SelMuxUlaA,
	SelMuxUlaB, SelMuxPC, zero, controleULA, controleIN, controleOUT, controlePWM, SelMuxIn,
	pop, push);

	input clk, zero, enter, reset;
	input [5:0] opcode;
	input [5:0] funct;
	output reg [4:0] estado;
	reg [4:0] prox_estado;
	reg SO;

	//sinais de controle de memoria
	output reg pop, push, EscrevePC, EscreveRI, EscreveReg, EscreveMem, controleIN, controleOUT, controlePWM;

	//seletores de multiplexadores
	output reg SelMuxEndMem, SelMuxDadoMem, SelMuxPilha, SelMuxReg1, SelMuxReg2, SelMuxUlaA, SelMuxIn;
	output reg [1:0] SelMuxUlaB, SelMuxPC;

	//sinal de controle da ULA
	reg [1:0]OpULA;
	output [4:0] controleULA;

	// Estados da UC
	parameter  ESTADO0=5'b00000,  ESTADO1=5'b00001,  ESTADO2=5'b00010,  ESTADO3=5'b00011,
				  ESTADO4=5'b00100,  ESTADO5=5'b00101,  ESTADO6=5'b00110,  ESTADO7=5'b00111, 
				  ESTADO8=5'b01000,  ESTADO9=5'b01001, ESTADO10=5'b01010, ESTADO11=5'b01011,
				 ESTADO12=5'b01100, ESTADO13=5'b01101, ESTADO14=5'b01110, ESTADO15=5'b01111,
				 ESTADO16=5'b10000, ESTADO17=5'b10001, ESTADO18=5'b10010, ESTADO19=5'b10011,
				 ESTADO20=5'b10100, ESTADO21=5'b10101;

	// Opcdode
	parameter    R=6'b000000, addi=6'b000001, subi=6'b000010, divi=6'b000011, multi=6'b000100, andi=6'b000101,
				  ori=6'b000110, nori=6'b000111, slei=6'b001000, slti=6'b001001,   beq=6'b001010,  bne=6'b001011,
				  blt=6'b001100,  bgt=6'b001101,  sti=6'b001110,  ldi=6'b001111,   str=6'b010000,  ldr=6'b010001,
				  hlt=6'b010010,   in=6'b010011,  out=6'b010100,  jmp=6'b010101,   jal=6'b010110,  jst=6'b010111,
				 lstk=6'b011100, sstk=6'b011101,  pwm=6'b011110;

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
			controleIN  <=  1'b0;
			controleOUT <=  1'b0;
			controlePWM <=  1'b0;
			OpULA       <= 2'b01;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxPilha <=  1'b0;
			SelMuxDadoMem  <=  1'b0;
			SelMuxEndMem   <=  1'b0;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxUlaA  <=  1'b0;
			SelMuxUlaB  <= 2'b01;
			SelMuxIn    <=  1'b1;
			prox_estado <= ESTADO1;
		end	

		ESTADO1: begin //decodifica instrucao
		// controle
			if(opcode == hlt) EscrevePC <= 1'b0;
			else EscrevePC   <=  1'b1;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b0;
			controleIN  <=  1'b0;
			if(opcode == out) controleOUT <=  1'b1;
			else controleOUT <=  1'b0;
			controlePWM <=  1'b0;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxPilha <=  1'b0;
			SelMuxDadoMem  <=  1'b0;
			SelMuxEndMem   <=  1'b0;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxUlaA  <=  1'b0;
			SelMuxUlaB  <= 2'b01;
			SelMuxIn    <=  1'b0;

			case(opcode)
			
				out: begin
					prox_estado <= ESTADO20; //out
				end

				pwm: begin
					prox_estado <= ESTADO21; //out
				end

				in: begin
					prox_estado <= ESTADO12; //in
				end
				
				sti: begin
					prox_estado <= ESTADO2; //sti
				end
				ldi: begin
					prox_estado <= ESTADO2; //ldi
				end
				str: begin
					prox_estado <= ESTADO2; //str
				end
				ldr: begin
					prox_estado <= ESTADO2; //ldr
				end
				R: begin
					prox_estado <= ESTADO6; //R
				end
				blt: begin
					prox_estado <= ESTADO8; //blt
				end
				bgt: begin
					prox_estado <= ESTADO8; //bgt
				end
				beq: begin
					prox_estado <= ESTADO8; ///beq   
				end
				bne: begin
					prox_estado <= ESTADO8; //bne
				end
				
				jmp: begin
					prox_estado <= ESTADO9; //jmp
				end
				
				jal: begin
					prox_estado <= ESTADO9; //jal
				end
				
				jst: begin
					prox_estado <= ESTADO10; //jst
				end
				
				hlt: begin
					prox_estado <= ESTADO14; //hlt
				end
				
				lstk: begin
					prox_estado = ESTADO16;
				end
				
				sstk: begin
					prox_estado = ESTADO18;
				end
				
				default: begin 
					prox_estado <= ESTADO11; // I
				end
			endcase
		end

		ESTADO2: begin //carrega ENDEREÇO na saida da ULA
		// controle
			EscrevePC   <=  1'b0;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b0;
			controleIN  <=  1'b0;
			controleOUT <=  1'b0;
			controlePWM <=  1'b0;
			if(opcode == sti) OpULA <= 2'b11;
			else if(opcode == ldi) OpULA <= 2'b11;
			else OpULA  <= 2'b01;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxPilha <=  1'b0;
			SelMuxDadoMem  <=  1'b0;
			SelMuxEndMem   <=  1'b1;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxUlaA  <=  1'b1;
			SelMuxUlaB  <= 2'b11;
			SelMuxIn    <=  1'b0;

			case(opcode)
				ldi: prox_estado <= ESTADO3;
				
				ldr: prox_estado <= ESTADO3;
				
				sti: prox_estado <= ESTADO5;
				
				str: prox_estado <= ESTADO5; 
				
				default: prox_estado <= ESTADO0;
			endcase
		end

		ESTADO3: begin //busca valor de dado dentro da memoria
		// controle
			EscrevePC   <=  1'b0;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b0;
			controleIN  <=  1'b0;
			controleOUT <=  1'b0;
			controlePWM <=  1'b0;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxPilha <=  1'b0;
			SelMuxDadoMem  <=  1'b0;
			SelMuxEndMem   <=  1'b1;
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
			controleIN  <=  1'b0;
			controleOUT <=  1'b0;
			controlePWM <=  1'b0;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxPilha <=  1'b0;
			SelMuxDadoMem  <=  1'b0;
			SelMuxEndMem   <=  1'b1;
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
			controleIN  <=  1'b0;
			controleOUT <=  1'b0;
			controlePWM <=  1'b0;
			OpULA       <= 2'b11;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxPilha <=  1'b0;
			if(opcode == sstk) SelMuxDadoMem  <=  1'b1;
			else SelMuxDadoMem  <=  1'b0;
			SelMuxEndMem   <=  1'b1;
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
			controleIN  <=  1'b0;
			controleOUT <=  1'b0;
			controlePWM <=  1'b0;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxPilha <=  1'b0;
			SelMuxDadoMem  <=  1'b0;
			SelMuxEndMem   <=  1'b0;
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
			controleIN  <=  1'b0;
			controleOUT <=  1'b0;
			controlePWM <=  1'b0;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxPilha <=  1'b0;
			SelMuxDadoMem  <=  1'b0;
			SelMuxEndMem   <=  1'b0;
			if(opcode == R)SelMuxReg1  <=  1'b1;
			else SelMuxReg1 <= 1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxUlaA  <=  1'b1;
			if(opcode == R)SelMuxUlaB  <= 2'b00;
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
			controleIN  <=  1'b0;
			controleOUT <=  1'b0;
			controlePWM <=  1'b0;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b01;
			SelMuxPilha <=  1'b0;
			SelMuxDadoMem  <=  1'b0;
			SelMuxEndMem   <=  1'b0;
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
			controleIN  <=  1'b0;
			controleOUT <=  1'b0;
			controlePWM <=  1'b0;
			OpULA       <= 2'b11;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxPilha <=  1'b0;
			SelMuxDadoMem  <=  1'b0;
			SelMuxEndMem   <=  1'b0;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxUlaA  <=  1'b1;
			SelMuxUlaB  <= 2'b11;
			SelMuxIn    <=  1'b0;
			prox_estado <= ESTADO13;
		end		

		ESTADO10: begin //atualiza pc
			if(zero == 1'b1) EscrevePC   <=  1'b1; // faz o branch?
			else if (opcode == jst) EscrevePC   <=  1'b1; //jst
			else EscrevePC   <=  1'b0;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b0;
			controleIN  <=  1'b0;
			controleOUT <=  1'b0;
			controlePWM <=  1'b0;
			OpULA       <= 2'b11;
			if (opcode == jst) pop <=  1'b1; //jst
			else pop    <=  1'b0;
			push        <=  1'b0;
		// mux
			if (opcode == jst) SelMuxPC <= 2'b11; //jst
			else SelMuxPC <= 2'b10;
			SelMuxPilha <=  1'b0;
			SelMuxDadoMem  <=  1'b0;
			SelMuxEndMem   <=  1'b0;
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
			controleIN  <=  1'b0;
			controleOUT <=  1'b0;
			controlePWM <=  1'b0;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxPilha <=  1'b0;
			SelMuxDadoMem  <=  1'b0;
			SelMuxEndMem   <=  1'b0;
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
			controleIN  <=  1'b1;
			controleOUT <=  1'b0;
			controlePWM <=  1'b0;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxPilha <=  1'b0;
			SelMuxDadoMem  <=  1'b0;
			SelMuxEndMem   <=  1'b0;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxUlaA  <=  1'b0;
			SelMuxUlaB  <= 2'b00;
			SelMuxIn    <=  1'b1;
			
			if(enter)
				prox_estado <= ESTADO15;
		end

		ESTADO13: begin // finaliza jmp, sw e lw
			if(opcode == jmp) EscrevePC <= 1'b1; //jmp
			else if(opcode == jal) EscrevePC <= 1'b1; //jal
			else EscrevePC <= 1'b0;
			EscreveRI   <=  1'b0;
			if(opcode == ldi) EscreveReg <= 1'b1; //lw
			else EscreveReg <= 1'b0;
			EscreveMem  <=  1'b0;
			controleIN  <=  1'b0;
			controleOUT <=  1'b0;
			controlePWM <=  1'b0;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			if(opcode == jal) push <=  1'b1;// jal
			else push   <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxPilha <=  1'b0;
			SelMuxDadoMem  <=  1'b0;
			SelMuxEndMem   <=  1'b0;
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
			controleIN  <=  1'b0;
			controleOUT <=  1'b0;
			controlePWM <=  1'b0;
			OpULA       <=  2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxPilha <=  1'b0;
			SelMuxDadoMem  <=  1'b0;
			SelMuxEndMem   <=  1'b0;
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
			if(opcode == sti || opcode == out) EscreveReg  <=  1'b0;
			else EscreveReg  <=  1'b1;
			EscreveMem  <=  1'b0;
			controleIN  <=  1'b0;
			controleOUT <=  1'b0;
			controlePWM <=  1'b0;
			OpULA       <= 2'b00;
			if(opcode == sstk) pop <= 1'b1;
			else pop <= 1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxPilha <=  1'b0;
			SelMuxDadoMem  <=  1'b0;
			SelMuxEndMem   <=  1'b0;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b1; 
			SelMuxUlaA  <=  1'b0;
			SelMuxUlaB  <= 2'b00;
			SelMuxIn    <=  1'b1;
			if(!enter)
				prox_estado <= ESTADO0;
		end

		ESTADO16: begin // Busca endereço no banco
			EscrevePC   <=   1'b0;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b0;
			controleIN  <=  1'b0;
			controleOUT <=  1'b0;
			controlePWM <=  1'b0;
			OpULA       <=  2'b11;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxPilha <=  1'b1;
			SelMuxDadoMem  <=  1'b0;
			SelMuxEndMem   <=  1'b0;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxIn    <=  1'b0;
			SelMuxUlaA  <=   1'b1;
			SelMuxUlaB  <=  2'b00;
			prox_estado <= ESTADO17;
		end

		ESTADO17: begin // Salva endereço na pilha
			EscrevePC   <=   1'b0;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b0;
			controleIN  <=  1'b0;
			controleOUT <=  1'b0;
			controlePWM <=  1'b0;
			OpULA       <=  2'b11;
			pop         <=  1'b0;
			push        <=  1'b1;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxPilha <=  1'b1;
			SelMuxDadoMem  <=  1'b0;
			SelMuxEndMem   <=  1'b0;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxIn    <=  1'b0;
			SelMuxUlaA  <=   1'b1;
			SelMuxUlaB  <=  2'b00;
			prox_estado <= ESTADO0;
		end

		ESTADO18: begin // Carrega valor na saida da ula
			EscrevePC   <=   1'b0;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b0;
			controleIN  <=  1'b0;
			controleOUT <=  1'b0;
			controlePWM <=  1'b0;
			OpULA       <=  2'b11;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxPilha <=  1'b0;
			SelMuxDadoMem  <=  1'b1;
			SelMuxEndMem   <=  1'b1;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxIn    <=  1'b0;
			SelMuxUlaA  <=   1'b1;
			SelMuxUlaB  <=  2'b00;
			prox_estado <= ESTADO19;
		end

		ESTADO19: begin // Descarrega a pilha na memoria
			EscrevePC   <=   1'b0;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b1;
			controleIN  <=  1'b0;
			controleOUT <=  1'b0;
			controlePWM <=  1'b0;
			OpULA       <=  2'b11;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxPilha <=  1'b0;
			SelMuxDadoMem  <=  1'b1;
			SelMuxEndMem   <=  1'b1;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxIn    <=  1'b0;
			SelMuxUlaA  <=   1'b1;
			SelMuxUlaB  <=  2'b00;
			prox_estado <= ESTADO15;
		end

		ESTADO20: begin
		// controle
			EscrevePC <= 1'b0;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b0;
			controleIN  <=  1'b0;
			controleOUT <=  1'b1;
			controlePWM <=  1'b0;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxPilha <=  1'b0;
			SelMuxDadoMem  <=  1'b0;
			SelMuxEndMem   <=  1'b0;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxUlaA  <=  1'b0;
			SelMuxUlaB  <= 2'b01;
			SelMuxIn    <=  1'b0;
			if (enter)
				prox_estado <= ESTADO15;
			end

		ESTADO21: begin
			// controle
			EscrevePC <= 1'b0;
			EscreveRI   <=  1'b0;
			EscreveReg  <=  1'b0;
			EscreveMem  <=  1'b0;
			controleIN  <=  1'b0;
			controleOUT <=  1'b1;
			controlePWM <=  1'b1;
			OpULA       <= 2'b00;
			pop         <=  1'b0;
			push        <=  1'b0;
		// mux
			SelMuxPC    <= 2'b00;
			SelMuxPilha <=  1'b0;
			SelMuxDadoMem  <=  1'b0;
			SelMuxEndMem   <=  1'b0;
			SelMuxReg1  <=  1'b0;
			SelMuxReg2  <=  1'b0;
			SelMuxUlaA  <=  1'b0;
			SelMuxUlaB  <= 2'b01;
			SelMuxIn    <=  1'b0;
			prox_estado <= ESTADO15;
		end
		endcase
	end //fim always

always @(posedge clk) begin
		if(reset) estado <= ESTADO0;
		else estado <= prox_estado;
	
	end//fim always
endmodule

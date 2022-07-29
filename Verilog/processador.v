module processador(dadosIN, chave, rst, realClk, estado, toOUT, controleIN, controlePWM);

input realClk, chave, rst;
input [7:0] dadosIN;
output [9:0] estado;
output [31:0]toOUT;
output controleIN, controlePWM;
wire [31:0] Dado, ePilha, sPilha, sregB, sMEM, saidaEXT, sregA, ULA1, ULA2, sULA, valorPC, carregaDados, sValorPC, sregULA, endereco, dadosMEM, mem, instr, dadosEscrita, sA, sB;
wire [4:0] regEscrita;

// SINAIS DE CONTROLE
//sinais de controle de memoria
wire clk, enter, pop, push, EscrevePC, SetPC, LeMem, EscreveRI, EscreveReg, controleOUT, EscreveMem, ovrflw, zero;

//seletores de multiplexadores
wire SelMuxEndMem, SelMuxDadoMem, SelReg1, SelReg2, SelMuxUlaA, SelMuxIn, SelMuxPilha;
wire [1:0] SelMuxUlaB, SelMuxPC;

//sinal de controle da ULA
wire [4:0]controleULA; 

// MODULOS

registradorPC PC(
	.controle(EscrevePC), 
	.reset(rst),
	.clk(clk),
	.led(estado),
	.entrada(valorPC),
	.saida(sValorPC)
	); // PC

mux2_32b MuxPilha(
	.seletor(SelMuxPilha),
	.entrada1(sValorPC),
	.entrada2(sULA),
	.saida(ePilha)
	); // para 'endereco' mem

stack Pilha(
	.dado(ePilha),
	.pop(pop),
	.push(push),
//	.led(estado),
	.wclk(clk),
	.rclk(clk),
	.saida(sPilha)
	); // pilha de recursao

mux2_32b MuxEndMem(
	.seletor(SelMuxEndMem),
	.entrada1(sValorPC),
	.entrada2(sULA),
	.saida(endereco)
	); // para 'endereco' mem

mux2_32b MuxDadoMem(
	.seletor(SelMuxDadoMem),
	.entrada1(sregB),
	.entrada2(sPilha),
	.saida(Dado)
	); // para 'endereco' mem	

memoria MEM(
	.dado(Dado),
	.endereco(endereco[9:0]),
	.write(EscreveMem),
	.wclk(clk),
	.rclk(clk),
	.saida(carregaDados)
	); // memoria (mem)

mux2_32b MuxIn(
	.seletor(SelMuxIn),
	.entrada1(carregaDados),
	.entrada2({24'd0,dadosIN}),
	.saida(sMEM)
	); // para r-mem

registrador32b Rmem(
	.controle(1'b1),
	.clk(clk),
	.entrada(sMEM),
	.saida(dadosMEM)
	); // registrador de dados da memoria (r-mem)

registrador32b ri(
	.controle(EscreveRI),
	.clk(clk),
	.entrada(carregaDados),
	.saida(instr)
	); // registrador de instr (ri)

mux2_5b MuxReg1(
	.seletor(SelReg1),
	.entrada1(instr[20:16]),
	.entrada2(instr[15:11]),
	.saida(regEscrita)
	); // para 'registrador de escrita b-reg

mux2_32b MuxReg2(
	.seletor(SelReg2),
	.entrada1(sregULA),
	.entrada2(dadosMEM),
	.saida(dadosEscrita)
	); // para 'dados para escrita' b-reg

bancoReg banco(
	.escreve(EscreveReg),
	.out(controleOUT),
	.clk(clk),
	.reg1(instr[25:21]),
	.reg2(instr[20:16]),
	.regF(regEscrita),
	.dados(dadosEscrita),
	.A(sA),
	.B(sB),
	.toOUT(toOUT)
	); // banco de registradores (b-reg)

registrador32b A(
	.controle(1'b1),
	.clk(clk),
	.entrada(sA),
	.saida(sregA)
	); // registrador A (a)

registrador32b B(
	.controle(1'b1),
	.clk(clk),
	.entrada(sB),
	.saida(sregB)
	); // registrador B (b)

extensor EXT(
	.sinal(instr[15:0]),
	.sinal_ext(saidaEXT)
	); // extensor de sinal (ext)

mux2_32b MuxUlaA(
	.seletor(SelMuxUlaA),
	.entrada1(endereco),
	.entrada2(sregA),
	.saida(ULA1)
	); // para ula-1

mux4_32b MuxUlaB(
	.seletor(SelMuxUlaB),
	.entrada1(sregB),
	.entrada2(32'd1),
	.entrada3(saidaEXT),
	.entrada4(saidaEXT),
	.saida(ULA2)
	); // para ula-2

ULA ALU(
	.A(ULA1),
	.B(ULA2),
	.clk(clk),
	.controle(controleULA),
	.saida(sULA),
	.overflow(ovrflw),
	.zero(zero)
	); // ULA

registrador32b saidaUla(
	.controle(1'b1),
	.clk(~clk),
	.entrada(sULA),
	.saida(sregULA)
	); // Saida ULA (s-ula)

mux4_32b MuxPC(
	.seletor(SelMuxPC),
	.entrada1(sULA),
	.entrada2(sregULA),
	.entrada3({16'b0, instr[15:0]}),
	.entrada4(sPilha),
	.saida(valorPC)
	); // para PC

//CONTROLE
divisor divFreq(
	.clk(realClk),
	.enter(chave),
	.div_clk(clk)
	);

ctrl_undd Controle(
	.opcode(instr[31:26]),
	.funct(instr[5:0]),
	.zero(zero),
	.enter(chave),
	.reset(rst),
	.clk(clk),
	// .estado(estado[4:0]),
	.SelMuxPC(SelMuxPC),
	.EscrevePC(EscrevePC),
	.SelMuxPilha(SelMuxPilha),
	.SelMuxEndMem(SelMuxEndMem),
	.SelMuxDadoMem(SelMuxDadoMem),
	.EscreveMem(EscreveMem),
	.EscreveRI(EscreveRI),
	.SelMuxReg1(SelReg1),
	.SelMuxReg2(SelReg2),
	.EscreveReg(EscreveReg),
	.SelMuxUlaA(SelMuxUlaA),
	.SelMuxUlaB(SelMuxUlaB),
	.controleULA(controleULA),
	.SelMuxIn(SelMuxIn),
	.controleIN(controleIN),
	.controleOUT(controleOUT),
	.controlePWM(controlePWM),
	.pop(pop),
	.push(push)
	);

endmodule

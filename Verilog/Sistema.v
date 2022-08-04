module Sistema(dadosIN, chave, rst, realClk, estado, pwmOut, rx, enableUsart, clk,
	disp5, disp4, disp3, disp2, disp1);

input realClk, chave, rst, rx;
input [7:0] dadosIN;
output pwmOut, enableUsart;
output [9:0] estado;
output [0:6] disp5, disp4, disp3, disp2, disp1;
output wire clk;
wire controleIN, controlePWM, controleUsart, dadoPronto, SelMuxUsart;
wire [31:0] bus, dadoUsart, dados;

processador CPU(
	.dadosIN({24'd0, dadosIN}),
	.dadoUsart(dadoUsart),
	.chave(chave),
	.dadoPronto(dadoPronto),
	.rst(rst),
	.clk(clk),
	.estado(estado),
	.toOUT(bus),
	.controleIN(controleIN),
	.controlePWM(controlePWM),
	.controleUsart(controleUsart),
	.SelMuxUsart(SelMuxUsart)
	);

moduloSaida ModOUT(
	.clk(realClk),
	.entrada(bus),
	.chaves(dadosIN),
	.controleOUT(controleIN),
	.controlePWM(controlePWM),
	.pwmOut(pwmOut),
	.saida1(disp1),
	.saida2(disp2),
	.saida3(disp3),
	.saida4(disp4),
	.saida5(disp5)
	);

divisor divFreq(
	.clk(realClk),
	.enter(chave),
	.div_clk(clk)
	);

usart usart(
	.controle(controleUsart),
	.Rx(rx),
	.clk(clk),
	.dado(dadoUsart),
	.habilitar(enableUsart),
	.dado_pronto(dadoPronto)
	);

endmodule

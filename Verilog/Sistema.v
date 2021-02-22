module Sistema(dadosIN,
					chave,
					rst, 
					realClk, 
					estado,
					disp5,
					disp4, 
					disp3, 
					disp2, 
					disp1);

input realClk;
input chave,rst;
input [7:0] dadosIN;
output [9:0] estado;
output [0:6] disp5, disp4, disp3, disp2, disp1;

wire controle;
wire [31:0] bus;

processador CPU(.dadosIN(dadosIN),
					 .chave(chave),
					 .rst(rst),
					 .realClk(realClk),
					 .estado(estado),
					 .toOUT(bus),
					 .controleIN(controle));
					 
moduloSaida ModOUT(.entrada(bus),
						 .chaves(dadosIN),
						 .controleOUT(controle),
						 .saida1(disp1),
						 .saida2(disp2),
						 .saida3(disp3),
						 .saida4(disp4),
						 .saida5(disp5),
						 .clk(realClk));	
endmodule

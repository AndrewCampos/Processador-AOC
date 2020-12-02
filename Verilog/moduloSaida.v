module moduloSaida(entrada,saida5, saida4, saida3, saida2, saida1,clk);

	input clk;
	input [31:0] entrada;
	output [6:0] saida1, saida2, saida3, saida4, saida5;
	reg [31:0] n1,  n2, n3, n4, n5;
	reg [31:0] temp;
	
initial begin

	n1 = 32'd15;
	n2 = 32'd15;
	n3 = 32'd15;
	n4 = 32'd15;
	n5 = 32'd15;

end
	
always @(*) begin
	temp = entrada;
		
		if(temp > 32'd99999) begin
			n1 <= 32'd14;
			n2 <= 32'd14;
			n3 <= 32'd14;
			n4 <= 32'd14;
			n5 <= 32'd14;
		end
		else begin
			n1  <= temp % 32'd10;
			temp = temp / 32'd10;
			n2  <= temp % 32'd10;
			temp = temp / 32'd10;
			n3  <= temp % 32'd10;
			temp = temp / 32'd10;
			n4  <= temp % 32'd10;
			temp = temp / 32'd10;
			n5  <= temp % 32'd10;
		end
	//end
end
// decodfica display 1
decodDisplay dispay1(n1[3:0],saida1);
// decodfica display 2
decodDisplay dispay2(n2[3:0],saida2);
// decodfica display 3
decodDisplay dispay3(n3[3:0],saida3);
// decodfica display 4
decodDisplay dispay4(n4[3:0],saida4);
// decodfica display 4
decodDisplay dispay5(n5[3:0],saida5);

endmodule 


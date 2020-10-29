module ULA(A, B, clk, controle, saida, overflow, zero);
	
	input [4:0] controle;
	input [31:0] A, B;
	input clk;
	output reg [31:0]saida;
	output reg overflow, zero;
	
always @(posedge clk) begin
	
	case(controle)
		5'd0: begin//add
			saida = A + B;
			overflow = 1'b0;
			zero = 1'b0;
		end
		5'd1: begin//sub
			saida = A - B;
			overflow = 1'b0;
			zero = 1'b0;
		end
		5'd2: //mult
		begin
			if(A[16] == 1 && B[16] == 1)
				overflow = 1'b1;
			else
				overflow = 1'b0;
			zero = 1'b0;
			saida = A * B;
		end

		5'd3: begin //div
			saida = A / B;
			overflow = 1'b0;
			zero = 1'b0;
		end
		5'd4: begin //and
			saida = A & B;
			overflow = 1'b0;
			zero = 1'b0;
		end
		5'd5: begin //or
			saida = A | B;
			overflow = 1'b0;
			zero = 1'b0;
		end
		5'd6: begin //nand
			saida = ~(A & B);
			overflow = 1'b0;
			zero = 1'b0;
		end
		5'd7: begin //nor
			saida = ~(A | B);
			overflow = 1'b0;
			zero = 1'b0;
		end
		5'd8: //beq
		begin
			saida = B;	
			overflow = 1'b0;
			if( A == B)
				zero = 1'b1;
			else
				zero = 1'b0;
		end

		5'd9: begin//bne
			saida = B;
			overflow = 1'b0;
			if(A != B)
				zero = 1'b1;
			else
				zero = 1'b0;
		end

		5'd10: //bgt 
		begin
			saida = B;
			overflow = 1'b0;
			if(A > B) 
				zero =  1'b1;
			else
				zero = 1'b0;
		end

		5'd11: //slt
		begin
			overflow = 1'b0;
			zero = 1'b0;
			if(A < B)
				saida = 1'b1;
			else
				saida = 1'b0;
		end

		5'd12: //sle
		begin
			overflow = 1'b0;
			zero = 1'b0;
			if(A > B)
				saida = 1'b0;
			else
				saida = 1'b1;
		end
		
		5'd13: //blt
		begin
			if(A < B)
				zero = 1'b1;
			else
				zero = 1'b0;
			overflow = 1'b0;
			saida = B;
			end
			
		5'd31: begin
			zero = 1'b0;
			overflow = 1'b0;
			saida = B;
		end
		
		default: begin 
			saida = saida;
			overflow = overflow;
			zero = zero;
		end
		
	endcase
	
end
endmodule

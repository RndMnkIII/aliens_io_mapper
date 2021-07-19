// D Flip Flop with async PRESET
// synchronized with global clock sysclk, 
// uses ck_ce clock enable signal to set the FF value
`default_nettype none
`timescale 1 ns / 100 ps
// module DFF2
// ( 
// 	input clk, d, ps,
// 	output reg q
// );
// 	parameter REGDLY = 1;
	
// 	always @(posedge clk or negedge ps) 
// 	begin
// 	 if(!ps) //Preset signal active low
// 	  q  = #REGDLY 1'b1; 
// 	 else q = #REGDLY d; 
// 	end 
// endmodule

//probar con cambiar a asignacion sin bloqueo
module DFF2
( 
	input clk, D, Sn,
	output reg Q,
	output Qn
);
	parameter REGDLY = 1;
	
	assign Qn = ~Q;

	always @(posedge clk or negedge Sn) 
	begin
	 if(!Sn) //Preset signal active low
		Q <= #13 1'b1;  //74ALS74
	 else 
	 	Q <= #25 D;  //74ALS74
	end 
endmodule
//bus_control_tb.v
//Author: RndMnkIII. 19/07/2021. (@RndMnkIII).
//---------------------------------------------------------
//iverilog -o bus_control_tb.vvp DFF2.v PAL16L8_053326_D21.v PAL16L8_053327_D20.v bus_control.v bus_control_tb.v
//vvp bus_control_tb.vvp -lxt2
//gtkwave bus_control_tb.lxt
`default_nettype none
`timescale 1 ns/ 10 ps //time-unit = 1 ns, precision = 1 ps

module bus_control_tb;
    //SYSCLK=48Mhz, period 20.832ns; 12Mhz, period 83.333ns; 3Mhz period 333.33ns
	parameter TS = 10.416;
	parameter T64 = TS * 64;
	parameter TS56 = TS * 56;
	parameter TS40 = TS * 40;
	parameter TS33 = TS * 33;
	parameter TS32 = TS * 32;
	parameter TS29 = TS * 29;
	parameter TS23 = TS * 23;
	parameter TS20 = TS * 20;
	parameter TS17 = TS * 17;
	parameter TS16 = TS * 16;
	parameter TS14 = TS * 14;
	parameter TS13 = TS * 13;
	parameter TS11 = TS * 11;
	parameter TS10 = TS * 10;
	parameter TS8 = TS * 8;
	parameter TS5 = TS * 5;
	parameter TS4 = TS * 4;
	parameter TS3 = TS * 3;
	parameter TS2 = TS * 2;
	
	reg [16:0] x,y;

	reg AS, BK4, INIT;
	reg WOCO, RMRD;
	reg SYSCLK, CK12, CKE, CKQ;
	reg [15:0] ADDR;
	reg RWb;
	wire PROG, BANK, WORK, OBJCS, VRAMCS, CRAMCS, IOCS, DTAC, NCK12;
	
	BusControl ABC(.BK4(BK4), .INIT(INIT), .ADDR(ADDR), .WOCO(WOCO), .RMRD(RMRD), 
	                     .CE(CKE), .CQ(CKQ), .CLK12(CK12), .RWb(RWb),
						 .PROG(PROG), .BANK(BANK), .WORK(WORK), .OBJCS(OBJCS), .VRAMCS(VRAMCS), .CRAMCS(CRAMCS), .IOCS(IOCS), 
						 .AS(AS), .DTAC(DTAC),
						 .CLK12n(NCK12));			 

	initial
	begin
		//INIT=1'b0;
		//#TS16
		INIT=1'b0;
		//RWb=1'b1;
	end
	
	
	//VRAMCS test
	initial //RWb timing
	begin
		RWb=1'b1;
		#TS4;
		for (x=16'h4000; x <= 16'h7fff; x= x + 16'h0001)
		begin
			
			RWb=1'b1;
			#TS8;
			RWb=1'b0;
			#TS23;
			RWb=1'b1;
			#TS;
		end
	end
	initial //AS timing
	begin
		AS=1'b1;
		#TS4;
		for (x=16'h4000; x <= 16'h7fff; x= x + 16'h0001)
		begin
			
			AS=1'b1;
			#TS10;
			AS=1'b0;
			#TS20;
			AS=1'b1;
			#TS2;
		end
	end
	
	initial //ADDR timing
	begin
		ADDR = 16'hFFFF; 
		#TS4;
		for (y=16'h4000; y <= 16'h7fff; y= y + 16'h0001)
		begin
			ADDR = y[15:0];
			#TS32;
		end
	end
	
	initial
	begin
		BK4 = 1'b0;
		RMRD = 1'b0;
		WOCO = 1'b1;
	end
	

	always
	begin
		SYSCLK = 1'b0;
		#TS; //high for 10.416 ns
		SYSCLK = 1'b1;
		#TS; //low for 10.416 ns
	end

	always
	begin
		//period 83.333ns
		CK12 = 1'b0;
		#TS2;
		CK12 = 1'b1;
		#TS2;
	end
	
	always
	begin
		CKE = 1'b0;
		#TS8;
		CKE = 1'b1;
		#TS8;
	end
	
	always
	begin
		CKQ = 1'b0;
		#TS4;
		CKQ = 1'b1;
		#TS8;
		CKQ = 1'b0;
		#TS4;
	end
	
	initial
	begin
		$dumpfile ("bus_control_tb.lxt");
		$dumpvars (0, bus_control_tb); //0 all variables included
		#46418500 $finish;
	end
endmodule
`default_nettype none
`timescale 1 ns / 100 ps
//iverilog bus_control.v PAL16L8_053326_D21.v PAL16L8_053327_D20.v DFF2.v
//7C00-7FFF, 7800-7807 Sprite data RAM k051960 1024 Bytes
//4000-7FFF VRAM
//   -> 4000-47ff LAYER FIX TILEMAP (ATTR.)
//   -> 4800-4fff LAYER A TILEMAP (ATTR.)
//   -> 5000-57ff LAYER B TILEMAP (ATTR.)
//   -> 580c-5833 A Y Scroll
//   -> 5a00-5bff A X Scroll
//   -> 6000-67ff LAYER FIX TILEMAP (CODE)
//   -> 6800-6fff LAYER A TILEMAP (CODE)
//   -> 7000-7fff LAYER B TILEMAP (CODE)
//   -> 7800-7807 051937 Space (registers)
//   -> 780c-7833 B Y Scroll
//   -> 7a00-7bff B X Scroll
//   -> 7c00-7fff 051960 Space (sprites) //8bytes per sprite x 128 sprites 
module BusControl
(
	input AS, BK4, INIT, 
	input [15:0] ADDR,
	input WOCO, 
	input RMRD,
	
	input CE, CQ, CLK12,
    input RWb,
	
	output PROG, BANK, WORK,
	output OBJCS, VRAMCS, CRAMCS, IOCS,
    output DTAC,
	output CLK12n
);

	wire D21_12, D21_15, D21_16, D21_17, D21_19; //D21 outputs

	wire D20_12; //D20 outputs
	
	wire ASn;
	
	wire C20_6 /* synthesis keep */;
	wire C20_3 /* synthesis keep */;
	wire C20_8 /* synthesis keep */;
	wire C19_3 /* synthesis keep */;
	wire C19_6 /* synthesis keep */;
	
	wire D18_5 /* synthesis keep */;
	wire D18_9 /* synthesis keep */;
	wire D18_dly;
	//wire D18_5_dly;
	wire D19_3 /* synthesis keep */;
    
	
	assign #5 CLK12n = ~CLK12;

	assign #10 C20_6 = ADDR[6] | ADDR[5];
	
	assign #10 C20_3 = ADDR[4] | ADDR[3];
	
	assign #5 C19_3 = D21_19 & IOCS;
	
	assign #5 ASn = ~AS;
	
	PAL16L8_053326_D21 D21(.AS(AS), .BK4(BK4), .INIT(INIT), .MAF(ADDR[15]), .MAE(ADDR[14]), .MAD(ADDR[13]), .MAC(ADDR[12]), .MAB(ADDR[11]), .MAA(ADDR[10]), .WOCO(WOCO),
	                       .D21_12(D21_12), .WORK(WORK), .BANK(BANK), .D21_15(D21_15), .D21_16(D21_16), .D21_17(D21_17), .PROG(PROG), .D21_19(D21_19));
	

	DFF2 D18_1( .clk(CQ), .D(D21_17), .Sn(ASn), .Q(D18_5));
	

	
	DFF2 D18_2( .clk(CLK12), .D(C19_3), .Sn(ASn), .Q(D18_9));
	
	PAL16L8_053327_D20 D20(.D18_5(D18_5), .D21_17(D21_17), .RMRD(RMRD), .MAA(ADDR[10]), .MA9(ADDR[9]), .MA8(ADDR[8]), .MA7(ADDR[7]), 
	                       .D21_12(D21_12), .C20_6(C20_6), .C20_3(C20_3), .D21_15(D21_15), .D21_16(D21_16),
	                       .D20_12(D20_12), .IOCS(IOCS), .CRAMCS(CRAMCS), .VRAMCS(VRAMCS), .OBJCS(OBJCS));
	
	assign #5 D19_3 = ~(CE & CQ);
	assign #10 C20_8 = D20_12 | D19_3;
	assign #5 C19_6 = D18_9 & C20_8;
	
	//Generates Konami-2 CPU DTAC control input signal
	DFF2 F11_1(.clk(CLK12n), .D(C19_6), .Sn(ASn), .Q(DTAC));
endmodule	
//PAL16L8_053326_D21.v
//Implementation of PAL 053326-D21 combinatorial logic
//used in Aliens Konami Arcade PCB.
//Converted to Verilog By RndMnkIII. 10/2019. (@RndMnkIII).
//---------------------------------------------------------
//Dumped from an unsecured PAL16L8, 
//converted to GAL16V8 with PALTOGAL 
//and tested by Caius (@Caius63417737).
//---------------------------------------------------------
`default_nettype none
`timescale 1 ns / 100 ps
module PAL16L8_053326_D21( 
	input AS, BK4, INIT, MAF, MAE, MAD, MAC, MAB, MAA, WOCO,
	output D21_12, WORK, BANK, D21_15, D21_16, D21_17, PROG, D21_19);
	
	parameter COMBDLY = 15; //tpd I, I/O typical 15ns max 30ns
	
	//D21_12 = ~[ADDR={0000 0000 00xx xxxx:0000-03FF} & WOCO=1]
	assign #COMBDLY D21_12 = ~(~MAF & ~MAE & ~MAD & ~MAC & ~MAB & ~MAA & WOCO);
	
	
	//WORK = ~[AS=0 & [ADDR={0000 01xx xxxx xxxx:0400-07FF} | 
	//        ADDR={0000 1xxx xxxx xxxx:0800-0FFF} | 
	//		  ADDR={0001 xxxx xxxx xxxx:1000-1FFF} |
	//		  [ADDR={0000 0000 00xx xxxx:0000-03FF} & WOCO=0] ]]
	assign #COMBDLY WORK = ~((~AS & ~MAF & ~MAE & ~MAD & ~MAC & ~MAB & MAA) |
       (~AS & ~MAF & ~MAE & ~MAD & ~MAC & MAB) |
       (~AS & ~MAF & ~MAE & ~MAD & MAC) | 
       (~AS & ~MAF & ~MAE & ~MAD & ~MAC & ~MAB & ~MAA & ~WOCO));
	
	//BANK = ~[AS=0 & ADDR={001x xxxx xxxx xxxx:2000-3FFF} & BK4=0]
	assign #COMBDLY BANK = ~(~AS & ~BK4 & ~MAF & ~MAE & MAD);
	
	//D21_15 = ~[AS=0 & ADDR={0101 11xx xxxx xxxx:5C00-5FFF}]
	assign #COMBDLY D21_15 = ~(~AS & ~MAF & MAE & ~MAD & MAC & MAB & MAA);
	
	//D21_16 = ~[INIT=1 & ADDR={0111 1xxx xxxx xxxx:7800-7FFF}]
	assign #COMBDLY D21_16 = ~(INIT & ~MAF & MAE & MAD & MAC & MAB);
	
	//D18_5 = D21_17 on CLKQ risedge
	//D21_17 = ~[[AS=0 & ADDR={0000 00xx xxxx xxxx:0000-03FF} & WOCO=1] | [AS=0 & ADDR={01xx xxxx xxxx xxxx:4000-7FFF}]]
	assign #COMBDLY D21_17 = ~((~AS & ~MAF & MAE) |
       (~AS & ~MAF & ~MAE & ~MAD & ~MAC & ~MAB & ~MAA & WOCO));
	
	//PROG = ~[AS=0 & [[BK4=1 & ADDR={001x xxxx xxxx xxxx:2000-3FFF}] | ADDR={1xxx xxxx xxxx xxxx:8000-FFFF}]]
	assign #COMBDLY PROG = ~((~AS & MAF) |
       (~AS & BK4 & ~MAF & ~MAE & MAD)); 
	
	//D21_19 = ~[AS=0 & [ ADDR={1xxx xxxx xxxx xxxx:8000-FFFF} |
	//           [BK4=1 & ADDR={001x xxxx xxxx xxxx:2000-3FFF}] |
	//           ADDR={0000 01xx xxxx xxxx:0400-07FF} |
	//           ADDR={0000 1xxx xxxx xxxx:0800-0FFF} |
	//           ADDR={0001 xxxx xxxx xxxx:1000-1FFF} |
	//           [ADDR={0000 0000 00xx xxxx:0000-03FF} & WOCO=0] |
	//           [ADDR={001x xxxx xxxx xxxx:2000-3FFF} & BK4=0]]]
	//D21_19 = PROG | WORK | BANK
	assign #COMBDLY D21_19 = ~((~AS & MAF) |
       (~AS & BK4 & ~MAF & ~MAE & MAD) |
       (~AS & ~MAF & ~MAE & ~MAD & ~MAC & ~MAB & MAA) |
       (~AS & ~MAF & ~MAE & ~MAD & ~MAC & MAB) |
       (~AS & ~MAF & ~MAE & ~MAD & MAC) |
       (~AS & ~MAF & ~MAE & ~MAD & ~MAC & ~MAB & ~MAA & ~WOCO) |
       (~AS & ~BK4 & ~MAF & ~MAE & MAD));
endmodule	   
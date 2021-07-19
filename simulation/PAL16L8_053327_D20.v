//PAL16L8_053326_D21.v
//Implementation of PAL 053327-D20 combinatorial logic
//used in Aliens Konami Arcade PCB.
//Converted to Verilog By RndMnkIII. 10/2019. (@RndMnkIII).
//---------------------------------------------------------
//Dumped from an unsecured PAL16L8, 
//converted to GAL16V8 with PALTOGAL 
//and tested by Caius (@Caius63417737).
//---------------------------------------------------------
`default_nettype none
`timescale 1 ns / 100 ps

// *** IMPORTANTE: LEER PARA PODER ENTENDER CORRECTAMENTE NOTACION ***
// LA NOTACION MMI-PAL ES UN TANTO CONFUSA CUANDO USA UNA ENTRADA COMO FEEDBACK YA QUE ESA ENTRADA SIN NEGAR ES LA MISMA SALIDA DE BUFFER TRI-ESTADO NEGADO
// PARA CON R14 Y R15. SI TENEMOS /R15 = ....,  CON VRAM = .... * R15 * .... ESTADOS USANDO /R15 MISMO SIN NEGAR
// *******************************************************************


//D21_17 = ~[[AS=0 & ADDR={0000 00xx xxxx xxxx:0000-03FF} & WOCO=1] | [AS=0 & ADDR={01xx xxxx xxxx xxxx:4000-7FFF}]]
//D18_5  = D21_17 on rising edge of Q
//D21_12 = ~[ADDR={0000 0000 00xx xxxx:0000-03FF} & WOCO=1]
//C20_6 = MA6 | MA5
//C20_3 = MA4 | MA3
//D21_15 = ~[AS=0 & ADDR={0101 11xx xxxx xxxx:5C00-5FFF}]
//D21_16 = ~[INIT=1 & ADDR={0111 1xxx xxxx xxxx:7800-7FFF}]

module PAL16L8_053327_D20( 
	input D18_5, D21_17, RMRD, MAA, MA9, MA8, MA7, D21_12, C20_6, C20_3, D21_15, D21_16,
	output D20_12, IOCS, CRAMCS, VRAMCS, OBJCS);
	
	parameter COMBDLY = 15; //tpd I, I/O typical 15ns max 30ns

	wire R14b, R15b;

	
	//D20_12 = ~[(7800-7807) & ~RMRD & INIT |  (7C00-7FFF) & ~RMRD & INIT | (4000-7FFF)-(5F80-5F90)-(7800-7807)-(7C00-7FFF) & ~RMRD]
	assign #COMBDLY D20_12 = ~((~D18_5 & ~RMRD & ~MAA & ~MA9 & ~MA8 & ~MA7 & ~C20_6 & ~C20_3 & ~D21_16) |
       (~D18_5 & ~RMRD & MAA & ~D21_16) |
       (~D18_5 & ~D21_17 & R14b & R15b));
	   
	//R14 = ~[[ADDR={0101 1111 100x xxxx:5F80-5F9F}] & ~AS]
	assign #COMBDLY R14b = ~(MA9 & MA8 & MA7 & ~C20_6 & ~D21_15);
	
	//IOCS  = ADDR={0101 1111 100x xxxx:5F80-5F90}
	assign #COMBDLY IOCS = R14b;
	
	// r15  = ~[[D18_5=0 & RMRD=0 & ADDR={0111 1000 0000 0xxx : 7800-7807}] | //051937 sprite generator attributes
	//          [D18_5=0 & RMRD=0 & ADDR={0111 11xx xxxx xxxx : 7C00-7FFF}]]  //051960 sprite ram (8bytes per sprite * 128)
	assign #COMBDLY R15b = ~((~D18_5 & ~RMRD & ~MAA & ~MA9 & ~MA8 & ~MA7 & ~C20_6 & ~C20_3 & ~D21_16) |
       (~D18_5 & ~RMRD & MAA & ~D21_16));
	
	// CRAMCS = ~[D18_5=0 & ~[ADDR={0000 0000 00xx xxxx:0000-03FF} & WOCO=1]]
	// CRAMCS = ~[(0-03FF) & WOCO & ~AS] & [(0-03FF) & WOCO & ~AS ] with CLKQ risedge] D18_5 implies evaluate value with CLKQ risedge
	assign #COMBDLY CRAMCS = ~(~D18_5 & ~D21_12);

	//VRAMCS = ~[[D18_5=0] & 
	//[[AS=0 & ADDR={0000 00xx xxxx xxxx:0000-03FF} & WOCO=1] | [AS=0 & ADDR={01xx xxxx xxxx xxxx:4000-7FFF}]] & 
	//  ~[ADDR={0000 0000 00xx xxxx:0000-03FF} & WOCO=1] & ~[ADDR={0101 1111 100x xxxx:5F80-5F90}] &
	//		   ~[[D18_5=0 & RMRD=0 & ADDR={0111 1000 0000 0xxx : 7800-7807}] | //051937 sprite generator attributes
	//          [D18_5=0 & RMRD=0 & ADDR={0111 11xx xxxx xxxx : 7C00-7FFF}]]  //051960 sprite ram (8bytes per sprite * 128)
	assign #COMBDLY VRAMCS = ~(~D18_5 & ~D21_17 & D21_12 & R14b & R15b); //4000-7FFF excludiding IOCS addresses and 7800-7807, 7C00-7FFF ranges???
	
	//OBJCS = ~[~AS & ~RMRD & INIT & (7800-7807) |  ~AS & ~RMRD & INIT & (7000-7FFF)
	assign #COMBDLY OBJCS = ~((~D18_5 & ~RMRD & ~MAA & ~MA9 & ~MA8 & ~MA7 & ~C20_6 & ~C20_3 & ~D21_16) | (~D18_5 & ~RMRD & MAA & ~D21_16));
endmodule   
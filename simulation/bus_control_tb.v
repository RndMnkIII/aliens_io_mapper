//bus_control_tb.v  
/****************************************************************
 * Test bench for the Konami Aliens Bus Control logic           *
 * Author: @RndMnkIII                                           *
 * Version: 1.0 18/07/2021 Preliminar                           *
 ***************************************************************/
//Test Bench Usage:
//iverilog -o bus_control_tb.vvp bus_control.v PAL16L8_053326_D21.v PAL16L8_053327_D20.v DFF2.v
//vvp bus_control_tb.vvp -lxt2
//gtkwave bus_control_tb.lxt&

`default_nettype none
`timescale 1ns/10ps

module k052109_tb;
    //Parameters for master clock
    localparam mc_freq = 12000000;
    localparam mc_p =  (1.0 / mc_freq) * 1000000000;
    localparam mc_hp = mc_p / 2;
    localparam mc_qp = mc_p / 4;
    localparam SIMULATION_TIME = 140000000; //ns

    //Test input signals
    reg RES; //System wide RESET, in Aliens generated by Watch Dog Timer 051550  
    reg [15:0] AB; //Address bus [CPU_INTERFACE]
    reg NRD; // NRD = ~CPU_RWn [CPU_INTERFACE]
    reg VRAMCSn; //CPU bus address selector for 052109/051962 data R/W -> VCS, CRCS //[CPU_INTERFACE]
    reg RMRD; //When enabled activates CPU GFX ROM read interface //[CPU_INTERFACE]
    //reg TEST; //When enabled activates the TEST interface (NOT TESTED YET ;-)

    //Test output signals
    wire [7:0] DB; //CPU data bus BIDIR [CPU_INTERFACE]

    wire RST; //Delayed RES signal for main CPU and sound CPU reset [CPU_INTERFACE]
    wire M12, PE, PQ; // MC6809, HD6309, Konami-2 CPU clocking signals //[CPU_INTERFACE]
    wire NMI, IRQ, FIRQ; // MC6809, HD6309, Konami-2 CPU interrupt signals //[CPU_INTERFACE]

    wire [7:0] COL; //ROM address lines + COLOR index lines, in Aliens COL[7:6] for color index, COL[5:0] -> GFX_ROM_ADDR[16:11]
    wire [10:0] VC; //GFX_ROM_ADDR[10:0]
    wire CAB1, CAB2; //GFX_ROM BANKING, in Aliens CAB1 -> GFX_ROM_ADDR[17], CAB2 -> GFX_ROM_ADR_RNG(0x00000-0x3FFFF) OEn (ROM ICs K13,K19)
                                                                        // ~CAB2 -> GFX_ROM_ADR_RNG(0x40000-0x5FFFF) OEn (ROM ICs J13,J19)

    //VRAM interface
    wire [12:0] RA; //VRAM ADDRESS
    wire [15:0] VD; //VRAM DATA bidirectional signal
    wire RCS1n, RCS0n; //VRAM CS RCS[1:0]
    wire ROE2n, ROE1n, ROE0n; //VRAM OE ROE[2:0]
    wire RWE2n, RWE1n, RWE0n; //VRAM WE RWE[2:0]

    //Sprite engine interface?
    wire HVOT; //In Aliens connected to 051960 HVIN

    //k051962 interface 
    //COL[7:6] in Aliens COL[7:6] for color index
    //COL[5:0] = 5'b0; //tied to GND
    wire BEN;
    wire ZB4H, ZB2H, ZB1H; //Layer B scroll
    wire ZA4H, ZA2H, ZA1H; //Layer A scroll

    //CRAM interface? 
    wire WRP; //In Aliens inhibits CPU writes to CRAM

    //Misc. signals
    wire WREN,RDEN;
    wire VDE;


    //Tri-state bus signals
    // wire [7:0] input_byte;
    // reg [7:0] output_byte;
    
    // wire [31:0] input_dword;
    // reg [31:0] output_dword;

    // assign input_byte = DB;
    // assign DB = (~CRCS & RMRD) ? output_byte : 8'hZZ;

    // assign input_dword = VC;
    // assign VC = (NRD & RMRD) ? output_dword : 32'hZZZZZZZZ; //when Z VC acts as INPUT, in the other case as OUPUT

    //UUT
    wire fde_q;
    wire fdn_q, fdn_qn;
    FDE_DLY fde1(.D(1'b1), .CLn(RES), .CK(clk24), .Q(fde_q));
    FDN_DLY fdn1(.D(fdn_qn), .Sn(fde_q), .CK(clk24), .Q(fdn_q), .Qn(fdn_qn));

    VRAM_G23 vram_low(.ADDR(RA), //8Kx8bit
                      .CEn(1'b0),
                      .OEn(ROE2n),
                      .WEn(RWE2n),
                      .DATA(VD[7:0]));

    VRAM_I23 vram_high(.ADDR(RA), //8Kx8bit
                      .CEn(RCS1n),
                      .OEn(ROE1n),
                      .WEn(RWE1n),
                      .DATA(VD[15:8]));

    k052109_DLY K052109_inst(
        .M24(clk24),
        .RES(RES),

        //TIMING, CLOCKING, INTERRUPT SIGNALS
        .M12(M12), //main CPU clocking
        .PE(PE), .PQ(PQ), //6809 style 90 degree phase delay clocks
        .NMI(NMI), .IRQ(IRQ), .FIRQ(FIRQ),

        //CPU bus interface
        .RST(RST), //Delayed RES signal
        .AB(AB),
        .NRD(NRD),
        .DB(DB), //BIDIR
        .VCS(VRAMCSn),
        .CRCS(VRAMCSn),
        .RMRD(RMRD),

        //ROM addressing interface 
        .VC(VC),
        .COL(COL),
        .CAB1(CAB1),
        .CAB2(CAB2),

        //VRAM interface
        .RA(RA), //VRAM ADDRESS
        .VD(VD), //VRAM DATA BIDIR
        .RCS({RCS1n, RCS0n}), //VRAM CSn
        .ROE({ROE2n, ROE1n, ROE0n}), //VRAM OEn
        .RWE({RWE2n, RWE1n, RWE0n}), //VRAM WEn

        //sprite engine interface
        .HVOT(HVOT),

        //k051962 interface 
        .BEN(BEN),
        //COL[7:6] <-> k051962
        .ZB4H(ZB4H), .ZB2H(ZB2H), .ZB1H(ZB1H),
        .ZA4H(ZA4H), .ZA2H(ZA2H), .ZA1H(ZA1H),

        //CRAM interface
        .WRP(WRP), //inhibits CRAM writes if equal to 1

        //MISC. signals
        .RDEN(RDEN), .WREN(WREN), //READ, WRITE enables
        .TEST(1'b0), //factory test, connected to GND when not used
        .VDE(VDE)    
    );

    initial
    begin
        $display("---------------------------------");
        $display("Master Clock Settings:");
        $display("Freq: %f Hz Period: %f ns", mc_freq, mc_p);
        $display("---------------------------------");
        $dumpfile("k052109_tb.lxt");
        $dumpvars(0,k052109_tb);
    end

    //24MHz master clock
    reg clk24 = 0;
    always #mc_hp clk24 = !clk24;

    //Testing timing signals
    initial 
        begin
            RES=1'b0; AB=16'h0; NRD=1'b1; VRAMCSn=1; RMRD=1'b0;
            #mc_p; #mc_p; #mc_hp; #mc_qp;
            RES=1'b1;
            //#SIMULATION_TIME; //For test the RST signal, needs 8 NVBK cycles
            //#64_700_000; //one frame aprox.
            #6_470_000;
            $finish;
        end
endmodule
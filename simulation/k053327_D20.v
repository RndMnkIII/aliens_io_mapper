//k053327_D20.v
//PAL16L8 equations
//iverilog k053327_D20.v
`default_nettype none
`timescale 1ns/1ps
// k053327_D20 D20(
//     .i1(D18_5), .i2(D21_17), .i3(RMRD), .i4(ADDR[10]), .i5(ADDR[9]), .i6(ADDR[8]), .i7(ADDR[7]), .i8(D21_12), .i9(C20_6), .i11(C20_3), .i13(D21_15), .i16(D21_16),
//     .o12(D20_12), .o14(IOCS), .o17(CRAMCS), .o18(VRAMCS), .o19(OBJCS)
// );
module k053327_D20 (
    input i1, i2, i3, i4, i5, i6, i7, i8, i9, i11, i13, i16,
    output o12, o14, o15, o17, o18, o19
);
    parameter COMBDLY = 15; //tPD(typical) 25ns for MMI PAL16L8

    wire f14, f15;

    assign #COMBDLY o12 = ~((~i1 & ~i3 & ~i4 & ~i5 & ~i6 & ~i7 & ~i9 & ~i11 & ~i16) |
                   (~i1 & ~i3 & i4 & ~i16) |
                   (~i1 & ~i2 & f14 & f15));

    assign #COMBDLY o14 = ~(i5 & i6 & i7 & ~i9 & ~i13);
    assign f14 = o14;

    assign #COMBDLY o15 = ~((~i1 & ~i3 & ~i4 & ~i5 & ~i6 & ~i7 & ~i9 & ~i11 & ~i16) |
                   (~i1 & ~i3 & i4 & ~i16));
    assign f15 = o15;

    assign #COMBDLY o17 = ~(~i1 & ~i8);

    assign #COMBDLY o18 = ~(~i1 & ~i2 & i8 & f14 & f15);

    assign #COMBDLY o19 = ~((~i1 & ~i3 & ~i4 & ~i5 & ~i6 & ~i7 & ~i9 & ~i11 & ~i16) |
                   (~i1 & ~i3 & i4 & ~i16));
endmodule
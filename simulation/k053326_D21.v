//k053326_D21.v
//PAL16L8 equations
//iverilog k053326_D21.v
`default_nettype none
`timescale 1ns/1ps

//example instance for Aliens PCB
//k053326_D21 D21 (
//     .i1(AS), .i2(BK4), .i3(INIT), 
//     .i4(ADDR[15]), .i5(ADDR[14]), .i6(ADDR[13]), .i7(ADDR[12]), .i8(ADDR[11]), .i9(ADDR[10]), .i11(WOCO),
//     .o12(D21_12), .o13(WORK), .o14(BANK), .o15(D21_15), .o16(D21_16), .o17(D21_17), .o18(PROG), .o19(D21_19)
// );

module k053326_D21 (
    input i1, i2, i3, i4, i5, i6, i7, i8, i9, i11,
    output o12, o13, o14, o15, o16, o17, o18, o19
);
    parameter COMBDLY = 35; //tPD(typical) 25ns for MMI PAL16L8

    assign #COMBDLY o12 = ~(~i4 & ~i5 & ~i6 & ~i7 & ~i8 & ~i9 & i11);

    assign #COMBDLY o13 = ~((~i1 & ~i4 & ~i5 & ~i6 & ~i7 & ~i8 & i9) |
        (~i1 & ~i4 & ~i5 & ~i6 & ~i7 & i8) |
        (~i1 & ~i4 & ~i5 & ~i6 & i7) |
        (~i1 & ~i4 & ~i5 & ~i6 & ~i7 & ~i8 & ~i9 & ~i11));

    assign #COMBDLY o14 = ~(~i1 & ~i2 & ~i4 & ~i5 & i6);

    assign #COMBDLY o15 = ~(~i1 & ~i4 & i5 & ~i6 & i7 & i8 & i9);

    assign #COMBDLY o16 = ~(i3 & ~i4 & i5 & i6 & i7 & i8);

    assign #COMBDLY o17 = ~(( ~i1 & ~i4 & i5) |
        (~i1 & ~i4 & ~i5 & ~i6 & ~i7 & ~i8 & ~i9 & i11));

    assign o18 = ~(( ~i1 & i4) |
        (~i1 & i2 & ~i4 & ~i5 & i6));

    assign o19 = ~(( ~i1 & i4) |
        (~i1 & i2 & ~i4 & ~i5 & i6) |
        (~i1 & ~i4 & ~i5 & ~i6 & ~i7 & ~i8 & i9) |
        (~i1 & ~i4 & ~i5 & ~i6 & ~i7 & i8) |
        (~i1 & ~i4 & ~i5 & ~i6 & i7) |
        (~i1 & ~i4 & ~i5 & ~i6 & ~i7 & ~i8 & ~i9 & ~i11) |
        (~i1 & ~i2 & ~i4 & ~i5 & i6));
endmodule

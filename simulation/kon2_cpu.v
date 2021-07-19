module kon2_cpu (
    	input CLK,
        input RES,
	    input [15:0] ADDR,
        inout [7:0] DB,
        input DTAC,
        output reg RWn,
        output AS,
);
    reg [15:0] addr_cnt;
    reg [7:0] data_out;
    wire [7:0] data_in;

    always @(posedge CLK, negedge RES) begin
        if(!RES) begin
            addr_cnt <= #5 0;
            data_out <= #5 8'h1A;
            RWn <= #5 1'b0;
        end
        else begin
            addr_cnt <= #5 addr_cnt + 1;
            data_out <= #10 data_out + 1;
        end
    end

    reg [1:0] trig_dtac;
    always @(posedge CLK, negedge RES) begin
        if(!RES) begin
                trig_dtac <= #5 2'b00;
            end
        else if (DTAC == 1'b0) begin
            trig_dtac <= #5 2'b01; //start following DTAC low value
        end
        else if ((DTAC == 1'b1) && (trig_dtac == 2'b01)) begin
            trig_dtac <= #5 2'b10; //trig AS=1
        end
        else if(trig_dtac == 2'b10) begin
            trig_dtac <= #5 2'b00;
        end
    end

    assign #10 AS = ((trig_dtac == 2'b00) || (trig_dtac == 2'b10))? 1'b1 : 1'b0;
    assign #10 ADDR = addr_cnt;
    //Tri-state data bus control
    assign #10 DB = (~RWn) ? data_out : 8'hzz;
    assign data_in = DB;
endmodule
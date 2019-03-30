`timescale 1ns / 1ps

module VGA_Controller(clk, Rin, Gin, Bin, vsync, hsync, R, G, B, hOut, vOut);
    input clk; input [3:0] Rin, Gin, Bin;
    output vsync, hsync; output [3:0] R, G, B; output [9:0] hOut, vOut;
    wire clk25MHz;
    reg HsyncReg,VsyncReg;
    reg [3:0] Rreg,Greg,Breg;
    reg [9:0] hcount,vcount;
    clk4th s1 (clk, clk25MHz);
    initial begin
        HsyncReg=0; VsyncReg=0;
        Rreg=0; Greg=0;    Breg=0;  hcount=0;   vcount=0;
    end
    assign vsync = VsyncReg;
    assign hsync = HsyncReg;
    assign R = Rreg;
    assign G = Greg;
    assign B = Breg;
    assign hOut = hcount;
    assign vOut = vcount;
    
    always@(posedge clk25MHz) begin
        HsyncReg <=0; VsyncReg<=0; Rreg<=0; Greg<=0; Breg<=0;
        if (hcount == 10'd799) begin
            hcount <= 10'd0;
            if (vcount == 10'd524) begin
                vcount <= 10'd0;
            end else begin
                vcount <= vcount +1;
            end
        end else begin
            hcount <= hcount+1;
            if ((10'd659<=hcount) && (hcount<=10'd755)) begin
                HsyncReg <= 1;
            end 
            if ((10'd493<=vcount) && (vcount<=10'd494)) begin
                VsyncReg <= 1;
            end 
            if((hcount<=10'd639) && (vcount<=10'd479)) begin
                Rreg <= Rin;
                Greg <= Gin;
                Breg <= Bin;
            end
        end
    end
endmodule

module clk4th (clk, clk25MHz);
    input clk; 
    output clk25MHz;
    reg [1:0] count=0;
    
    assign clk25MHz = count[1];
    always@(posedge clk) begin
        count <= count + 1;
    end
endmodule
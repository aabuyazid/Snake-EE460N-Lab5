`timescale 1ns / 1ps
`define  sCol  12'h0F0;
`define  bCol  12'hFFF;
`define black  12'h000;
module Snake_1(clk, Px1, Py1, Px2, Py2, Px3, Py3, Px4, Py4, hIndex,vIndex,color,AllBlack);
    input clk, AllBlack;
    input [5:0] hIndex, vIndex;
    input [5:0] Px1, Py1, Px2, Py2, Px3, Py3, Px4, Py4;
    output [11:0] color;
    wire clk25MHz;
    reg [11:0] colorReg;
    clk4th s7 (clk, clk25MHz);

    //maps the screen to the output
    assign color = colorReg;
    always@(posedge clk25MHz) begin
        if (AllBlack) begin
            colorReg <= `black;
        end else begin
            if((vIndex == Py1 && hIndex == Px1) || (vIndex == Py2 && hIndex == Px2) || (vIndex == Py3 && hIndex == Px3) || (vIndex == Py4 && hIndex == Px4)) begin
                colorReg <= `sCol;
            end else
                colorReg <= `bCol;
        end
    end
endmodule

module clkFPS (clk, clkFPS);
    input clk; 
    output reg clkFPS;
    reg [24:0] count=0;
    initial
        clkFPS=0;
    
    always@(posedge clk) begin
        if (count == 25'd10000000) begin
            clkFPS = ~clkFPS;
            count <= 0;
        end else
            count <= count + 1;
    end
endmodule

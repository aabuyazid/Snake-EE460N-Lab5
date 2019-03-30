`timescale 1ns / 1ps
`define  sCol  12'h0F0;
`define  bCol  12'hFFF;
module Snake_1(clk, Py1, Py2, Py3, Py4, Px1, Px2, Px3, Px4, hIndex,vIndex,color);
    input clk;
    input [6:0] hIndex, vIndex;
    input [6:0] Py1, Py2, Py3, Py4, Px1, Px2, Px3, Px4;
    output [11:0] color;
    wire clkFPS, clk25MHz;
    integer i;
    reg [63:0] screen [48:0];
    reg [11:0] colorReg;
    clkFPS s6 (clk, clkFPS);
    clk4th s7 (clk, clk25MHz);
    
    //Refreshes the screen and places the snake 
    always@(posedge clkFPS) begin
        for (i=0; i<47; i=i+1) begin
            screen[i] <= 63'd0;
        end
        screen[Py1][Px1] <= 1'b1;
        screen[Py2][Px2] <= 1'b1;
        screen[Py3][Px3] <= 1'b1;
        screen[Py4][Px4] <= 1'b1;
    end
    //maps the screen to the output
    assign color = colorReg;
    always@(posedge clk25MHz) begin
        if(screen[vIndex][hIndex]) begin
            colorReg <= `sCol;
        end else
            colorReg <= `bCol;
    end
endmodule


`timescale 1ns / 1ps

module clkFPS (clk, clkFPS);
    input clk; 
    output clkFPS;
    reg [23:0] count=0;
    
    assign clkFPS = count[20];
    always@(posedge clk) begin
        count <= count + 1;
    end
endmodule

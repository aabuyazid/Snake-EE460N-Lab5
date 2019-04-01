`timescale 1ns / 1ps
`define  sCol  12'h0F0;
`define  bCol  12'hFFF;
`define  black  12'h000;
module Snake_1(clk, Py1, Py2, Py3, Py4, Px1, Px2, Px3, Px4, hIndex,vIndex,color,AllBlack);
    input clk, AllBlack;
    input [6:0] hIndex, vIndex;
    input [6:0] Py1, Py2, Py3, Py4, Px1, Px2, Px3, Px4;
    output [11:0] color;
    wire clkFPS, clk25MHz;
    integer i,j;
    reg [63:0] screen [47:0];
    reg [11:0] colorReg;
    clkFPS s6 (clk, clkFPS);
    clk4th s7 (clk, clk25MHz);
    
    //Refreshes the screen and places the snake 
    always@(posedge clkFPS) begin
//        for (i=0; i<48; i=i+1) begin
//            for (j=0; j<64; j=j+1) begin
//                screen[i][j] <= (i == Py1 && j == Px1) || 
//                                (i == Py2 && j == Px2) ||
//                                (i == Py3 && j == Px3) ||
//                                (i == Py4 && j == Px4);
//            end
//        end
        for (i=0; i<48; i=i+1) begin
            screen[i] = 0;
        end
        screen[vIndex][hIndex] = 1'b1;
    end
    //maps the screen to the output
    assign color = colorReg;
    always@(posedge clk25MHz) begin
        if(AllBlack) begin
            colorReg <= `black;
        end else begin
            if(screen[vIndex][hIndex]) begin
                colorReg <= `sCol;
            end else
                colorReg <= `bCol;
        end
    end
endmodule

module clkFPS (clk, clkFPS); // 5kHz
    input clk; 
    output clkFPS;
    reg [19:0] count=0;
    reg game_clk = 0;
    assign clkFPS = game_clk;
    always @(posedge clk) begin
        if(count == 10000000) begin
            game_clk <= ~game_clk;
            count <= 0;
        end else
            count <= count + 1;
    end
endmodule

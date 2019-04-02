`timescale 1ns / 1ps

module TopSnake(
    input clk,
    input PS2CLK,
    input PS2Data,
    output hsync,
    output vsync,
    output [11:0] color
    );
    wire [5:0] Px1, Py1, Px2, Py2, Px3, Py3, Px4, Py4;// pluse the black flag for escape
    wire [9:0] hcount,vcount; // output indices
    reg [5:0] hIndex, vIndex; // screen matrix indices 
    wire [11:0] cTemp;
    wire AllBlack;
    wire clkFPS;
    clkFPS s12 (clk, clkFPS);
    Snake_SMY sm1 (clk,clkFPS,PS2CLK,PS2Data,Px1,Py1,Px2,Py2,Px3,Py3,Px4,Py4,AllBlack);
    //screenAndMapping_TEST tst (clk,Py1,Py2,Py3,Py4,Px1,Px2,Px3,Px4);
    Snake_1 sk (clk, Px1, Py1, Px2, Py2, Px3, Py3, Px4, Py4, hIndex, vIndex, cTemp, AllBlack);
    VGA_Controller vga (clk, cTemp[11:8], cTemp[7:4], cTemp[3:0], vsync, hsync, color[11:8], color[7:4], color[3:0], hcount, vcount);
    // Index into the screen from veritcal and horizontal counts
    always@(hcount)
        hIndex <= hcount /  4'd10;
    always@(vcount)
        vIndex <= vcount /  4'd10;
endmodule


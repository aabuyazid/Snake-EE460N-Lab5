`timescale 1ns / 1ps

module LAB5_part2(clk, select, vsync, hsync, R, G, B);
    input clk;
    input [7:0] select;
    output vsync, hsync;
    output [3:0] R, G, B;
    
    wire [3:0] Rin, Gin, Bin;
        VGA_Controller vga1 (clk, Rin, Gin, Bin, vsync, hsync, R, G, B);
    assign Rin = select[0] ?  4'h0 : select[1] ? 4'h0 : select[2] ? 4'hC : select[3] ? 4'h0 : select[4] ? 4'hF : select[5] ? 4'hF : select[6] ? 4'hF : select[7] ?  4'hF : 4'b0;
    assign Gin = select[0] ?  4'h0 : select[1] ? 4'h0 : select[2] ? 4'h4 : select[3] ? 4'hF : select[4] ? 4'h0 : select[5] ? 4'h0 : select[6] ? 4'hF : select[7] ?  4'hF : 4'b0;
    assign Bin = select[0] ?  4'h0 : select[1] ? 4'hF : select[2] ? 4'h1 : select[3] ? 4'hF : select[4] ? 4'h0 : select[5] ? 4'hF : select[6] ? 4'h0 : select[7] ?  4'hF : 4'b0;
endmodule
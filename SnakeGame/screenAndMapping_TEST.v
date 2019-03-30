`timescale 1ns / 1ps

module screenAndMapping_TEST(Py1,Py2,Py3,Py4,Px1,Px2,Px3,Px4);
    output [6:0] Py1,Py2,Py3,Py4,Px1,Px2,Px3,Px4;
    
    assign Py1 = 7'd20;
    assign Py2 = 7'd21;
    assign Py3 = 7'd22;
    assign Py4 = 7'd23;
    assign Px1 = 7'd20;
    assign Px2 = 7'd20;
    assign Px3 = 7'd20;
    assign Px4 = 7'd20;
endmodule

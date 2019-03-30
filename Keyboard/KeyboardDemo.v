module KeyboardDemo(
    input clk,
    input PS2CLK,
    input PS2Data,
    output [3:0] an,
    output [6:0] sseg,
    output strobe,
    output lightCheck
);

wire [7:0] KeyPress;
wire KeyRelease;

reg lightCheck_reg;
initial
begin
    lightCheck_reg=0;
end
assign lightCheck = lightCheck_reg;

PS2 ps (PS2CLK,PS2Data,KeyPress,KeyRelease);
PS2DisplayController psd (clk,KeyPress,KeyRelease,an,sseg,strobe);

always@(negedge PS2CLK) begin
    lightCheck_reg <= ~lightCheck_reg;
end

endmodule


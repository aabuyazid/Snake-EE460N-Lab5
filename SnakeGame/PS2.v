
module GetPS2Data(
    input PS2CLK,
    input PS2Data,
    output reg [0:21] Data
);
initial 
    Data = 22'h3FFFFF;

always @(negedge PS2CLK) begin
    Data <= {PS2Data,Data[0:20]};
end

endmodule

module PS2(
    input PS2CLK,
    input PS2Data,
    output [7:0] KeyPress,
    output newKey
);

wire [0:21] Data;
wire ready, KeyRelease;

reg [7:0] PrevKeyPress = 8'hF0;

reg [7:0] KeyPress_reg = 8'hF0;

assign KeyPress = KeyPress_reg;

GetPS2Data get (PS2CLK,PS2Data,Data);

assign KeyRelease = (Data[13:20] == 8'hF0) ? 1:0;

assign newKey = (PrevKeyPress != KeyPress);

always @(negedge PS2CLK) begin
    if(KeyRelease) begin
        PrevKeyPress <= KeyPress_reg;
        KeyPress_reg <= Data[2:9];
    end
    else begin
        KeyPress_reg <= KeyPress_reg;
        PrevKeyPress <= PrevKeyPress;
    end
end

endmodule


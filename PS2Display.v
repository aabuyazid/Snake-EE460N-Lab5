`define ENDSTROBE 1000000

module hexto7segment(
    input [3:0] x,
    output reg [6:0] r
    );
    
    always @ (*)
        case (x)
            4'b0000: r = 7'b0000001;
            4'b0001: r = 7'b1001111;
            4'b0010: r = 7'b0010010;
            4'b0011: r = 7'b0000110;
            4'b0100: r = 7'b1001100;
            4'b0101: r = 7'b0100100;
            4'b0110: r = 7'b0100000;
            4'b0111: r = 7'b0001111;
            4'b1000: r = 7'b0000000;
            4'b1001: r = 7'b0000100;
            4'b1010: r = 7'b0001000;
            4'b1011: r = 7'b1100000;
            4'b1100: r = 7'b0110001;
            4'b1101: r = 7'b1000010;
            4'b1110: r = 7'b0110000;
            4'b1111: r = 7'b0111000;
        endcase
        
endmodule

module SSEGClkDivider(
    input clk,
    output SSEGClk
);

reg [18:0] COUNT; // Arbitrary number, GO CHANGE IT
    
assign SSEGClk = COUNT[18];
    
always @(posedge clk) begin
    COUNT = COUNT + 1;
end

endmodule

module PS2Display(
    input SSEGClk,
    input [13:0] sev_seg_data,
    input KeyRelease,
    output reg [3:0] an,
    output reg [6:0] sseg
    );
    
    reg [1:0] state = 2'b11;
    reg [1:0] next_state;
    
    always @ (*) begin
        case (state)
            2'b00: begin
                an = 4'b1101; 
                sseg = sev_seg_data[13:7];
                next_state = 2'b01;
            end
            2'b01: begin
                an = 4'b1110; 
                sseg = sev_seg_data[6:0];
                next_state = 2'b00;
            end
            default: begin
                if(KeyRelease)
                    next_state = 2'b00;
                else
                    next_state = 2'b11;
                an = 4'b1111;
                sseg = 7'b1111111;
            end
        endcase
    end

    always @(posedge SSEGClk) begin
        state <= next_state;
    end
    
endmodule

module PS2DisplayController(
    input clk,
    input [7:0] KeyPress,
    input KeyRelease,
    output [3:0] an,
    output [6:0] sseg,
    output strobe
);

wire [13:0] sev_seg_data;
wire SSEGClk;

reg [19:0] strobe_counter = 0;
reg strobe_reg = 0;

reg checkedRelease = 0;

assign strobe = strobe_reg;

SSEGClkDivider s1 (clk,SSEGClk);

hexto7segment left  (KeyPress[7:4],sev_seg_data[13:7]);
hexto7segment right (KeyPress[3:0],sev_seg_data[6:0]);

PS2Display dis (SSEGClk,sev_seg_data,KeyRelease,an,sseg);

always @(posedge clk) begin
    if(checkedRelease) begin
        if(strobe_counter == `ENDSTROBE) begin
            strobe_reg <= 0;
            checkedRelease <= 0;
            strobe_counter <= strobe_counter;
        end
        else
            strobe_counter <= strobe_counter + 1;
            strobe_reg <= 1;
            checkedRelease <= 1;
            
    end
    else begin
        if(KeyRelease) begin
            checkedRelease <= 1;
            strobe_reg <= 1;
            strobe_counter <= 0;
        end
        else begin
            checkedRelease <= 0;
            strobe_reg <= 0;
            strobe_counter <= strobe_counter;
        end
    end
end 

endmodule

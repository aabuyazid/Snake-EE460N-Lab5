// Keyboard Inputs
`define START 8'h1B
`define ESC 8'h76
`define PAUSE 8'h4d
`define RESUME 8'h2D
`define UP 8'h75
`define DOWN 8'h72
`define RIGHT 8'h74
`define LEFT 8'h6b

// Game-stopping/Game-starting States
`define WAIT 0
`define INTIALIZE 1
`define BLACK 2
`define GAMEOVER 3

// Snake-movement states
`define UP0 4
`define UP1 5
`define UP2 6
`define UP3 7
`define UPPAUSE 8

`define DOWN0 9
`define DOWN1 10
`define DOWN2 11
`define DOWN3 12
`define DOWNPAUSE 13

`define LEFT0 14
`define LEFT1 15
`define LEFT2 16
`define LEFT3 17
`define LEFTPAUSE 18

`define RIGHT0 19
`define RIGHT1 20
`define RIGHT2 21
`define RIGHT3 22
`define RIGHTPAUSE 23

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

module StateDisplay(
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

module StateDisplayController(
    input clk,
    input [7:0] curr_state,
    output [3:0] an,
    output [6:0] sseg
);

wire [13:0] sev_seg_data;
wire SSEGClk;

SSEGClkDivider s1 (clk,SSEGClk);

hexto7segment left  (curr_state[7:4],sev_seg_data[13:7]);
hexto7segment right (curr_state[3:0],sev_seg_data[6:0]);

StateDisplay display (SSEGClk,sev_seg_data,an,sseg);

endmodule

module clk_div(
    input main_clk,
    output reg game_clk
);

reg [23:0] count;

initial begin
    count = 0;
    game_clk = 0;
end

always @(posedge main_clk) begin
    if(count == 10000000)
        game_clk = ~game_clk;
    else
        count = count + 1;
end

endmodule

module Snake_SM(
    input main_clk,
    input game_clk, // Should be 5Hz
    input PS2CLK,
    input PS2Data,
    output [6:0] SnakePos0_X,
    output [6:0] SnakePos0_Y,
    output [6:0] SnakePos1_X,
    output [6:0] SnakePos1_Y,
    output [6:0] SnakePos2_X,
    output [6:0] SnakePos2_Y,
    output [6:0] SnakePos3_X,
    output [6:0] SnakePos3_Y,
    output reg AllBlack,
    output [3:0] an,
    output [6:0] sseg
);

wire [7:0] KeyPress;

PS2 keyboard (PS2CLK,PS2Data,KeyPress);

reg [6:0] SnakePos [7:0];

reg [4:0] curr_state;
reg [4:0] next_state;
reg [1:0] curr_tail;
reg [1:0] next_tail;
reg [1:0] curr_head;
reg [1:0] next_head;
 
reg [2:0] index;

StateDisplayController con (main_clk,curr_state,an,sseg);

assign SnakePos0_X = SnakePos[0];
assign SnakePos0_Y = SnakePos[1];
assign SnakePos1_X = SnakePos[2];
assign SnakePos1_Y = SnakePos[3];
assign SnakePos2_X = SnakePos[4];
assign SnakePos2_Y = SnakePos[5];
assign SnakePos3_X = SnakePos[6];
assign SnakePos3_Y = SnakePos[7];

initial begin
    curr_state <= `WAIT;
    curr_head <= 3;
    curr_tail <= 0;
    AllBlack <= 0;
    next_state <= `WAIT;
end

always@(posedge main_clk) begin
    case (curr_state)
        // Game-stopping/Game-starting States
        `WAIT: begin
            if(KeyPress == `ESC) begin
                next_state <= `BLACK;
            end
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else
                    next_state <= `WAIT;
            end
            for(index = 0; index < 4; index = index + 1) begin
                SnakePos[index+index] <= index; // x-coor
                SnakePos[index+index+1] <= 48; // y-coor
            end
        end
        `INTIALIZE: begin
            if(KeyPress == `ESC) begin
                next_state <= `BLACK;
            end
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else
                    next_state <= `RIGHT3;
            end
            for(index = 0; index < 4; index = index + 1) begin
                SnakePos[index+index] <= index; // x-coor
                SnakePos[index+index+1] <= 23; // y-coor
            end
            next_head <= 3;
            next_tail <= 0;
            AllBlack <= 0;
        end
        `BLACK: begin
            if(KeyPress == `START)
                next_state <= `INTIALIZE;
            else
                next_state <= curr_state;
            AllBlack <= 1;
        end
        `GAMEOVER: begin
            if(KeyPress == `ESC) begin
                next_state <= `BLACK;
            end
            else 
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else
                    next_state <= curr_state;
            end
        
        // Snake-movement states
        // Up Direction
        `UP0: begin
            if(KeyPress == `ESC) begin
                next_state <= `BLACK;
            end
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else
                    next_state <= `UP1;
            end
            next_head <= curr_tail; 
            next_tail <= (curr_tail+1) % 4;
            SnakePos[curr_tail+curr_tail] <= SnakePos[curr_head+curr_head];
            SnakePos[curr_tail+curr_tail+1] <= SnakePos[curr_head+curr_head+1] - 1;
        end
        `UP1: begin
            if(KeyPress == `ESC) begin
                next_state <= `BLACK;
            end
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else
                    next_state <= `UP2;
            end
            next_head <= curr_tail; 
            next_tail <= (curr_tail+1) % 4;
            SnakePos[curr_tail+curr_tail] <= SnakePos[curr_head+curr_head];
            SnakePos[curr_tail+curr_tail+1] <= SnakePos[curr_head+curr_head+1] - 1;
        end
        `UP2: begin
            if(KeyPress == `ESC) begin
                next_state <= `BLACK;
            end
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else
                    next_state <= `UP3;
            end
            next_head <= curr_tail; 
            next_tail <= (curr_tail+1) % 4;
            SnakePos[curr_tail+curr_tail] <= SnakePos[curr_head+curr_head];
            SnakePos[curr_tail+curr_tail+1] <= SnakePos[curr_head+curr_head+1] - 1;
        end
        `UP3: begin
            if(KeyPress == `ESC) begin
                next_state <= `BLACK;
            end
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else begin
                    if(KeyPress == `PAUSE)
                        next_state <= `UPPAUSE;
                    else begin
                        if(KeyPress == `LEFT)
                            next_state <= `LEFT0;
                        else begin
                            if(KeyPress == `RIGHT)
                                next_state <= `RIGHT0;
                            else 
                                next_state <= `UP3;
                        end
                    end
                end
            end
            next_head <= curr_tail; 
            next_tail <= (curr_tail+1) % 4;
            SnakePos[curr_tail+curr_tail] <= SnakePos[curr_head+curr_head];
            SnakePos[curr_tail+curr_tail+1] <= SnakePos[curr_head+curr_head+1] - 1;
        end
        `UPPAUSE: begin
            if(KeyPress == `ESC)
                next_state <= `BLACK;
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else begin
                    if(KeyPress == `RESUME)
                        next_state <= `UP3;
                    else
                        next_state <= curr_state;
                end
            end
        end
                    
        // Down direction
        `DOWN0: begin
            if(KeyPress == `ESC) begin
                next_state <= `BLACK;
            end
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else
                    next_state <= `DOWN1;
            end
            next_head <= curr_tail; 
            next_tail <= (curr_tail+1) % 4;
            SnakePos[curr_tail+curr_tail] <= SnakePos[curr_head+curr_head];
            SnakePos[curr_tail+curr_tail+1] <= SnakePos[curr_head+curr_head+1] + 1;
        end
        `DOWN1: begin
            if(KeyPress == `ESC) begin
                next_state <= `BLACK;
            end
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else
                    next_state <= `DOWN2;
            end
            next_head <= curr_tail; 
            next_tail <= (curr_tail+1) % 4;
            SnakePos[curr_tail+curr_tail] <= SnakePos[curr_head+curr_head];
            SnakePos[curr_tail+curr_tail+1] <= SnakePos[curr_head+curr_head+1] + 1;
        end
        `DOWN2: begin
            if(KeyPress == `ESC) begin
                next_state <= `BLACK;
            end
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else
                    next_state <= `DOWN3;
            end
            next_head <= curr_tail; 
            next_tail <= (curr_tail+1) % 4;
            SnakePos[curr_tail+curr_tail] <= SnakePos[curr_head+curr_head];
            SnakePos[curr_tail+curr_tail+1] <= SnakePos[curr_head+curr_head+1] + 1;
        end
        `DOWN3: begin
            if(KeyPress == `ESC) begin
                next_state <= `BLACK;
            end
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else begin
                    if(KeyPress == `PAUSE)
                        next_state <= `DOWNPAUSE;
                    else begin
                        if(KeyPress == `LEFT)
                            next_state <= `LEFT0;
                        else begin
                            if(KeyPress == `RIGHT)
                                next_state <= `RIGHT0;
                            else 
                                next_state <= `DOWN3;
                        end
                    end
                end
            end
            next_head <= curr_tail; 
            next_tail <= (curr_tail+1) % 4;
            SnakePos[curr_tail+curr_tail] <= SnakePos[curr_head+curr_head];
            SnakePos[curr_tail+curr_tail+1] <= SnakePos[curr_head+curr_head+1] + 1;
        end
        `DOWNPAUSE: begin
            if(KeyPress == `ESC)
                next_state <= `BLACK;
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else begin
                    if(KeyPress == `RESUME)
                        next_state <= `DOWN3;
                    else
                        next_state <= curr_state;
                end
            end
        end

        // Right direction
        `RIGHT0: begin
            if(KeyPress == `ESC) begin
                next_state <= `BLACK;
            end
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else
                    next_state <= `RIGHT1;
            end
            next_head <= curr_tail;
            next_tail <= (curr_tail+1) % 4;
            SnakePos[curr_tail+curr_tail] <= SnakePos[curr_head+curr_head] + 1; // x-coor
            SnakePos[curr_tail+curr_tail+1] <= SnakePos[curr_head+curr_head+1]; // y-coor
        end
        `RIGHT1: begin
            if(KeyPress == `ESC) begin
                next_state <= `BLACK;
            end
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else
                    next_state <= `RIGHT2;
            end
            next_head <= curr_tail;
            next_tail <= (curr_tail+1) % 4;
            SnakePos[curr_tail+curr_tail] <= SnakePos[curr_head+curr_head] + 1; // x-coor
            SnakePos[curr_tail+curr_tail+1] <= SnakePos[curr_head+curr_head+1]; // y-coor
        end
        `RIGHT2: begin
            if(KeyPress == `ESC) begin
                next_state <= `BLACK;
            end
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else
                    next_state <= `RIGHT3;
            end
            next_head <= curr_tail;
            next_tail <= (curr_tail+1) % 4;
            SnakePos[curr_tail+curr_tail] <= SnakePos[curr_head+curr_head] + 1; // x-coor
            SnakePos[curr_tail+curr_tail+1] <= SnakePos[curr_head+curr_head+1]; // y-coor
        end
        `RIGHT3: begin
            if(KeyPress == `ESC) begin
                next_state <= `BLACK;
            end
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else begin
                    if(KeyPress == `PAUSE)
                        next_state <= `RIGHTPAUSE;
                    else begin
                        if(KeyPress == `UP)
                            next_state <= `UP0;
                        else begin
                            if(KeyPress == `DOWN)
                                next_state <= `DOWN0;
                            else 
                                next_state <= `RIGHT3;
                        end
                    end
                end
            end
            next_head <= curr_tail;
            next_tail <= (curr_tail+1) % 4;
            SnakePos[curr_tail+curr_tail] <= SnakePos[curr_head+curr_head] + 1; // x-coor
            SnakePos[curr_tail+curr_tail+1] <= SnakePos[curr_head+curr_head+1]; // y-coor
        end
        `RIGHTPAUSE: begin
            if(KeyPress == `ESC)
                next_state <= `BLACK;
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else begin
                    if(KeyPress == `RESUME)
                        next_state <= `RIGHT3;
                    else
                        next_state <= curr_state;
                end
            end
        end

        // Left Direction
        `LEFT0: begin
            if(KeyPress == `ESC) begin
                next_state <= `BLACK;
            end
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else
                    next_state <= `LEFT1;
            end
            next_head <= curr_tail;
            next_tail <= (curr_tail+1) % 4;
            SnakePos[curr_tail+curr_tail] <= SnakePos[curr_head+curr_head] - 1; // x-coor
            SnakePos[curr_tail+curr_tail+1] <= SnakePos[curr_head+curr_head+1]; // y-coor
        end
        `LEFT1: begin
            if(KeyPress == `ESC) begin
                next_state <= `BLACK;
            end
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else
                    next_state <= `LEFT2;
            end
            next_head <= curr_tail;
            next_tail <= (curr_tail+1) % 4;
            SnakePos[curr_tail+curr_tail] <= SnakePos[curr_head+curr_head] - 1; // x-coor
            SnakePos[curr_tail+curr_tail+1] <= SnakePos[curr_head+curr_head+1]; // y-coor
        end
        `LEFT2: begin
            if(KeyPress == `ESC) begin
                next_state <= `BLACK;
            end
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else
                    next_state <= `LEFT3;
            end
            next_head <= curr_tail;
            next_tail <= (curr_tail+1) % 4;
            SnakePos[curr_tail+curr_tail] <= SnakePos[curr_head+curr_head] - 1; // x-coor
            SnakePos[curr_tail+curr_tail+1] <= SnakePos[curr_head+curr_head+1]; // y-coor
        end
        `LEFT3: begin
            if(KeyPress == `ESC) begin
                next_state <= `BLACK;
            end
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else begin
                    if(KeyPress == `PAUSE) 
                        next_state <= `LEFTPAUSE;
                    else begin
                        if(KeyPress == `UP)
                            next_state <= `UP0;
                        else begin
                            if(KeyPress == `DOWN)
                                next_state <= `DOWN0;
                            else 
                                next_state <= `LEFT3;
                        end
                    end
                end
            end
            next_head <= curr_tail;
            next_tail <= (curr_tail+1) % 4;
            SnakePos[curr_tail+curr_tail] <= SnakePos[curr_head+curr_head] + 1; // x-coor
            SnakePos[curr_tail+curr_tail+1] <= SnakePos[curr_head+curr_head+1]; // y-coor
        end
        `LEFTPAUSE: begin
            if(KeyPress == `ESC)
                next_state <= `BLACK;
            else begin
                if(KeyPress == `START)
                    next_state <= `INTIALIZE;
                else begin
                    if(KeyPress == `RESUME)
                        next_state <= `LEFT3;
                    else
                        next_state <= curr_state;
                end
            end
        end

        default: begin
            next_state <= `GAMEOVER;
        end
    endcase
end

always@(posedge game_clk) begin
    curr_state <= next_state;
    curr_head <= next_head;
    curr_tail <= next_tail;
end
endmodule

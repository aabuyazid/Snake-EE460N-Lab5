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
    output reg AllBlack
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
    curr_head <= 0;
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
                                next_state <= `UP0;
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
                                next_state <= `DOWN0;
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
                                next_state <= `RIGHT0;
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
                                next_state <= `RIGHT0;
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

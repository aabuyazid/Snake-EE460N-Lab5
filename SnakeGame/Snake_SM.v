// Keyboard Inputs
`define START 8'h1B
`define ESC 8'h76
`define PAUSE 8'h4d
`define RESUME 8'h2D
`define UP 8'h75
`define DOWN 8'h72
`define RIGHT 8'he0
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

module Snake_SMY(
    input main_clk,
    input game_clk, // Should be 5Hz
    input PS2CLK,
    input PS2Data,
    output [5:0] SnakePos0_X,
    output [5:0] SnakePos0_Y,
    output [5:0] SnakePos1_X,
    output [5:0] SnakePos1_Y,
    output [5:0] SnakePos2_X,
    output [5:0] SnakePos2_Y,
    output [5:0] SnakePos3_X,
    output [5:0] SnakePos3_Y,
    output reg AllBlack
);

reg [5:0] SnakePos [7:0];
reg [4:0] curr_state;
reg [4:0] next_state;

wire [7:0] next_KeyPress;
reg [7:0] KeyPress;

PS2 keyboard (PS2CLK,PS2Data,next_KeyPress);

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

    AllBlack <= 0;
    next_state <= `WAIT;
end

always@(posedge game_clk) begin
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
            SnakePos[0] <= 0; // x-coor
            SnakePos[1] <= 48; // y-coor
            SnakePos[2] <= 1; // x-coor
            SnakePos[3] <= 48; // y-coor
            SnakePos[4] <= 2; // x-coor
            SnakePos[5] <= 48; // y-coor
            SnakePos[6] <= 3; // x-coor
            SnakePos[7] <= 48; // y-coor
        end
        `INTIALIZE: begin
            if(KeyPress == `ESC) begin
                next_state <= `BLACK;
            end
            else
                next_state <= `RIGHT3;
                
            SnakePos[0] <= 0; // x-coor
            SnakePos[1] <= 23; // y-coor
            SnakePos[2] <= 1; // x-coor
            SnakePos[3] <= 23; // y-coor
            SnakePos[4] <= 2; // x-coor
            SnakePos[5] <= 23; // y-coor
            SnakePos[6] <= 3; // x-coor
            SnakePos[7] <= 23; // y-coor

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
            SnakePos[0] <= SnakePos[2];
            SnakePos[1] <= SnakePos[3];
            SnakePos[2] <= SnakePos[4];
            SnakePos[3] <= SnakePos[5];
            SnakePos[4] <= SnakePos[6];
            SnakePos[5] <= SnakePos[7];
            SnakePos[7] <= SnakePos[7]-1;
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
            SnakePos[0] <= SnakePos[2];
            SnakePos[1] <= SnakePos[3];
            SnakePos[2] <= SnakePos[4];
            SnakePos[3] <= SnakePos[5];
            SnakePos[4] <= SnakePos[6];
            SnakePos[5] <= SnakePos[7];
            SnakePos[7] <= SnakePos[7]-1;
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
            SnakePos[0] <= SnakePos[2];
            SnakePos[1] <= SnakePos[3];
            SnakePos[2] <= SnakePos[4];
            SnakePos[3] <= SnakePos[5];
            SnakePos[4] <= SnakePos[6];
            SnakePos[5] <= SnakePos[7];
            SnakePos[7] <= SnakePos[7]-1;
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
            SnakePos[0] <= SnakePos[2];
            SnakePos[1] <= SnakePos[3];
            SnakePos[2] <= SnakePos[4];
            SnakePos[3] <= SnakePos[5];
            SnakePos[4] <= SnakePos[6];
            SnakePos[5] <= SnakePos[7];
            SnakePos[7] <= SnakePos[7]-1;
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
            SnakePos[0] <= SnakePos[2];
            SnakePos[1] <= SnakePos[3];
            SnakePos[2] <= SnakePos[4];
            SnakePos[3] <= SnakePos[5];
            SnakePos[4] <= SnakePos[6];
            SnakePos[5] <= SnakePos[7];
            SnakePos[7] <= SnakePos[7]+1;
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
            SnakePos[0] <= SnakePos[2];
            SnakePos[1] <= SnakePos[3];
            SnakePos[2] <= SnakePos[4];
            SnakePos[3] <= SnakePos[5];
            SnakePos[4] <= SnakePos[6];
            SnakePos[5] <= SnakePos[7];
            SnakePos[7] <= SnakePos[7]+1;
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
            SnakePos[0] <= SnakePos[2];
            SnakePos[1] <= SnakePos[3];
            SnakePos[2] <= SnakePos[4];
            SnakePos[3] <= SnakePos[5];
            SnakePos[4] <= SnakePos[6];
            SnakePos[5] <= SnakePos[7];
            SnakePos[7] <= SnakePos[7]+1;
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
            SnakePos[0] <= SnakePos[2];
            SnakePos[1] <= SnakePos[3];
            SnakePos[2] <= SnakePos[4];
            SnakePos[3] <= SnakePos[5];
            SnakePos[4] <= SnakePos[6];
            SnakePos[5] <= SnakePos[7];
            SnakePos[7] <= SnakePos[7]+1;
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
            SnakePos[0] <= SnakePos[2];
            SnakePos[1] <= SnakePos[3];
            SnakePos[2] <= SnakePos[4];
            SnakePos[3] <= SnakePos[5];
            SnakePos[4] <= SnakePos[6];
            SnakePos[5] <= SnakePos[7];
            SnakePos[6] <= SnakePos[6]+1;
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
            SnakePos[0] <= SnakePos[2];
            SnakePos[1] <= SnakePos[3];
            SnakePos[2] <= SnakePos[4];
            SnakePos[3] <= SnakePos[5];
            SnakePos[4] <= SnakePos[6];
            SnakePos[5] <= SnakePos[7];
            SnakePos[6] <= SnakePos[6]+1;
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
            SnakePos[0] <= SnakePos[2];
            SnakePos[1] <= SnakePos[3];
            SnakePos[2] <= SnakePos[4];
            SnakePos[3] <= SnakePos[5];
            SnakePos[4] <= SnakePos[6];
            SnakePos[5] <= SnakePos[7];
            SnakePos[6] <= SnakePos[6]+1;
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
            SnakePos[0] <= SnakePos[2];
            SnakePos[1] <= SnakePos[3];
            SnakePos[2] <= SnakePos[4];
            SnakePos[3] <= SnakePos[5];
            SnakePos[4] <= SnakePos[6];
            SnakePos[5] <= SnakePos[7];
            SnakePos[6] <= SnakePos[6]+1;
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
            SnakePos[0] <= SnakePos[2];
            SnakePos[1] <= SnakePos[3];
            SnakePos[2] <= SnakePos[4];
            SnakePos[3] <= SnakePos[5];
            SnakePos[4] <= SnakePos[6];
            SnakePos[5] <= SnakePos[7];
            SnakePos[6] <= SnakePos[6]-1;
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
            SnakePos[0] <= SnakePos[2];
            SnakePos[1] <= SnakePos[3];
            SnakePos[2] <= SnakePos[4];
            SnakePos[3] <= SnakePos[5];
            SnakePos[4] <= SnakePos[6];
            SnakePos[5] <= SnakePos[7];
            SnakePos[6] <= SnakePos[6]-1;
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
            SnakePos[0] <= SnakePos[2];
            SnakePos[1] <= SnakePos[3];
            SnakePos[2] <= SnakePos[4];
            SnakePos[3] <= SnakePos[5];
            SnakePos[4] <= SnakePos[6];
            SnakePos[5] <= SnakePos[7];
            SnakePos[6] <= SnakePos[6]-1;
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
            SnakePos[0] <= SnakePos[2];
            SnakePos[1] <= SnakePos[3];
            SnakePos[2] <= SnakePos[4];
            SnakePos[3] <= SnakePos[5];
            SnakePos[4] <= SnakePos[6];
            SnakePos[5] <= SnakePos[7];
            SnakePos[6] <= SnakePos[6]-1;
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
    
    if ( next_KeyPress != KeyPress )
        KeyPress <= next_KeyPress;
    else 
        KeyPress <= 0;
    curr_state <= next_state;
end

endmodule

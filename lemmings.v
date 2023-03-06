// Code for Lemmings Game - Verilog Implementation

module lemmings(
    input clk,input areset,input bump_left,input bump_right,input ground,input dig,
    output walk_left,output walk_right,output aaah,output digging ); 
    
reg [2:0]state,next_state;
reg [10:0]count;//used to store the count of clk cylces while falling
wire dig_l,dig_r,fall_l,fall_r;
parameter LEFT=0,RIGHT=1,DIG_L=2,DIG_R=3,FALL_L=4,FALL_R=5,SPLAT_L=6,SPLAT_R=7;

always @(posedge clk , posedge areset) // Flip flop for state change
    begin
      if(areset) begin
        state <= LEFT;
        end     
    else begin
        state <= next_state;
        end
    end

always@(*) // state transition logic
    begin
    case(state)

        LEFT : begin
            if(ground == 0)begin
                next_state = FALL_L;
            end
            else begin
                if(dig == 1) begin
                    next_state = DIG_L;
                end
                else if(bump_left == 1) begin
                    next_state = RIGHT; end
                else if(bump_left & dig) begin
                    next_state = DIG_L; end
                else begin
                    next_state = LEFT;
                end
            end
        end

        RIGHT : begin
            if(ground == 0)begin
                next_state = FALL_R;
            end
            else begin
                if(dig == 1) begin
                    next_state = DIG_R;
                end
                else if(bump_right == 1) begin
                    next_state = LEFT; end
                else if(bump_right & dig) begin
                    next_state = DIG_R; end
                else begin
                    next_state = RIGHT;
                end
            end
        end


        DIG_L : begin
        if(ground == 0)
            next_state = FALL_L;
        else 
            next_state = DIG_L;
        end

        DIG_R : begin
        if(ground == 0)
            next_state = FALL_R;
        else 
            next_state = DIG_R;
        end

        FALL_L : begin
        if(ground == 0)begin
            next_state = FALL_L;
        end
        else begin
            if(count > 19)
                next_state = SPLAT_L;
            else 
                next_state = LEFT;
            end
        end

        FALL_R : begin
        if(ground == 0)begin
            next_state = FALL_R;
        end
        else begin
            if(count > 19)
                next_state = SPLAT_R;
            else 
                next_state = RIGHT;
            end
        end

        SPLAT_L : next_state = SPLAT_L;
        SPLAT_R : next_state = SPLAT_R;
        
    endcase
    end

always @(posedge clk)  // counter 
    begin
        if(state == FALL_L)
            count <= count + 1 ;
        else if(state == FALL_R) begin
            count <= count + 1;
        end
        else begin
            count <= 0;
        end
    end

//output assign

assign walk_left = (state == LEFT);
assign walk_right= (state == RIGHT);

assign fall_l = (state == FALL_L);
assign fall_r = (state == FALL_R);
assign aaah = fall_l | fall_r;

assign dig_l = (state == DIG_L);
assign dig_r = (state == DIG_R);
assign digging = dig_l | dig_r ;


endmodule






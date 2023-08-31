module traffic_light_controller 
  // parameters determine final value to count for each timer 
#(parameter TIMER_A_FINAL_VALUE = 60, TIMER_B_FINAL_VALUE = 50, FINAL_B_EXTRA_FINAL_VALUE = 10)
(
  input clk, reset_n,
  input sa, sb,
  output GA, RA, YA, GB, RB, YB
  );
  
  //states encoding
  localparam str_A_green       = 3'b000,
             str_A_yellow      = 3'b001,
             str_B_green       = 3'b010,
             str_B_extra_time  = 3'b011,
             str_B_yellow      = 3'b100; 
 
  reg [2:0] state_reg, state_next;
  wire timerA_reset_n, timerB_reset_n, timerB_extra_reset_n;
  wire timerA_tick, timerB_tick, timerB_extra_tick;
  
  //timers instantiation to account for how long each street will be open
  timer #(.FINAL_VALUE(TIMER_A_FINAL_VALUE)) timerA(
    .clk(clk),
    .reset_n(timerA_reset_n),
    .done(timerA_tick)
  );
  
  timer #(.FINAL_VALUE(TIMER_B_FINAL_VALUE)) timerB(
    .clk(clk),
    .reset_n(timerB_reset_n),
    .done(timerB_tick)
  );
  
  timer #(.FINAL_VALUE(FINAL_B_EXTRA_FINAL_VALUE)) timerB_extra(
    .clk(clk),
    .reset_n(timerB_extra_reset_n),
    .done(timerB_extra_tick)
  );

  //state logic
  always@(posedge clk, negedge reset_n)
  begin
    if(~reset_n)
      state_reg <= str_A_green;
    else
      state_reg <= state_next;
  end
  
  
  //next state logic
  always@(*)
  begin
    case(state_reg)
      str_A_green: 
      begin
        if(~sb | ~timerA_tick)
          state_next = str_A_green;
        else 
          state_next = str_A_yellow;
      end
      
      str_A_yellow: 
      begin
        state_next = str_B_green;
      end
      
      str_B_green: 
      begin
        if(~timerB_tick)
          state_next = str_B_green;
        else if (~sa & sb)
          state_next = str_B_extra_time;
        else
          state_next = str_B_yellow;
      end
      
      str_B_extra_time:
        if(~timerB_extra_tick)
          state_next = str_B_extra_time;
        else
          state_next = str_B_yellow;
          
      str_B_yellow: 
        state_next = str_A_green;
        
      default: state_next = state_reg;
    endcase
  end
  
  //timers reset signals
  assign timerA_reset_n =  reset_n & (state_reg == str_A_green);
  assign timerB_reset_n =  reset_n & (state_reg == str_B_green);
  assign timerB_extra_reset_n = reset_n & (state_reg == str_B_extra_time);
  
  
  //output logic
  assign GA = (state_reg == str_A_green); 
  assign YA = (state_reg == str_A_yellow);
  assign RA = (state_reg == str_B_green) | (state_reg == str_B_yellow) | (state_reg == str_B_extra_time);
  
  assign GB = (state_reg == str_B_green) | (state_reg == str_B_extra_time);
  assign YB = (state_reg == str_B_yellow);
  assign RB = (state_reg == str_A_green) | (state_reg == str_A_yellow);

endmodule



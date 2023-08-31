module traffic_light_controller_tb ();

localparam T = 10;  

/*determine tick of each timer from its final value, where
  tick time = FINAL_VALUE*Tclk*/
localparam TIMER_A_FINAL_VALUE = 7,
           TIMER_B_FINAL_VALUE = 5, 
           TIMER_B_EXTRA_FINAL_VALUE = 2;

reg clk, reset_n, sa, sb;
wire GA, RA, YA, GB, RB, YB;

reg [3:0] fail_count;

traffic_light_controller #(.TIMER_A_FINAL_VALUE (TIMER_A_FINAL_VALUE),
                           .TIMER_B_FINAL_VALUE (TIMER_B_FINAL_VALUE),
                           .FINAL_B_EXTRA_FINAL_VALUE(TIMER_B_EXTRA_FINAL_VALUE) ) UUT (
 
  .clk(clk),
  .reset_n (reset_n),
  .sa(sa),
  .sb(sb),
  .GA(GA), .RA(RA), .YA(YA),
  .GB(GB), .RB(RB), .YB(YB)
  );
  

//clock generation with period 10 ns
initial
begin
  clk = 1'b0;
  forever #(T/2) clk = ~clk;
end


initial 
begin
  //initialize fail counter
  fail_count = 0;
  
  reset_n = 1'b0;
  {sa, sb} = 2'b11;
  
  repeat(2) @(negedge clk);
  reset_n =  1'b1;
  
  repeat(TIMER_A_FINAL_VALUE + 1) @(negedge clk);
  if( !(YA&RB)) begin
      $display("Timer A fails");
      fail_count = fail_count + 1;
    end
    else begin
      $display("Timer A passes");
    end

  repeat(TIMER_B_FINAL_VALUE + 2) @(negedge clk);
  if( !(YB&RA)) begin
      $display("Timer B fails");
      fail_count = fail_count + 1;
    end
    else begin
      $display("Timer B passes");
    end

  @(negedge clk)
  {sa, sb} = 2'b01;

  repeat(TIMER_A_FINAL_VALUE + TIMER_B_FINAL_VALUE + TIMER_B_EXTRA_FINAL_VALUE +  4) @(negedge clk);
  if( !(YB&RA)) begin
      $display("Timer B extra time fails");
      fail_count = fail_count + 1;
    end
    else begin
      $display("Timer B extra time passes");
    end
  
  {sa, sb} = 2'b10;

  repeat(TIMER_A_FINAL_VALUE + 3) @(negedge clk)
  if( !(GA&RB)) begin
      $display("Error, opening empty street B");
      fail_count = fail_count + 1;
    end
    
  $stop; 
  
end
  
endmodule 


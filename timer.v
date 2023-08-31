module timer  
#(parameter FINAL_VALUE=10)
(
  input clk, reset_n,
  output done
  );

localparam BITS = $clog2(FINAL_VALUE) + 1;

reg [BITS-1:0] Q;


always@(posedge clk, negedge reset_n)
begin
  if(~reset_n)
    Q <= 0;
  else if (~done)
   Q <= Q + 1;
 else
   Q <= Q;
end


assign done = (Q == FINAL_VALUE);

endmodule


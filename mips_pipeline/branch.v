module branch(a,b,q);
  
  input [31:0] a,b;
  output q;
  reg q;
  
  always @(a,b) begin
    if (a==b)
      q = 1'b1;
    else
      q = 1'b0;
  end
endmodule

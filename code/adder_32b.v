module adder_32b (a , b, cin, sum);
  input [31:0] a, b;
  input cin;
  output [31:0] sum;
  
  assign sum = a + b + cin;
  
endmodule

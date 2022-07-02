module jump (j_in,pcadrs,j_out);
  input [25:0] j_in;
  input [31:0] pcadrs;
  output [31:0] j_out;
  
  wire [27:0] j_mid;
  wire [27:0] j_mid2;
  
  assign j_mid = {{2{j_in[25]}}, j_in};
  assign j_mid2 = j_mid << 2;
  assign j_out = {{pcadrs[31],pcadrs[30],pcadrs[29],pcadrs[28]}, j_mid2};
  
endmodule


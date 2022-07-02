module branch_test;
  
  reg [31:0] a,b;
  wire q;
  
  branch BNCH(a,b,q);
  
  initial begin
    #10 a=32'd10;b=32'd90;
    #100 a=32'd78;b=32'd78;
    #100 a=32'd1001;b=32'd78;
    #100 a=32'd700;b=32'd98;
  end
endmodule

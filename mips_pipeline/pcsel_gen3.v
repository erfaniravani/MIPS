module pcsel_gen3(opcode,flush_flag,selout);
  input [5:0] opcode;
  input flush_flag;
  output selout;
  reg selout;
  
   always @(opcode , flush_flag)
  begin
    if ((opcode == 6'b000110) && flush_flag == 1'b1) begin
      selout = 1'b1;
    end
    else begin
      selout = 1'b0;
    end
  end
endmodule
  





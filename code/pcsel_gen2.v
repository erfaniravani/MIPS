module pcsel_gen2(opcode,flush_flag,selout);
  input [5:0] opcode;
  input flush_flag;
  output selout;
  reg selout;
  
   always @(opcode , flush_flag)
  begin
    if ((opcode == 6'b000010 || opcode == 6'b000011) && flush_flag == 1'b1) begin
      selout = 1'b1;
    end
    else begin
      selout = 1'b0;
    end
  end
endmodule
  



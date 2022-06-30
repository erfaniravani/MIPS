module mipstb;
  
  wire [31:0] inst_adr, inst, data_adr, data_in, data_out;
  wire mem_read, mem_write;
  reg clk, rst;
  
  mips_pipeline CPU(rst, clk, inst_adr, inst, data_adr, data_in, data_out, mem_read, mem_write);
  
  inst_mem IM2 (inst_adr, inst);
  
  data_mem DM2 (data_adr, data_out, mem_read, mem_write, clk, data_in);
  
  
  
  initial
  begin
    rst = 1'b1;
    clk = 1'b0;
    #20 rst = 1'b0;
    #50000 $stop;
  end
  
  always
  begin
    #8 clk = ~clk;
  end
  
endmodule

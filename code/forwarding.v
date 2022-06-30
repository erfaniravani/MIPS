module forwarding(exmem_regwrite,memwb_regwrite,exmem_rd,memwb_rd,idex_rt,idex_rs,src_a,src_b);
  
  input exmem_regwrite,memwb_regwrite;
  input [4:0] exmem_rd,memwb_rd,idex_rt,idex_rs;
  output [1:0] src_a,src_b;
  reg [1:0] src_a,src_b;
  
  always@(posedge exmem_regwrite,memwb_regwrite,exmem_rd,memwb_rd,idex_rt,idex_rs) begin
    {src_a,src_b} = 4'b0;
    if((exmem_regwrite == 1) && (exmem_rd == idex_rs) && (exmem_rd != 5'b0))
      src_a = 2'b01;
    else if((memwb_regwrite == 1) && (memwb_rd == idex_rs) && (memwb_rd != 5'b0) && (src_a != 2'b10))
      src_a = 2'b10;
    if((exmem_regwrite == 1) && (exmem_rd == idex_rt) && (exmem_rd != 5'b0))
      src_b = 2'b01;
    else if((memwb_regwrite == 1) && (memwb_rd == idex_rt) && (memwb_rd != 5'b0) && (src_b != 2'b10))
      src_b = 2'b10;
  end
endmodule


module mips_pipeline(rst,clk,inst_adr, inst, data_adr, data_in, data_out, mem_read, mem_write);
  
  input clk,rst;
  input [31:0] inst,data_in;
  output [31:0] inst_adr,data_adr,data_out;
  output mem_read, mem_write;
  
  wire zero,alusrc,regdst,memwrite,memread,memtoreg,regwrite,exmem_regwrite,memwb_regwrite,
       idex_memread,nop,ifidwrite,pcwrite,ifflush,exmem_regwrite_out,idex_regwrite_out,flush2;
  wire [5:0] func,opcode;
  wire [4:0] exmem_rd,memwb_rd,idex_rt,idex_rs,idex_rd_out,rt,rs;
  wire [1:0] src_a,src_b;
  wire [2:0] aluop;
  
  
  pipe_data_path DP(clk,rst,pcwrite,ifidwrite,ifflush,regwrite,nop,regdst,
                    alusrc,src_a,src_b,aluop,memwrite,memread,memtoreg,inst,data_in,
                    zero,func,opcode,exmem_rd,memwb_rd,idex_rt,idex_rs,exmem_regwrite,
                    memwb_regwrite,rt,rs,idex_memread,inst_adr,data_adr,data_out,
                    mem_write,mem_read,exmem_regwrite_out,idex_rd_out,idex_regwrite_out);
                    
  control CTRL(zero,func,opcode,alusrc,regdst,memwrite,memread,memtoreg,regwrite,flush2,
               ifflush,aluop);
                 
  forwarding FRWD(exmem_regwrite,memwb_regwrite,exmem_rd,memwb_rd,idex_rt,idex_rs,src_a,src_b);
  
  hazard HZD(opcode,exmem_rd,idex_memread,mem_read,exmem_regwrite_out,idex_rt,idex_rd_out,rt,rs,
             idex_regwrite_out,nop,ifidwrite,pcwrite,flush2);
  
endmodule
                 
      

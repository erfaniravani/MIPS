module pipe_data_path(clk,rst,pcwrite,ifidwrite,ifflush,regwrite,nop,regdst,
                alusrc,alu_src_a,alu_src_b,aluop,memwrite,memread,memtoreg,inst,readdata,
                
                branchequal,func,opcode,exmem_rd_out,memwb_rd_out,idex_rt_out,idex_rs_out,exmem_regwrite_out,
                memwb_regwrite_out,rt_out,rs_out,idex_memread_out,inst_ad,mem_ad,mem_write_data,
                datamem_mem_write,datamem_mem_read,exmem_regwrite_out,idex_rd_out,idex_regwrite_out);
  //inputs and outputs              
  input  clk,rst,pcwrite,ifidwrite,ifflush,regwrite,regdst,
         alusrc,memwrite,memread,memtoreg,nop;
  input  [1:0] alu_src_a,alu_src_b;
  input  [2:0] aluop;
  input  [31:0] inst,readdata;
  output branchequal,exmem_regwrite_out,memwb_regwrite_out,idex_memread_out,datamem_mem_write,
         datamem_mem_read,exmem_regwrite_out,idex_regwrite_out;
  output [5:0] func,opcode;
  output [4:0] exmem_rd_out,memwb_rd_out,idex_rt_out,idex_rs_out,idex_rd_out,rt_out,rs_out;
  output [31:0] inst_ad,mem_ad,mem_write_data;
  
  
  //wires
  wire [31:0] pc_in,pc_in2,pc_in3,pc_in4,pc_out,adder1_out,ifid_pc_out,ifid_inst,jump_out;
  wire [31:0] sx,shl,adder2_out,data1,data2;
  wire [31:0] memtoreg_out;
  wire [31:0] idex_data1,idex_data2,idex_sx;
  wire [4:0] idex_rt,idex_rd,idex_rs;
  wire [2:0] idex_aluop;
  wire idex_alusrc,idex_regdst,idex_memwrite,idex_memread,idex_memtoreg,
       idex_regwrite;
  wire [31:0] alu_in1,alu_in2,alu_src_in,alu_result;
  wire [4:0] regdst_out,exmem_r,selj_out;
  wire [31:0] exmem_result,exmem_data;
  wire exmem_memwrite,exmem_memread,exmem_memtoreg,exmem_regwrite;
  wire memwb_memtoreg,memwb_regwrite;
  wire [31:0] memwb_data,memwb_result;
  wire [4:0] memwb_reg;
  wire [2:0] mux_aluop;
  wire jrselect,jumpselect,beqselect,mux_ifflush,mux_alusrc,mux_regdst,mux_memwrite,
       mux_memread,mux_memtoreg,mux_regwrite;
  
  
  reg_32b PC(pc_in,rst,pcwrite,clk,pc_out);
  
  adder_32b ADDER1(pc_out,32'd4,1'b0,adder1_out);
  
  ifid IF_ID(inst,adder1_out,clk,rst,ifidwrite,mux_ifflush,ifid_pc_out,ifid_inst);
    
  jump JUMP(ifid_inst[25:0],pc_out,jump_out);
  
  sign_ext SIGN_EXTEND(ifid_inst[15:0],sx);
  
  shl2 SHIFT_LEFT(sx,shl);

  adder_32b ADDER2(ifid_pc_out,shl,1'b0,adder2_out);
  
  //mux4to1_32b MUX_PC(adder1_out,adder1_out,adder1_out,adder1_out,exmem_pcsrc,pc_in4);
  
  pcsel_gen BEQADDRESS(ifid_inst[31:26],mux_ifflush,beqselect);
  
  pcsel_gen2 JUMPADDRESS(ifid_inst[31:26],mux_ifflush,jumpselect);
  
  pcsel_gen3 JRADDRESS(ifid_inst[31:26],mux_ifflush,jrselect);
  
  mux2to1_32b MUX_BEQADDRESS(adder1_out,adder2_out,beqselect,pc_in3);
  
  mux2to1_32b MUX_JUMPADDRESS(pc_in3,jump_out,jumpselect,pc_in2);
  
  mux2to1_32b MUX_JRADDRESS(pc_in2,data1,jrselect,pc_in);
  
  //mux2to1_32b MUX_SELRF(memtoreg_out,adder1_out,memwb_selrf,selrf_out);
  
  reg_file RF(memtoreg_out,ifid_inst[25:21],ifid_inst[20:16],memwb_reg,memwb_regwrite,rst,clk,
              data1,data2);
              
  branch BRNCH(data1,data2,branchequal);
  
  mux2to1_10b MUXNOP(10'b0,{ifflush,aluop,alusrc,regdst,memwrite,memread,memtoreg,regwrite},
                     nop,{mux_ifflush,mux_aluop,mux_alusrc,mux_regdst,mux_memwrite,mux_memread,mux_memtoreg,mux_regwrite});
  
  idex ID_EX(mux_aluop,mux_alusrc,mux_regdst,mux_memwrite,mux_memread,mux_memtoreg,mux_regwrite,data1,data2,sx,
             ifid_inst[20:16],ifid_inst[15:11],ifid_inst[25:21],clk,rst,1'b1,idex_aluop,
             idex_alusrc,idex_regdst,idex_memwrite,idex_memread,idex_memtoreg,
             idex_regwrite,idex_data1,idex_data2,idex_sx,idex_rt,idex_rd,idex_rs);
             
  mux3to1_32b MUX_ALU_A(idex_data1,exmem_result,memtoreg_out,alu_src_a,alu_in1);
  
  mux3to1_32b MUX_ALU_B(idex_data2,exmem_result,memtoreg_out,alu_src_b,alu_src_in);
  
  mux2to1_32b MUX_ALUSRC(alu_src_in,idex_sx,idex_alusrc,alu_in2);
  
  mux2to1_5b MUX_REGDST(idex_rt,idex_rd,idex_regdst,regdst_out);
  
  //mux2to1_5b MUX_SELJ(regdst_out,5'd31,idex_selj,selj_out);
  
  alu ALU(alu_in1,alu_in2,idex_aluop,alu_result,zero);
  
  exmem EX_MEM(idex_memwrite,idex_memread,idex_memtoreg,idex_regwrite,
               alu_result,alu_src_in,regdst_out,clk,rst,1'b1,exmem_memwrite,exmem_memread,
               exmem_memtoreg,exmem_regwrite,exmem_result,exmem_data,exmem_r);
              
  memwb MEM_WB(exmem_memtoreg,exmem_regwrite,readdata,exmem_result,exmem_r,clk,rst,1'b1,
               memwb_memtoreg,memwb_regwrite,memwb_data,memwb_result,memwb_reg);
  
  mux2to1_32b MUX_MEMTOREG(memwb_result,memwb_data,memwb_memtoreg,memtoreg_out);
  
  assign func = ifid_inst[5:0];
  assign opcode = ifid_inst[31:26];
  assign exmem_regwrite_out = exmem_regwrite;
  assign memwb_regwrite_out = memwb_regwrite;
  assign exmem_rd_out = exmem_r;
  assign memwb_rd_out = memwb_reg;
  assign idex_rt_out = idex_rt;
  assign idex_rs_out = idex_rs;
  assign idex_rd_out = idex_rd;
  assign idex_memread_out = idex_memread;
  assign rt_out = ifid_inst[20:16];
  assign rs_out = ifid_inst[25:21];
  assign inst_ad = pc_out;
  assign mem_ad = exmem_result;
  assign mem_write_data = exmem_data;
  assign datamem_mem_write = exmem_memwrite;
  assign datamem_mem_read = exmem_memread;
  assign exmem_regwrite_out = exmem_regwrite;
  assign idex_regwrite_out = idex_regwrite;
endmodule
  
  
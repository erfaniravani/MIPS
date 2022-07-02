module datapath ( clk, rst, adrs, read_data, write_data,
                  IorD, IRwrite, ND1, ND2,
                  reg_dst, mem_to_reg, alu_src_A, alu_src_B, alu_ctrl, reg_write,
                  pc_src, pc_ld, zero,IRo
                 );
  input  clk, rst;
  output [31:0] adrs, write_data,IRo;
  input  [31:0] read_data;
  input  IorD, IRwrite, ND1, ND2, reg_dst, mem_to_reg, alu_src_A, reg_write, pc_ld ;
  input  [1:0] alu_src_B, pc_src;
  input  [2:0] alu_ctrl;
  output zero;
//  reg zero;

  wire [31:0] pc_out,pc_src_out;
  wire [31:0] IorD_out,IR_out;
  wire [31:0] MDR_out;
  wire [31:0] sgn_ext_out;
  wire [31:0] mem_to_reg_out, ND2_out;
  wire [31:0] alu_out;
  wire [31:0] A_out, B_out;
  wire [31:0] shl2_out;
  wire [31:0] alu_src_A_out;
  wire [31:0] alu_src_B_out;
  wire [31:0] alu_reg_out;
  wire [31:0] j_address;
  wire [31:0] read1,read2;
  wire [4:0]  reg_dst_out, ND1_out;
  

  reg_32b PC(pc_src_out, rst, pc_ld, clk, pc_out);
  
  mux2to1_32b MUX_IorD(pc_out, alu_reg_out, IorD, IorD_out);
  
  reg_32b IR(read_data, rst, IRwrite, clk, IR_out);
  
  reg_32b MDR(read_data, rst, 1'b1, clk, MDR_out);
  
  mux2to1_5b MUX_reg_dst(IR_out[20:16], IR_out[15:11], reg_dst, reg_dst_out);
  
  mux2to1_5b MUX_ND1(reg_dst_out, 5'b11111, ND1, ND1_out);
  
  mux2to1_32b MUX_mem_to_reg(alu_reg_out, MDR_out, mem_to_reg, mem_to_reg_out);
  
  mux2to1_32b MUX_ND2(mem_to_reg_out, pc_out, ND2, ND2_out);
  
  reg_file  RF(ND2_out, IR_out[25:21], IR_out[20:16], ND1_out, reg_write, rst, clk, read1, read2);
  
  reg_32b A(read1, rst, 1'b1, clk, A_out);
  
  reg_32b B(read2, rst, 1'b1, clk, B_out);
  
  mux2to1_32b MUX_A(pc_out, A_out, alu_src_A, alu_src_A_out);
  
  sign_ext SGN_EXT(IR_out[15:0], sgn_ext_out);
  
  shl2 SHIFT_LEFT_2b(sgn_ext_out, shl2_out);
  
  mux4to1_32b MUX_B(B_out, 32'd4, sgn_ext_out, shl2_out, alu_src_B, alu_src_B_out);
  
  alu ALU(alu_src_B_out, alu_src_A_out, alu_ctrl, alu_out, zero);
  
  reg_32b ALU_out_reg(alu_out, rst, 1'b1, clk, alu_reg_out);
  
  jump J_ADRS(IR_out[25:0], pc_out, j_address);
  
  mux4to1_32b MUX_pcsrc(alu_out, j_address, alu_reg_out, A_out, pc_src, pc_src_out);
  
  
//  assign inst_adr = pc_out;
 // assign data_adr = alu_out;
  //assign data_out = read_data2;
  assign adrs = IorD_out;
  assign write_data = B_out;
  assign IRo = IR_out;
endmodule

module mips_multi_cycle (rst, clk, adrs, data_in, data_out, mem_read, mem_write,done);
  input rst, clk;
  output [31:0] adrs;
  input  [31:0] data_in;
  output [31:0] data_out;
  output mem_read, mem_write,done;
  
  wire IorD,IRwrite,ND1,ND2,reg_dst,mem_to_reg, alu_src_A,pc_ld, zero;
  wire [1:0] alu_src_B, pc_src;
  wire [2:0] alu_cntrl;
  wire [31:0] IRo;
  
  
  datapath DP( clk, rst, adrs, data_in, data_out,
                  IorD, IRwrite, ND1, ND2,
                  reg_dst, mem_to_reg, alu_src_A, alu_src_B, alu_cntrl, reg_write,
                  pc_src, pc_ld, zero,IRo
                 );
                 
  controller CU( IRo[31:26], IRo[5:0], zero, 
                    IorD, IRwrite, ND1, ND2,
                    reg_dst, mem_to_reg, alu_src_A, alu_src_B, alu_cntrl, reg_write, 
                    pc_src, pc_ld, mem_read, mem_write,clk,rst,done
                  );
  
endmodule

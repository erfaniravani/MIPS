module idex(aluop,alusrc,regdst,memwrite,memread,memtoreg,regwrite,data1,data2,
            sx,rt,rd,rs,clk,rst,idex_ld,aluop_out,alusrc_out,regdst_out,memwrite_out,
            memread_out,memtoreg_out,regwrite_out,data1_out,data2_out,sx_out,
            rt_out,rd_out,rs_out);
  
  input clk,rst,idex_ld,alusrc,regdst,memwrite,memread,memtoreg,regwrite;
  input [31:0] data1,data2,sx;
  input [2:0] aluop;
  input [4:0] rt,rd,rs;
  output [31:0] data1_out,data2_out,sx_out;
  output [2:0] aluop_out;
  output [4:0] rt_out,rd_out,rs_out;
  output alusrc_out,regdst_out,memwrite_out,memread_out,memtoreg_out,regwrite_out;
  reg [31:0] data1_out,data2_out,sx_out;
  reg [2:0] aluop_out;
  reg [4:0] rt_out,rd_out,rs_out;
  reg alusrc_out,regdst_out,memwrite_out,memread_out,memtoreg_out,regwrite_out;
  
  always @(posedge clk,posedge rst)
  begin
    if (rst == 1'b1) begin
      data1_out = 32'b0;
      data2_out = 32'b0;
      sx_out = 32'b0;
      aluop_out = 3'b0;
      rt_out = 5'b0;
      rs_out = 5'b0;
      rd_out = 5'b0;
      {alusrc_out,regdst_out,memwrite_out,memread_out,memtoreg_out,
      regwrite_out} = 6'b0;
    end
    else if (idex_ld == 1'b1) begin
      data1_out = data1;
      data2_out = data2;
      sx_out = sx;
      aluop_out = aluop;
      rt_out = rt;
      rs_out = rs;
      rd_out = rd;
      alusrc_out = alusrc;
      regdst_out = regdst;
      memwrite_out = memwrite;
      memread_out = memread;
      memtoreg_out = memtoreg;
      regwrite_out = regwrite;

    end
  end  
endmodule

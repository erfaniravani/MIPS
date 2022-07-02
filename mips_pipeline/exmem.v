module exmem(memwrite,memread,memtoreg,regwrite,result,data,r,clk,
            rst,exmem_ld,memwrite_out,memread_out,
            memtoreg_out,regwrite_out,result_out,data_out,r_out);
  
  input memwrite,memread,memtoreg,regwrite,clk,rst,exmem_ld;
  input [31:0] result,data;
  input [4:0] r;
  output [31:0] result_out,data_out;
  output [4:0] r_out;
  output memwrite_out,memread_out,memtoreg_out,regwrite_out;
  reg [31:0] result_out,data_out;
  reg [4:0] r_out;
  reg memwrite_out,memread_out,memtoreg_out,regwrite_out;
  
  always @(posedge clk,posedge rst)
  begin
    if (rst == 1'b1) begin
      result_out = 32'b0;
      data_out = 32'b0;
      r_out = 5'b0;
      {memwrite_out,memread_out,memtoreg_out,regwrite_out} = 4'b0;
    end
    else if (exmem_ld == 1'b1) begin
      result_out = result;
      data_out = data;
      r_out = r;
      memwrite_out = memwrite;
      memread_out = memread;
      memtoreg_out = memtoreg;
      regwrite_out = regwrite;
    end
  end
  
endmodule



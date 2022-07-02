module memwb(memtoreg,regwrite,mem_data,alu_result,r,clk,
            rst,memwb_ld,memtoreg_out,regwrite_out,mem_data_out,alu_result_out,r_out);
  
  input memtoreg,regwrite,clk,rst,memwb_ld;
  input [31:0] mem_data,alu_result;
  input [4:0] r;
  output [31:0] mem_data_out,alu_result_out;
  output memtoreg_out,regwrite_out;
  output [4:0] r_out;
  reg [31:0] mem_data_out,alu_result_out;
  reg memtoreg_out,regwrite_out;
  reg [4:0] r_out;
  
  always @(posedge clk,posedge rst)
  begin
    if (rst == 1'b1) begin
      mem_data_out = 32'b0;
      alu_result_out = 32'b0;
      r_out = 5'b0;
      {memtoreg_out,regwrite_out} = 2'b0;
    end
    else if (memwb_ld == 1'b1) begin
      mem_data_out = mem_data;
      alu_result_out = alu_result;
      r_out = r;
      memtoreg_out = memtoreg;
      regwrite_out = regwrite;
    end
  end
  
endmodule




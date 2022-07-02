module ifid(inst,nextaddress,clk,rst,ifid_ld,flush,pc_out,inst_out);
  
  input clk,rst,ifid_ld,flush;
  input [31:0] inst,nextaddress;
  output [31:0] pc_out,inst_out;
  reg [31:0] pc_out,inst_out;
  
  always @(posedge clk,posedge rst)
  begin
    if (rst == 1'b1) begin
      pc_out = 32'b0;
      inst_out = 32'b0;
    end
    else if (flush == 1'b1) begin
      pc_out = 32'b0;
      inst_out = 32'b0; 
    end
    else if (ifid_ld == 1'b1) begin
      pc_out = nextaddress;
      inst_out = inst;
    end
    else begin
      pc_out = pc_out;
      inst_out = inst_out;  
    end
  end
  
endmodule

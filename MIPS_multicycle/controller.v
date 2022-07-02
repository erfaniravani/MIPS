`define   S0      4'b0000
`define   S1      4'b0001
`define   S2      4'b0010
`define   S3      4'b0011
`define   S4      4'b0100
`define   S5      4'b0101
`define   S6      4'b0110
`define   S7      4'b0111
`define   S8      4'b1000
`define   S9      4'b1001
`define   S10     4'b1010
`define   S11     4'b1011
`define   S12     4'b1100
`define   S13     4'b1101
`define   S14     4'b1110
`define   S15     4'b1111

module controller ( opcode, func, zero, 
                    IorD, IRwrite, ND1, ND2,
                    reg_dst, mem_to_reg, alu_src_A, alu_src_B, operation, reg_write, 
                    pc_src, pc_ld, mem_read, mem_write,clk,rst,done
                  );
                    
    input [5:0] opcode;
    input [5:0] func;
    input zero,clk,rst;
    output  IorD, IRwrite, ND1, ND2, reg_dst, mem_to_reg, alu_src_A, reg_write,
            pc_ld, mem_read, mem_write,done;
    reg     IorD, IRwrite, ND1, ND2, reg_dst, mem_to_reg, alu_src_A, reg_write,
            pc_ld, mem_read, mem_write,done;
    output [2:0] operation;
    output [1:0] pc_src,alu_src_B;
            
    reg [1:0] alu_op,pc_src,alu_src_B;     
    reg pcwrite, pcwrite_cond;   
    
    alu_controller ALU_CTRL(alu_op, func, operation);
    
    reg [3:0] ps,ns;
    // Sequential part 
    always @(posedge clk)
    if (rst)
      ps <= 4'b0000;
    else
      ps <= ns;
      
    always @(ps or opcode)
    begin  
    case (ps)
    `S0:  ns = `S1 ;
    `S1:   begin
           case(opcode)
           6'b000000 : ns = `S6; //Rt
           6'b100011 : ns = `S2; //lw
           6'b101011 : ns = `S2; //sw
           6'b000100 : ns = `S8; //beq
           6'b000010 : ns = `S9; //J
           6'b001001 : ns = `S10; //addi 
           6'b001010 : ns = `S12; //slti
           6'b000110 : ns = `S14; //jr
           6'b000011 : ns = `S15; //jal
           endcase
           end
    `S2:  begin
          case(opcode)
          6'b100011 : ns = `S3; //LW
          6'b101011 : ns = `S5; //SW
          endcase
          end
    `S3:  ns = `S4;
    `S4:  ns = `S0;
    `S5:  ns = `S0;
    `S6:  ns = `S7;
    `S7:  ns = `S0;
    `S8:  ns = `S0;
    `S9:  ns = `S0;
    `S10: ns = `S11;
    `S11: ns = `S0;
    `S12: ns = `S13;
    `S13: ns = `S0;
    `S14: ns = `S0;
    `S15: ns = `S0;
    endcase
  end
  
   always @(ps)
    begin
    {pcwrite,pcwrite_cond,done,IorD, IRwrite, ND1, ND2, reg_dst, mem_to_reg, alu_src_A, reg_write, mem_read,
     mem_write, alu_op, pc_src, alu_src_B} = 19'd0;
    case (ps)
      `S0: {mem_read,IRwrite,pcwrite,alu_src_B} = 5'b11101;
      `S1: {alu_src_B} = 2'b11;
      `S2: {alu_src_A,alu_src_B} = 3'b110;
      `S3: {mem_read,IorD} = 2'b11;
      `S4: {done,reg_write,mem_to_reg} = 3'b111;
      `S5: {done,mem_write,IorD} = 3'b111;
      `S6: {alu_src_A,alu_op} = 3'b110;
      `S7: {done,reg_dst,reg_write} = 3'b111;
      `S8: {done,alu_src_A,pcwrite_cond,pc_src,alu_op} = 7'b1111001;
      `S9: {done,pcwrite,pc_src} = 4'b1101;
      `S10: {alu_src_A,alu_src_B} = 3'b110;
      `S11: {done,reg_write} = 2'b11;
      `S12: {alu_src_A,alu_src_B,alu_op} = 5'b11011;
      `S13: {done,reg_write} = 2'b11;
      `S14: {done,pcwrite,pc_src} = 4'b1111;
      `S15: {done,ND1,ND2,pcwrite,reg_write,pc_src} = 7'b1111101;
    endcase
  end
    always @(pcwrite,pcwrite_cond,zero) begin
        pc_ld = pcwrite || ( pcwrite_cond && zero );
    end

endmodule

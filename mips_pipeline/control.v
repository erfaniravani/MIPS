module control(branchequal,func,opcode,alusrc,regdst,memwrite,memread,memtoreg,regwrite,flush2,
               ifflush,aluop);

  input branchequal,flush2;
  input [5:0] func,opcode;
  output alusrc,regdst,memwrite,memread,memtoreg,regwrite;
  output [2:0] aluop;
  output ifflush;
  reg alusrc,regdst,memwrite,memread,memtoreg,regwrite,ifflush;
  
  reg [1:0] operation;
  
  alu_control ALU_CTRL(operation,func,aluop);
  
  always @(opcode,branchequal,flush2)
    begin
      {alusrc,regdst,memwrite,memread,memtoreg,regwrite,ifflush,operation} = 10'd0;
      case (opcode)
        // RType instructions
        6'b000000 : {regdst, regwrite, operation} = 4'b1110;   
        // Load Word (lw) instruction           
        6'b100011 : {alusrc, memtoreg, regwrite, memread} = 4'b1111; 
        // Store Word (sw) instruction
        6'b101011 : {alusrc, memwrite} = 2'b11; 
        // Branch on equal (beq) instruction
        6'b000100 : begin
                    ifflush = (branchequal) ? 1'b1 : 1'b0;
                    //ifflush = (branchequal==1'b1 && flush2==1'b0) ? 1'b1 : 1'b0;
                    end
        // Add immediate (addi) instruction
        6'b001001: {regwrite, alusrc} = 2'b11;
        // jump to an address (j) instruction
        6'b000010: {ifflush} = 1'b1;
        // jump to an address in a register (jr) instruction
        6'b000110: {ifflush} = 1'b1;               
        // slt immediate (slti) instruction
        6'b001010: {regwrite, alusrc, operation} = 4'b1111;
        // jump to an address and save pc+4 in R31 (jal) instruction
        //6'b000011: {regwrite,ifflush,selrf,selj,pcsrc} = 6'b111110;
      endcase
    end
    
  
endmodule
  
  
  
  

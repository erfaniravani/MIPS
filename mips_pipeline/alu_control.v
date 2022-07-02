module alu_control(operation,func,aluop);

  input [5:0] func;
  input [1:0] operation;
  output [2:0] aluop;
  reg [2:0] aluop;
  
  always @(operation, func)
  begin
    aluop = 3'b000;
    if (operation == 2'b00)        // lw or sw
      aluop = 3'b010;
    else if (operation == 2'b01)   // beq
      aluop = 3'b110;
    else if (operation == 2'b11)   // slti
      aluop = 3'b111;
    else
      begin
        case (func)
          6'b100000: aluop = 3'b010;  // add
          6'b100011: aluop = 3'b110;  // sub
          6'b100100: aluop = 3'b000;  // and
          6'b100101: aluop = 3'b001;  // or
          6'b101010: aluop = 3'b111;  // slt
          default:   aluop = 3'b000;
        endcase
      end
        
  end
endmodule
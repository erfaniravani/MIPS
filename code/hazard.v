module hazard(opcode,exmem_rd,idex_memread,exmem_memread,exmem_regwrite,idex_rt,idex_rd,rt,rs,idex_regwrite,
              nop,ifidwrite,pcwrite,flush2);
  
  input [5:0] opcode;
  input idex_memread,idex_regwrite,exmem_memread,exmem_regwrite;
  input [4:0] idex_rt,idex_rd,rt,rs,exmem_rd;
  output nop,ifidwrite,pcwrite,flush2;
  reg nop,ifidwrite,pcwrite,flush2;
  
  always@(opcode,idex_memread,exmem_memread,exmem_regwrite,idex_rt,idex_rd,rt,rs,exmem_rd)begin
    {nop,ifidwrite,pcwrite,flush2} = 4'b1110;
    if (opcode == 6'b000100) begin
        if (rt == exmem_rd || rt == idex_rd || rs == exmem_rd || rs == idex_rd || rs == idex_rt || rt == idex_rt) begin
            if (exmem_memread || idex_memread || exmem_regwrite || idex_regwrite) begin
                pcwrite = 0;
                ifidwrite = 0;
                nop = 0;
                flush2 = 1;
            end
        end
    end
    
    if (opcode == 6'b000110) begin
        if (rt == exmem_rd || rt == idex_rd || rs == exmem_rd || rs == idex_rd || rs == idex_rt || rt == idex_rt) begin
            if (exmem_memread || idex_memread || exmem_regwrite || idex_regwrite) begin
                pcwrite = 0;
                ifidwrite = 0;
                nop = 0;
                flush2 = 1;
            end
        end
    end

    if (idex_rt == rs) begin
        if (idex_memread) begin
            pcwrite = 0;
            ifidwrite = 0;
            nop = 0;
            flush2 = 1;
        end
    end
    if (idex_rt == rt) begin
        if (idex_memread) begin
            pcwrite = 0;
            ifidwrite = 0;
            nop = 0;
            flush2 =1;
        end
    end
end
endmodule

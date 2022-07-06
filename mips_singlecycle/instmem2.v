module instmem2 (adr, d_out);
  input [31:0] adr;
  output [31:0] d_out;
  
  reg [7:0] mem[0:65535];
  
  initial
  begin
    //         lw     R1,1000(R0)            A[0]                                       0
    //         addi   R2,  R0, 0             index of A[0]                              4 
    //         addi   R3,  R0, 0             loop variable                              8
    //         addi   R15, R0,80             indicating end memory index                12
    // Loop:   beq    R3,  R15, END          checking if the loop is over               16
    //         addi   R3,  R3,4              update loop variable                       20
    //         lw     R10,1000(R3)           A[i+1]                                     24
    //         slt    R4,R10,R1              checking if its least item                 28
    //         beq    R4,R0,LOOP             back to loop if it is not least item       32
    //         add    R1, R10, R0            update the least item                      36
    //         addi   R2, R3, 0              update the index of least item             40
    //         beq    R0,R0, LOOP            get back too loop                          44
    // END:    sw     R1, 2000(R0)           save the least item                        48
    //         addi   R11,R0,4               a pointer for 2004 memory                  52
    //         sw     R10, 2000(R11)         save the index of least                    56
    
    {mem[3], mem[2], mem[1], mem[0]}     = {6'h23, 5'd0, 5'd1, 16'd1000};   //0
    {mem[7], mem[6], mem[5], mem[4]}     = {6'h09, 5'd0, 5'd2, 16'd0};      //4         
    {mem[11], mem[10], mem[9], mem[8]}   = {6'h09, 5'd0, 5'd3, 16'd0};      //8
    {mem[15], mem[14], mem[13], mem[12]} = {6'h09, 5'd0, 5'd12, 16'd0};
    {mem[19], mem[18], mem[17], mem[16]} = {6'h09, 5'd0, 5'd15, 16'd80};    //12      
    {mem[23], mem[22], mem[21], mem[20]} = {6'h04, 5'd3, 5'd15, 16'd8};     //16
    {mem[27], mem[26], mem[25], mem[24]} ={6'h09, 5'd12, 5'd12, 16'd1};
    {mem[31], mem[30], mem[29], mem[28]}  = {6'h09, 5'd3, 5'd3, 16'd4};      //20        
    {mem[35], mem[34], mem[33], mem[32]} = {6'h23, 5'd3, 5'd10, 16'd1000};  //24             
    {mem[39], mem[38], mem[37], mem[36]} = {6'h00, 5'd10, 5'd1, 5'd4, 5'd0,6'b101010};    //28       
    {mem[43], mem[42], mem[41], mem[40]} = {6'h04, 5'd4, 5'd0, -16'd6};                      //32    
    {mem[47], mem[46], mem[45], mem[44]} = {6'h00, 5'd10, 5'd0, 5'd1, 5'd0, 6'h20};          //36
    {mem[51], mem[50], mem[49], mem[48]} = {6'h09, 5'd12, 5'd2, 16'd0};                       //40            
    {mem[55], mem[54], mem[53], mem[52]} = {6'h04, 5'd0, 5'd0, -16'd9};                      //44
    {mem[59], mem[58], mem[57], mem[56]} = {6'h2B, 5'd0, 5'd1, 16'd2000};                    //48
    {mem[63], mem[62], mem[61], mem[60]} = {6'h09, 5'd0, 5'd11, 16'd4};                      //52
    {mem[67], mem[66], mem[65], mem[64]} = {6'h2B, 5'd11, 5'd2, 16'd2000};                  //56
    //$readmemb("meminstb.txt",mem,0);
    
  end
  
  assign d_out = {mem[adr[15:0]+3], mem[adr[15:0]+2], mem[adr[15:0]+1], mem[adr[15:0]]};
  
endmodule
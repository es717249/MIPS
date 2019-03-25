module VirtualMemory_unit
#(
    parameter ADDR_WIDTH=32
)
(
    input [ADDR_WIDTH-1:0]  address,
    output [ADDR_WIDTH-1:0] translated_addr,
    output [ADDR_WIDTH-1:0] MIPS_address,
    output aligment_error   //1= aligment error , 0 = correct address
);

wire [ADDR_WIDTH-1:0]  add_tmp;
/* Check if the address is aligned */
assign aligment_error = (address & 3)==0 ? 1'd0 : 1'd1 ;

/* divide by 4  */
assign add_tmp = address & 32'hFFBFFFFF;
assign translated_addr = (add_tmp >> 2) ;  
//assign MIPS_address = add_tmp + 32'h400000;
assign MIPS_address = add_tmp + 32'h3FFFFC;


endmodule
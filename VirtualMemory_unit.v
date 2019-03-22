module VirtualMemory_unit
#(
    parameter ADDR_WIDTH=32
)
(
    input [ADDR_WIDTH-1:0]  address,
    output [ADDR_WIDTH-1:0] translated_addr,
    output aligment_error   //1= aligment error , 0 = correct address
);

/* Check if the address is aligned */
assign aligment_error = (address & 3)==0 ? 0 : 1 ;

/* divide by 4  */
assign translated_addr = address >> 2;  


endmodule
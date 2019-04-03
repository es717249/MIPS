module VirtualAddress_RAM
#(
    parameter ADDR_WIDTH=32
)(
    input [ADDR_WIDTH-1:0]  address,
    output [ADDR_WIDTH-1:0] translated_addr,
    output [ADDR_WIDTH-1:0] MIPS_address,
    output aligment_error   //1= aligment error , 0 = correct address    
);

wire [ADDR_WIDTH-1:0]  add_tmp;

assign aligment_error = (address & 3)==0 ? 1'd0 : 1'd1 ;



assign add_tmp = address - 32'h10010000;
//assign add_tmp = address - 32'h10004000;
assign translated_addr = (add_tmp >> 2) + 192;
//assign translated_addr = add_tmp ;


assign MIPS_address = add_tmp + 32'h10010000;
//assign MIPS_address = add_tmp + 32'h10004000;



endmodule
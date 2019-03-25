module Shift_Concatenate
(
    input   [25:0] J_address,
    input   [3:0]  PC_add,
    output  [31:0] new_jumpAddr
);

assign new_jumpAddr[0] =1'b0;
assign new_jumpAddr[1] =1'b0;

assign new_jumpAddr[31:28] = PC_add; 
assign new_jumpAddr[27:2] = J_address;

endmodule
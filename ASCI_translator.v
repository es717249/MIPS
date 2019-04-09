module ASCI_translator #(
    parameter Nbits = 8
)
(
    input [Nbits-1:0] Data_in,
    output [Nbits-1:0] Data_out
);

reg [Nbits-1:0] Data_out_reg;

/*  48d: 0 
    49d: 1
    50d: 2
    51d: 3
    52d: 4
    53d: 5
    57d: 9
*/

assign Data_out = Data_out_reg;

always@(Data_in)begin
    case(Data_in)
        8'd48:
            Data_out_reg <= 8'd0; 
        8'd49:
            Data_out_reg <= 8'd1; 
        8'd50:
            Data_out_reg <= 8'd2; 
        8'd51:
            Data_out_reg <= 8'd3; 
        8'd52:
            Data_out_reg <= 8'd4; 
        8'd53:
            Data_out_reg <= 8'd5; 
        8'd54:
            Data_out_reg <= 8'd6; 
        8'd55:
            Data_out_reg <= 8'd7; 
        8'd56:
            Data_out_reg <= 8'd8; 
        8'd57:
            Data_out_reg <= 8'd9; 
        default:
            Data_out_reg <= 8'd0; 
    endcase 
end


endmodule
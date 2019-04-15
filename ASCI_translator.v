module ASCI_translator #(
    parameter Nbits = 8
)
(
    input [Nbits-1:0] Data_in_Rx,
    output [Nbits-1:0] Data_out_Rx,
    input [Nbits-1:0] Data_in_Tx,
    output [Nbits-1:0] Data_out_Tx
);

reg [Nbits-1:0] Data_out_Rx_reg;
reg [Nbits-1:0] Data_out_Tx_reg;

/*  48d: 0 
    49d: 1
    50d: 2
    51d: 3
    52d: 4
    53d: 5
    57d: 9
*/

assign Data_out_Rx = Data_out_Rx_reg;
assign Data_out_Tx = Data_out_Tx_reg;

always@(Data_in_Rx)begin
    case(Data_in_Rx)
        8'd48:
            Data_out_Rx_reg <= 8'd0; 
        8'd49:
            Data_out_Rx_reg <= 8'd1; 
        8'd50:
            Data_out_Rx_reg <= 8'd2; 
        8'd51:
            Data_out_Rx_reg <= 8'd3; 
        8'd52:
            Data_out_Rx_reg <= 8'd4; 
        8'd53:
            Data_out_Rx_reg <= 8'd5; 
        8'd54:
            Data_out_Rx_reg <= 8'd6; 
        8'd55:
            Data_out_Rx_reg <= 8'd7; 
        8'd56:
            Data_out_Rx_reg <= 8'd8; 
        8'd57:
            Data_out_Rx_reg <= 8'd9;
        8'd97:  /* a */
            Data_out_Rx_reg <= 8'd10;
        8'd98: /* b */
            Data_out_Rx_reg <= 8'd11;
        8'd99: /* c */
            Data_out_Rx_reg <= 8'd12;
        8'd100: /* d */
            Data_out_Rx_reg <= 8'd13;
        8'd101: /* e */
            Data_out_Rx_reg <= 8'd14;
        8'd102: /* f */
            Data_out_Rx_reg <= 8'd15;
        default:
            Data_out_Rx_reg <= 8'd0; 
    endcase 
end

always@(Data_in_Tx)begin
    case(Data_in_Tx)
        8'd0:
            Data_out_Tx_reg <= 8'd48; 
        8'd1:
            Data_out_Tx_reg <= 8'd49; 
        8'd2:
            Data_out_Tx_reg <= 8'd50; 
        8'd3:
            Data_out_Tx_reg <= 8'd51; 
        8'd4:
            Data_out_Tx_reg <= 8'd52; 
        8'd5:
            Data_out_Tx_reg <= 8'd53; 
        8'd6:
            Data_out_Tx_reg <= 8'd54; 
        8'd7:
            Data_out_Tx_reg <= 8'd55; 
        8'd8:
            Data_out_Tx_reg <= 8'd56; 
        8'd9:
            Data_out_Tx_reg <= 8'd57;
        8'ha:
            Data_out_Tx_reg <= 8'd65;
        8'hb:
            Data_out_Tx_reg <= 8'd66;
        8'hc:
            Data_out_Tx_reg <= 8'd67;
        8'hd:
            Data_out_Tx_reg <= 8'd68;
        8'he:
            Data_out_Tx_reg <= 8'd69;
        8'hf:
            Data_out_Tx_reg <= 8'd70;
        default:
            Data_out_Tx_reg <= 8'd48; 
    endcase 
end

endmodule
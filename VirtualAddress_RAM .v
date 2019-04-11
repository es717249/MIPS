module VirtualAddress_RAM
#(
    parameter ADDR_WIDTH=32
)(
    input [ADDR_WIDTH-1:0]  address,
    input swdetect,
    output [ADDR_WIDTH-1:0] translated_addr,
    output [ADDR_WIDTH-1:0] MIPS_address,
    output aligment_error,   //1= aligment error , 0 = correct address    
    output [1:0] dataBack_Selector_out,        /* Selector forDemux for Write_back operation*/
    output Data_selector_periph_or_mem,  /* for selecting memory or peripheral on mux */
    output clr_rx_flag      /* clear uart rx flag */
);

reg [1:0] dataBack_Selector_reg;

wire [ADDR_WIDTH-1:0]  add_tmp;
reg Data_selector_periph_or_mem_reg;

assign aligment_error = (address & 3)==0 ? 1'd0 : 1'd1 ;

assign add_tmp = address - 32'h10010000;
assign translated_addr = (add_tmp >> 2);
assign MIPS_address = add_tmp + 32'h10010000;

always@(address)begin
    case (address)

      32'h10010024:     /* GPIO */
        begin
            dataBack_Selector_reg = 2'd2;
            Data_selector_periph_or_mem_reg = 1'b0;
        end
      32'h1001002C:     /* UART TX */
        begin
            dataBack_Selector_reg = 2'd1;
            Data_selector_periph_or_mem_reg = 1'b0;
        end
        32'h10010028:     /* UART RX */
        begin
            dataBack_Selector_reg = 2'd0;
            Data_selector_periph_or_mem_reg = 1'b1;
        end
      default: 
        begin
                        /* RAM Memory  */
            dataBack_Selector_reg = 2'd0;
            Data_selector_periph_or_mem_reg = 1'b0;
        end
    endcase
end

/* always@(address)begin
    case (address)

      32'h10010028:     // UART RX 
            Data_selector_periph_or_mem_reg = 1'd1;
      default:                         
            Data_selector_periph_or_mem_reg = 1'd0;
    endcase
end */

assign dataBack_Selector_out = dataBack_Selector_reg;

/* assign Data_selector_periph_or_mem =(address == 32'h10010028) ? 1'd1: 1'd0; */
assign Data_selector_periph_or_mem = Data_selector_periph_or_mem_reg;

/* Clear UART Rx flag */
assign clr_rx_flag =(address == (32'h10010029)&&(swdetect==1'b1)) ? 1'd0: 1'd1;




endmodule
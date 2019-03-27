module GPIO_controller#(
    parameter DATA_WIDTH=8,	/* length of data */
    parameter ADDR_WIDTH=32			//bits to address the elements
)
(    
    input [(ADDR_WIDTH-1):0] addr_ram,
    input [(DATA_WIDTH-1):0] wdata,
    input clk,
    input reset,
    input enable_sw,
    output [7:0] gpio_data_out,
    output demuxSelector
    );

    reg [7:0] register_out_reg;
    wire enable_write;
    reg demuxSelector_reg;
    
    assign enable_write = (addr_ram == 32'h10010024) ? 1'd1: 1'd0;
    assign gpio_data_out = register_out_reg;
    assign demuxSelector =demuxSelector_reg;

    always@(posedge clk or negedge reset)begin

        if(reset==1'b0)begin
            register_out_reg <= {DATA_WIDTH{1'b0}};
            demuxSelector_reg <=0;
        end else begin
            if(enable_write==1'd1 && enable_sw==1'b1 )begin
                register_out_reg <= wdata;
                demuxSelector_reg <=1;
            end
        end
            
    
    end


endmodule
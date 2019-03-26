module GPIO_controller#(
    parameter DATA_WIDTH=8,	/* length of data */
    parameter ADDR_WIDTH=32			//bits to address the elements
)
(    
    input [(ADDR_WIDTH-1):0] addr_ram,
    input [(DATA_WIDTH-1):0] wdata,
    input clk,
    input reset,
    output enable_write,
    output [7:0] register_out
    );

    reg [7:0] register_out_reg;


    
    assign enable_write = (addr_ram == 32'h10010024) ? 1'd1: 1'd0;
    assign register_out = register_out_reg;
    

    always@(posedge clk or negedge reset)begin

        if(reset==1'b0)
            register_out_reg <= {DATA_WIDTH{1'b0}};
        else
            if(enable_write==1'd1)
                register_out_reg <= wdata;
    
    end


endmodule
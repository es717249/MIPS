module Flipflop
#(
	parameter Nbit=12
)
(
	input [Nbit-1:0] input_data,
	input clk,
	input enable,
	input reset,
	output reg[Nbit-1:0] output_data/*,
	output stored_flag*/
);
//reg stored_reg;
always @(posedge clk or negedge reset) begin
	if(reset==1'b0) begin
		output_data <={Nbit{1'b0}};		
		//stored_reg <=1'b0;
	end
	else begin
		
		if(enable==1'b1)begin
			output_data <=input_data;
			//stored_reg <=1'b1;
		end

	end
end

//assign stored_flag = stored_reg;
endmodule
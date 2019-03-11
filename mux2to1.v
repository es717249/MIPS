
module mux2to1
#(
	parameter Nbit=12
)
(
	input mux_sel,
	input [Nbit-1:0] data1,
	input [Nbit-1:0] data2,
	output [Nbit-1:0] Data_out
);

reg [Nbit-1:0] mux_output;

always@(mux_sel,data1,data2)begin
	
	if(mux_sel==1'b0)begin
		mux_output = data1;
	end else begin
		mux_output = data2;
	end

end

assign Data_out = mux_output;

endmodule
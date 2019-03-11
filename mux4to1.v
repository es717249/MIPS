module mux4to1
#(
	parameter Nbit=12
)
(
	input [1:0]mux_sel,
	input [Nbit-1:0] data1,
	input [Nbit-1:0] data2,
	input [Nbit-1:0] data3,
	input [Nbit-1:0] data4,
	output [Nbit-1:0] Data_out
);


wire [Nbit-1:0] Data_outm0;
wire [Nbit-1:0] Data_outm1;

mux2to1
#(
	.Nbit(Nbit)
)mux0
(
	.mux_sel(mux_sel[0]),
	.data1(data1),
	.data2(data2),
	.Data_out(Data_outm0)
);

mux2to1
#(
	.Nbit(Nbit)
)mux1
(
	.mux_sel(mux_sel[0]),
	.data1(data3),
	.data2(data4),
	.Data_out(Data_outm1)
);

mux2to1
#(
	.Nbit(Nbit)
)mux2
(
	.mux_sel(mux_sel[1]),
	.data1(Data_outm0),
	.data2(Data_outm1),
	.Data_out(Data_out)
);

endmodule
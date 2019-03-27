module CounterwFlag_P_TB;

    localparam MAXIMUM_VALUE = 5'd16;
	localparam TARGET= MAXIMUM_VALUE/2;
	localparam NBITS = CeilLog2(MAXIMUM_VALUE);

	reg clk=1'b0;
	reg reset=0;
//	reg enable=0;
	wire flag;
//	wire[NBITS-1:0] counter;

	//for one shot 
	reg Start=0;

	// Output Ports
	wire Shot;

	//for counter
	reg  FF_xor8_1=0; 
	wire [5:0] counter8_1;


initial begin 

	$recordfile("results_CwF.trn");	
	$recordvars;
end


CounterwFlag_P 
#(
	// Parameter Declarations
    .MAXIMUM_VALUE(MAXIMUM_VALUE)	
)cont16_TB
(
	// Input Ports
	.clk(clk),
	.reset(reset),
//	.enable(enable),	
	.flag(flag) ,
	//.counter(counter)
);


/*
One_Shot onesht
(
	// Input Ports
	.clk(clk) ,
	.reset(reset) ,
	.Start(flag) ,

	// Output Ports
	.Shot(Shot)
);


CounterEvents
#(
	// Parameter Declarations
	.NBITS(6)
)counter_8_1
(
	// Input Ports
    .eventtoC(FF_xor8_1),
	.clk(clk),
    //.clk(neg_clk_0),
	.reset(Shot),
	.enable(1'b1),		
	// Output Ports	
	.counter(counter8_1)
);*/

initial begin 
    forever #2504 clk=!clk;
end 

initial begin 
    forever #2504 FF_xor8_1=!FF_xor8_1;
end 

initial begin
	#0
	reset =0;
//	enable=0;
	#10
	reset =1;
//	enable=1;
	#100 $finish;	
	
end
/*********************************************************************************************/
   
 /*Log Function*/
     function integer CeilLog2;
       input integer data;
       integer i,result;
       begin
          for(i=0; 2**i < data; i=i+1)
             result = i + 1;
          CeilLog2 = result;
       end
    endfunction

/*********************************************************************************************/
endmodule

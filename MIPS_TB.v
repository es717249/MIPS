module MIPS_TB;

	parameter DATA_WIDTH=32; 
	parameter ADDR_WIDTH=8;
	parameter NBITS =CeilLog2(DATA_WIDTH);
	//Parameters for UART;	
	parameter Nbit =8;		//Number of bits to transmit
	parameter baudrate=9600;	//baudrate to use 
	parameter clk_freq =50000000;	//system clock frequency	
//inputs for UART
	
	//reg SerialDataIn; //it's the input data port 
	reg clk=1'b0; //clk signal
	reg reset; //async signal to reset 	
	//reg clr_rx_flag; //to clear the Rx signal	
	
	//outputs for UART	
	//wire Parity_error; //when received logic data contains parity errors. Just for pair parity	
	//wire SerialDataOut; //Output for serial data  

	/*reg [4 : 0]A1_RF;
	reg [4 : 0]A2_RF;
	reg [4 : 0]A3;
	reg [DATA_WIDTH-1 : 0] WD_RF;
	reg WE_RF;*/
	wire [DATA_WIDTH-1 : 0] RD1;
	wire [DATA_WIDTH-1 : 0] RD2;

	//reg  [(ADDR_WIDTH-1):0]addr;
	wire  [(DATA_WIDTH-1):0]q;
	/*reg  [(DATA_WIDTH-1):0]wd;
	reg  we_mem;
	reg  mem_sel;*/
	//reg [DATA_WIDTH-1:0] PCaddr;
	//reg PC_en;
	//reg IR_write;
	reg [2:0]count_state; //7 states
MIPS
#(
	.DATA_WIDTH(DATA_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH),
	.NBITS(NBITS),
	.Nbit(Nbit),
	.baudrate(baudrate),
	.clk_freq(clk_freq)
)MIPS_module
(
	//inputs for UART
	
	//.SerialDataIn(SerialDataIn), //it's the input data port 
	.clk(clk), //clk signal
	.reset(reset), //async signal to reset 	
	//.clr_rx_flag(clr_rx_flag), //to clear the Rx signal	
	
	//outputs for UART	
	//.Parity_error(Parity_error), //when received logic data contains parity errors. Just for pair parity	
	//.SerialDataOut(SerialDataOut),  //Output for serial data  		
	.RD1(RD1), //output
	.RD2(RD2), //output
	//for rom
	//.PCaddr(PCaddr),
	//.PC_en(PC_en),
	//.IR_write(IR_write),
	.count_state(count_state), //input
	.Mmemory_output(q)		//output	

);
 
 initial begin
 	forever #1 clk=!clk;
 end
 initial begin
 	#0 reset=1'b0;

	count_state =0;
 	#4 count_state =1; //fetch
 	reset =1;
 	

 	#3 count_state =2;//decode
 	#2 count_state =3;
 	#2 count_state =4;

 	//segunda instruccion
 	#2 count_state =1;
 	#2 count_state =2;//decode
 	#2 count_state =3;
 	#2 count_state =4;

 	//tercera instruccion
	#2 count_state =1;
	#2 count_state =2;//decode
 	#2 count_state =3;
 	#2 count_state =4;
 	
 	//cuarta instruccion
	#2 count_state =1;
	#2 count_state =2;//decode
 	#2 count_state =3;
 	#2 count_state =4;

 	//quinta instruccion //addi $t4,$t4, 0x02
	#2 count_state =1;
	#2 count_state =2;//decode
 	#2 count_state =3;
 	#2 count_state =4;

//tipo R
 	//sexta instruccion 	
	#2 count_state =1; //fetch  add $s1,$t1,$t0
	#2 count_state =2;//decode
 	#2 count_state =3;
 	#2 count_state =4;
	//septima instruccion 
 	#2 count_state =1; //fetch  sll $s1,$s1,0x4
 	#2 count_state =2;//decode
 	#2 count_state =3;
 	#2 count_state =4;
	//octava instruccion 
 	#2 count_state =1; //fetch  or $s1,$s1,t2
 	#2 count_state =2;//decode
 	#2 count_state =3;
 	#2 count_state =4;
	//novena instruccion 
	#2 count_state =1; //fetch  andi $s3,$t3,xF0
 	#2 count_state =2;//decode
 	#2 count_state =3;
 	#2 count_state =4;

 end


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
endmodule
//Using 5cgxfc5c6f27c7
/**
    This is a new implementation of the MIPS
 */

module MIPS_new
#
(
    parameter DATA_WIDTH=32,/* length of data */
    parameter ADDR_WIDTH=8 /* bits to address the elements */
)
(
	input clk, 				/* clk signal */
	input reset, 			/* async signal to reset */
	/* Test signals */
	input [DATA_WIDTH-1:0]Instruction_fetched, 	//signal from FF to Register files to indicate instruction	
	input RegWrite,		/* Write enable for register file unit*/
	input MemWrite,		/* Write enable for the memory unit */
	input MemtoReg,		/* Control signal for the Mux from ALU to register file */
	input mem_sel, 		/* Memory selection: 0=ROM, 1=RAM*/
	input [3:0]ALUControl, 			//@Control signal: Selects addition operation (010b)
	input [1:0]sel_muxALU_srcB 		//@Control signal: allows to select the operand for getting srcB number
);

/***************************************************************
Signals for Memory unit
***************************************************************/
wire [DATA_WIDTH-1 : 0] B;	//data from Reg file RD2 to 'mux4_1_forALU'
wire  [(DATA_WIDTH-1):0]Mmemory_output;

/***************************************************************
Signals for ALU unit
***************************************************************/
//wire [1:0]sel_muxALU_srcB; 		//@Control signal: allows to select the operand for getting srcB number
wire zero;						//zero flag
wire [DATA_WIDTH-1:0]shifted2;	//4th input for ALU: shifted by 2 data
wire [DATA_WIDTH-1:0]SrcB;		//output of ALU
//wire [3:0]ALUControl; 			//@Control signal: Selects addition operation (010b)
wire [DATA_WIDTH-1 : 0]ALUResult;
/***************************************************************
Signals for PC 
***************************************************************/

/***************************************************************
Signals for Register File
***************************************************************/
wire [DATA_WIDTH-1 : 0] RD1; 
wire [DATA_WIDTH-1 : 0] RD2;
//wire MemtoReg;		//@Control signal
wire [DATA_WIDTH-1:0]datatoWD3;
/***************************************************************
Signals for Sign Extend module
***************************************************************/
wire [DATA_WIDTH-1:0] sign_extended_out;

/***************************************************************
Signals for Address preparation module
***************************************************************/
//wire [DATA_WIDTH-1:0]Instruction_fetched; 	//signal from FF to Register files to indicate instruction
wire [5:0] opcode;							//Opcode field of the instruction

wire [4 : 0]rs;		 			//source 1	(R-I type)
wire [4 : 0]rt;		 			//source 2	(R-I type)
wire [4 : 0]rt_im;				//Destination: 20:16 bit (I type)
wire [4 : 0]rd;		  			//Destination: 15:11 bit (R type)
wire [4 : 0]shamt;				//shamt field (R type)
wire [5: 0]funct;				//select the function
wire [15: 0]immediate_data;		//immediate field (I type)
wire [25:0] address_j;			//address field for (J type)
/***************************************************************
Control signals: these go to the control unit
***************************************************************/


//####################     Address preparation   #######################
addres_preparation add_prep
(	
	/* Input */
	.Mmemory_output(Instruction_fetched),	//rom fetched instruction content
	/* Output */
	.opcode(opcode),  				//Opcode  value
	.funct(funct),    				//function value
	.rs(rs),		 				//source 1	(R-I type)		
	.rt(rt),		 				//source 2	(R-I type)		
	.rt_im(rt_im),					//Destination: 20:16 bit (I type)		
	.rd(rd),						//Destination: 15:11 bit (R type)		
	.shamt(shamt),					//shamt field (R type)	
	.immediate_data(immediate_data),//immediate field (I type)	
	.address_j(address_j)			//address field for (J type)	
);


//####################   Memory Unit     ####################
MemoryUnit #(
	.DATA_WIDTH(DATA_WIDTH), 
	.ADDR_WIDTH(ADDR_WIDTH)//bits to address the elements
)MemoryMIPS
(
    /* inputs */
	.addr(ALUResult),				//Address to read from ROM
	.wdata(RD2),		            //data to write to RAM
	.we(MemWrite),					//@Control signal: enable
	.clk(clk), 						//clock signal
	.mem_sel(mem_sel),				//@Control signal: memory selector: 0=ROM, 1=RAM
    /* output */
	.q(Mmemory_output)
);

////####################  Register File  ###################
Register_File #(
	.WORD_LENGTH(DATA_WIDTH),	
	.NBITS(5)
)RegisterFile_Unit
(
	/* Inputs */
	.clk(clk),
	.reset(reset),
	.Read_Reg1(rs),				//Rs-> 25:21
	.Read_Reg2(rt), 			//Rt-> 20:16
	.Write_Reg(rd),				//(A3)Register destination; bits I->20:16 ; R->15:11
	.Write_Data(datatoWD3),  	//(WD3) data to write 
	.Write(RegWrite),			//@Control Signal:(WE3) enable signal
	/* Outputs */
	.Read_Data1(RD1),
	.Read_Data2(RD2)	
);

//####################  Sign extend Module  ###############

SignExtend_module signExt
(
	.immediate(immediate_data),
	.extended_sign_out(sign_extended_out)
);


//##########  Mux from Register File to ALU (srcB) ############
mux4to1 #(
	.Nbit(DATA_WIDTH)
)mux4_1_forALU
(
	.mux_sel(sel_muxALU_srcB),
	/* 32 bit DATA inputs */
	.data1(RD2),					//From Register File RD2
	.data2(4), 						//Sum 4 for PC+4
	.data3(sign_extended_out),		//For Sign extended module output
	.data4(shifted2), 					//This should be shift<<2
	/* 32 bit DATA outputs */
	.Data_out(SrcB)					//output of Mux
);

//##############  Mux from Memory to Register File ############
mux2to1 #(
	.Nbit(DATA_WIDTH)
)MUX_to_updateRegFile
(
	.mux_sel(MemtoReg),			//@Control signal:  0=ALU , 1=Memory
	.data1(ALUResult), 			//From ALU result
	.data2(Mmemory_output),		//From Memory: Read data
	.Data_out(datatoWD3) 			//This have the Address for Memory input
);

//####################        ALU   #######################
ALU #(
	.WORD_LENGTH(DATA_WIDTH)
)alu_unit
(
	/* inputs */	
	.dataA(RD1),				//From RD1 		 , input 1
	.dataB(SrcB),				//From Mux 4 to 1, input 2 
	.control(ALUControl),		//@Control signal
	/* outputs */
	.carry(zero),			//Zero signal
	.dataC(ALUResult) 		//Result	
);




endmodule
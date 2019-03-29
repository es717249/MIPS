//Using 5cgxfc5c6f27c7
/**
    This is a new implementation of the MIPS
 */

module MIPS_new
#(
    parameter DATA_WIDTH=32,	/* length of data */
    parameter ADDR_WIDTH=8 		/* bits to address the elements */
)
(
	input clk, 					/* clk signal */
	input reset, 				/* async signal to reset */	
	input [2:0]count_state, 		/* 7 states */
	output [7:0] gpio_data_out
);

/***************************************************************
Signals for Memory unit
***************************************************************/
wire [DATA_WIDTH-1 : 0] B;	//data from Reg file RD2 to 'mux4_1_forALU'
wire [DATA_WIDTH-1 : 0] WD_input;	//output of demux module to data input of Memory unit
wire [DATA_WIDTH-1 : 0] A;	//data from Reg file RD1 to MUX to ALU
wire [DATA_WIDTH-1:0]Mmemory_output/* synthesis keep */;
wire MemWrite_wire;			//@Control signal: Write enable for the memory unit
wire IRWrite_wire;			//@Control signal: Enable signal for FF to let the instruction pass to 'Prepare inst module'
wire DataWrite_wire;		//@Control signal: Enable signal for FF to let the data pass to Mux to 'Register File'
wire mem_sel_wire; 		    //@Control signal: Memory selection: 0=ROM, 1=RAM
wire IorD_wire;				//@Control signal: Instruction or Data selection. 0=from PC, 1=from ALU
/***************************************************************
Signals for ALU unit
***************************************************************/

wire zero;							//zero flag
wire carry;							//carry flag
wire negative;						//negative flag
wire [DATA_WIDTH-1:0]shifted2;		//4th input for ALU: shifted by 2 data
wire [DATA_WIDTH-1:0] SrcA;			//input 0 of ALU
wire [DATA_WIDTH-1:0] SrcB;			//input 1 of ALU
wire [3:0]ALUControl_wire; 			//@Control signal: Selects addition operation (010b)
wire [DATA_WIDTH-1 : 0]ALUResult;	//Output result of ALU unit
wire [DATA_WIDTH-1 : 0]ALUOut;		//Registerd output of ALU
wire [1:0]sel_muxALU_srcB; 			//@Control signal: allows to select the operand for getting srcB number on mux 'Mux4_1_forALU'
wire ALUSrcA_wire;					//@Control signal: allow to select the SrcA source. 0=PC, 1=RD1
wire ALUresult_en_wire;				//@Control signal: enables the FF at ALUout

/***************************************************************
Signals for Register File
***************************************************************/
wire [DATA_WIDTH-1 : 0] RD1; 
wire [DATA_WIDTH-1 : 0] RD2;
wire RegDst_wire;					/*@Control signal: for Write reg in Register File */
wire MemtoReg_wire;					/*@Control signal: for the Mux from ALU to Register File */
wire RegWrite_wire;					/*@Control signal: Write enable for register file unit*/
wire [DATA_WIDTH-1:0]datatoWD3;   	/* Conexion from MUX to select a Data from Memory or from ALU. 0=ALU,1=Memory */
wire [DATA_WIDTH-1:0]DataMemory;	/* Output of FF from Data Memory  */	
wire RDx_FF_en_wire;				/*@Control signal: to enable FF to MUX to ALU */
/***************************************************************
Signals for Sign Extend module
***************************************************************/
wire [DATA_WIDTH-1:0] sign_extended_out;

/***************************************************************
Signals for Address preparation module
***************************************************************/
wire [DATA_WIDTH-1:0]Instruction_fetched/*synthesis keep*/; 	//signal from FF to Register files to indicate instruction
wire [5 :0 ]opcode_wire;							//Opcode field of the instruction
wire [4 : 0]rs_wire;		 			//source 1	(R-I type)
wire [4 : 0]rt_wire;		 			//source 2	(R-I type)
wire [4 : 0]rd_wire;		  			//Destination: 15:11 bit (R type)
wire [4 : 0]shamt_wire;				//shamt field (R type)
wire [5 : 0]funct_wire;				//select the function
wire [15: 0]immediate_data_wire;		//immediate field (I type)
wire [25: 0]address_j_wire;			//address field for (J type)

/***************************************************************
Signals for A3 Destination mux
***************************************************************/
wire [4:0]mux_A3out;
/***************************************************************
Signals for Branch instructions
***************************************************************/
wire PCWrite_wire;
wire Branch_wire;

/***************************************************************
Signals for Shift and concatenate jump address module 
***************************************************************/
wire [DATA_WIDTH-1:0] New_JumpAddress;
wire flag_Jtype_wire;
/***************************************************************
Signals to update Program Counter
***************************************************************/
wire PCSrc_wire;					/* Signal for a mux to select the source of PC */
wire [DATA_WIDTH-1:0]PC_current/*synthesis keep*/;					/* Current Program counter */
wire [DATA_WIDTH-1:0] PC_source/*synthesis keep*/;	/* signal from mux to PC register */
wire [DATA_WIDTH-1:0] PC_source_tmp;	/* signal from mux to PC register */
wire PC_En_wire;
wire [DATA_WIDTH-1:0] mux_address_Data_out;
wire [DATA_WIDTH-1 : 0]ALUOut_Translated;		//Registerd output of ALU
/***************************************************************
Signals for the Virtual Memory unit 
***************************************************************/
wire aligment_error_wire;
wire aligment_error_RAM_wire;
wire [DATA_WIDTH-1:0] translated_addr_wire;
wire [DATA_WIDTH-1:0] MIPS_address/*synthesis keep*/;
wire [DATA_WIDTH-1:0] MIPS_RAM_address/*synthesis keep*/;

/***************************************************************
Signals for GPIO
***************************************************************/
wire gpio_enable;
//wire [7:0] gpio_data_out;
wire sw_inst_detector;
wire demuxSelector_wire;
wire [DATA_WIDTH-1:0]Gpio_data_input;

//####################     GPIO controller unit   #######################
GPIO_controller #(
	.DATA_WIDTH(8),
	.ADDR_WIDTH(32)
)GPIO
(
	//.addr_rom(PC_current),
	.addr_ram(ALUOut),
	.wdata( Gpio_data_input[7:0]),
	.clk(clk),
	.reset(reset),
	.enable_sw(sw_inst_detector),
	.gpio_data_out(gpio_data_out),
	.demuxSelector(demuxSelector_wire)
);

//####################     Data bus Demuxplexer  #######################
Demux1to2 #(
    .DATA_LENGTH(DATA_WIDTH)
)demux_MemUnit_or_GPIO(
	// Input Ports
	.Demux_Input(B),
	.Selector(demuxSelector_wire),
    //output Ports
    .Dataout0(WD_input),
    .Dataout1(Gpio_data_input)
);

//####################     ROM Address translator unit   #######################
VirtualMemory_unit #(
	.ADDR_WIDTH(DATA_WIDTH)
)VirtualMem
(
	.address(PC_current),
	.translated_addr(translated_addr_wire),
	.MIPS_address(MIPS_address),
	.aligment_error(aligment_error_wire)
);

//####################     RAM Address translator unit   #######################
VirtualAddress_RAM #(
	.ADDR_WIDTH(DATA_WIDTH)
)VirtualRAM_Mem
(
	.address(ALUOut),
	.translated_addr(ALUOut_Translated),
	.MIPS_address(MIPS_RAM_address),
	.aligment_error(aligment_error_RAM_wire)
);

//####################     Control unit   #######################
ControlUnit CtrlUnit(
    /* Inputs */
    .clk(clk), 						//clk signal
	.reset(reset), 					//async signal to reset 	
    .count_state(count_state), 		//7 states
    .Opcode(opcode_wire),
    .Funct(funct_wire),
	.Zero(zero),
    /* Outputs */
    .IorD(IorD_wire),
    .MemWrite(MemWrite_wire),
    .IRWrite(IRWrite_wire),
    .RegDst(RegDst_wire),
    .MemtoReg(MemtoReg_wire),
    .PCWrite(PCWrite_wire),
    .Branch(Branch_wire),
    .PCSrc(PCSrc_wire),
    .ALUControl(ALUControl_wire),
    .ALUSrcB(sel_muxALU_srcB),
    .ALUSrcA(ALUSrcA_wire),
    .RegWrite(RegWrite_wire),
    .Mem_select(mem_sel_wire),		//@Control signal: Memory selection: 0=ROM, 1=RAM
	.DataWrite(DataWrite_wire),
	.RDx_FF_en(RDx_FF_en_wire),
	.ALUresult_en(ALUresult_en_wire),
	.PC_En(PC_En_wire),
	.flag_J_type_out(flag_Jtype_wire),
	.flag_sw_out(sw_inst_detector)
);

//####################     Address preparation   #######################
addres_preparation add_prep
(	
	/* Input */
	.Mmemory_output(Instruction_fetched),	//rom fetched instruction content
	/* Output */
	.opcode(opcode_wire),  			//Opcode  value
	.funct(funct_wire),    				//function value
	.rs(rs_wire),		 				//source 1	(R-I type)		
	.rt(rt_wire),		 				//source 2	(R-I type)		
	.rd(rd_wire),						//Destination: 15:11 bit (R type)		
	.shamt(shamt_wire),					//shamt field (R type)	
	.immediate_data(immediate_data_wire),//immediate field (I type)	
	.address_j(address_j_wire)			//address field for (J type)	
);
//#################### Register for Program Counter #################
Register#(
	.WORD_LENGTH(DATA_WIDTH)
)ProgramCounter_Reg
(		
	.clk(clk),
	.reset(reset),
	.enable(PC_En_wire),	
	.Data_Input(PC_source), 	//This comes from the ALU Result after MUX_for_PC_source
	.Data_Output(PC_current)	//output Program counter update
);
//###############   FF, from PC to Memory Unit     ##################
mux2to1#(.Nbit(DATA_WIDTH))
MUX_for_PC
(
	.mux_sel(IorD_wire),				//@Control signal: Instruction or Data selection. 1=from ALU
	//.data1(PC_current), 				//0=Comes from 'PC_Reg'
	.data1(translated_addr_wire), 				//0=Comes from 'PC_Reg'	
	//.data2(ALUOut), 					//1=From ALUOut signal 	
	.data2(ALUOut_Translated), 					//1=From ALUOut signal 
	.Data_out(mux_address_Data_out) 	//this have the Address for Memory input
);


//####################   Memory Unit     ########################
MemoryUnit #(
	.DATA_WIDTH(DATA_WIDTH), 
	.ADDR_WIDTH(ADDR_WIDTH)//bits to address the elements
)MemoryMIPS
(
    /* inputs */
	//.addr(translated_addr_wire),	//Address to read from ROM
	.addr(mux_address_Data_out),	//Address to read from ROM
	//.wdata(B),			            //data to write to RAM
	.wdata(WD_input),			            //data to write to RAM
	.we(MemWrite_wire),				//@Control signal: enable
	.clk(clk), 						//clock signal
	.mem_sel(mem_sel_wire),			//@Control signal: memory selector: 0=ROM, 1=RAM
    /* output */
	.q(Mmemory_output)
);

////################  Registers for Inst and Data ##############
Register#(
	.WORD_LENGTH(DATA_WIDTH)
)Reg_forInstruction 
(		
	.clk(clk),
	.reset(reset),
	.enable(IRWrite_wire),
	.Data_Input(Mmemory_output),//output from MEMORY (ROM)
	.Data_Output(Instruction_fetched)//output Program counter update
);
Register#(
	.WORD_LENGTH(DATA_WIDTH)
)Reg_forData 
(		
	.clk(clk),
	.reset(reset),
	.enable(DataWrite_wire),			//controls the flip flop for data (RAM to reg)
	.Data_Input(Mmemory_output), 		//output from MEMORY (RAM)
	.Data_Output(DataMemory)			//Output of FF to Mux to WD3 (reg file)
);

//#################### A3 Destination Mux ######################
mux2to1#(
	.Nbit(3'd5)
)mux_A3_destination
(
	.mux_sel(RegDst_wire),		/* 1= R type (rd), 0= I type (rt) */
	.data1(rt_wire),
	.data2(rd_wire),
	.Data_out(mux_A3out)
);

////####################  Register File  #######################
Register_File #(
	.WORD_LENGTH(DATA_WIDTH),	
	.NBITS(5)
)RegisterFile_Unit
(
	/* Inputs */
	.clk(clk),
	.reset(reset),
	.Read_Reg1(rs_wire),		//It'll always be 'Rs'-> 25:21. 
	.Read_Reg2(rt_wire), 			//It'll always be 'Rt'-> 20:16
	.Write_Reg(mux_A3out),		//(A3)Register destination; bits I->20:16 ; R->15:11
	.Write_Data(datatoWD3),  	//(WD3) data to write 
	.Write(RegWrite_wire),		//@Control Signal:(WE3) enable signal
	/* Outputs */
	.Read_Data1(RD1),
	.Read_Data2(RD2)	
);

//##############  Mux from Memory to Register File ############
mux2to1 #(
	.Nbit(DATA_WIDTH)
)MUX_to_WriteData_RegFile
(
	.mux_sel(MemtoReg_wire),			//@Control signal:  0=ALU , 1=Memory
	.data1(ALUOut),		 			//From ALU result
	.data2(DataMemory),				//From Memory: Read data
	.Data_out(datatoWD3) 				//This have the Address for Memory input
);

//####################  Sign extend Module  ###############
SignExtend_module signExt
(
	.immediate(immediate_data_wire),
	.extended_sign_out(sign_extended_out)
);

////#################### FF, from RD1 to ALU  #######################
Register#(
	.WORD_LENGTH(DATA_WIDTH)
)FromRegtoSrcA_FF
(		
	.clk(clk),
	.reset(reset),
	.enable(RDx_FF_en_wire),//controls the flip flop from Reg to SrcA ALU
	.Data_Input(RD1), 
	.Data_Output(A)		
);
////#################### FF, from RD2 to Mux_4_1_forALU #############
Register#(
	.WORD_LENGTH(DATA_WIDTH)
)FromRegtoSrcB_FF 
(		
	.clk(clk),
	.reset(reset),
	.enable(RDx_FF_en_wire),//@Control signal: control the FF from Reg to SrcB ALU
	.Data_Input(RD2), 
	.Data_Output(B)		
);

//####################   MUX to update SrcA  ########################
mux2to1#(
	.Nbit(DATA_WIDTH)
)MUX_to_updateSrcA
(
	.mux_sel(ALUSrcA_wire),		//@Control signal: mux selector, 0= PC,1 =RD1
	.data1(PC_current), 		//comes from PC Reg
	.data2(A), 					//RD1 output from Reg File
	.Data_out(SrcA) 			//Input 1 of ALU
);



//##########  Mux from Register File to ALU (srcB) ############

assign shifted2[1:0]=2'd0;
assign shifted2[DATA_WIDTH-1:2] = sign_extended_out[DATA_WIDTH-1-2:0];		/* immediate value x 4 */

mux4to1 #(
	.Nbit(DATA_WIDTH)
)mux4_1_forALU
(
	.mux_sel(sel_muxALU_srcB),
	/* 32 bit DATA inputs */
	.data1(B),					//From Register File RD2
	.data2(4), 						//Sum 4 for PC+4
	.data3(sign_extended_out),		//For Sign extended module output
	.data4(shifted2), 					//This should be shift<<2
	/* 32 bit DATA outputs */
	.Data_out(SrcB)					//output of Mux
);

//####################        ALU   #######################
ALU #(
	.WORD_LENGTH(DATA_WIDTH)
)alu_unit
(
	/* inputs */	
	.dataA(SrcA),					//From MUX_to_updateSrcA 	, input 1
	.dataB(SrcB),					//From Mux 4 to 1		, input 2 
	.control(ALUControl_wire),		//@Control signal
	.shmt(shamt_wire),				//shamt field to do shift operations
	/* outputs */
	.carry(carry),					//Carry signal
	.zero(zero),					//Zero signal
	.negative(negative),			//Negative signal
	.dataC(ALUResult) 				//Result	
);

//####################   ALU Flip flop to the ALUOut ####################
Register#(
	.WORD_LENGTH(DATA_WIDTH)
)Mem_forALUOut
(		
	.clk(clk),
	.reset(reset),
	.enable(ALUresult_en_wire),
	.Data_Input(ALUResult), //This comes from the ALU Result after MUX
	.Data_Output(ALUOut)//output Program counter update
);

//####################   MUX after ALU result to update PC ####################
mux2to1#(
	.Nbit(DATA_WIDTH)
)MUX_for_PC_source
(
	.mux_sel(PCSrc_wire),
	.data1(ALUResult), //comes from PC Reg
	.data2(ALUOut), //from ALUout signal 
	.Data_out(PC_source_tmp) //this have the Address for Memory input
	//.Data_out(PC_source) //this have the Address for Memory input
);


//####################   Shift and concatenate jump address module ####################
Shift_Concatenate shiftConcat_mod
(
	.J_address(address_j_wire ), /* shifted <<2 */
	.PC_add(PC_current[31:28]),
	.new_jumpAddr(New_JumpAddress)
);
//assign New_JumpAddress = {PC_current[31:28],address_j_wire[23:2]};

//####################   MUX to update PC considering Jump instruction  ########################

mux2to1#(
	.Nbit(DATA_WIDTH)
)MUX_to_updatePC_withJump
(
	.mux_sel(flag_Jtype_wire),		//@Control signal: mux selector, 0=normal PC,1 =jump address
	.data1(PC_source_tmp), 			//comes from MUX_for_PC_source
	.data2(New_JumpAddress), 		//New jump address 32 bit long
	.Data_out(PC_source) 			//Input for ProgramCounter_Reg
);

endmodule
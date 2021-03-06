//Using 5cgxfc5c6f27c7
/**
    This is a new implementation of the MIPS
    working ok up to time 39ns. Writing to $zero needs to be corrected
 */

module MIPS_new
#(
    parameter DATA_WIDTH=32,	/* length of data */
    parameter ADDR_WIDTH=8,		/* bits to address the elements */    
    //UART RX
    parameter UART_Nbit =8,
    parameter baudrate =9600,
    parameter clk_freq = 50000000
    /* parameter baudrate= 5,	
	parameter clk_freq =50 */

)
(
    input clk, 					/* clk signal */
    input reset, 				/* async signal to reset */	
    //UART RX
    input SerialDataIn, //it's the input data port 
    //input clr_rx_flag, //to clear the Rx signal. 0=start new Reception, 1=stop, clear flag after reading the data
    output Rx_flag,  //indicates the data was completely received 
    output [UART_Nbit-1:0] DataRx_out/*synthesis keep*/, //Port where Rx information is available
    output SerialDataOut,
    output [7:0] gpio_data_out
    //output [7 : 0] copyRD1
);

/***************************************************************
Signals for Memory unit
***************************************************************/
wire [DATA_WIDTH-1 : 0] B/*synthesis keep*/;	//data from Reg file RD2 to 'mux4_1_forALU'
wire [DATA_WIDTH-1 : 0] WD_input/*synthesis keep*/;	//output of demux module to data input of Memory unit
wire [DATA_WIDTH-1 : 0] A/*synthesis keep*/;	//data from Reg file RD1 to MUX to ALU
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
wire [DATA_WIDTH-1:0]shifted2/*synthesis keep*/;		//4th input for ALU: shifted by 2 data
wire [DATA_WIDTH-1:0] SrcA/*synthesis keep*/;			//input 0 of ALU
wire [DATA_WIDTH-1:0] SrcB/*synthesis keep*/;			//input 1 of ALU
wire [3:0]ALUControl_wire/*synthesis keep*/; 			//@Control signal: Selects addition operation (010b)
wire [DATA_WIDTH-1 : 0]ALUResult/*synthesis keep*/;	//Output result of ALU unit
wire [DATA_WIDTH-1 : 0]ALUResult_tmp/*synthesis keep*/;	//Output result of ALU unit
wire [DATA_WIDTH-1 : 0]ALUOut/*synthesis keep*/;		//Registerd output of ALU
wire [1:0]sel_muxALU_srcB/*synthesis keep*/; 			//@Control signal: allows to select the operand for getting srcB number on mux 'Mux4_1_forALU'
wire ALUSrcA_wire/*synthesis keep*/;					//@Control signal: allow to select the SrcA source. 0=PC, 1=RD1
wire ALUresult_en_wire/*synthesis keep*/;				//@Control signal: enables the FF at ALUout

/***************************************************************
Signals for Register File
***************************************************************/
wire [DATA_WIDTH-1 : 0] RD1/*synthesis keep*/; 
wire [DATA_WIDTH-1 : 0] RD2/*synthesis keep*/;
wire [1:0] RegDst_wire/*synthesis keep*/;					/*@Control signal: for Write reg in Register File */
wire [1:0]MemtoReg_wire/*synthesis keep*/;					/*@Control signal: for the Mux from ALU to Register File */
wire RegWrite_wire/*synthesis keep*/;					/*@Control signal: Write enable for register file unit*/
wire [DATA_WIDTH-1:0]datatoWD3/*synthesis keep*/;   	/* Conexion from MUX to select a Data from Memory or from ALU. 0=ALU,1=Memory */
wire [DATA_WIDTH-1:0]DataMemory/*synthesis keep*/;	/* Output of FF from Data Memory  */	
wire RDx_FF_en_wire;				/*@Control signal: to enable FF to MUX to ALU */
wire [DATA_WIDTH-1:0] Mem_or_Periph_Data;
/***************************************************************
Signals for Sign Extend module
***************************************************************/
wire [DATA_WIDTH-1:0] sign_extended_out/*synthesis keep*/;
wire immediate_selector/*synthesis keep*/;
/***************************************************************
Signals for Address preparation module
***************************************************************/
wire [DATA_WIDTH-1:0]Instruction_fetched/*synthesis keep*/; 	//signal from FF to Register files to indicate instruction
wire [5 :0 ]opcode_wire/*synthesis keep*/;							//Opcode field of the instruction
wire [4 : 0]rs_wire/*synthesis keep*/;		 			//source 1	(R-I type)
wire [4 : 0]rt_wire/*synthesis keep*/;		 			//source 2	(R-I type)
wire [4 : 0]rd_wire/*synthesis keep*/;		  			//Destination: 15:11 bit (R type)
wire [4 : 0]shamt_wire/*synthesis keep*/;				//shamt field (R type)
wire [5 : 0]funct_wire/*synthesis keep*/;				//select the function
wire [15: 0]immediate_data_wire/*synthesis keep*/;		//immediate field (I type)
wire [15: 0]immediateData_toextend/*synthesis keep*/;		
wire [25: 0]address_j_wire/*synthesis keep*/;			//address field for (J type)

/***************************************************************
Signals for A3 Destination mux
***************************************************************/
wire [4:0]mux_A3out/*synthesis keep*/;
/***************************************************************
Signals for Branch instructions
***************************************************************/
wire PCWrite_wire;
wire Branch_wire;

/***************************************************************
Signals for Shift and concatenate jump address module 
***************************************************************/
wire [DATA_WIDTH-1:0] New_JumpAddress;
/* wire flag_Jtype_wire; */
wire [1:0] flag_Jtype_wire;
/***************************************************************
Signals to update Program Counter
***************************************************************/
wire PCSrc_wire;					/* Signal for a mux to select the source of PC */
wire [DATA_WIDTH-1:0]PC_current/*synthesis keep*/;					/* Current Program counter */
wire [DATA_WIDTH-1:0] PC_source/*synthesis keep*/;	/* signal from mux to PC register */
wire [DATA_WIDTH-1:0] start_PC;     /* Signal to initialize the PC to x400000 */
wire [DATA_WIDTH-1:0] PC_source_tmp;	/* signal from mux to PC register */
wire PC_En_wire;
wire startPC_wire;
wire [DATA_WIDTH-1:0] mux_address_Data_out/*synthesis keep*/;
wire [DATA_WIDTH-1 : 0]ALUOut_Translated/*synthesis keep*/;		//Registerd output of ALU
/***************************************************************
Signals for the Virtual Memory unit 
***************************************************************/
wire aligment_error_wire;
wire aligment_error_RAM_wire;
wire [DATA_WIDTH-1:0] translated_addr_wire/*synthesis keep*/;
wire [DATA_WIDTH-1:0] MIPS_address/*synthesis keep*/;
wire [DATA_WIDTH-1:0] MIPS_RAM_address/*synthesis keep*/;

/***************************************************************
Signals for GPIO
***************************************************************/
wire gpio_enable/*synthesis keep*/;
/* wire [7:0] gpio_data_out; */
wire sw_inst_detector/*synthesis keep*/;
wire lw_inst_detector/*synthesis keep*/;
wire [1:0] dataBack_Selector_wire/*synthesis keep*/;
wire [DATA_WIDTH-1:0]Gpio_data_input/*synthesis keep*/;
/***************************************************************
Signals for Lo and Hi registers
***************************************************************/
wire [DATA_WIDTH-1:0]lo_data/*synthesis keep*/;
wire hi_data/*synthesis keep*/;
wire enable_lo_hi/*synthesis keep*/;
/***************************************************************
Signals for Lo-Hi demux
***************************************************************/
wire [DATA_WIDTH-1:0] demux_aluout_0/*synthesis keep*/ ;
wire [DATA_WIDTH-1:0] demux_aluout_1/*synthesis keep*/;
wire demux_aluout_sel/*synthesis keep*/;
/***************************************************************
Signals for MUX ALU result / Lo Reg
***************************************************************/
wire mflo_flag;
/***************************************************************
Signals for UART
***************************************************************/
wire [UART_Nbit-1:0] DataRx_tmp/*synthesis keep*/;
wire clr_rx_flag/*synthesis keep*/; //to clear the Rx signal. 0=start new Reception, 1=stop, clear flag after reading the data
wire clr_tx_flag/*synthesis keep*/; //to clear the Tx signal. 0=start new Transmission, 1=no effect
wire [DATA_WIDTH-1:0] uart_tx_input/*synthesis keep*/;
wire [DATA_WIDTH-1:0] DataRx/*synthesis keep*/;
wire see_uartflag_wire/*synthesis keep*/;
wire Start_Tx/*synthesis keep*/;
wire Start_uartTx_input_wire/*synthesis keep*/;
wire Start_uartTx_output_wire/*synthesis keep*/;
wire enable_StoreTxbuff_fromMem/*synthesis keep*/;   
wire enable_StoreTxbuff_output/*synthesis keep*/;  



//assign copyRD1 = RD1[7:0]/*synthesis keep*/; 


/***************************************************************
Signals for Peripheral mux
***************************************************************/
wire [DATA_WIDTH-1:0] peripheral_data;
wire [DATA_WIDTH-1:0] Rx_flag_out;
wire [DATA_WIDTH-1:0] Tx_flag_out;
wire Data_selector_uart_or_mem;
wire [DATA_WIDTH-1:0]reserved_output_wb;



assign DataRx_out = DataRx[7:0]/*synthesis keep*/;
assign Rx_flag = Rx_flag_out[0];

//####################     UART controller unit   #######################

UART_controller #(
    .DATA_WIDTH(DATA_WIDTH),
    .UART_Nbit(UART_Nbit),
    .baudrate(baudrate),
    .clk_freq(clk_freq)
)uart_ctrlUnit
(
    .SerialDataIn(SerialDataIn), //it's the input data port 
    .clk(clk), 					/* clk signal */
    .reset(reset), 				/* async signal to reset */	
    .clr_rx_flag(clr_rx_flag),
    .clr_tx_flag(clr_tx_flag),
    .uart_tx(uart_tx_input),        /* Data to transmit */
    .Start_Tx( Start_uartTx_output_wire  ),            /* Input */
    .enable_StoreTxbuff(  enable_StoreTxbuff_output   ),
    /* outputs */
    .UART_data(DataRx),
    .SerialDataOut(SerialDataOut),
    .Rx_flag_out(Rx_flag_out),
    .Tx_flag_out(Tx_flag_out)
);

assign enable_StoreTxbuff_output = sw_inst_detector & enable_StoreTxbuff_fromMem;
//####################     Mux to decide which flag from uart will be read #######################

mux2to1#(.Nbit(DATA_WIDTH))
MUX_UART_bitRxorTx
(
    .mux_sel( see_uartflag_wire ),
    .data1(Rx_flag_out), 		
    .data2(Tx_flag_out), 		
    .Data_out(peripheral_data) 	
);


//####################     GPIO controller unit   #######################
GPIO_controller #(
    .DATA_WIDTH(8),
    .ADDR_WIDTH(32)
)GPIO
(
    .addr_ram(demux_aluout_0),	
    .wdata( Gpio_data_input[7:0] ),
    .clk(clk),
    .reset(reset),
    .enable_sw(sw_inst_detector),
    .gpio_data_out(gpio_data_out)
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
    .address(demux_aluout_0),	
    .swdetect(sw_inst_detector),
    .translated_addr(ALUOut_Translated),
    .MIPS_address(MIPS_RAM_address),
    .aligment_error(aligment_error_RAM_wire),
    .dataBack_Selector_out(dataBack_Selector_wire ),
    .Data_selector_periph_or_mem(Data_selector_uart_or_mem),
    .clr_rx_flag(clr_rx_flag),
    .clr_tx_flag(clr_tx_flag),
    .Start_uart_tx(Start_uartTx_input_wire ),       /* Output from memory controller */
    .enable_StoreTxbuff(enable_StoreTxbuff_fromMem)
);


//####################     DEMUX for writeback operation   #######################


Demux1to4 #(
    .DATA_LENGTH(DATA_WIDTH)
)demux_writeback(
	// Input Ports
	.Demux_Input(B),
	.Selector(dataBack_Selector_wire),
    //output Ports
    .Dataout0(WD_input),
    .Dataout1(uart_tx_input),
    .Dataout2(Gpio_data_input),
    .Dataout3(reserved_output_wb)
);

//####################     Control unit   #######################
ControlUnit CtrlUnit(
    /* Inputs */
    .clk(clk), 						//clk signal
    .reset(reset), 					//async signal to reset 	
    .Opcode(opcode_wire),
    .Funct(funct_wire),
    .Zero(zero),    
    .Start_uart_tx_input(Start_uartTx_input_wire),
    /* Outputs */
    .IorD(IorD_wire),
    .MemWrite(MemWrite_wire),
    .IRWrite(IRWrite_wire),
    .RegDst(RegDst_wire),
    .MemtoReg(MemtoReg_wire),
    .PCWrite(PCWrite_wire),			//@TODO: probably not needed
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
    .flag_sw_out(sw_inst_detector),
    .flag_lw_out(lw_inst_detector),
    .mult_operation_out(demux_aluout_sel),		//this controls if the result is saved in Lo-Hi reg(1) or Reg file (0)
    .mflo_flag_out(mflo_flag),
    .selectPC_out(startPC_wire),
    .see_uartflag(see_uartflag_wire),
    .Start_uart_tx_output( Start_uartTx_output_wire  )	 );

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
MUX_from_PC_to_Mem_Unit
(
    .mux_sel(IorD_wire),				//@Control signal: Instruction or Data selection. 1=from ALU
    //.data1(PC_current), 				//0=Comes from 'PC_Reg'
    .data1(translated_addr_wire), 				//0=Comes from 'PC_Reg'	    
    .data2(ALUOut_Translated), 					//1=From ALUOut signal 
    .Data_out(mux_address_Data_out) 	//this have the Address for Memory input
);


//####################   Memory Unit     ########################
MemoryUnit #(
    .DATA_WIDTH(DATA_WIDTH),     
    .ADDR_WIDTH(8)//bits to address the elements
)MemoryMIPS
(
    /* inputs */
   
    .addr(mux_address_Data_out[7:0]),	//Address to read from ROM
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



//###############   Mux for Write data, input 2 of 4    ##################
mux2to1#(.Nbit(DATA_WIDTH))
MUX_Mem_or_Periph_to_MUXWriteData
(
    .mux_sel(Data_selector_uart_or_mem),				//@Control signal: Instruction or Data selection. 1=from ALU
    .data1(DataMemory), 				//0=Comes from 'PC_Reg'	    
    .data2(DataRx), 					//1=From ALUOut signal 
    .Data_out(  Mem_or_Periph_Data ) 	//this have the Address for Memory input
);

//###############   Mux for Target register, for Register File    ##################


mux4to1#(
    .Nbit(3'd5)
)mux_A3_destination
(
    .mux_sel(RegDst_wire),		/* 1= R type (rd), 0= I type (rt) */
    .data1(rt_wire),
    .data2(rd_wire),
    .data3(5'd31),			/* For writing to $ra (31) register */
    .data4(5'd0),           /* @TODO: for future use */
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

mux4to1 #(
    .Nbit(DATA_WIDTH)
)MUX_to_WriteData_RegFile
(
    .mux_sel(MemtoReg_wire),			//@Control signal:  0=ALU , 1=Memory    
    .data1(demux_aluout_0),		 			//From ALU result	
    .data2( Mem_or_Periph_Data ),				//From Memory: Read data
    .data3(PC_current),             //for JAL instruction, write to Reg 31 ($ra)
    .data4( peripheral_data ),        //Data from peripherals such as UART
    .Data_out(datatoWD3) 				//This have the Address for Memory input
);

//####################  Sign extend Module  ###############
SignExtend_module signExt
(
    //.immediate(immediateData_toextend),
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
    .data1(B),                      //From Register File RD2
    .data2(4),                      //Sum 4 for PC+4
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
    .dataC(ALUResult_tmp) 				//Result	
);


//####################	 Mux Alu/Lo Reg             ######################
mux2to1#(
    .Nbit(DATA_WIDTH)
)mux_ALU_Lo_reg
(
    .mux_sel(mflo_flag),		/* 1= R type (rd), 0= I type (rt) */
    .data1(ALUResult_tmp),
    .data2(lo_data),
    .Data_out(ALUResult)
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


//####################   Demux to pass the Aluout result to RegFile or Lo-Hi registers ######
Demux1to2 #(
    .DATA_LENGTH(DATA_WIDTH)
)demux_aluout(
    // Input Ports
    .Demux_Input(ALUOut),
    //.Demux_Input(ALUResult),
    .Selector(demux_aluout_sel),
    //output Ports
    .Dataout0(demux_aluout_0),
    .Dataout1(demux_aluout_1)
);

//####################   Lo Register for mult operation ####################
Register#(
    .WORD_LENGTH(DATA_WIDTH)
)Lo_Reg
(		
    .clk(clk),
    .reset(reset),
    .enable(demux_aluout_sel),
    .Data_Input(demux_aluout_1), //This comes from 
    .Data_Output(lo_data)//output 
);
//####################   Hi Register for mult operation ####################
/* this stores only the overflow or carry bit from multiplication operation */
Register#(
    .WORD_LENGTH(1)
)Hi_Reg
(		
    .clk(clk),
    .reset(reset),
    .enable(demux_aluout_sel),
    .Data_Input(carry), //This comes from 
    .Data_Output(hi_data)//output 
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
);


//####################   Shift and concatenate jump address module ####################
Shift_Concatenate shiftConcat_mod
(
    .J_address(address_j_wire ), /* shifted <<2 */
    .PC_add(PC_current[31:28]),
    .new_jumpAddr(New_JumpAddress)
);

//####################   MUX to update PC considering Jump instruction  ########################

mux4to1#(
    .Nbit(DATA_WIDTH)
)MUX_to_updatePC_withJump
(
    .mux_sel(flag_Jtype_wire),		//@Control signal: mux selector, 0=normal PC,1 =jump address
    .data1(PC_source_tmp), 			//comes from MUX_for_PC_source
    .data2(New_JumpAddress), 		//New jump address 32 bit long
    .data3(A),						//for JR instruction
    .data4(0),
    //.Data_out(PC_source) 			//Input for ProgramCounter_Reg
    .Data_out(start_PC) 			//Input for ProgramCounter_Reg
);




mux2to1#(
    .Nbit(DATA_WIDTH)
)MUX_Boot_startAddr
(
    .mux_sel(startPC_wire),				//@Control signal: Instruction or Data selection. 1=from ALU    
    .data1(32'h400000), 				//0=Comes from bootloader    
    .data2(start_PC), 					//1=comes from mux to update PC w jump 
    .Data_out(PC_source) 	
);


endmodule
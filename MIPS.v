module MIPS
#(
	parameter DATA_WIDTH=32, 
	parameter ADDR_WIDTH=8,
	parameter NBITS = CeilLog2(DATA_WIDTH),
	//Parameters for UART
	parameter Nbit =8,		//Number of bits to transmit
	parameter baudrate= 9600,	//baudrate to use 
	parameter clk_freq =50000000,		//system clock frequency	

	//Machine states
	parameter IDLE=0,
	parameter FETCH=1,
	parameter DECODE=2,
	parameter EXECUTE=3,	
	parameter WRITE_BACKTOREG=4,
	parameter STORE=5,
	parameter LOAD=6,
	parameter SEND_UART=7
)
(
	//inputs for UART
	
	//input SerialDataIn, //it's the input data port 
	input clk, //clk signal
	input reset, //async signal to reset 	
	//input clr_rx_flag, //to clear the Rx signal	
	
	//outputs for UART	
	//output Parity_error, //when received logic data contains parity errors. Just for pair parity	
	//output SerialDataOut,  //Output for serial data  
		
	output [DATA_WIDTH-1 : 0] RD1, 
	output [DATA_WIDTH-1 : 0] RD2, 

	//Rom signals
	//input start,
	//input PC_en,
	//input IR_write,
	input [2:0]count_state, //7 states
	output  [(DATA_WIDTH-1):0]Mmemory_output
);


////UART signals

//TX
/*
reg Transmit_reg;//signal to indicate the start of transmission . 
wire Transmit_wire; //signal to indicate the start of transmission . 
assign Transmit_wire=Transmit_reg;
reg[Nbit-1:0] DataTx_reg; //Port where Tx data is placed  (tx_data)
wire[Nbit-1:0] DataTx_wire; //Port where Tx data is placed  (tx_data)
assign DataTx_wire=DataTx_reg;

//RX
reg[Nbit-1:0] DataRx_reg; //Port where Rx information is available
wire[Nbit-1:0] DataRx_wire; //Port where Rx information is available
assign DataRx_wire=DataRx_reg;
wire Rx_flag; //indicates a data was received 

UART
#(
	.Nbit(Nbit),		//Number of bits to transmit
	.baudrate(baudrate),	//baudrate to use 
	.clk_freq(clk_freq)	//system clock frequency	
)UART_TX_RX
(	
	//inputs
	.SerialDataIn(SerialDataIn), //it's the input data port 
	.clk(clk), //clk signal
	.reset(reset), //async signal to reset 	
	.clr_rx_flag(clr_rx_flag), //to clear the Rx signal
	.Transmit(Transmit_wire), //signal to indicate the start of transmission . (Ready)
	.DataTx(DataTx_wire), //Port where Tx data is placed  (tx_data)
	
	//outputs	
	//RX
	.DataRx(DataRx_wire), //Port where Rx information is available
	.Rx_flag(Rx_flag) , //indicates a data was received 
	.Parity_error(Parity_error), //when received logic data contains parity errors. Just for pair parity
	//TX
	.SerialDataOut(SerialDataOut)  //Output for serial data  (TxD )	
);
*/
// ######################## UART ends  ########################

///////////////////// Register for PC

/*This will store the program counter*/

/**** Control signal ********/
wire PC_en;   //control signal for the PC flip flop
/**** Control signal ********/

wire [DATA_WIDTH-1:0] PCaddr; //starts on address 0 from rom  (test)
wire [DATA_WIDTH-1:0] mux_address_data0;
Register
#(
	.WORD_LENGTH(DATA_WIDTH)
)Mem_Add_Reg //for PC
(		
	.clk(clk),
	.reset(reset),
	.enable(PC_en),
	.Data_Input(PCaddr), //This comes from the ALU Result after MUX
	.Data_Output(mux_address_data0)//output Program counter update
);
//#################### Register for PC ends ########################

////////////////////// Mux for Program counter 
/*This mux receives the output of the program counter and selects 
 this or the ALUout signal */

/**** Control signal ********/
wire IorD; //0= program counter, fetch, 1=load operation
/**** Control signal ********/

//wire [DATA_WIDTH-1:0] mux_address_data0;
wire [DATA_WIDTH-1:0] ALUOut;
wire [DATA_WIDTH-1:0] mux_address_Data_out;

mux2to1
#(
	.Nbit(DATA_WIDTH)
)MUX_for_PC
(
	.mux_sel(IorD),
	.data1(mux_address_data0), //comes from PC Reg
	.data2(ALUOut), //from ALUout signal 
	.Data_out(mux_address_Data_out) //this have the Address for Memory input
);
//################## Mux for Program counter ends #####################

//////////////// Memory unit 

/**** Control signal ********/
wire we_mem;  /*write enable for the memory (on RAM)*/
wire mem_sel; /*memory selection: 0=ROM, 1=RAM*/
/**** Control signal ********/

/*
wire [(DATA_WIDTH-1):0]Mmemory_output;
*/
wire [(DATA_WIDTH-1):0]wd;  //this will contain the data to write to RAM
wire [DATA_WIDTH-1 : 0] B;
MemoryUnit
#
(
	.DATA_WIDTH(DATA_WIDTH), 
	.ADDR_WIDTH(ADDR_WIDTH)//bits to address the elements
)MemoryMIPS
(
	.addr(mux_address_Data_out),//for rom instruction mem. Program counter
	.wd(B),		//for ram data mem
	.we(we_mem),
	.clk(clk), 
	.mem_sel(mem_sel),	
	.q(Mmemory_output)
);

//#################### Memory unit ends  ########################


///////////////////// Instruction Register for ROM
/**** Control signal ********/
wire IR_write; //enable signal for Instruction register (ROM to reg)
/**** Control signal ********/

wire [DATA_WIDTH-1:0]Instruction_fetched; //signal from FF to Register files to indicate instruction

Register
#(
	.WORD_LENGTH(DATA_WIDTH)
)Reg_forInstruction 
(		
	.clk(clk),
	.reset(reset),
	.enable(IR_write),
	.Data_Input(Mmemory_output),//output from MEMORY (ROM)
	.Data_Output(Instruction_fetched)//output Program counter update
);
//#################### Instruction register ########################

///////////////////// Data Register for RAM

/**** Control signal ********/
wire data_pass_en; //controls the flip flop for data (RAM to reg)
/**** Control signal ********/
wire [DATA_WIDTH-1:0]mux_DatatoA3;

Register
#(
	.WORD_LENGTH(DATA_WIDTH)
)Reg_forData 
(		
	.clk(clk),
	.reset(reset),
	.enable(data_pass_en),//controls the flip flop for data (RAM to reg)
	.Data_Input(Mmemory_output), //output from MEMORY (RAM)
	.Data_Output(mux_DatatoA3)			//
);
//#################### Data Register ends   ########################

////////////////////// Mux for RAM Data to WD3

/**** Control signal ********/
wire memtoReg_sel; //This will select the correct data for WD3
/**** Control signal ********/
wire [DATA_WIDTH-1:0]datatoWD3;

mux2to1
#(
	.Nbit(DATA_WIDTH)
)mux_RAMtoA3
(
	.mux_sel(memtoReg_sel),
	.data1(ALUOut),
	.data2(mux_DatatoA3), 
	.Data_out(datatoWD3)
);
//#################### Mux for Data to A3   ########################

/////////// address Preparation Module
/*Control signals: these go to the control unit*/
wire [5:0] opcode;
//reg [5:0] opcode_reg;
//assign opcode = opcode_reg;
wire [5: 0]funct; //select the function
//reg  [5: 0]funct_reg; //select the function
//assign funct =funct_reg ;

/*Control signals: these go to the control unit*/
wire [4 : 0]rs;		 //source 1
wire [4 : 0]rt;		 //source 2
wire [4 : 0]rt_im;		 //Destination: 20:16 bit (immediate)
wire [4 : 0]rd;		  //Destination: 15:11 bit (R type)
wire [15:0] immediate_data;
wire [4:0]shamt;

addres_preparation add_prep
(	
	.Mmemory_output(Instruction_fetched),	//rom fetched instruction content
	.opcode(opcode),  //Opcode  value
	.funct(funct),    //function value
	.rs(rs),		 //source 1, for both R type and I type
	.rt(rt),		 //source 2, on R type is a source, on I type is a target
	.rt_im(rt_im),		 //Destination: 20:16 bit (immediate)
	.rd(rd),		  //Destination: 15:11 bit (R type)
	//.shamt(shamt),
	.immediate_data(immediate_data)
);
//####################  address Preparation ENDS

////////////////////  Mux from instruction to A3
//Allows to select the correct destination depending on the instruction type
/**** Control signal ********/
wire destination_indicator;
//wire RegDst; //mux selector for A3(destination), 0=rt (i), 1=rd (r)
/**** Control signal ********/

wire [4:0]mux_A3out;
mux2to1
#(
	.Nbit(3'd5)
)mux_FetchedInst_toA3_destination
(
	//.mux_sel(RegDst),
	.mux_sel(destination_indicator),
	.data1(rt),
	.data2(rd),
	.Data_out(mux_A3out)
);
//#################### Mux from instruction to A3 ENDS

///////////////////// Register File 
/**** Control signal ********/
wire Reg_Write;// enable to write on Register file
/**** Control signal ********/

/*
wire [4 : 0]A3;
wire [DATA_WIDTH-1 : 0] WD_RF;
wire [DATA_WIDTH-1 : 0] RD1;
wire [DATA_WIDTH-1 : 0] RD2;
*/

/////////////////////  Register File
Register_File
#(
	.WORD_LENGTH(DATA_WIDTH),	
	.NBITS(5)
)RegisterFile_Unit
(
	.clk(clk),
	.reset(reset),
	.Read_Reg1(rs),//Rs-> 25:21
	.Read_Reg2(rt),//Rt-> 20:16
	.Write_Reg(mux_A3out),//(A3)Register destination; bits I->20:16 ; R->15:11
	.Write_Data(datatoWD3),  //(WD3) data to write 
	.Write(Reg_Write),//WE3 enable signal
	.Read_Data1(RD1),
	.Read_Data2(RD2)	
);
 //####################  Register file ends



////////////////  Flip flop for Data Read A 

/*this register will store the content of Register specified by the A3 address
For execution process*/

/**** Control signal ********/
wire RD1_FF_en; //controls the flip flop from Reg to SrcA ALU
/**** Control signal ********/

wire [DATA_WIDTH-1 : 0] A;
Register
#(
	.WORD_LENGTH(DATA_WIDTH)
)FromRegtoSrcA_FF
(		
	.clk(clk),
	.reset(reset),
	.enable(RD1_FF_en),//controls the flip flop from Reg to SrcA ALU
	.Data_Input(RD1), 
	.Data_Output(A)		
);
//#################### Flip flop for Data Read A -ENDS   ########################

////////////////  Flip flop for Data Read B

/*this register will store the content of Register specified by the A3 address
For execution process*/

/**** Control signal ********/
wire RD2_FF_en; //controls the flip flop from Reg to SrcB ALU
/**** Control signal ********/


Register
#(
	.WORD_LENGTH(DATA_WIDTH)
)FromRegtoSrcB_FF 
(		
	.clk(clk),
	.reset(reset),
	.enable(RD2_FF_en),//controls the flip flop from Reg to SrcA ALU
	.Data_Input(RD2), 
	.Data_Output(B)		
);
//#################### Flip flop for Data Read B -ENDS   ########################

/////////// Mux 4 to 1 for ALU 

/**** Control signal ********/
wire [1:0]sel_muxALU_srcB; //allows to select the operand for getting srcB number
/**** Control signal ********/

wire [DATA_WIDTH-1:0] SrcB;
wire [DATA_WIDTH-1:0] sign_extended_out;
localparam zero=32'd0;

mux4to1
#(
	.Nbit(DATA_WIDTH)
)mux4_1_forALU
(
	.mux_sel(sel_muxALU_srcB),
	.data1(B),
	.data2(1), 
	.data3(sign_extended_out),
	.data4(zero), //This should be shift<<2
	.Data_out(SrcB)
);
//####################  Mux 4 to 1 for ALU -ENDS  #################### 

///////////// Sign extend module 

SignExtend_module signExt
(
	.immediate(immediate_data),
	.extended_sign_out(sign_extended_out)
);
//####################   sign extend - END #################### 


////////////////////   MUX to update SrcA 

/**** Control signal ********/
wire ALUSrcA;  //allows to select either PC or data from A
/**** Control signal ********/

wire [DATA_WIDTH-1 : 0] SrcA;
mux2to1
#(
	.Nbit(DATA_WIDTH)
)MUX_to_updatePC
(
	.mux_sel(ALUSrcA),
	.data1(mux_address_data0), //comes from PC Reg
	.data2(A), //from ALUout signal 
	.Data_out(SrcA) //this have the Address for Memory input
);
//####################   MUX to update SrcA  ########################


////////////////////   ALU declaration

/**** Control signal ********/
wire [3:0]ALUControl; //Selects addition operation (010b)
/**** Control signal ********/


wire carry;
wire [DATA_WIDTH-1 : 0]ALUResult;
wire [DATA_WIDTH-1:0] mux_address_data1;

ALU
#(
	.WORD_LENGTH(DATA_WIDTH)
)alu_unit
(
	.dataA(SrcA),
	.dataB(SrcB),
	.control(ALUControl),
	.carry(carry),
	.dataC(ALUResult) //result	
);
//####################  ALU ends  ########################

////////////////////   ALU Flip flop to the ALUout
/**** Control signal ********/
wire ALUresult_en; //allows writing to ALU register 
/**** Control signal ********/

Register
#(
	.WORD_LENGTH(DATA_WIDTH)
)Mem_forALUOut
(		
	.clk(clk),
	.reset(reset),
	.enable(ALUresult_en),
	.Data_Input(ALUResult), //This comes from the ALU Result after MUX
	.Data_Output(ALUOut)//output Program counter update
);

//####################   ALU Flip flop to the ALUout ENDS ####################


////////////////////   MUX to update Program Counter (PC)
//This mux is at the end of the datapath, after ALUOut

/**** Control signal ********/
wire PCSrc;  //allows to select either PC source, 0=ALUResult, 1=ALUOut
/**** Control signal ********/

mux2to1
#(
	.Nbit(DATA_WIDTH)
)MUX_for_PC_source
(
	.mux_sel(PCSrc),
	.data1(ALUResult), //comes from PC Reg
	.data2(ALUOut), //from ALUout signal 
	.Data_out(PCaddr) //this have the Address for Memory input
);
//####################   MUX to update (PC)  ########################


//////////////////// MACHINE STATE 

//register definitions for the control

		//************* program counter
		reg PC_en_reg;   //control signal for the PC flip flop
		assign PC_en = PC_en_reg ;

		reg IorD_reg; /*selects the address: 0= program counter(fetch), 1=load operation*/
		assign IorD = IorD_reg ;		
		reg we_mem_reg;  /*write enable for the memory (on RAM)*/
		reg mem_sel_reg; /*memory selection: 0=ROM, 1=RAM*/
		assign we_mem= we_mem_reg;
		assign mem_sel= mem_sel_reg;		
		reg IR_write_reg; /*enable signal for Instruction Flip flop (ROM to reg)*/
		assign IR_write =IR_write_reg;		
		reg data_pass_en_reg; /*controls the flip flop for data (RAM to reg)*/
		assign data_pass_en =data_pass_en_reg ;		
		reg memtoReg_sel_reg;
		assign memtoReg_sel = memtoReg_sel_reg;
		reg RegDst_reg; //mux selector for A3(destination), 0=rt (imm), 1=rd (r)
		//assign RegDst = RegDst_reg ;		
		reg Reg_Write_reg;// enable to write on Register file
		assign Reg_Write = Reg_Write_reg;		
		reg RD1_FF_en_reg; //controls the flip flop from Reg to SrcA ALU (execution)
		assign RD1_FF_en = RD1_FF_en_reg ;		
		reg RD2_FF_en_reg; //controls the flip flop from Reg to SrcB ALU (execution)
		assign RD2_FF_en = RD2_FF_en_reg ;		
		reg [1:0]sel_muxALU_srcB_reg; //allows to select the operand for getting srcB number
		assign sel_muxALU_srcB = sel_muxALU_srcB_reg;
		reg [3:0]ALUControl_reg; //Selects operation
		assign ALUControl = ALUControl_reg;
		reg ALUSrcA_reg;  //allows to select either PC (0) or data from A (1)
		assign ALUSrcA =ALUSrcA_reg ;		
		reg ALUresult_en_reg; //allows writing to ALU register 
		assign ALUresult_en = ALUresult_en_reg;
		reg PCSrc_reg;  //allows to select either PC source, 0=ALUResult, 1=ALUOut
		assign PCSrc =PCSrc_reg ;

reg [2:0]state; //5 states
wire flag_sw;
wire flag_lw;
//reg [2:0]count_state; //5 states

always @(posedge clk or negedge reset) begin
	if (reset==1'b0) begin
		state <= IDLE;	
		//count_state=0;	
	end	else begin

		case(state)
			IDLE: //0
			begin
				if(count_state==3'b1)
					state<=FETCH;
				else if(count_state==3'b0)
					state<=IDLE;
			end
			FETCH:
			begin
				if(count_state==3'd2)
					state<=DECODE;
				else if(state==3'd1)
					state<=FETCH;
			end
			DECODE:
			begin
				if(count_state==3'd3)
					state<=EXECUTE;
				else if(state==3'd2)
					state <= DECODE;
			end

			EXECUTE:
			begin
				if(flag_sw==1'b1)
					state<=WRITE_BACKTOREG;
				else if(state==3'd3)
					state <= EXECUTE;
			end
			WRITE_BACKTOREG:
			begin
				if(count_state==3'd1)
					state<=FETCH;
				else if(state==3'd4)
					state <= WRITE_BACKTOREG;
			end
			STORE:
			begin
				if(count_state==3'd6)
					state<=LOAD;
				else if(state==3'd5)
					state <= STORE;
			end

			LOAD:
			begin
				
			end
			
			SEND_UART:
			begin
				
			end

		endcase 
	end
end



//assign destination_reg_indicator_wire = destination_reg_indicator;



wire [3:0] ALUoperation;
wire [1:0]mux4selector;
wire controlSrcA;

decode_instruction decoder_module
(
	.opcode_reg(opcode),
	.funct_reg(funct),
	.destination_indicator(destination_indicator),
	.ALUControl(ALUoperation),
	.flag_sw(flag_sw),
	.flag_lw(flag_lw),
	.mux4selector(mux4selector),
	.controlSrcA(controlSrcA)
);


always @(state) begin
	case(state)
		IDLE:
		begin
			PC_en_reg=  0;   //control signal for the PC flip flop		
			IorD_reg=  0; /*selects the address: 0= program counter(fetch), 1=load operation*/		
			we_mem_reg= 0 ;  /*write enable for the memory (on RAM)*/
			mem_sel_reg= 0 ; /*memory selection: 0=ROM, 1=RAM*/		
			IR_write_reg= 0 ; /*enable signal for Instruction Flip flop (ROM to reg)*/		
			data_pass_en_reg= 0 ; /*controls the flip flop for data (RAM to reg)*/		
			memtoReg_sel_reg=  0;	/*This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
			//this does not matter 		
			RegDst_reg=  0; //mux selector for A3(destination), 0=rt (imm), 1=rd (r)		
			Reg_Write_reg= 0 ;// enable to write on Register file		
			RD1_FF_en_reg=  0; //controls the flip flop from Reg to SrcA ALU (execution)		
			RD2_FF_en_reg=  0; //controls the flip flop from Reg to SrcB ALU (execution)		
			sel_muxALU_srcB_reg= 0 ; //allows to select the operand for getting srcB number		
			ALUControl_reg=  0; //Selects ALU operation		
			ALUSrcA_reg= 0 ;  //allows to select either PC (0) or data from A (1)		
			ALUresult_en_reg= 0 ; //allows writing to ALU register 		
			PCSrc_reg= 0 ;  //allows to select either PC source, 0=ALUResult, 1=ALUOut		
			
	
		end
		FETCH:
		begin

			PC_en_reg=  1;   //control signal for the PC flip flop		
			IorD_reg= 0 ; /*selects the address: 0= program counter(fetch), 1=load operation*/		
			we_mem_reg= 0 ;  /*write enable for the memory (on RAM)*/
			mem_sel_reg= 0; /*memory selection: 0=ROM, 1=RAM*/		
			IR_write_reg= 1 ; /*enable signal for Instruction Flip flop (ROM to reg)*/		
			data_pass_en_reg= 0 ; /*controls the flip flop for data (RAM to reg)*/		
			///this does not matter 		
			memtoReg_sel_reg= 0 ;	/*This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
			//this does not matter 		
			RegDst_reg= 0 ; //mux selector for A3(destination), 0=rt (imm), 1=rd (r)		
			Reg_Write_reg= 0;// enable to write on Register file		
			RD1_FF_en_reg= 0 ; //controls the flip flop from Reg to SrcA ALU (execution)		
			RD2_FF_en_reg= 0 ; //controls the flip flop from Reg to SrcB ALU (execution)		
			sel_muxALU_srcB_reg= 2'd1 ; //allows to select the operand for getting srcB number		
			ALUControl_reg= 4'd2; //Selects ALU operation		
			
			ALUSrcA_reg= 0 ;  //allows to select either PC (0) or data from A (1)		
			//ALUSrcA_reg=0  ;  //allows to select either PC (0) or data from A (1)		
			ALUresult_en_reg= 0 ; //allows writing to ALU register 		
			PCSrc_reg= 0 ;  //allows to select either PC source, 0=ALUResult, 1=ALUOut
			
		end
		DECODE:
		begin
			PC_en_reg= 0 ;   //control signal for the PC flip flop		
			//this does not matter
			IorD_reg= 0 ; /*selects the address: 0= program counter(fetch), 1=load operation*/		
			
			we_mem_reg= 0 ;  /*write enable for the memory (on RAM)*/
			mem_sel_reg= 0 ; /*memory selection: 0=ROM, 1=RAM*/		
			IR_write_reg= 0 ; /*enable signal for Instruction Flip flop (ROM to reg)*/		
			//this does not matter
			data_pass_en_reg= 0 ; /*controls the flip flop for data (RAM to reg)*/		
			//this does not matter
			memtoReg_sel_reg= 0;	/*This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/	
			
			RegDst_reg= destination_indicator; //mux selector for A3(destination), 0=rt (imm), 1=rd (r)		
			Reg_Write_reg= 0;// enable to write on Register file		
			//Not storing the values yet 
			RD1_FF_en_reg= 1; //controls the flip flop from Reg to SrcA ALU (execution)		
			//Not storing the values yet 
			RD2_FF_en_reg=  1; //controls the flip flop from Reg to SrcB ALU (execution)		
				//destination--> 0=rt (imm), 1=rd (r)		
			//if I type -> the mux should work with the sign extended number 
			//If R type -> the mux should work with the data from B register 
			sel_muxALU_srcB_reg= mux4selector; //allows to select the operand for getting srcB number		

			//it does not matter
			ALUControl_reg= ALUoperation; //Selects addition operation from decoding
			//it does not matter
			//ALUSrcA_reg=  controlSrcA;
			ALUSrcA_reg= 0 ;  //allows to select either PC (0) or data from A (1)		
			//it does not matter
			ALUresult_en_reg= 1 ; //allows writing to ALU register 		
			//it does not matter
			PCSrc_reg=  0;  //allows to select either PC source, 0=ALUResult, 1=ALUOut
		end
		EXECUTE:
		begin
		//it does not matter
			PC_en_reg= 0 ;   //control signal for the PC flip flop		
		//it does not matter
			IorD_reg=  0; /*selects the address: 0= program counter(fetch), 1=load operation*/		
		//it does not matter			
			we_mem_reg= 0 ;  /*write enable for the memory (on RAM)*/
		//it does not matter
			mem_sel_reg= 0; /*memory selection: 0=ROM, 1=RAM*/		
		//it does not matter
			IR_write_reg=  0; /*enable signal for Instruction Flip flop (ROM to reg)*/		
		//it does not matter
			data_pass_en_reg=0 ; /*controls the flip flop for data (RAM to reg)*/		
		//it does not matter
			memtoReg_sel_reg=0 ;	/*This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/		
		//it does not matter
			RegDst_reg= destination_indicator; //mux selector for A3(destination), 0=rt (imm), 1=rd (r)		
		//it does not matter
			Reg_Write_reg= 0;// enable to write on Register file		
		//it does not matter
			RD1_FF_en_reg= 1; //controls the flip flop from Reg to SrcA ALU (execution)		
			RD2_FF_en_reg= 1; //controls the flip flop from Reg to SrcB ALU (execution)		
		
			//destination--> 0=rt (imm), 1=rd (r)		
			//if I type -> the mux should work with the sign extended number 
			//If R type -> the mux should work with the data from B register 
			sel_muxALU_srcB_reg= mux4selector; //allows to select the operand for getting srcB number		

		/**** The operation was chosen on Decode stage*/
			ALUControl_reg= ALUoperation  ; //Selects operation		
		//selects A
			//ALUSrcA_reg=  controlSrcA;  //allows to select either PC (0) or data from A (1)		
			ALUSrcA_reg=  1;  //allows to select either PC (0) or data from A (1)		
			ALUresult_en_reg=1 ; //allows writing to ALU register 		
			PCSrc_reg=  1;  //allows to select either PC source, 0=ALUResult, 1=ALUOut
		end
		WRITE_BACKTOREG:
		begin
			//it does not matter
			PC_en_reg=  0;   //control signal for the PC flip flop		
			//it does not matter
			IorD_reg= 0 ; /*selects the address: 0= program counter(fetch), 1=load operation*/		
			//it does not matter
			we_mem_reg= 0 ;  /*write enable for the memory (on RAM)*/
			mem_sel_reg= 0; /*memory selection: 0=ROM, 1=RAM*/		
			IR_write_reg= 0 ; /*enable signal for Instruction Flip flop (ROM to reg)*/		
			data_pass_en_reg= 0 ; /*controls the flip flop for data (RAM to reg)*/		
			///select from ALU 		
			memtoReg_sel_reg= 0 ;	/*This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
			//this does not matter 		
			RegDst_reg= destination_indicator ; //mux selector for A3(destination), 0=rt (imm), 1=rd (r)		
			Reg_Write_reg= 1;// enable to write on Register file		
			RD1_FF_en_reg= 0 ; //controls the flip flop from Reg to SrcA ALU (execution)		
			RD2_FF_en_reg= 0 ; //controls the flip flop from Reg to SrcB ALU (execution)		
			//it does not matter
			sel_muxALU_srcB_reg= 2'd0 ; //allows to select the operand for getting srcB number		
			//it does not matter
			ALUControl_reg= 4'd2; //Selects ALU operation		
			//it does not matter
			
			//ALUSrcA_reg= controlSrcA ;  //allows to select either PC (0) or data from A (1)		
			ALUSrcA_reg= 0 ;  //allows to select either PC (0) or data from A (1)		

			ALUresult_en_reg= 0 ; //allows writing to ALU register 		
			//it does not matter
			PCSrc_reg= 0 ;  //allows to select either PC source, 0=ALUResult, 1=ALUOut
			
		end
		STORE:
		begin
			PC_en_reg=  0;   //control signal for the PC flip flop		
			IorD_reg=  0; /*selects the address: 0= program counter(fetch), 1=load operation*/		
			we_mem_reg= 0 ;  /*write enable for the memory (on RAM)*/
			mem_sel_reg= 0 ; /*memory selection: 0=ROM, 1=RAM*/		
			IR_write_reg= 0 ; /*enable signal for Instruction Flip flop (ROM to reg)*/		
			data_pass_en_reg= 0 ; /*controls the flip flop for data (RAM to reg)*/		
			memtoReg_sel_reg=  0;	/*This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
			RegDst_reg= destination_indicator ; //mux selector for A3(destination), 0=rt (imm), 1=rd (r)		
			//this does not matter 		
			RegDst_reg=  0; //mux selector for A3(destination), 0=rt (imm), 1=rd (r)		
			Reg_Write_reg= 0 ;// enable to write on Register file		
			RD1_FF_en_reg=  0; //controls the flip flop from Reg to SrcA ALU (execution)		
			RD2_FF_en_reg=  0; //controls the flip flop from Reg to SrcB ALU (execution)		
			sel_muxALU_srcB_reg= 0 ; //allows to select the operand for getting srcB number		
			ALUControl_reg=  0; //Selects ALU operation		
			ALUSrcA_reg= 0 ;  //allows to select either PC (0) or data from A (1)		
			ALUresult_en_reg= 0 ; //allows writing to ALU register 		
			PCSrc_reg= 0 ;  //allows to select either PC source, 0=ALUResult, 1=ALUOut
			
		end

		LOAD:
		begin
			PC_en_reg=  0;   //control signal for the PC flip flop		
			IorD_reg=  0; /*selects the address: 0= program counter(fetch), 1=load operation*/		
			we_mem_reg= 0 ;  /*write enable for the memory (on RAM)*/
			mem_sel_reg= 0 ; /*memory selection: 0=ROM, 1=RAM*/		
			IR_write_reg= 0 ; /*enable signal for Instruction Flip flop (ROM to reg)*/		
			data_pass_en_reg= 0 ; /*controls the flip flop for data (RAM to reg)*/		
			memtoReg_sel_reg=  0;	/*This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
			RegDst_reg= destination_indicator ; //mux selector for A3(destination), 0=rt (imm), 1=rd (r)		
			//this does not matter 		
			RegDst_reg=  0; //mux selector for A3(destination), 0=rt (imm), 1=rd (r)		
			Reg_Write_reg= 0 ;// enable to write on Register file		
			RD1_FF_en_reg=  0; //controls the flip flop from Reg to SrcA ALU (execution)		
			RD2_FF_en_reg=  0; //controls the flip flop from Reg to SrcB ALU (execution)		
			sel_muxALU_srcB_reg= 0 ; //allows to select the operand for getting srcB number		
			ALUControl_reg=  0; //Selects ALU operation		
			ALUSrcA_reg= 0 ;  //allows to select either PC (0) or data from A (1)		
			ALUresult_en_reg= 0 ; //allows writing to ALU register 		
			PCSrc_reg= 0 ;  //allows to select either PC source, 0=ALUResult, 1=ALUOut
			
		end
		
		SEND_UART:
		begin
			PC_en_reg=  0;   //control signal for the PC flip flop		
			IorD_reg=  0; /*selects the address: 0= program counter(fetch), 1=load operation*/		
			we_mem_reg= 0 ;  /*write enable for the memory (on RAM)*/
			mem_sel_reg= 0 ; /*memory selection: 0=ROM, 1=RAM*/		
			IR_write_reg= 0 ; /*enable signal for Instruction Flip flop (ROM to reg)*/		
			data_pass_en_reg= 0 ; /*controls the flip flop for data (RAM to reg)*/		
			memtoReg_sel_reg=  0;	/*This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
			RegDst_reg= destination_indicator ; //mux selector for A3(destination), 0=rt (imm), 1=rd (r)		
			//this does not matter 		
			RegDst_reg=  0; //mux selector for A3(destination), 0=rt (imm), 1=rd (r)		
			Reg_Write_reg= 0 ;// enable to write on Register file		
			RD1_FF_en_reg=  0; //controls the flip flop from Reg to SrcA ALU (execution)		
			RD2_FF_en_reg=  0; //controls the flip flop from Reg to SrcB ALU (execution)		
			sel_muxALU_srcB_reg= 0 ; //allows to select the operand for getting srcB number		
			ALUControl_reg=  0; //Selects ALU operation		
			ALUSrcA_reg= 0 ;  //allows to select either PC (0) or data from A (1)		
			ALUresult_en_reg= 0 ; //allows writing to ALU register 		
			PCSrc_reg= 0 ;  //allows to select either PC source, 0=ALUResult, 1=ALUOut			
		end
		default: 
		begin
			ALUControl_reg=  0; //Selects ALU operation		
			RegDst_reg= destination_indicator ; //mux selector for A3(destination), 0=rt (imm), 1=rd (r)		
		end
	endcase
end
////#################### MACHINE STATE END ####################


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

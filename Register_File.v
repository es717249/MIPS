 /*******************************************************************
* Name:
*	Register_File.v
* Description:
* 	This module generates a bank of 32 registers which can have n bits 

* Parameters:
	
	parameter WORD_LENGTH: The number of bits of the registers
	parameter NBITS: the number of needed bits for the address registers

* Inputs:
	
	input clk:  clock signal
	input reset: reset signal
	input [NBITS-1 : 0]Read_Reg1: controls the selection of the register to read on the Read Data 1 output
	input [NBITS-1 : 0]Read_Reg2: controls the selection of the register to read on the Read Data 2 output
	input [NBITS-1 : 0]Write_Reg: controls the selection of the register to write
	input [WORD_LENGTH-1 : 0] Write_Data: data to write 
	input Write: enables the writing operation

* Outputs:
	output [WORD_LENGTH-1 : 0] Read_Data1: output Data port 1
	output [WORD_LENGTH-1 : 0] Read_Data2: output Data port 2

* Versión:  
*	1.0
* Author: 
*	Nestor Damian Garcia Hernandez
*	Diego Gonźalez Avalos
* Fecha: 
*	19/10/2017
*********************************************************************/

module Register_File

#(
	parameter WORD_LENGTH =32,
	parameter NBITS = CeilLog2(WORD_LENGTH)
)
(
	input clk,
	input reset,
	input [NBITS-1 : 0]Read_Reg1, //which reg will be read
	input [NBITS-1 : 0]Read_Reg2, //which reg will be read
	input [NBITS-1 : 0]Write_Reg, //Target register to write 
	input [WORD_LENGTH-1 : 0] Write_Data, //which data will be written
	input Write, 				//enable signal to write . 1=enable, 0=disable
	
	output [WORD_LENGTH-1 : 0] Read_Data1, //data output 1
	output [WORD_LENGTH-1 : 0] Read_Data2  //data output 2
	
);

//Array of Wires for the demultiplexer 
wire DemuxtoReg [WORD_LENGTH-1 : 0];

//Array of Wires for the multiplexer 
wire [WORD_LENGTH-1 : 0]RegtoMux [WORD_LENGTH-1 : 0];


//Demultiplexer to receive the information 
Demux1to32
#(
 .WORD_LENGTH(WORD_LENGTH)
)
Demux
(
 .Demux_Input(Write),
 .Selector(Write_Reg), 
 .Data_0(DemuxtoReg[0]),
 .Data_1(DemuxtoReg[1]),
 .Data_2(DemuxtoReg[2]),
 .Data_3(DemuxtoReg[3]),
 .Data_4(DemuxtoReg[4]),
 .Data_5(DemuxtoReg[5]),
 .Data_6(DemuxtoReg[6]),
 .Data_7(DemuxtoReg[7]),
 .Data_8(DemuxtoReg[8]),
 .Data_9(DemuxtoReg[9]),
 .Data_10(DemuxtoReg[10]),
 .Data_11(DemuxtoReg[11]),
 .Data_12(DemuxtoReg[12]),
 .Data_13(DemuxtoReg[13]),
 .Data_14(DemuxtoReg[14]),
 .Data_15(DemuxtoReg[15]),
 .Data_16(DemuxtoReg[16]),
 .Data_17(DemuxtoReg[17]),
 .Data_18(DemuxtoReg[18]),
 .Data_19(DemuxtoReg[19]),
 .Data_20(DemuxtoReg[20]),
 .Data_21(DemuxtoReg[21]),
 .Data_22(DemuxtoReg[22]),
 .Data_23(DemuxtoReg[23]),
 .Data_24(DemuxtoReg[24]),
 .Data_25(DemuxtoReg[25]),
 .Data_26(DemuxtoReg[26]),
 .Data_27(DemuxtoReg[27]),
 .Data_28(DemuxtoReg[28]),
 .Data_29(DemuxtoReg[29]),
 .Data_30(DemuxtoReg[30]),
 .Data_31(DemuxtoReg[31])
);

//Multiplexer for the Read register number 1
Mux32to1
#(
 .WORD_LENGTH(WORD_LENGTH)
)
Mux_Read_Register_Number1
(
 .Selector(Read_Reg1), 
 .Data_0(RegtoMux[0]),
 .Data_1(RegtoMux[1]),
 .Data_2(RegtoMux[2]),
 .Data_3(RegtoMux[3]),
 .Data_4(RegtoMux[4]),
 .Data_5(RegtoMux[5]),
 .Data_6(RegtoMux[6]),
 .Data_7(RegtoMux[7]),
 .Data_8(RegtoMux[8]),
 .Data_9(RegtoMux[9]),
 .Data_10(RegtoMux[10]),
 .Data_11(RegtoMux[11]),
 .Data_12(RegtoMux[12]),
 .Data_13(RegtoMux[13]),
 .Data_14(RegtoMux[14]),
 .Data_15(RegtoMux[15]),
 .Data_16(RegtoMux[16]),
 .Data_17(RegtoMux[17]),
 .Data_18(RegtoMux[18]),
 .Data_19(RegtoMux[19]),
 .Data_20(RegtoMux[20]),
 .Data_21(RegtoMux[21]),
 .Data_22(RegtoMux[22]),
 .Data_23(RegtoMux[23]),
 .Data_24(RegtoMux[24]),
 .Data_25(RegtoMux[25]),
 .Data_26(RegtoMux[26]),
 .Data_27(RegtoMux[27]),
 .Data_28(RegtoMux[28]),
 .Data_29(RegtoMux[29]),
 .Data_30(RegtoMux[30]),
 .Data_31(RegtoMux[31]),
 .Mux_Output(Read_Data1)
);

//Multiplexer for the Read register number 2
Mux32to1
#(
 .WORD_LENGTH(WORD_LENGTH)
)
Mux_Read_Register_Number2
(
 .Selector(Read_Reg2), 
 .Data_0(RegtoMux[0]),
 .Data_1(RegtoMux[1]),
 .Data_2(RegtoMux[2]),
 .Data_3(RegtoMux[3]),
 .Data_4(RegtoMux[4]),
 .Data_5(RegtoMux[5]),
 .Data_6(RegtoMux[6]),
 .Data_7(RegtoMux[7]),
 .Data_8(RegtoMux[8]),
 .Data_9(RegtoMux[9]),
 .Data_10(RegtoMux[10]),
 .Data_11(RegtoMux[11]),
 .Data_12(RegtoMux[12]),
 .Data_13(RegtoMux[13]),
 .Data_14(RegtoMux[14]),
 .Data_15(RegtoMux[15]),
 .Data_16(RegtoMux[16]),
 .Data_17(RegtoMux[17]),
 .Data_18(RegtoMux[18]),
 .Data_19(RegtoMux[19]),
 .Data_20(RegtoMux[20]),
 .Data_21(RegtoMux[21]),
 .Data_22(RegtoMux[22]),
 .Data_23(RegtoMux[23]),
 .Data_24(RegtoMux[24]),
 .Data_25(RegtoMux[25]),
 .Data_26(RegtoMux[26]),
 .Data_27(RegtoMux[27]),
 .Data_28(RegtoMux[28]),
 .Data_29(RegtoMux[29]),
 .Data_30(RegtoMux[30]),
 .Data_31(RegtoMux[31]),
 .Mux_Output(Read_Data2)
);

genvar i; //auxiliary variable for the cycle

//Generation of registers which will store the information 
generate
	for(i=0;i<=WORD_LENGTH-1; i = i + 1)begin:Register

		Register
		RegisterUnit
		(
			// Input Ports
			.clk(clk),
			.reset(reset),
			.enable(DemuxtoReg[i]),
			.Data_Input(Write_Data),
			
			// Output Ports
			.Data_Output(RegtoMux[i])

		);
	end
endgenerate


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

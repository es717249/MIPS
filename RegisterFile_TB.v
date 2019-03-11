module RegisterFile_TB;

	parameter WORD_LENGTH =32;
	parameter NBITS = CeilLog2(WORD_LENGTH);
	
	reg clk=0;
	reg reset;
	reg [NBITS-1 : 0]Read_Reg1;
	reg [NBITS-1 : 0]Read_Reg2;
	reg [NBITS-1 : 0]Write_Reg;
	reg [WORD_LENGTH-1 : 0] Write_Data;
	reg Write;
	
	wire[WORD_LENGTH-1 : 0] Read_Data1;
	wire [WORD_LENGTH-1 : 0] Read_Data2;
	
	
	Register_File
	#(
		.WORD_LENGTH(WORD_LENGTH)
	)DUV(
		.clk(clk),
		.reset(reset),
		.Read_Reg1(Read_Reg1),
		.Read_Reg2(Read_Reg2),
		.Write_Reg(Write_Reg),
		.Write_Data(Write_Data),
		.Write(Write),
		.Read_Data1(Read_Data1),
		.Read_Data2(Read_Data2)		
	);
	
	initial begin
		forever #1 clk=!clk;
	end
	
	initial begin
		#0 reset =0;
		#0 Write =0;

		#4 reset =1;			

		//#0 Write =1;
		//#0 Write_Data =32'hFEFEFEFE;
		//#0 Write_Reg = 5'd5; //write to Reg #5 out of 32
		//#2	Write=1;		//disable writing

		//#5 Read_Reg1 = 5'd4; //By reading reg 4 we should expect 0 since we haven't saved anything		
		//#0 Read_Reg2 = 5'd3; //By reading reg 3 we should expect 0 since we haven't saved anything

		//#5 Read_Reg2 = 5'd5; //By reading reg 5 we should expect the stored value
		//#0 Read_Reg1 = 5'd5; //By reading reg 5 we should expect the stored value

		//#5 Write_Data =32'hABABABAB;
		//#0 Write =1;
		//#0 Write_Reg = 5'd4; //write to Reg #5 out of 32
		//#0 Read_Reg1 = 5'd4;	//read a diff reg
		//#0 Read_Reg2 = 5'd5;//read a diff reg

		//#3 Write_Data =32'hCECECECE;
		//#0 Read_Reg1 = 5;
		//#0 Write_Reg = 5'd3; //write to Reg #5 out of 32
		//#2 Write =0;

		//#3 Read_Reg1 = 5'd3;	//read stored info
		//#4 Read_Reg2 = 5'd3; //read stored info
		
		//Let's write to every register a value
		
		//write a 0 to reg 0
		#0 Write =1; 
		#0 Write_Data =32'd0; 
		#0 Write_Reg = 5'd0;
		
		#4 Write =0;
		
		//write a 1 to reg 1
		#1 Write =1;
		#0 Write_Data =32'd1; 
		#0 Write_Reg = 5'd1;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd2; 
		#0 Write_Reg = 5'd2;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd3; 
		#0 Write_Reg = 5'd3;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd4; 
		#0 Write_Reg = 5'd4;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd5; 
		#0 Write_Reg = 5'd5;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd6; 
		#0 Write_Reg = 5'd6;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd7; 
		#0 Write_Reg = 5'd7;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd8; 
		#0 Write_Reg = 5'd8;
		
		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd9; 
		#0 Write_Reg = 5'd9;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd10; 
		#0 Write_Reg = 5'd10;

		#4 Write =0;

		#0 Write =1; 
		#0 Write_Data =32'd11; 
		#0 Write_Reg = 5'd11;

		#4 Write =0;
		//write a 1 to reg 1
		#1 Write =1;
		#0 Write_Data =32'd12; 
		#0 Write_Reg = 5'd12;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd13; 
		#0 Write_Reg = 5'd13;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd14; 
		#0 Write_Reg = 5'd14;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd15; 
		#0 Write_Reg = 5'd15;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd16; 
		#0 Write_Reg = 5'd16;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd17; 
		#0 Write_Reg = 5'd17;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd18; 
		#0 Write_Reg = 5'd18;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd19; 
		#0 Write_Reg = 5'd19;
		
		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd20; 
		#0 Write_Reg = 5'd20;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd21; 
		#0 Write_Reg = 5'd21;

		#4 Write =0;

		#0 Write =1; 
		#0 Write_Data =32'd22; 
		#0 Write_Reg = 5'd22;

		#4 Write =0;
		//write a 1 to reg 1
		#1 Write =1;
		#0 Write_Data =32'd23; 
		#0 Write_Reg = 5'd23;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd24; 
		#0 Write_Reg = 5'd24;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd25; 
		#0 Write_Reg = 5'd25;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd26; 
		#0 Write_Reg = 5'd26;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd27; 
		#0 Write_Reg = 5'd27;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd28; 
		#0 Write_Reg = 5'd28;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd29; 
		#0 Write_Reg = 5'd29;

		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd30; 
		#0 Write_Reg = 5'd30;
		
		#4 Write =0;
		//write a  to reg 
		#1 Write =1;
		#0 Write_Data =32'd31; 
		#0 Write_Reg = 5'd31;

		//start reading
		#4 Write =0;

		#2 Read_Reg1 = 5'd5;  

		#0 Read_Reg2 = 5'd10;  
		
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
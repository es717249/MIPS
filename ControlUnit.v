module ControlUnit
#(
    //Machine states
	parameter IDLE=0,
	parameter FETCH=1,
	parameter DECODE=2,
	parameter EXECUTE=3,	    
	parameter WRITE_BACKTOREG=4,
	parameter STORE=5,
	parameter LOAD=6,
    parameter GET_EFFECTIVE_ADDR=7,
    parameter BRANCH=8,
    parameter BRANCH_EQUAL_GET_ADDR=9,
    parameter BRANCH_EQUAL_COMPARE=10,
    parameter EXEC_JUMP=11,
    parameter UNDEFINED_INSTRUCTION=12,
    parameter NOTBRANCH_EQUAL_COMPARE=13,
    parameter UPDATE_PC=14,
    parameter DUMMY=15

	//parameter SEND_UART=7
)
(
    /* Inputs */
    input clk,              //clk signal
	input reset,            //async signal to reset
    input [5:0]Opcode,
    input [5:0]Funct,
    input Zero,    
    input Start_uart_tx_input,
    //output clr_rx_flag,
    /* Outputs */
    output IorD,
    output MemWrite,
    output IRWrite,
    output [1:0] RegDst,
    output [1:0] MemtoReg,
    output PCWrite,
    output Branch,
    output PCSrc,
    output [3:0]ALUControl,
    output [1:0]ALUSrcB,    
    output ALUSrcA,
    output RegWrite,
    output Mem_select,
    output DataWrite,
    output RDx_FF_en,
    output ALUresult_en,
    output PC_En,
    output [1:0]flag_J_type_out,
    output flag_sw_out,
    output flag_lw_out,
    output mult_operation_out,
    output mflo_flag_out,
    output selectPC_out,
    output see_uartflag, /* to select Rx flag or Tx flag */
    output Start_uart_tx_output /* Signal to indicate the start of uart Tx  */
    );

//###################### Variables ########################

reg [3:0]state;     //8 available states
wire AND1_wire;
wire flag_sw_wire;
wire flag_lw_wire;
wire [1:0]destination_indicator_wire;
wire [1:0]ALUSrcB_wire;
wire flag_R_type_wire;
wire flag_I_type_wire;
wire [1:0] flag_J_type_wire;
wire [3:0]ALUControl_wire;
wire mult_operation_wire;
wire mflo_flag_wire;

wire [1:0] writedata_indicator_wire;
wire selector_peripheraldata_wire;
 
reg IorD_reg;
reg MemWrite_reg;
reg IRWrite_reg;
reg [1:0] RegDst_reg;
reg [1:0] MemtoReg_reg;
reg PCWrite_reg;
reg Branch_reg;
reg PCSrc_reg;
reg [3:0]ALUControl_reg;
reg [1:0]ALUSrcB_reg;
reg ALUSrcA_reg;
reg RegWrite_reg;
reg Mem_select_reg;
reg DataWrite_reg;
reg RDx_FF_en_reg;
reg ALUresult_en_reg;
reg PC_En_reg;
reg mult_operation_reg;
reg mflo_flag_reg;
reg selectPC_reg;
reg Start_uartTx_signal_reg;


//####################     Assignations   #######################
assign IorD = IorD_reg;
assign MemWrite = MemWrite_reg;
assign IRWrite = IRWrite_reg;
assign RegDst = RegDst_reg;
assign MemtoReg = MemtoReg_reg;
assign PCWrite = PCWrite_reg;
assign Branch = Branch_reg;
assign PCSrc = PCSrc_reg;
assign ALUControl = ALUControl_reg;
assign ALUSrcB = ALUSrcB_reg;
assign ALUSrcA = ALUSrcA_reg;
assign RegWrite = RegWrite_reg;
assign Mem_select = Mem_select_reg;
assign DataWrite = DataWrite_reg;
assign RDx_FF_en = RDx_FF_en_reg;
assign ALUresult_en = ALUresult_en_reg;
assign flag_J_type_out = flag_J_type_wire;
assign flag_sw_out = flag_sw_wire;
assign flag_lw_out = flag_lw_wire;
assign mult_operation_out = mult_operation_reg;
assign mflo_flag_out = mflo_flag_reg;
assign selectPC_out = selectPC_reg;
/* assign clr_rx_flag = clr_rx_flag_reg; */
assign PC_En  = Branch | PCWrite ;    /* Signal for Program counter enable register */

assign Start_uart_tx_output = Start_uartTx_signal_reg;


decode_instruction decoder_module
(
    /* Inputs */
	.opcode_reg(Opcode),
	.funct_reg(Funct),
    /* Outputs */
	.destination_indicator(destination_indicator_wire), //1: R type, 0: I type
	.ALUControl(ALUControl_wire),
	.flag_sw(flag_sw_wire),
	.flag_lw(flag_lw_wire),
    .flag_R_type(flag_R_type_wire), 
    .flag_I_type(flag_I_type_wire), 
    .flag_J_type(flag_J_type_wire),
	.ALUSrcBselector(ALUSrcB_wire),    //allows to select the operand for getting srcB number
    .mult_operation(mult_operation_wire),
    .mflo_flag(mflo_flag_wire),    
    .writedata_indicator(writedata_indicator_wire),
    .see_uartflag_ind(see_uartflag)    
);



always @(posedge clk or negedge reset) begin
    if(reset==1'b0) begin
        state <= IDLE;
    end else begin
        case(state)
            IDLE:
            begin
                state <= FETCH;
            end
            FETCH:
            begin
                state <= DECODE;
            end
            DECODE:
            begin
                    if(flag_R_type_wire ==1'b1)begin /* Execute a R type operation */
                    /* the decoder already determined the needed ALU operation */
                                   /* Go to execute */
                        if(flag_J_type_wire==2'd2) begin
                            state <= EXEC_JUMP;        
                        end else
                            state <= EXECUTE;
                    end 
                    else if(flag_I_type_wire ==1'b1)begin   /* Execute an I type operation */                    
                        
                        /* Check for the opcode */
                        /* @TODO: If a new instruction will be supported, it should be added here as well */
                        case(Opcode)

                            6'b000100:      /* Beq - 0x04 */
                            begin 
                                state <= BRANCH_EQUAL_GET_ADDR;
                            end 
                            6'b000101:      /* bne - 0x05*/
                            begin 
                                /*@TODO: edit this */
                                state <= BRANCH_EQUAL_GET_ADDR;
                            end 
                            6'b000110:      /* Uart_readFlag_rx - 0x06 */
                            begin 
                                state <= EXECUTE;
                            end
                            6'b000111:      /* Uart_readFlag_tx - 0x07 */
                            begin 
                                state <= EXECUTE;
                            end
                            6'b001000:      /* Addi - 0x08 */
                            begin 
                                state <= EXECUTE;
                            end
                            6'b001010:	    /* slti - 0x0A */
                            begin
                                state<=EXECUTE;
                            end                                     
                            6'b001100:      /* andi - 0x0C */
                            begin 
                                state <= EXECUTE;
                            end                     
                            6'b001101:      /* ori - 0x0D */
                            begin 
                                state <= EXECUTE;
                            end 
                            6'b001111:      /* Lui - 0x0F */                            
                            begin
                                state <= EXECUTE;
                            end
                            6'b101011:      /* sw - 0x2B */
                            begin 
                                state <= GET_EFFECTIVE_ADDR;        
                            end 
                            6'b100011:      /* lw - 0x23 */
                            begin
                                state <= GET_EFFECTIVE_ADDR;        
                            end 
                            default:
                            begin 
                                state<=UNDEFINED_INSTRUCTION;
                            end
                        endcase

                    end
                    else if(flag_J_type_wire > 2'd0)begin /* >0 to include j and jr instructions */
                        state <= EXEC_JUMP;
                    end  
                    else begin
                    
                        state <= FETCH;     /* Should not reach this point */                    
                    end
            end
            EXECUTE:            /* count_state = 3 */
            begin
                state<=WRITE_BACKTOREG;
            end
            WRITE_BACKTOREG:        /* Write to RAM */ /* Request to write back to register file */
            begin
                state <= DUMMY;
            end
            GET_EFFECTIVE_ADDR:         /* count_state = 3 */
            begin
                /* Get the effective address for Store operation */
                    if(flag_sw_wire == 1'b1)begin    /* Check if store instruction was requested*/                     
                        state <= STORE;     /* Write to memory from reg */
                    end 
                    else if(flag_lw_wire==1'd1)begin    /* Check if Load instruction was requested */                        
                        state <= LOAD;      /* Read from memory to reg */
                    end
            end
            STORE:      /* Save from a register to memory. Write to memory from reg  */
            begin
                state <= DUMMY;
            end
            DUMMY:
            begin
                state <= FETCH;
            end
            LOAD:       /* Copy from memory to a register */
            begin
                state <= DUMMY;
            end
            BRANCH_EQUAL_GET_ADDR:         /* count_state = 3 */
            begin
                    case(Opcode)
                        6'b000100:      /* Beq - 0x04 */
                        begin 
                            state <= BRANCH_EQUAL_COMPARE;
                        end 
                        6'b000101:      /* bne - 0x05*/
                        begin                             
                            state <= NOTBRANCH_EQUAL_COMPARE;
                        end 
                        default:
                        begin
                            /* not expected */
                            state<=UNDEFINED_INSTRUCTION;
                        end
                    endcase
            end
            BRANCH_EQUAL_COMPARE:
            begin
                state <= DUMMY;
            end
            NOTBRANCH_EQUAL_COMPARE:
            begin
                state <= DUMMY;
            end
            EXEC_JUMP:
            begin
                state <= UPDATE_PC;
            end
            UPDATE_PC:
            begin
                state <= DUMMY;
            end
            default:
            begin
                state<=IDLE;
            end
        endcase
    end 
end

always@(state,destination_indicator_wire,ALUSrcB_wire,ALUControl_wire,Zero,flag_lw_wire,flag_sw_wire,mflo_flag_wire,mult_operation_wire,writedata_indicator_wire,Start_uart_tx_input)begin 
    case(state)
        
        IDLE:
        begin
            //PC_En_reg       =0; /* Control signal for the PC flip flop */
            selectPC_reg    =0;
            IorD_reg        =0; /* Selects the address: 0= program counter(fetch), 1=load operation*/
            MemWrite_reg    =0; /* Write enable for the memory (on RAM), 1=enable, 0= disabled*/
            Mem_select_reg  =0; /* Memory selection: 0=ROM, 1=RAM*/
            IRWrite_reg     =0; /* Enable signal for Instruction Flip flop (ROM to Reg File)*/
            DataWrite_reg   =0; /* Controls the flip flop for data (RAM to Reg File)*/
            MemtoReg_reg    <=writedata_indicator_wire;	/* This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
            RegDst_reg      =0; /* Mux selector for A3(destination)-Reg File, 0=rt (imm 20:16), 1=rd (r 15:11)*/
            RegWrite_reg    <=0; /* Enables writing on Register file*/
            RDx_FF_en_reg   =0; /* Controls the flip flop from RD1 to SrcA ALU (execution) and from RD2 to MUX4:1*/
            ALUSrcB_reg     <=0; /* Allows to select the operand (on Mux 4:1) for getting srcB number */
            ALUControl_reg  =0; /* Selects ALU operation,prepares for fetch */
            ALUSrcA_reg     =0; /* Allows to select either PC (0) or data from A (1) */	
            ALUresult_en_reg<=0; /* Allows writing to ALU register*/
            PCSrc_reg       =0; /* Allows to select the PC source, 0=ALUResult, 1=ALUOut*/
            Branch_reg      =0; /* not relevant */
            PCWrite_reg     =1; /* not relevant */
            mult_operation_reg = 0 ;
            mflo_flag_reg = 0;
            Start_uartTx_signal_reg = 0;
            //selector_peripheraldata_reg = 0 ; //select new available data from peripheral on mux 

        end
        FETCH:
        begin
            /* Read ROM mem and store it in instruction Flip flop */
            /* Aumenta PC, 4*/
            //PC_En_reg       =1;     /* Control signal for the PC flip flop */
            selectPC_reg    =1;
            IorD_reg        =0;     /* Selects the address: 0= program counter(fetch), 1=load operation*/
            MemWrite_reg    =0;     /* Write enable for the memory (on RAM), 1=enable, 0= disabled*/
            Mem_select_reg  =0;     /* Memory selection: 0=ROM, 1=RAM*/
            IRWrite_reg     <=1;     /* Enable signal for Instruction Flip flop (ROM to Reg File)*/
            DataWrite_reg   =0;     /* Controls the flip flop for data (RAM to Reg File)*/
            MemtoReg_reg    <=writedata_indicator_wire;	    /* This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
            //RegDst_reg      =0;     /* Mux selector for A3(destination)-Reg File, 0=rt (imm 20:16), 1=rd (r 15:11)*/
            RegDst_reg      =destination_indicator_wire;     /* Mux selector for A3(destination)-Reg File, 0=rt (imm 20:16), 1=rd (r 15:11)*/
            
            RegWrite_reg    <=0;     /* Enables writing on Register file*/
            RDx_FF_en_reg   =0;     /* Controls the flip flop from RD1 to SrcA ALU (execution) and from RD2 to MUX4:1*/
            ALUSrcB_reg     <=2'd1;  /* Selects operand 01 = 4 to do PC+4*/
            ALUControl_reg  =4'd2;  /* Selects ALU operation : Sum */
            //ALUControl_reg  <=ALUControl_wire;  /* Selects ALU operation : Sum */
            
            ALUSrcA_reg     =0;     /* Allows to select either PC (0) */	
            ALUresult_en_reg<=0;     /* Allows writing to ALU register*/
            PCSrc_reg       =0;     /* Allows to select the PC source, 0=ALUResult*/
            Branch_reg      =0; /* not relevant */
            PCWrite_reg     =1; /* not relevant */
            mult_operation_reg = 0 ;
            mflo_flag_reg = 0;
            Start_uartTx_signal_reg = 0;
            //selector_peripheraldata_reg = 0 ; //select new available data from peripheral on mux 

        end
        DECODE:
        begin
            /*  El PC ya tiene 4 más , apunta a la siguiente dirección
                Traduce la instrucción (Prepare address)
                Define qué tipo de instrucción es.
                Prepara la operación de la ALU */
            //PC_En_reg       =0;     /* Control signal for the PC flip flop */
            selectPC_reg    =1;
            IorD_reg        =0;     /* not relevant*/
            MemWrite_reg    =0;     /* Write enable for the memory (on RAM), 1=enable, 0= disabled*/
            Mem_select_reg  =0;     /* Memory selection: 0=ROM,  1=RAM*/
            IRWrite_reg     <=0;     /* not relevant*/
            DataWrite_reg   <=0;     /* if it is LW save the data */
            MemtoReg_reg    <=writedata_indicator_wire;	    /* not relevant */
            //MemtoReg_reg    <=flag_lw_wire;	    /* not relevant */            
            RegDst_reg      = destination_indicator_wire;     /* A3(destination)-Reg File, 0=rt (imm 20:16), 1=rd (r 15:11)*/
            RegWrite_reg    <=0;     /* not relevant*/
            //RegWrite_reg    <=flag_lw_wire[1]; /* save for JAL operation */
            RDx_FF_en_reg   =1;     /* FF RD1 to SrcA ALU (execution) and from RD2 to MUX4:1*/
            ALUSrcB_reg     <= ALUSrcB_wire;     /* not relevant */
            ALUControl_reg  <= ALUControl_wire;     /* not relevant */
            ALUSrcA_reg     =1;     /* not relevant */
            ALUresult_en_reg<=0;     /* not relevant */
            PCSrc_reg       =0;     /* not relevant */
            Branch_reg      =0; /* not relevant */
            PCWrite_reg     =0; /* not relevant */
            mult_operation_reg = 0 ;
            mflo_flag_reg = 0;
            Start_uartTx_signal_reg = 0;
            //selector_peripheraldata_reg = 0 ; //select new available data from peripheral on mux 
        end

        EXECUTE:
        begin
            /*  Ya se tienen los datos provenientes del Reg File (RD1 y RD2)
                Se pasan los datos a la ALU para alguna operación
                Se elige la operación a realizar dependiendo de la decodificación de la instrucción
                Se guarda el resultado en Flip flop ALUout
            */
            //PC_En_reg       =0; /* not relevant */
            selectPC_reg    =1;
            IorD_reg        =0; /* not relevant */
            MemWrite_reg    =0; /* not relevant */
            Mem_select_reg  =0; /* not relevant */
            IRWrite_reg     =0; /* not relevant */
            DataWrite_reg   =0; /* not relevant */
            MemtoReg_reg    <=writedata_indicator_wire;	/* not relevant */
            RegDst_reg      =destination_indicator_wire; /* not relevant */
            RegWrite_reg    <=0; /* not relevant */
            RDx_FF_en_reg   =1; /* not relevant */
            ALUSrcB_reg     <=ALUSrcB_wire; /* Allows to select the operand (on Mux 4:1) for getting srcB number */
            ALUControl_reg  <=ALUControl_wire; /* Selects ALU operation */
            ALUSrcA_reg     =1; /* Select data from A , RD1 */	
            ALUresult_en_reg <=1; /* allows to save on the next cycle the ALU result*/
            PCSrc_reg       =0; /* not relevant */
            Branch_reg      =0; /* not relevant */
            PCWrite_reg     =0; /* not relevant */
            mult_operation_reg = 0;
            //mflo_flag_reg = 0;
            mflo_flag_reg = mflo_flag_wire; /* on mflo inst, enable passing data to Aluout reg */
            Start_uartTx_signal_reg = 0;
            //selector_peripheraldata_reg = 0 ; //select new available data from peripheral on mux 

        end
        EXEC_JUMP:
        begin
            selectPC_reg    =1;
            IorD_reg        =0; /* not relevant */
            MemWrite_reg    =0; /* not relevant */
            Mem_select_reg  =0; /* not relevant */
            IRWrite_reg     =0; /* not relevant */
            DataWrite_reg   =0; /* not relevant */
            MemtoReg_reg    <=writedata_indicator_wire;	/* not relevant */
            //MemtoReg_reg    =flag_lw_wire;	/* select PC for WD3 to the register file for JAL instruction*/
            
            RegDst_reg      =destination_indicator_wire; /* not relevant */
            //RegWrite_reg    <=0; /* not relevant */
            RegWrite_reg    <=1; /* relevant but check */
            RDx_FF_en_reg   =0; /* not relevant */
            ALUSrcB_reg     <=ALUSrcB_wire; /*not relevant */
            ALUControl_reg  <=ALUControl_wire; /* not relevant */
            ALUSrcA_reg     =1; /* not relevant */	
            ALUresult_en_reg <=1; /* not relevant */
            PCSrc_reg       =0; /* not relevant */
            Branch_reg      =0; /* not relevant */
            PCWrite_reg     =1; /* Save the updated jump address in PC */
            
            mult_operation_reg = 0;
            mflo_flag_reg = 0;
            Start_uartTx_signal_reg = 0;
            //selector_peripheraldata_reg = 0 ; //select new available data from peripheral on mux 

        end
        UPDATE_PC:
        begin
            /* wait until the PC is updated. This is like doing FETCH */

            /* Aumenta PC, 4*/
            selectPC_reg    =1;
            IorD_reg        =0;     /* Selects the address: 0= program counter(fetch), 1=load operation*/
            MemWrite_reg    =0;     /* Write enable for the memory (on RAM), 1=enable, 0= disabled*/
            Mem_select_reg  =0;     /* Memory selection: 0=ROM, 1=RAM*/
            IRWrite_reg     <=1;     /* Enable signal for Instruction Flip flop (ROM to Reg File)*/
            DataWrite_reg   =0;     /* Controls the flip flop for data (RAM to Reg File)*/
            MemtoReg_reg    <=writedata_indicator_wire;	    /* This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
            RegDst_reg      =0;     /* Mux selector for A3(destination)-Reg File, 0=rt (imm 20:16), 1=rd (r 15:11)*/
            RegWrite_reg    <=0;     /* Enables writing on Register file*/
            RDx_FF_en_reg   =0;     /* Controls the flip flop from RD1 to SrcA ALU (execution) and from RD2 to MUX4:1*/
            ALUSrcB_reg     <=2'd1;  /* Selects operand 01 = 4 to do PC+4*/
            ALUControl_reg  =4'd2;  /* Selects ALU operation : Sum */
            //ALUControl_reg  <=ALUControl_wire;  /* Selects ALU operation : Sum */
            
            ALUSrcA_reg     =0;     /* Allows to select either PC (0) */	
            ALUresult_en_reg<=0;     /* Allows writing to ALU register*/
            PCSrc_reg       =0;     /* Allows to select the PC source, 0=ALUResult*/
            Branch_reg      =0; /* not relevant */
            PCWrite_reg     =0; /* not relevant */
            mult_operation_reg = 0 ;
            mflo_flag_reg = 0;
            Start_uartTx_signal_reg = 0;
            //selector_peripheraldata_reg = 0 ; //select new available data from peripheral on mux 

        end 
        WRITE_BACKTOREG:
        begin
            /*  El resultado de la ALU se escribe al registro destino en Register File
              */
            //PC_En_reg       =0; /* not relevant */
            selectPC_reg    =1;
            IorD_reg        =0; /* not relevant */
            MemWrite_reg    =0; /* not relevant */
            Mem_select_reg  =0; /* Memory selection: 0=ROM, 1=RAM*/
            IRWrite_reg     =0; /* not relevant */
            DataWrite_reg   =0; /* not relevant */
            MemtoReg_reg    =writedata_indicator_wire;	/* This will select the correct data for WD3; 0=ALUout*/
            RegDst_reg      =destination_indicator_wire; /* Mux selector for A3(destination)-Reg File, 0=rt (imm 20:16), 1=rd (r 15:11)*/
            RegWrite_reg    <=1; /* Enables writing on Register file*/
            RDx_FF_en_reg   =0; /* not relevant */
            ALUSrcB_reg     <=0; /* not relevant */
            ALUControl_reg  <=ALUControl_wire; /* not relevant */
            ALUSrcA_reg     =0; /* not relevant */	
            ALUresult_en_reg<=1; /* not relevant */
            PCSrc_reg       =0; /* not relevant */          
            Branch_reg      =0; /* not relevant */
            PCWrite_reg     =0; /* not relevant */
            mult_operation_reg = mult_operation_wire ;
            mflo_flag_reg <= mflo_flag_wire;
            Start_uartTx_signal_reg = 0;
            //selector_peripheraldata_reg = 0 ; //select new available data from peripheral on mux 

        end
        GET_EFFECTIVE_ADDR:     /* For sw operation */
        begin
            /* En este punto ya se decodificó la instrucción
                rs: tiene el valor a escribir (está en RD1)
                rt: tiene la dirección base del destino (está en RD2)
                immediate: tiene el offset que hay que sumar a rt */
            
            //PC_En_reg       =0; /* not relevant */
            selectPC_reg    =1;
            IorD_reg        =0; /* not relevant */
            MemWrite_reg    =0; /* not relevant */
            Mem_select_reg  =0; /* not relevant */
            IRWrite_reg     =0; /* not relevant */
            //DataWrite_reg   <=flag_lw_wire; /* not relevant */
            DataWrite_reg   <=0; /* not relevant */
            MemtoReg_reg    <=writedata_indicator_wire;	/* not relevant */
            RegDst_reg      =0; /* not relevant */
            RegWrite_reg    <=0; /* not relevant */
            RDx_FF_en_reg   =1; /* Controls the flip flop from RD1 to SrcA ALU (execution) and from RD2 to MUX4:1*/
            ALUSrcB_reg     <=2'd2; /* Allows to select '10' for srcB number */
            ALUControl_reg  =ALUControl_wire; /* It should do Add operation */
            ALUSrcA_reg     =1; /* Select data from A (1) */	
            ALUresult_en_reg<=1; /* Allows writing to ALU register*/
            PCSrc_reg       =0; /* not relevant */
            Branch_reg      =0; /* not relevant */
            PCWrite_reg     =0; /* not relevant */
            mult_operation_reg = 0 ;
            mflo_flag_reg = 0;
            Start_uartTx_signal_reg = 0;
            //selector_peripheraldata_reg = 0 ; //select new available data from peripheral on mux 

        end 
        STORE:
        begin
            //PC_En_reg       =0; /* not relevant */
            selectPC_reg    =1;
            IorD_reg        =1; /* Selects the address: 1=store operation*/
            MemWrite_reg    =1; /* Write enable for the memory (on RAM), 1=enable, 0= disabled*/
            Mem_select_reg  =1; /* Memory selection: 0=ROM, 1=RAM*/
            IRWrite_reg     =0; /* not relevant */
            DataWrite_reg   =0; /* not relevant */
            MemtoReg_reg    <=writedata_indicator_wire;	/* not relevant */
            RegDst_reg      =0; /* not relevant */
            RegWrite_reg    <=0; /* not relevant */
            RDx_FF_en_reg   =0; /* not relevant */
            ALUSrcB_reg     <=0; /* not relevant */
            ALUControl_reg  =0; /* not relevant */
            ALUSrcA_reg     =0; /* not relevant */	
            ALUresult_en_reg<=0; /* not relevant */
            PCSrc_reg       =0; /* not relevant */
            Branch_reg      =0; /* not relevant */
            PCWrite_reg     =0; /* not relevant */
            mult_operation_reg = 0 ;
            mflo_flag_reg = 0;
            Start_uartTx_signal_reg = Start_uart_tx_input;    /* Send 1 from Start Tx signal if 0x1001002E is detected */
            //selector_peripheraldata_reg = 0 ; //select new available data from peripheral on mux 

        end
        DUMMY:
        begin
        selectPC_reg    =1;
            IorD_reg        =1; /* Selects the address: 1=store operation*/
            MemWrite_reg    =0; /* Write enable for the memory (on RAM), 1=enable, 0= disabled*/
            Mem_select_reg  =0; /* Memory selection: 0=ROM, 1=RAM*/
            IRWrite_reg     =0; /* not relevant */
            DataWrite_reg   =0; /* not relevant */
            //MemtoReg_reg    <=flag_lw_wire;	/* if 0 (normal)-data from alu, if 1(lw inst)-data from ram,if 2 (JAL inst)- data from PC*/
            MemtoReg_reg    <=writedata_indicator_wire;
            RegDst_reg      =destination_indicator_wire; /* not relevant */
            RegWrite_reg    <=flag_lw_wire; /* nif lw operation enable the FF writing */
            RDx_FF_en_reg   =0; /* not relevant */
            ALUSrcB_reg     <=0; /* not relevant */
            ALUControl_reg  =0; /* not relevant */
            ALUSrcA_reg     =0; /* not relevant */	
            ALUresult_en_reg<=0; /* not relevant */
            PCSrc_reg       =0; /* not relevant */
            Branch_reg      =0; /* not relevant */
            PCWrite_reg     =0; /* not relevant */
            mult_operation_reg = 0 ;
            mflo_flag_reg = 0;
            Start_uartTx_signal_reg = Start_uart_tx_input;
            //selector_peripheraldata_reg = 0 ; //select new available data from peripheral on mux 

        end
        LOAD:
        begin
            //PC_En_reg       =0; /* not relevant */
            selectPC_reg    =1;
            IorD_reg        =1; /* Selects the address: 1=load operation */
            MemWrite_reg    =0; /* not relevant */
            Mem_select_reg  =1; /* Memory selection: 0=ROM, 1=RAM*/
            IRWrite_reg     =0; /* not relevant */
            DataWrite_reg   =1; /* Controls the flip flop for data (RAM to Reg File)*/
            //MemtoReg_reg    =1;	/* This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
            MemtoReg_reg    <=writedata_indicator_wire;
            RegDst_reg      =destination_indicator_wire; 
            RegWrite_reg    <=1; /* write to register file */
            RDx_FF_en_reg   =0; /* not relevant */
            ALUSrcB_reg     <=0; /* not relevant */
            ALUControl_reg  =0; /* not relevant */
            ALUSrcA_reg     =0; /* not relevant */
            ALUresult_en_reg<=0; /* not relevant */
            PCSrc_reg       =0; /* not relevant */
            Branch_reg      =0; /* not relevant */
            PCWrite_reg     =0; /* not relevant */
            mult_operation_reg = 0 ;
            mflo_flag_reg = 0;
            Start_uartTx_signal_reg = 0;
            //selector_peripheraldata_reg = 0 ; //select new available data from peripheral on mux 


        end
        BRANCH_EQUAL_GET_ADDR:
        begin
            //PC_En_reg       =0; /* not relevant */
            selectPC_reg    =1;
            IorD_reg        =0; /* Selects the address: 0= program counter(fetch), 1=load operation*/
            MemWrite_reg    =0; /* not relevant */
            Mem_select_reg  =0; /* Memory selection: 0=ROM, 1=RAM*/
            IRWrite_reg     =0; /* not relevant */
            DataWrite_reg   =0; /* not relevant */
            MemtoReg_reg    <=writedata_indicator_wire;	/* not relevant */
            RegDst_reg      =0; /* not relevant */
            RegWrite_reg    <=0; /* not relevant */
            RDx_FF_en_reg   =0; /* not relevant */
            ALUSrcB_reg     <=2'd3; /* Allows to select the operand (on Mux 4:1) for getting srcB number */
            //ALUSrcB_reg     <=ALUSrcB_wire;/* Allows to select the operand (on Mux 4:1) for getting srcB number */
            ALUControl_reg  =4'd2; /* Selects addition operation */
            ALUSrcA_reg     =0; /* Allows to select either PC (0) or data from A (1) */	
            ALUresult_en_reg<=1; /* Allows writing to ALU register*/
            PCSrc_reg       =0; /* Allows to select the PC source, 0=ALUResult, 1=ALUOut*/            
            Branch_reg      =0; /* Prepare signal for branch (and operation) */
            PCWrite_reg     =0; /* Signal to enable updating Program Counter */
            mult_operation_reg = 0 ;
            mflo_flag_reg = 0;
            Start_uartTx_signal_reg = 0;
            //selector_peripheraldata_reg = 0 ; //select new available data from peripheral on mux 

        end
        BRANCH_EQUAL_COMPARE:
        begin 
            //PC_En_reg       =0; /* Control signal for the PC flip flop */
            selectPC_reg    =1;
            IorD_reg        =0; /* Selects the address: 0= program counter(fetch)*/
            MemWrite_reg    =0; /* Write enable for the memory (on RAM), 1=enable, 0= disabled*/
            Mem_select_reg  =0; /* Memory selection: 0=ROM, 1=RAM*/
            IRWrite_reg     =0; /* Enable signal for Instruction Flip flop (ROM to Reg File)*/
            DataWrite_reg   =0; /* Controls the flip flop for data (RAM to Reg File)*/
            MemtoReg_reg    <=writedata_indicator_wire;	/* This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
            RegDst_reg      =0; /* Mux selector for A3(destination)-Reg File, 0=rt (imm 20:16), 1=rd (r 15:11)*/
            RegWrite_reg    <=0; /* Enables writing on Register file*/
            RDx_FF_en_reg   =1; /* Controls the flip flop from RD1 to SrcA ALU (execution) and from RD2 to MUX4:1*/
            ALUSrcB_reg     <=0; /* Select (on Mux 4:1) B for srcB */
            ALUControl_reg  =4'd1; /* Selects substract on ALU operation */
            ALUSrcA_reg     =1; /* Select data from A (1) */	
            ALUresult_en_reg<=0; /* Allows writing to ALU register*/
            PCSrc_reg       =1; /* Select 1=ALUOut */ 
            //Branch_reg      =1; /* Prepare signal for branch (and operation) */
            Branch_reg      <=Zero; /* Prepare signal for branch (and operation) */
            PCWrite_reg     =0; /* Signal to enable updating Program Counter */
            mult_operation_reg = 0 ;
            mflo_flag_reg = 0;
            Start_uartTx_signal_reg = 0;
            //selector_peripheraldata_reg = 0 ; //select new available data from peripheral on mux 

        end 
        NOTBRANCH_EQUAL_COMPARE:
        begin 
            //PC_En_reg       =0; /* Control signal for the PC flip flop */
            selectPC_reg    =1;
            IorD_reg        =0; /* Selects the address: 0= program counter(fetch)*/
            MemWrite_reg    =0; /* Write enable for the memory (on RAM), 1=enable, 0= disabled*/
            Mem_select_reg  =0; /* Memory selection: 0=ROM, 1=RAM*/
            IRWrite_reg     =0; /* Enable signal for Instruction Flip flop (ROM to Reg File)*/
            DataWrite_reg   =0; /* Controls the flip flop for data (RAM to Reg File)*/
            MemtoReg_reg    <=writedata_indicator_wire;	/* This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
            RegDst_reg      =0; /* Mux selector for A3(destination)-Reg File, 0=rt (imm 20:16), 1=rd (r 15:11)*/
            RegWrite_reg    <=0; /* Enables writing on Register file*/
            RDx_FF_en_reg   =1; /* Controls the flip flop from RD1 to SrcA ALU (execution) and from RD2 to MUX4:1*/
            ALUSrcB_reg     <=0; /* Select (on Mux 4:1) B for srcB */
            ALUControl_reg  =4'd1; /* Selects substract on ALU operation */
            ALUSrcA_reg     =1; /* Select data from A (1) */	
            ALUresult_en_reg<=0; /* Allows writing to ALU register*/
            PCSrc_reg       =1; /* Select 1=ALUOut */ 
            //Branch_reg      =1; /* Prepare signal for branch (and operation) */
            Branch_reg      <=!Zero; /* Prepare signal for branch (and operation) */
            PCWrite_reg     =0; /* Signal to enable updating Program Counter */
            mult_operation_reg = 0 ;
            mflo_flag_reg = 0;
            Start_uartTx_signal_reg = 0;
            //selector_peripheraldata_reg = 0 ; //select new available data from peripheral on mux 

        end 
        default:
        begin 
            //PC_En_reg       =0; /* Control signal for the PC flip flop */
            selectPC_reg    =1;
            IorD_reg        =0; /* Selects the address: 0= program counter(fetch), 1=load operation*/
            MemWrite_reg    =0; /* Write enable for the memory (on RAM), 1=enable, 0= disabled*/
            Mem_select_reg  =0; /* Memory selection: 0=ROM, 1=RAM*/
            IRWrite_reg     =0; /* Enable signal for Instruction Flip flop (ROM to Reg File)*/
            DataWrite_reg   =0; /* Controls the flip flop for data (RAM to Reg File)*/
            MemtoReg_reg    =0;	/* This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
            RegDst_reg      =0; /* Mux selector for A3(destination)-Reg File, 0=rt (imm 20:16), 1=rd (r 15:11)*/
            RegWrite_reg    <=1; /* Enables writing on Register file*/
            RDx_FF_en_reg   =0; /* Controls the flip flop from RD1 to SrcA ALU (execution) and from RD2 to MUX4:1*/
            ALUSrcB_reg     <=0; /* Allows to select the operand (on Mux 4:1) for getting srcB number */
            ALUControl_reg  =0; /* Selects ALU operation */
            ALUSrcA_reg     =0; /* Allows to select either PC (0) or data from A (1) */	
            ALUresult_en_reg<=0; /* Allows writing to ALU register*/
            PCSrc_reg       =0; /* Allows to select the PC source, 0=ALUResult, 1=ALUOut*/
            Branch_reg      =0; /* not relevant */
            PCWrite_reg     =0; /* not relevant */
            mult_operation_reg = 0 ;
            mflo_flag_reg = 0;
            Start_uartTx_signal_reg = 0;
            //selector_peripheraldata_reg = 0 ; //select new available data from peripheral on mux 

        end
    endcase
end 



endmodule
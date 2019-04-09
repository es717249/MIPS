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
    input [2:0]count_state, 
    input [5:0]Opcode,
    input [5:0]Funct,
    input Zero,
    input flag_uartdone,
    output clr_rx_flag,
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
    output mult_operation_out,
    output mflo_flag_out,
    output selectPC_out,
    output immediate_src_out);

//###################### Variables ########################

reg [3:0]state;     //8 available states
wire AND1_wire;
wire flag_sw_wire;
wire [1:0] flag_lw_wire;
wire [1:0]destination_indicator_wire;
wire [1:0]ALUSrcB_wire;
wire flag_R_type_wire;
wire flag_I_type_wire;
wire [1:0] flag_J_type_wire;
wire [3:0]ALUControl_wire;
wire mult_operation_wire;
wire mflo_flag_wire;
wire immediate_selector_wire;

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
reg immediate_selector_reg;
reg clr_rx_flag_reg;


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
assign mult_operation_out = mult_operation_reg;
assign mflo_flag_out = mflo_flag_reg;
assign selectPC_out = selectPC_reg;
assign immediate_src_out = immediate_selector_reg;
assign clr_rx_flag = clr_rx_flag_reg;
//####################     Assignations   #######################
//assign AND1_wire = Branch & Zero;
//assign PC_En  = AND1_wire | PCWrite | PC_En_reg;    /* Signal for Program counter enable register */
assign PC_En  = Branch | PCWrite ;    /* Signal for Program counter enable register */

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
	.mux4selector(ALUSrcB_wire),    //allows to select the operand for getting srcB number
    .mult_operation(mult_operation_wire),
    .mflo_flag(mflo_flag_wire),
    .immediate_src(immediate_selector_wire)
);



always @(posedge clk or negedge reset) begin
    if(reset==1'b0) begin
        state <= IDLE;
    end else begin
        case(state)
            IDLE:
            begin
//                if(count_state==3'd1 )
//                    state <= FETCH;
//                else if(count_state ==3'd0 ) /* remain in the same state: IDLE */
//                    state <= IDLE;
                state <= FETCH;
            end
            FETCH:
            begin
//                if(count_state==3'd2 )
//                    state <= DECODE;
//                else if(count_state==3'd1)    /* remain in FETCH */
//                    state <= FETCH;
                state <= DECODE;
            end
            DECODE:
            begin
//                if(count_state==3'd3)begin

                    if(flag_R_type_wire ==1'b1)begin /* Execute a R type operation */
                    /* the decoder already determined the needed ALU operation */
                                   /* Go to execute */
                        if(flag_J_type_wire==2'd2)begin
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
                            6'b000110:      /* Uart_rx - 0x06 */
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

//                end else if(count_state==3'd2)  /* remain in DECODE */
//                    state <= DECODE;
            end

            EXECUTE:            /* count_state = 3 */
            begin
//                if(count_state==3'd4)begin
//                    state<=WRITE_BACKTOREG;
//                 end else if(count_state==3'd3)          /* Remain in EXECUTE */
//                    state <= EXECUTE;
                state<=WRITE_BACKTOREG;
            end
            WRITE_BACKTOREG:        /* Write to RAM */ /* Request to write back to register file */
            begin

//                if(count_state==3'd5)       /* Go and do another stuff from the beginning*/
//                    state <= DUMMY;
//                else if(count_state == 3'd4)      /* Remain in WRITE_BACKTOREG */
//                    state <= WRITE_BACKTOREG;
                state <= DUMMY;
            end
            GET_EFFECTIVE_ADDR:         /* count_state = 3 */
            begin
                /* Get the effective address for Store operation */
//                if(count_state==3'd4)begin
                    
                    if(flag_sw_wire == 1'b1)begin    /* Check if store instruction was requested*/                     
                        state <= STORE;     /* Write to memory from reg */
                    end 
                    else if(flag_lw_wire==2'd1)begin    /* Check if Load instruction was requested */                        
                        state <= LOAD;      /* Read from memory to reg */
                    end

//                end else if(count_state == 3'd3)
//                    state <=GET_EFFECTIVE_ADDR;
            end

            STORE:      /* Save from a register to memory. Write to memory from reg  */
            begin
//                if(count_state==3'd5)
//                    state <= DUMMY;
//                else if(count_state == 3'd4)
//                    state <=STORE;
                state <= DUMMY;
            end
            DUMMY:
            begin
//                if(count_state==3'd1)
//                    state <= FETCH;
//                else if(count_state == 3'd5)
//                    state <=DUMMY;
                state <= FETCH;
            end
            LOAD:       /* Copy from memory to a register */
            begin

//                if(count_state==3'd5)
//                    state <= DUMMY;
//                else if(count_state == 3'd4)
//                    state <=LOAD;
                state <= DUMMY;
            end
            BRANCH_EQUAL_GET_ADDR:         /* count_state = 3 */
            begin
//                if(count_state==3'd4)
                    
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
                    
//                else if(state == 4'd3)
//                    state <=BRANCH_EQUAL_GET_ADDR;
            end
            BRANCH_EQUAL_COMPARE:
            begin
//                if(count_state==3'd5)
//                    state <= DUMMY;
//                else if(state == 4'd4)
//                    state <=BRANCH_EQUAL_COMPARE;
                state <= DUMMY;
            end
            NOTBRANCH_EQUAL_COMPARE:
            begin
//                if(count_state==3'd5)
//                    state <= DUMMY;
//                else if(state == 4'd4)
//                    state <=NOTBRANCH_EQUAL_COMPARE;              
                state <= DUMMY;
            end
            EXEC_JUMP:
            begin
//                if(count_state==3'd4)
//                    state <= UPDATE_PC;
//                else if(state == 4'd3)
//                    state <=EXEC_JUMP;
                state <= UPDATE_PC;
            end
            UPDATE_PC:
            begin
//                if(count_state==3'd5)   
//                    state <= DUMMY;
//                else if(state == 4'd4)
//                    state <=UPDATE_PC;
                state <= DUMMY;
            end

            default:
            begin
                state<=IDLE;            
            end
        endcase
    end 
end

always@(state,count_state,destination_indicator_wire,ALUSrcB_wire,ALUControl_wire,Zero,flag_lw_wire,flag_sw_wire,mflo_flag_wire,mult_operation_wire,immediate_selector_wire)begin 
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
            MemtoReg_reg    =0;	/* This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
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
            clr_rx_flag_reg =0;
            immediate_selector_reg<=0;
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
            MemtoReg_reg    =0;	    /* This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
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
            PCWrite_reg     =1; /* not relevant */
            mult_operation_reg = 0 ;
            mflo_flag_reg = 0;
            clr_rx_flag_reg =0;
            immediate_selector_reg<=0;
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
            //MemtoReg_reg    =0;	    /* not relevant */
            MemtoReg_reg    <=flag_lw_wire;	    /* not relevant */            
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
            clr_rx_flag_reg =1;
            immediate_selector_reg<=immediate_selector_wire;
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
            MemtoReg_reg    =0;	/* not relevant */
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
            clr_rx_flag_reg =0;      
            immediate_selector_reg<=immediate_selector_wire;      
        end
        EXEC_JUMP:
        begin
        selectPC_reg    =1;
            IorD_reg        =0; /* not relevant */
            MemWrite_reg    =0; /* not relevant */
            Mem_select_reg  =0; /* not relevant */
            IRWrite_reg     =0; /* not relevant */
            DataWrite_reg   =0; /* not relevant */
            //MemtoReg_reg    =0;	/* not relevant */
            MemtoReg_reg    =flag_lw_wire;	/* select PC for WD3 to the register file for JAL instruction*/
            
            RegDst_reg      =destination_indicator_wire; /* not relevant */
            //RegWrite_reg    <=0; /* not relevant */
            RegWrite_reg    <=flag_lw_wire[1]; /* not relevant */
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
            clr_rx_flag_reg =0;
            immediate_selector_reg<=0;
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
            MemtoReg_reg    =0;	    /* This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
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
            clr_rx_flag_reg =0;
            immediate_selector_reg<=0;
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
            MemtoReg_reg    =0;	/* This will select the correct data for WD3; 0=ALUout*/
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
            clr_rx_flag_reg =0;
            immediate_selector_reg<=0;
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
            MemtoReg_reg    =0;	/* not relevant */
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
            clr_rx_flag_reg =0;
            immediate_selector_reg<=0;
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
            MemtoReg_reg    =0;	/* not relevant */
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
            clr_rx_flag_reg =0;
            immediate_selector_reg<=0;
        end
        DUMMY:
        begin
        selectPC_reg    =1;
            IorD_reg        =1; /* Selects the address: 1=store operation*/
            MemWrite_reg    =0; /* Write enable for the memory (on RAM), 1=enable, 0= disabled*/
            Mem_select_reg  =0; /* Memory selection: 0=ROM, 1=RAM*/
            IRWrite_reg     =0; /* not relevant */
            DataWrite_reg   =0; /* not relevant */
            MemtoReg_reg    <=flag_lw_wire;	/* if 0 (normal)-data from alu, if 1(lw inst)-data from ram,if 2 (JAL inst)- data from PC*/
            RegDst_reg      =0; /* not relevant */
            RegWrite_reg    <=flag_lw_wire[0]; /* nif lw operation enable the FF writing */
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
            clr_rx_flag_reg =0;
            immediate_selector_reg<=0;
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
            MemtoReg_reg    =1;	/* This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
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
            clr_rx_flag_reg =0;
            immediate_selector_reg<=0;

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
            MemtoReg_reg    =0;	/* not relevant */
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
            clr_rx_flag_reg =0;
            immediate_selector_reg<=0;
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
            MemtoReg_reg    =0;	/* This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
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
            clr_rx_flag_reg =0;
            immediate_selector_reg<=0;
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
            MemtoReg_reg    =0;	/* This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
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
            clr_rx_flag_reg =0;
            immediate_selector_reg<=0;
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
            clr_rx_flag_reg =0;
            immediate_selector_reg<=0;
        end
    endcase
end 



endmodule
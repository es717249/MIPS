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
    parameter BRANCH=7
	//parameter SEND_UART=7
)
(
    /* Inputs */
    input clk, //clk signal
	input reset, //async signal to reset 	
    input [2:0]count_state, //7 states
    input [5:0]Opcode,
    input [5:0]Funct,
    input Zero,
    /* Outputs */
    output IorD,
    output MemWrite,
    output IRWrite,
    output RegDst,
    output MemtoReg,
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
    output PC_En);

//###################### Variables ########################

reg [2:0]state;     //8 available states
wire AND1_wire;
wire flag_sw_wire;
wire flag_lw_wire;
wire destination_indicator_wire;
wire [3:0]ALUoperation_wire;
wire R_or_I_inst;
wire [1:0]ALUSrcB_wire;
wire flag_R_type_wire;
wire flag_I_type_wire;
wire flag_J_type_wire;

reg PC_En_reg;
reg IorD_reg;
reg MemWrite_reg;
reg Mem_select_reg;
reg IRWrite_reg;
reg DataWrite_reg;
reg MemtoReg_reg;
reg RegDst_reg;
reg RegWrite_reg;
reg RDx_FF_en_reg;
reg [3:0]ALUControl_reg;
reg [1:0]ALUSrcB_reg;
reg ALUSrcA_reg;
reg ALUresult_en_reg;
reg PCSrc_reg;

//####################     Assignations   #######################
assign AND1_wire = Branch & Zero;
assign PC_En  = AND1_wire | PCWrite;    /* Signal for Program counter enable register */

decode_instruction decoder_module
(
    /* Inputs */
	.opcode_reg(Opcode),
	.funct_reg(Funct),
    /* Outputs */
	.destination_indicator(destination_indicator_wire), //1: R type, 0: I type
	.ALUControl(ALUControl),
	.flag_sw(flag_sw_wire),
	.flag_lw(flag_lw_wire),
    .flag_R_type(flag_R_type_wire), 
    .flag_I_type(flag_I_type_wire), 
    .flag_J_type(flag_J_type_wire),
	.mux4selector(ALUSrcB_wire),    //allows to select the operand for getting srcB number
	.controlSrcA(controlSrcA)       //to control the source data for srcA
);


always @(posedge clk or negedge reset) begin
    if(reset==1'b0) begin
        state <= IDLE;
    end else begin
        case(state)
            IDLE:
            begin
                if(count_state==3'd1)
                    state <= FETCH;
                else if(count_state ==3'd0) /* remain in the same state: IDLE */
                    state <= IDLE;
            end
            FETCH:
            begin
                if(count_state==3'd2)
                    state <= DECODE;
                else if(count_state==3'd1)    /* remain in FETCH */
                    state <= FETCH;
            end
            DECODE:
            begin
                if(count_state==3'd3)
                    state <= DETERMINE_EXECUTION;                
                else if(count_state==3'd2)  /* remain in DECODE */
                    state <= DECODE;
            end
            DETERMINE_EXECUTION:    /* count_state = 3 */
            begin 
                if(flag_R_type_wire ==1'b1)begin /* Execute a R type operation */
                    /* the decoder already determined the needed ALU operation */
                    state <= EXECUTE;                   /* Go to execute */
                end 
                else if(flag_I_type_wire ==1'b1)begin   /* Execute an I type operation */                    
                    state <= GET_EFFECTIVE_ADDR;        /* Get effective address. This is common for sw and lw */
                end
                else if(flag_J_type_wire==1'b1)begin
                    state <= BRANCH;
                end  
                else begin
                    state <= FETCH;     /* Should not reach this point */
                end

            end 
            EXECUTE:            /* count_state = 3 */
            begin
                if(count_state==3'd4)
                    state<=WRITE_BACKTOREG;          
                else if(count_state==3'd3)          /* Remain in EXECUTE */
                    state <= EXECUTE;
            end
            WRITE_BACKTOREG:        /* Write to RAM */ /* Request to write back to register file */
            begin

                if(count_state==3'd1)       /* Go and do another stuff from the beginning*/
                    state <= FETCH;
                else if(count_state == 3'd4)      /* Remain in WRITE_BACKTOREG */
                    state <= WRITE_BACKTOREG;
            end
            GET_EFFECTIVE_ADDR:         /* count_state = 3 */
            begin
                /* Get the effective address for Store operation */
                if(count_state==3'd4)
                    state<= STORE_OR_LOAD; 
                else if(count_state == 3'd3)
                    state <=GET_EFFECTIVE_ADDR;
            end
            STORE_OR_LOAD:          /* count_state = 4 */
            begin
                if(flag_sw_wire == 1'b1)begin    /* Check if store instruction was requested*/                     
                    state <= STORE;     /* Write to memory from reg */
                end 
                else if(flag_lw_wire==1'b1)begin    /* Check if Load instruction was requested */                        
                    state <= LOAD;      /* Read from memory to reg */
                end
            end
            end
            STORE:      /* Save from a register to memory. Write to memory from reg  */
            begin
                if(count_state==3'd1)
                    state <= FETCH;
                else if(count_state == 3'd4)
                    state <=STORE;
            end
            LOAD:       /* Copy from memory to a register */
            begin
                if(count_state==3'd1)
                    state <= FETCH;
                else if(count_state == 3'd4)
                    state <=LOAD;
            end
            BRANCH:         /* count_state = 3 */
            begin
                if(count_state==3'd1)
                    state <= FETCH;
                else if(state == 3'd3)
                    state <=BRANCH;
            end
        endcase
    end 
end

always@(state)begin 
    case(state)
        IDLE:
        begin
            PC_En_reg       =0; /* Control signal for the PC flip flop */
            IorD_reg        =0; /* Selects the address: 0= program counter(fetch), 1=load operation*/
            MemWrite_reg    =0; /* Write enable for the memory (on RAM), 1=enable, 0= disabled*/
            Mem_select_reg  =0; /* Memory selection: 0=ROM, 1=RAM*/
            IRWrite_reg     =0; /* Enable signal for Instruction Flip flop (ROM to Reg File)*/
            DataWrite_reg   =0; /* Controls the flip flop for data (RAM to Reg File)*/
            MemtoReg_reg    =0;	/* This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
            RegDst_reg      =0; /* Mux selector for A3(destination)-Reg File, 0=rt (imm 20:16), 1=rd (r 15:11)*/
            RegWrite_reg    =0; /* Enables writing on Register file*/
            RDx_FF_en_reg   =0; /* Controls the flip flop from RD1 to SrcA ALU (execution) and from RD2 to MUX4:1*/
            ALUSrcB_reg     =0; /* Allows to select the operand (on Mux 4:1) for getting srcB number */
            ALUControl_reg  =0; /* Selects ALU operation */
            ALUSrcA_reg     =0; /* Allows to select either PC (0) or data from A (1) */	
            ALUresult_en_reg=0; /* Allows writing to ALU register*/
            PCSrc_reg       =0; /* Allows to select the PC source, 0=ALUResult, 1=ALUOut*/
        end
        FETCH:
        begin
            /* Read ROM mem and store it in instruction Flip flop */
            /* Aumenta PC, 4*/
            PC_En_reg       =1;     /* Control signal for the PC flip flop */
            IorD_reg        =0;     /* Selects the address: 0= program counter(fetch), 1=load operation*/
            MemWrite_reg    =0;     /* Write enable for the memory (on RAM), 1=enable, 0= disabled*/
            Mem_select_reg  =0;     /* Memory selection: 0=ROM, 1=RAM*/
            IRWrite_reg     =1;     /* Enable signal for Instruction Flip flop (ROM to Reg File)*/
            DataWrite_reg   =0;     /* Controls the flip flop for data (RAM to Reg File)*/
            MemtoReg_reg    =0;	    /* This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
            RegDst_reg      =0;     /* Mux selector for A3(destination)-Reg File, 0=rt (imm 20:16), 1=rd (r 15:11)*/
            RegWrite_reg    =0;     /* Enables writing on Register file*/
            RDx_FF_en_reg   =0;     /* Controls the flip flop from RD1 to SrcA ALU (execution) and from RD2 to MUX4:1*/
            ALUSrcB_reg     =2'd1;  /* Selects operand 01 = 4 to do PC+4*/
            ALUControl_reg  =4'd2;  /* Selects ALU operation : Sum */
            ALUSrcA_reg     =0;     /* Allows to select either PC (0) */	
            ALUresult_en_reg=0;     /* Allows writing to ALU register*/
            PCSrc_reg       =0;     /* Allows to select the PC source, 0=ALUResult*/
        end
        DECODE:
        begin
            /*  El PC ya tiene 4 más , apunta a la siguiente dirección
                Traduce la instrucción (Prepare address)
                Define qué tipo de instrucción es.
                Prepara la operación de la ALU */
            PC_En_reg       =0;     /* Control signal for the PC flip flop */
            IorD_reg        =0;     /* not relevant*/
            MemWrite_reg    =0;     /* Write enable for the memory (on RAM), 1=enable, 0= disabled*/
            Mem_select_reg  =0;     /* Memory selection: 0=ROM,  1=RAM*/
            IRWrite_reg     =0;     /* not relevant*/
            DataWrite_reg   =0;     /* not relevant */
            MemtoReg_reg    =0;	    /* not relevant */
            RegDst_reg      = destination_indicator_wire;     /* A3(destination)-Reg File, 0=rt (imm 20:16), 1=rd (r 15:11)*/
            RegWrite_reg    =0;     /* not relevant*/
            RDx_FF_en_reg   =1;     /* FF RD1 to SrcA ALU (execution) and from RD2 to MUX4:1*/
            ALUSrcB_reg     = ALUSrcB_wire;     /* not relevant */
            ALUControl_reg  = ALUControl;     /* not relevant */
            ALUSrcA_reg     =1;     /* not relevant */
            ALUresult_en_reg=0;     /* not relevant */
            PCSrc_reg       =0;     /* not relevant */
        end
        DETERMINE_EXECUTION:
        begin
        end
        STORE_OR_LOAD:
        begin
        end 
        EXECUTE:
        begin
            /*  Ya se tienen los datos provenientes del Reg File (RD1 y RD2)
                Se pasan los datos a la ALU para alguna operación
                Se elige la operación a realizar dependiendo de la decodificación de la instrucción
                Se guarda el resultado en Flip flop ALUout
            */
            PC_En_reg       =0; /* not relevant */
            IorD_reg        =0; /* not relevant */
            MemWrite_reg    =0; /* not relevant */
            Mem_select_reg  =0; /* not relevant */
            IRWrite_reg     =0; /* not relevant */
            DataWrite_reg   =0; /* not relevant */
            MemtoReg_reg    =0;	/* not relevant */
            RegDst_reg      =destination_indicator_wire; /* not relevant */
            RegWrite_reg    =0; /* not relevant */
            RDx_FF_en_reg   =0; /* not relevant */
            ALUSrcB_reg     =ALUSrcB_wire; /* Allows to select the operand (on Mux 4:1) for getting srcB number */
            ALUControl_reg  =ALUControl; /* Selects ALU operation */
            ALUSrcA_reg     =1; /* Select data from A , RD1 */	
            ALUresult_en_reg=1; /* allows to save on the next cycle the ALU result*/
            PCSrc_reg       =0; /* not relevant*/
        end
        WRITE_BACKTOREG:
        begin
            /*  El resultado de la ALU se escribe al registro destino en Register File
              */
            PC_En_reg       =0; /* not relevant */
            IorD_reg        =0; /* not relevant */
            MemWrite_reg    =0; /* not relevant */
            Mem_select_reg  =0; /* Memory selection: 0=ROM, 1=RAM*/
            IRWrite_reg     =0; /* not relevant */
            DataWrite_reg   =0; /* not relevant */
            MemtoReg_reg    =0;	/* This will select the correct data for WD3; 0=ALUout*/
            RegDst_reg      =destination_indicator_wire /* Mux selector for A3(destination)-Reg File, 0=rt (imm 20:16), 1=rd (r 15:11)*/
            RegWrite_reg    =1; /* Enables writing on Register file*/
            RDx_FF_en_reg   =0; /* not relevant */
            ALUSrcB_reg     =0; /* not relevant */
            ALUControl_reg  =0; /* not relevant */
            ALUSrcA_reg     =0; /* not relevant */	
            ALUresult_en_reg=0; /* not relevant */
            PCSrc_reg       =0; /* not relevant */          
        end
        GET_EFFECTIVE_ADDR:     /* For sw operation */
        begin
            /* En este punto ya se decodificó la instrucción
                rs: tiene el valor a escribir (está en RD1)
                rt: tiene la dirección base del destino (está en RD2)
                immediate: tiene el offset que hay que sumar a rt */
            
            PC_En_reg       =0; /* not relevant */
            IorD_reg        =0; /* not relevant */
            MemWrite_reg    =0; /* not relevant */
            Mem_select_reg  =0; /* not relevant */
            IRWrite_reg     =0; /* not relevant */
            DataWrite_reg   =0; /* not relevant */
            MemtoReg_reg    =0;	/* not relevant */
            RegDst_reg      =0; /* not relevant */
            RegWrite_reg    =0; /* not relevant */
            RDx_FF_en_reg   =1; /* Controls the flip flop from RD1 to SrcA ALU (execution) and from RD2 to MUX4:1*/
            ALUSrcB_reg     =2'd2; /* Allows to select '10' for srcB number */
            ALUControl_reg  =ALUControl; /* It should do Add operation */
            ALUSrcA_reg     =1; /* Select data from A (1) */	
            ALUresult_en_reg=1; /* Allows writing to ALU register*/
            PCSrc_reg       =0; /* not relevant */
        end 
        STORE:
        begin
            PC_En_reg       =0; /* not relevant */
            IorD_reg        =1; /* Selects the address: 1=store operation*/
            MemWrite_reg    =1; /* Write enable for the memory (on RAM), 1=enable, 0= disabled*/
            Mem_select_reg  =1; /* Memory selection: 0=ROM, 1=RAM*/
            IRWrite_reg     =0; /* not relevant */
            DataWrite_reg   =0; /* not relevant */
            MemtoReg_reg    =0;	/* not relevant */
            RegDst_reg      =0; /* not relevant */
            RegWrite_reg    =0; /* not relevant */
            RDx_FF_en_reg   =0; /* not relevant */
            ALUSrcB_reg     =0; /* not relevant */
            ALUControl_reg  =0; /* not relevant */
            ALUSrcA_reg     =0; /* not relevant */	
            ALUresult_en_reg=0; /* not relevant */
            PCSrc_reg       =0; /* not relevant */
        end
        LOAD:
        begin
            PC_En_reg       =0; /* not relevant */
            IorD_reg        =1; /* Selects the address: 1=load operation */
            MemWrite_reg    =0; /* not relevant */
            Mem_select_reg  =1; /* Memory selection: 0=ROM, 1=RAM*/
            IRWrite_reg     =0; /* not relevant */
            DataWrite_reg   =1; /* Controls the flip flop for data (RAM to Reg File)*/
            MemtoReg_reg    =1;	/* This will select the correct data for WD3; 0=ALUout, 1=Data from RAM*/
            RegDst_reg      =destination_indicator_wire; 
            RegWrite_reg    =0; /* not relevant */
            RDx_FF_en_reg   =0; /* not relevant */
            ALUSrcB_reg     =0; /* not relevant */
            ALUControl_reg  =0; /* not relevant */
            ALUSrcA_reg     =0; /* not relevant */
            ALUresult_en_reg=0; /* not relevant */
            PCSrc_reg       =0; /* not relevant */

        end
        BRANCH:
        begin
            
        end
    endcase
end 



endmodule
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Magenta /MIPS_jump_TB/clk
add wave -noupdate /MIPS_jump_TB/reset
add wave -noupdate -color Magenta -label count_state /MIPS_jump_TB/state
add wave -noupdate -color Yellow -label state_controlUnit /MIPS_jump_TB/testing_unit/CtrlUnit/state
add wave -noupdate -divider MemoryMIPS
add wave -noupdate /MIPS_jump_TB/testing_unit/MemoryMIPS/addr
add wave -noupdate /MIPS_jump_TB/testing_unit/MemoryMIPS/wdata
add wave -noupdate /MIPS_jump_TB/testing_unit/MemoryMIPS/we
add wave -noupdate /MIPS_jump_TB/testing_unit/MemoryMIPS/clk
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/MemoryMIPS/mem_sel
add wave -noupdate -radix hexadecimal /MIPS_jump_TB/testing_unit/MemoryMIPS/q
add wave -noupdate -radix hexadecimal /MIPS_jump_TB/testing_unit/MemoryMIPS/q_rom
add wave -noupdate -radix hexadecimal /MIPS_jump_TB/testing_unit/MemoryMIPS/q_ram
add wave -noupdate -divider Virtual_Memory
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/VirtualMem/address
add wave -noupdate -radix hexadecimal /MIPS_jump_TB/testing_unit/VirtualMem/translated_addr
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/VirtualMem/aligment_error
add wave -noupdate -radix hexadecimal /MIPS_jump_TB/testing_unit/VirtualMem/MIPS_address
add wave -noupdate -radix hexadecimal /MIPS_jump_TB/testing_unit/VirtualMem/add_tmp
add wave -noupdate -divider Reg_forInstruction
add wave -noupdate /MIPS_jump_TB/testing_unit/Reg_forInstruction/clk
add wave -noupdate /MIPS_jump_TB/testing_unit/Reg_forInstruction/reset
add wave -noupdate -label IRWrite_wire -radix unsigned /MIPS_jump_TB/testing_unit/Reg_forInstruction/enable
add wave -noupdate -label Mmemory_output -radix hexadecimal /MIPS_jump_TB/testing_unit/Reg_forInstruction/Data_Input
add wave -noupdate -color Red -label Instruction_fetched -radix hexadecimal /MIPS_jump_TB/testing_unit/Reg_forInstruction/Data_Output
add wave -noupdate -radix hexadecimal /MIPS_jump_TB/testing_unit/VirtualMem/MIPS_address
add wave -noupdate -divider Reg_forData
add wave -noupdate /MIPS_jump_TB/testing_unit/Reg_forData/clk
add wave -noupdate /MIPS_jump_TB/testing_unit/Reg_forData/reset
add wave -noupdate -label DataWrite_wire /MIPS_jump_TB/testing_unit/Reg_forData/enable
add wave -noupdate -label Mmemory_output -radix hexadecimal /MIPS_jump_TB/testing_unit/Reg_forData/Data_Input
add wave -noupdate -label DataMemory -radix hexadecimal /MIPS_jump_TB/testing_unit/Reg_forData/Data_Output
add wave -noupdate -divider Mux_SrcA
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/MUX_to_updateSrcA/mux_sel
add wave -noupdate /MIPS_jump_TB/testing_unit/MUX_to_updateSrcA/data1
add wave -noupdate /MIPS_jump_TB/testing_unit/MUX_to_updateSrcA/data2
add wave -noupdate /MIPS_jump_TB/testing_unit/MUX_to_updateSrcA/Data_out
add wave -noupdate -divider Mux_4_1
add wave -noupdate /MIPS_jump_TB/testing_unit/mux4_1_forALU/mux_sel
add wave -noupdate /MIPS_jump_TB/testing_unit/mux4_1_forALU/data1
add wave -noupdate /MIPS_jump_TB/testing_unit/mux4_1_forALU/data2
add wave -noupdate /MIPS_jump_TB/testing_unit/mux4_1_forALU/data3
add wave -noupdate /MIPS_jump_TB/testing_unit/mux4_1_forALU/data4
add wave -noupdate /MIPS_jump_TB/testing_unit/mux4_1_forALU/Data_out
add wave -noupdate -divider ALU
add wave -noupdate -radix hexadecimal /MIPS_jump_TB/testing_unit/alu_unit/dataA
add wave -noupdate -radix hexadecimal /MIPS_jump_TB/testing_unit/alu_unit/dataB
add wave -noupdate /MIPS_jump_TB/testing_unit/alu_unit/control
add wave -noupdate /MIPS_jump_TB/testing_unit/alu_unit/shmt
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/alu_unit/carry
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/alu_unit/zero
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/alu_unit/negative
add wave -noupdate -radix hexadecimal /MIPS_jump_TB/testing_unit/alu_unit/dataC
add wave -noupdate -divider ALUOut_Reg
add wave -noupdate /MIPS_jump_TB/testing_unit/Mem_forALUOut/clk
add wave -noupdate /MIPS_jump_TB/testing_unit/Mem_forALUOut/reset
add wave -noupdate -color Red -label ALUresult_en_wire -radix unsigned /MIPS_jump_TB/testing_unit/Mem_forALUOut/enable
add wave -noupdate -label ALUResult -radix hexadecimal /MIPS_jump_TB/testing_unit/Mem_forALUOut/Data_Input
add wave -noupdate -label ALUOut -radix hexadecimal /MIPS_jump_TB/testing_unit/Mem_forALUOut/Data_Output
add wave -noupdate -divider MUX_for_PC_Source
add wave -noupdate -label PCSrc_wire -radix unsigned /MIPS_jump_TB/testing_unit/MUX_for_PC_source/mux_sel
add wave -noupdate -label ALUResult -radix hexadecimal /MIPS_jump_TB/testing_unit/MUX_for_PC_source/data1
add wave -noupdate -label ALUOut -radix hexadecimal /MIPS_jump_TB/testing_unit/MUX_for_PC_source/data2
add wave -noupdate -label PC_source -radix hexadecimal /MIPS_jump_TB/testing_unit/MUX_for_PC_source/Data_out
add wave -noupdate -divider ProgramCounter_Reg
add wave -noupdate /MIPS_jump_TB/testing_unit/ProgramCounter_Reg/clk
add wave -noupdate /MIPS_jump_TB/testing_unit/ProgramCounter_Reg/reset
add wave -noupdate -color {Blue Violet} -label PC_En_wire -radix unsigned /MIPS_jump_TB/testing_unit/ProgramCounter_Reg/enable
add wave -noupdate -label PC_source -radix hexadecimal /MIPS_jump_TB/testing_unit/ProgramCounter_Reg/Data_Input
add wave -noupdate -label PC_current -radix hexadecimal /MIPS_jump_TB/testing_unit/ProgramCounter_Reg/Data_Output
add wave -noupdate -divider MUX_toupdatePC_jump
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/MUX_to_updatePC_withJump/mux_sel
add wave -noupdate -radix hexadecimal /MIPS_jump_TB/testing_unit/MUX_to_updatePC_withJump/data1
add wave -noupdate -radix hexadecimal /MIPS_jump_TB/testing_unit/MUX_to_updatePC_withJump/data2
add wave -noupdate -radix hexadecimal /MIPS_jump_TB/testing_unit/MUX_to_updatePC_withJump/Data_out
add wave -noupdate -divider decode_instruction
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/decoder_module/opcode_reg
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/decoder_module/funct_reg
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/decoder_module/destination_indicator
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/decoder_module/ALUControl
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/CtrlUnit/decoder_module/flag_sw
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/CtrlUnit/decoder_module/flag_lw
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/CtrlUnit/decoder_module/flag_R_type
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/CtrlUnit/decoder_module/flag_I_type
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/CtrlUnit/decoder_module/flag_J_type
add wave -noupdate -divider Shift_Concat
add wave -noupdate -radix hexadecimal /MIPS_jump_TB/testing_unit/shiftConcat_mod/J_address
add wave -noupdate /MIPS_jump_TB/testing_unit/shiftConcat_mod/PC_add
add wave -noupdate -radix hexadecimal /MIPS_jump_TB/testing_unit/shiftConcat_mod/new_jumpAddr
add wave -noupdate -divider Address_preparation
add wave -noupdate -label Instruction_fetched -radix hexadecimal /MIPS_jump_TB/testing_unit/add_prep/Mmemory_output
add wave -noupdate /MIPS_jump_TB/testing_unit/add_prep/opcode
add wave -noupdate /MIPS_jump_TB/testing_unit/add_prep/rs
add wave -noupdate /MIPS_jump_TB/testing_unit/add_prep/rt
add wave -noupdate /MIPS_jump_TB/testing_unit/add_prep/rd
add wave -noupdate /MIPS_jump_TB/testing_unit/add_prep/immediate_data
add wave -noupdate -radix hexadecimal /MIPS_jump_TB/testing_unit/add_prep/address_j
add wave -noupdate /MIPS_jump_TB/testing_unit/add_prep/shamt
add wave -noupdate /MIPS_jump_TB/testing_unit/add_prep/funct
add wave -noupdate -divider MUX_to_WriteData_RegFile
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/MUX_to_WriteData_RegFile/mux_sel
add wave -noupdate /MIPS_jump_TB/testing_unit/MUX_to_WriteData_RegFile/data1
add wave -noupdate /MIPS_jump_TB/testing_unit/MUX_to_WriteData_RegFile/data2
add wave -noupdate /MIPS_jump_TB/testing_unit/MUX_to_WriteData_RegFile/Data_out
add wave -noupdate -divider mux_A3_destination
add wave -noupdate -radix hexadecimal /MIPS_jump_TB/testing_unit/mux_A3_destination/mux_sel
add wave -noupdate /MIPS_jump_TB/testing_unit/mux_A3_destination/data1
add wave -noupdate /MIPS_jump_TB/testing_unit/mux_A3_destination/data2
add wave -noupdate /MIPS_jump_TB/testing_unit/mux_A3_destination/Data_out
add wave -noupdate -divider Register_file
add wave -noupdate /MIPS_jump_TB/testing_unit/RegisterFile_Unit/clk
add wave -noupdate /MIPS_jump_TB/testing_unit/RegisterFile_Unit/reset
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/RegisterFile_Unit/Read_Reg1
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/RegisterFile_Unit/Read_Reg2
add wave -noupdate -label mux_A3out -radix unsigned /MIPS_jump_TB/testing_unit/RegisterFile_Unit/Write_Reg
add wave -noupdate -label datatoWD3 -radix hexadecimal /MIPS_jump_TB/testing_unit/RegisterFile_Unit/Write_Data
add wave -noupdate -color Red -label RegWrite_wire -radix unsigned /MIPS_jump_TB/testing_unit/RegisterFile_Unit/Write
add wave -noupdate -color {Orange Red} -label RD1 -radix hexadecimal /MIPS_jump_TB/testing_unit/RegisterFile_Unit/Read_Data1
add wave -noupdate -color {Orange Red} -label RD2 -radix hexadecimal /MIPS_jump_TB/testing_unit/RegisterFile_Unit/Read_Data2
add wave -noupdate -divider Control_unit
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/clk
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/reset
add wave -noupdate -color Magenta /MIPS_jump_TB/testing_unit/CtrlUnit/count_state
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/Opcode
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/Funct
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/CtrlUnit/Zero
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/CtrlUnit/IorD
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/CtrlUnit/MemWrite
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/CtrlUnit/IRWrite
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/CtrlUnit/RegDst
add wave -noupdate -color Red -radix unsigned /MIPS_jump_TB/testing_unit/CtrlUnit/MemtoReg
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/CtrlUnit/PCWrite
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/CtrlUnit/Branch
add wave -noupdate -radix unsigned /MIPS_jump_TB/testing_unit/CtrlUnit/PCSrc
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/ALUControl
add wave -noupdate -color Magenta /MIPS_jump_TB/testing_unit/CtrlUnit/ALUSrcB
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/ALUSrcA
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/RegWrite
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/Mem_select
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/DataWrite
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/RDx_FF_en
add wave -noupdate -color Red -radix unsigned /MIPS_jump_TB/testing_unit/CtrlUnit/ALUresult_en
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/PC_En
add wave -noupdate -color Yellow /MIPS_jump_TB/testing_unit/CtrlUnit/state
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/AND1_wire
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/flag_sw_wire
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/flag_lw_wire
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/destination_indicator_wire
add wave -noupdate -color Magenta /MIPS_jump_TB/testing_unit/CtrlUnit/ALUSrcB_wire
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/flag_R_type_wire
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/flag_I_type_wire
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/flag_J_type_wire
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/IorD_reg
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/MemWrite_reg
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/IRWrite_reg
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/RegDst_reg
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/MemtoReg_reg
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/PCWrite_reg
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/Branch_reg
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/PCSrc_reg
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/ALUControl_reg
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/ALUSrcB_reg
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/ALUSrcA_reg
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/RegWrite_reg
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/Mem_select_reg
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/DataWrite_reg
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/RDx_FF_en_reg
add wave -noupdate /MIPS_jump_TB/testing_unit/CtrlUnit/ALUresult_en_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {410 ps} 0} {{Cursor 2} {430 ps} 0} {{Cursor 3} {450 ps} 0} {{Cursor 4} {770 ps} 0} {{Cursor 8} {890 ps} 0} {{Cursor 9} {1150 ps} 0}
quietly wave cursor active 4
configure wave -namecolwidth 170
configure wave -valuecolwidth 264
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {594 ps} {1041 ps}

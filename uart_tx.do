onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Test_UART_Controller/clk
add wave -noupdate /Test_UART_Controller/reset
add wave -noupdate /Test_UART_Controller/SerialDataIn
add wave -noupdate /Test_UART_Controller/clr_rx_flag
add wave -noupdate /Test_UART_Controller/clr_tx_flag
add wave -noupdate /Test_UART_Controller/uart_tx
add wave -noupdate /Test_UART_Controller/Start_Tx
add wave -noupdate /Test_UART_Controller/DataRx
add wave -noupdate /Test_UART_Controller/Rx_flag
add wave -noupdate /Test_UART_Controller/Tx_flag
add wave -noupdate /Test_UART_Controller/SerialDataOut
add wave -noupdate -divider {New Divider}
add wave -noupdate /Test_UART_Controller/uartctrl/Rx_flag_out
add wave -noupdate -radix hexadecimal /Test_UART_Controller/uartctrl/Tx_flag_out
add wave -noupdate -divider tx
add wave -noupdate -radix unsigned /Test_UART_Controller/uartctrl/SerialDataOut
add wave -noupdate /Test_UART_Controller/uartctrl/clk
add wave -noupdate -radix hexadecimal /Test_UART_Controller/uartctrl/uart_tx
add wave -noupdate -radix unsigned /Test_UART_Controller/uartctrl/Start_Tx
add wave -noupdate -radix unsigned /Test_UART_Controller/uartctrl/state_tx
add wave -noupdate -color Red -radix unsigned /Test_UART_Controller/uartctrl/endTx_flag
add wave -noupdate -radix unsigned /Test_UART_Controller/uartctrl/Send_byte_indicator
add wave -noupdate -radix unsigned /Test_UART_Controller/uartctrl/clr_tx_flag
add wave -noupdate -radix unsigned /Test_UART_Controller/uartctrl/byte_number
add wave -noupdate -radix hexadecimal /Test_UART_Controller/uartctrl/uart_tx_copy
add wave -noupdate -radix hexadecimal /Test_UART_Controller/uartctrl/Data_to_Tx_tmp_reg
add wave -noupdate -radix unsigned /Test_UART_Controller/uartctrl/Send_byte_indicator_reg
add wave -noupdate -radix unsigned /Test_UART_Controller/uartctrl/cleanTx_flag_reg
add wave -noupdate -divider tx_uart
add wave -noupdate /Test_UART_Controller/uartctrl/DUV_UART_TX/clk
add wave -noupdate /Test_UART_Controller/uartctrl/DUV_UART_TX/reset
add wave -noupdate -color Yellow /Test_UART_Controller/uartctrl/DUV_UART_TX/Transmit
add wave -noupdate /Test_UART_Controller/uartctrl/DUV_UART_TX/DataTx
add wave -noupdate -radix unsigned /Test_UART_Controller/uartctrl/DUV_UART_TX/clr_tx_flag
add wave -noupdate -color Yellow /Test_UART_Controller/uartctrl/DUV_UART_TX/SerialDataOut
add wave -noupdate -color Red /Test_UART_Controller/uartctrl/DUV_UART_TX/endTx_flag
add wave -noupdate -radix unsigned /Test_UART_Controller/uartctrl/DUV_UART_TX/bit_number
add wave -noupdate -color Yellow -radix unsigned /Test_UART_Controller/uartctrl/DUV_UART_TX/state
add wave -noupdate -radix hexadecimal /Test_UART_Controller/uartctrl/DUV_UART_TX/buff_tx
add wave -noupdate -radix unsigned /Test_UART_Controller/uartctrl/DUV_UART_TX/baud_count
add wave -noupdate /Test_UART_Controller/uartctrl/DUV_UART_TX/end_Tx_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 4} {26475 ps} 0} {{Cursor 5} {5885 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 206
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {63 ns}

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lcd_uart_tb/DUT/clk
add wave -noupdate /lcd_uart_tb/DUT/reset_l
add wave -noupdate -divider In
add wave -noupdate /lcd_uart_tb/DUT/RX
add wave -noupdate -divider Out
add wave -noupdate /lcd_uart_tb/DUT/CMD_PX_GO
add wave -noupdate -radix unsigned /lcd_uart_tb/DUT/CHAR
add wave -noupdate -divider -height 27 Internal
add wave -noupdate /lcd_uart_tb/DUT/epres
add wave -noupdate /lcd_uart_tb/DUT/esig
add wave -noupdate -divider Loop
add wave -noupdate -color {Orange Red} /lcd_uart_tb/DUT/RLOOP
add wave -noupdate -color Coral /lcd_uart_tb/DUT/CLR_LOOP
add wave -noupdate -color Coral /lcd_uart_tb/DUT/INCR_LOOP
add wave -noupdate -color Coral /lcd_uart_tb/DUT/END_LOOP
add wave -noupdate -divider Contador
add wave -noupdate -color {Orange Red} /lcd_uart_tb/DUT/RCONT
add wave -noupdate -color Coral /lcd_uart_tb/DUT/PR_CONT_HALF
add wave -noupdate -color Coral /lcd_uart_tb/DUT/PR_CONT_FULL
add wave -noupdate -color Coral /lcd_uart_tb/DUT/DECR_CONT
add wave -noupdate -color Coral /lcd_uart_tb/DUT/END_CONT
add wave -noupdate -divider Bitshift
add wave -noupdate -color {Orange Red} /lcd_uart_tb/DUT/RSHIFT
add wave -noupdate -color Coral /lcd_uart_tb/DUT/BITSHIFT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {128023372 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits ns
update
WaveRestoreZoom {93661550 ps} {185417370 ps}

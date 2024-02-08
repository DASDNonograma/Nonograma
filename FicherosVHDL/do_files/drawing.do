onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lcd_drawing_tb/DUT/Clk
add wave -noupdate /lcd_drawing_tb/DUT/RESET_L
add wave -noupdate -divider IN
add wave -noupdate -color Gold /lcd_drawing_tb/DUT/DEL_SCREEN
add wave -noupdate -color Gold /lcd_drawing_tb/DUT/DRAW_FIG
add wave -noupdate -color Red -radix hexadecimal /lcd_drawing_tb/DUT/COLOUR_CODE
add wave -noupdate -color Gold /lcd_drawing_tb/DUT/DONE_CURSOR
add wave -noupdate -color Gold /lcd_drawing_tb/DUT/DONE_COLOUR
add wave -noupdate -divider {OUT - TO LCD_CTRL}
add wave -noupdate /lcd_drawing_tb/DUT/OP_SETCURSOR
add wave -noupdate -color Turquoise -radix unsigned /lcd_drawing_tb/DUT/XCOL
add wave -noupdate -color Turquoise -radix unsigned /lcd_drawing_tb/DUT/YROW
add wave -noupdate /lcd_drawing_tb/DUT/OP_DRAWCOLOUR
add wave -noupdate -color Turquoise -radix hexadecimal /lcd_drawing_tb/DUT/RGB
add wave -noupdate -color Turquoise -radix unsigned /lcd_drawing_tb/DUT/NUM_PIX
add wave -noupdate -divider LCD_DRAWING
add wave -noupdate -color Gray70 /lcd_drawing_tb/DUT/epres
add wave -noupdate -color Gray70 /lcd_drawing_tb/DUT/esig
add wave -noupdate -color Magenta /lcd_drawing_tb/DUT/MUX_val
add wave -noupdate -color Magenta /lcd_drawing_tb/DUT/MUX_CLR
add wave -noupdate -color Magenta /lcd_drawing_tb/DUT/MUX_PRS
add wave -noupdate -color Magenta /lcd_drawing_tb/DUT/END_TRIA
add wave -noupdate -color Magenta /lcd_drawing_tb/DUT/INC_XYTRIA
add wave -noupdate -color Magenta /lcd_drawing_tb/DUT/DEC_TRIA_PIX
add wave -noupdate -radix unsigned /lcd_drawing_tb/DUT/TRIA_PIX
add wave -noupdate -divider -height 27 LCD_CTRL
add wave -noupdate -color Gold /lcd_drawing_tb/ctrl/LCD_CS_N
add wave -noupdate -color Gold /lcd_drawing_tb/ctrl/LCD_WR_N
add wave -noupdate -color Gold /lcd_drawing_tb/ctrl/LCD_RS
add wave -noupdate -color Red -radix hexadecimal /lcd_drawing_tb/ctrl/LCD_DATA
add wave -noupdate -radix unsigned /lcd_drawing_tb/ctrl/numpix_internal
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3274640 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 406
configure wave -valuecolwidth 98
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
WaveRestoreZoom {0 ps} {8925 ns}

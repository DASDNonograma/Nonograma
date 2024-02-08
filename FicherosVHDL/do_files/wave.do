onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lcd_ctrl_tb/DUT/clk
add wave -noupdate /lcd_ctrl_tb/DUT/reset
add wave -noupdate /lcd_ctrl_tb/DUT/LCD_init_done
add wave -noupdate /lcd_ctrl_tb/DUT/OP_SETCURSOR
add wave -noupdate /lcd_ctrl_tb/DUT/OP_DRAWCOLOUR
add wave -noupdate /lcd_ctrl_tb/DUT/XCOL
add wave -noupdate /lcd_ctrl_tb/DUT/YROW
add wave -noupdate -radix hexadecimal /lcd_ctrl_tb/DUT/RGB
add wave -noupdate -radix unsigned /lcd_ctrl_tb/DUT/NUM_PIX
add wave -noupdate /lcd_ctrl_tb/DUT/DONE_CURSOR
add wave -noupdate /lcd_ctrl_tb/DUT/DONE_COLOUR
add wave -noupdate /lcd_ctrl_tb/DUT/LCD_CS_N
add wave -noupdate /lcd_ctrl_tb/DUT/LCD_RS
add wave -noupdate /lcd_ctrl_tb/DUT/LCD_WR_N
add wave -noupdate -radix hexadecimal /lcd_ctrl_tb/DUT/LCD_DATA
add wave -noupdate /lcd_ctrl_tb/DUT/epres
add wave -noupdate /lcd_ctrl_tb/DUT/esig
add wave -noupdate /lcd_ctrl_tb/DUT/CL_LCD_DATA
add wave -noupdate /lcd_ctrl_tb/DUT/RXCOL
add wave -noupdate /lcd_ctrl_tb/DUT/RYROW
add wave -noupdate /lcd_ctrl_tb/DUT/LD_cursor
add wave -noupdate -radix hexadecimal -childformat {{/lcd_ctrl_tb/DUT/RRGB(15) -radix hexadecimal} {/lcd_ctrl_tb/DUT/RRGB(14) -radix hexadecimal} {/lcd_ctrl_tb/DUT/RRGB(13) -radix hexadecimal} {/lcd_ctrl_tb/DUT/RRGB(12) -radix hexadecimal} {/lcd_ctrl_tb/DUT/RRGB(11) -radix hexadecimal} {/lcd_ctrl_tb/DUT/RRGB(10) -radix hexadecimal} {/lcd_ctrl_tb/DUT/RRGB(9) -radix hexadecimal} {/lcd_ctrl_tb/DUT/RRGB(8) -radix hexadecimal} {/lcd_ctrl_tb/DUT/RRGB(7) -radix hexadecimal} {/lcd_ctrl_tb/DUT/RRGB(6) -radix hexadecimal} {/lcd_ctrl_tb/DUT/RRGB(5) -radix hexadecimal} {/lcd_ctrl_tb/DUT/RRGB(4) -radix hexadecimal} {/lcd_ctrl_tb/DUT/RRGB(3) -radix hexadecimal} {/lcd_ctrl_tb/DUT/RRGB(2) -radix hexadecimal} {/lcd_ctrl_tb/DUT/RRGB(1) -radix hexadecimal} {/lcd_ctrl_tb/DUT/RRGB(0) -radix hexadecimal}} -subitemconfig {/lcd_ctrl_tb/DUT/RRGB(15) {-height 15 -radix hexadecimal} /lcd_ctrl_tb/DUT/RRGB(14) {-height 15 -radix hexadecimal} /lcd_ctrl_tb/DUT/RRGB(13) {-height 15 -radix hexadecimal} /lcd_ctrl_tb/DUT/RRGB(12) {-height 15 -radix hexadecimal} /lcd_ctrl_tb/DUT/RRGB(11) {-height 15 -radix hexadecimal} /lcd_ctrl_tb/DUT/RRGB(10) {-height 15 -radix hexadecimal} /lcd_ctrl_tb/DUT/RRGB(9) {-height 15 -radix hexadecimal} /lcd_ctrl_tb/DUT/RRGB(8) {-height 15 -radix hexadecimal} /lcd_ctrl_tb/DUT/RRGB(7) {-height 15 -radix hexadecimal} /lcd_ctrl_tb/DUT/RRGB(6) {-height 15 -radix hexadecimal} /lcd_ctrl_tb/DUT/RRGB(5) {-height 15 -radix hexadecimal} /lcd_ctrl_tb/DUT/RRGB(4) {-height 15 -radix hexadecimal} /lcd_ctrl_tb/DUT/RRGB(3) {-height 15 -radix hexadecimal} /lcd_ctrl_tb/DUT/RRGB(2) {-height 15 -radix hexadecimal} /lcd_ctrl_tb/DUT/RRGB(1) {-height 15 -radix hexadecimal} /lcd_ctrl_tb/DUT/RRGB(0) {-height 15 -radix hexadecimal}} /lcd_ctrl_tb/DUT/RRGB
add wave -noupdate -radix unsigned /lcd_ctrl_tb/DUT/numpix_internal
add wave -noupdate /lcd_ctrl_tb/DUT/LD_DRAW
add wave -noupdate /lcd_ctrl_tb/DUT/DEC_PIX
add wave -noupdate /lcd_ctrl_tb/DUT/END_PIX
add wave -noupdate -radix hexadecimal /lcd_ctrl_tb/DUT/LCD_DATA_local
add wave -noupdate /lcd_ctrl_tb/DUT/LD_2C
add wave -noupdate /lcd_ctrl_tb/DUT/INC_DAT
add wave -noupdate /lcd_ctrl_tb/DUT/CL_DAT
add wave -noupdate -radix unsigned /lcd_ctrl_tb/DUT/QDAT
add wave -noupdate /lcd_ctrl_tb/DUT/RSDAT
add wave -noupdate /lcd_ctrl_tb/DUT/RSCOM
add wave -noupdate -radix hexadecimal /lcd_ctrl_tb/DUT/rgb_int
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2218516 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 135
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
WaveRestoreZoom {1949297 ps} {2629697 ps}

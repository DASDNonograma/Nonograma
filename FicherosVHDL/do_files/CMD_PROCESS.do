onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lcd_cmd_process_tb/DUT/clk
add wave -noupdate /lcd_cmd_process_tb/DUT/reset_l
add wave -noupdate -divider IN
add wave -noupdate -radix ascii /lcd_cmd_process_tb/DUT/CHAR
add wave -noupdate /lcd_cmd_process_tb/DUT/CMD_PX_GO
add wave -noupdate /lcd_cmd_process_tb/DUT/NONO_Init_Done
add wave -noupdate /lcd_cmd_process_tb/DUT/DONE_CMD
add wave -noupdate -divider OUT
add wave -noupdate /lcd_cmd_process_tb/DUT/COMMAND
add wave -noupdate /lcd_cmd_process_tb/DUT/OUT_CMD
add wave -noupdate /lcd_cmd_process_tb/DUT/NONO_INI
add wave -noupdate -divider -height 27 INTERNAL
add wave -noupdate /lcd_cmd_process_tb/DUT/epres
add wave -noupdate /lcd_cmd_process_tb/DUT/esig
add wave -noupdate -divider signals
add wave -noupdate /lcd_cmd_process_tb/DUT/RMODE
add wave -noupdate /lcd_cmd_process_tb/DUT/NONO_MODE
add wave -noupdate /lcd_cmd_process_tb/DUT/IMG_MODE
add wave -noupdate -radix ascii /lcd_cmd_process_tb/DUT/RCHAR
add wave -noupdate /lcd_cmd_process_tb/DUT/LD_CHAR
add wave -noupdate /lcd_cmd_process_tb/DUT/RCOMMAND
add wave -noupdate /lcd_cmd_process_tb/DUT/COD_CMD
add wave -noupdate /lcd_cmd_process_tb/DUT/LD_COMMAND
add wave -noupdate /lcd_cmd_process_tb/DUT/VALID_CHAR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {590000 ps} 0}
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
WaveRestoreZoom {379270 ps} {2085302 ps}

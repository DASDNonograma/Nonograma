onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cmd_process_tb/DUT/clk
add wave -noupdate /cmd_process_tb/DUT/reset_l
add wave -noupdate -divider IN
add wave -noupdate -radix ascii /cmd_process_tb/DUT/CHAR
add wave -noupdate /cmd_process_tb/DUT/CMD_PX_GO
add wave -noupdate /cmd_process_tb/DUT/DONE_CMD
add wave -noupdate /cmd_process_tb/DUT/DONE_BIT
add wave -noupdate -divider OUT
add wave -noupdate /cmd_process_tb/DUT/COMMAND
add wave -noupdate /cmd_process_tb/DUT/OUT_CMD
add wave -noupdate /cmd_process_tb/DUT/INI_NONO
add wave -noupdate -divider -height 27 INTERNAL
add wave -noupdate /cmd_process_tb/DUT/epres
add wave -noupdate /cmd_process_tb/DUT/esig
add wave -noupdate /cmd_process_tb/DUT/RMODE
add wave -noupdate /cmd_process_tb/DUT/NONO_MODE
add wave -noupdate /cmd_process_tb/DUT/INI_MODE
add wave -noupdate /cmd_process_tb/DUT/IMG_MODE
add wave -noupdate /cmd_process_tb/DUT/RCHAR
add wave -noupdate /cmd_process_tb/DUT/LD_CHAR
add wave -noupdate /cmd_process_tb/DUT/RCOMMAND
add wave -noupdate /cmd_process_tb/DUT/COD_CMD
add wave -noupdate /cmd_process_tb/DUT/IN_COMMAND
add wave -noupdate /cmd_process_tb/DUT/LD_COMMAND
add wave -noupdate -radix unsigned /cmd_process_tb/DUT/CONT
add wave -noupdate /cmd_process_tb/DUT/INCR_CONT
add wave -noupdate /cmd_process_tb/DUT/END_SOL
add wave -noupdate /cmd_process_tb/DUT/IS_ONE
add wave -noupdate /cmd_process_tb/DUT/VALID_CHAR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {82584 ps} 0}
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
WaveRestoreZoom {0 ps} {3150 ns}

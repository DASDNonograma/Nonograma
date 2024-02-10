onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /nono_cursor_tb/DUT/clk
add wave -noupdate /nono_cursor_tb/DUT/reset_l
add wave -noupdate -divider IN
add wave -noupdate /nono_cursor_tb/DUT/COMMAND
add wave -noupdate /nono_cursor_tb/DUT/OUT_COMMAND
add wave -noupdate /nono_cursor_tb/DUT/DONE_UPDATE
add wave -noupdate /nono_cursor_tb/DUT/DONE_TOGGLE
add wave -noupdate /nono_cursor_tb/DUT/NONO_INIT_DONE
add wave -noupdate -divider OUT
add wave -noupdate /nono_cursor_tb/DUT/CURSORX
add wave -noupdate /nono_cursor_tb/DUT/CURSORY
add wave -noupdate /nono_cursor_tb/DUT/UPDATE_CURSOR
add wave -noupdate /nono_cursor_tb/DUT/TOGGLE_CURSOR
add wave -noupdate -divider -height 27 INTERNAL
add wave -noupdate -color {Orange Red} /nono_cursor_tb/DUT/epres
add wave -noupdate -color {Orange Red} /nono_cursor_tb/DUT/esig
add wave -noupdate -color {Orange Red} /nono_cursor_tb/DUT/VERT
add wave -noupdate -color {Orange Red} /nono_cursor_tb/DUT/cursor_cmd
add wave -noupdate -color {Orange Red} /nono_cursor_tb/DUT/incr_decr
add wave -noupdate -color {Orange Red} /nono_cursor_tb/DUT/RCOMMAND
add wave -noupdate -color {Orange Red} /nono_cursor_tb/DUT/LD_COMMAND
add wave -noupdate -color {Orange Red} /nono_cursor_tb/DUT/UP_DOWN
add wave -noupdate -color {Orange Red} /nono_cursor_tb/DUT/RCURSORX
add wave -noupdate -color {Orange Red} /nono_cursor_tb/DUT/RCURSORY
add wave -noupdate -color {Orange Red} /nono_cursor_tb/DUT/COUNTX
add wave -noupdate -color {Orange Red} /nono_cursor_tb/DUT/COUNTY
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {531481 ps} 0}
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
WaveRestoreZoom {0 ps} {2625 ns}

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Entradas
add wave -noupdate /nono_graphics_tb/DUT/Clk
add wave -noupdate /nono_graphics_tb/DUT/Reset_L
add wave -noupdate /nono_graphics_tb/DUT/OUT_CMD
add wave -noupdate /nono_graphics_tb/DUT/DONE_DEL
add wave -noupdate /nono_graphics_tb/DUT/DONE_FIG
add wave -noupdate /nono_graphics_tb/DUT/UPDATE_CURSOR
add wave -noupdate /nono_graphics_tb/DUT/TOGGLE_CURSOR
add wave -noupdate /nono_graphics_tb/DUT/NONO_INI
add wave -noupdate /nono_graphics_tb/DUT/COMMAND
add wave -noupdate -radix unsigned /nono_graphics_tb/DUT/CURSOR_POSX
add wave -noupdate -radix unsigned /nono_graphics_tb/DUT/CURSOR_POSY
add wave -noupdate -divider Salidas
add wave -noupdate /nono_graphics_tb/DUT/DRAW_TRIA
add wave -noupdate /nono_graphics_tb/DUT/DRAW_CUAD
add wave -noupdate /nono_graphics_tb/DUT/DRAW_LINE
add wave -noupdate /nono_graphics_tb/DUT/DEL_SCREEN
add wave -noupdate /nono_graphics_tb/DUT/DONE_UPDATE
add wave -noupdate /nono_graphics_tb/DUT/DONE_TOGGLE
add wave -noupdate /nono_graphics_tb/DUT/NONO_init_DONE
add wave -noupdate /nono_graphics_tb/DUT/DONE_BIT
add wave -noupdate -radix unsigned /nono_graphics_tb/DUT/XCOOR
add wave -noupdate -radix unsigned /nono_graphics_tb/DUT/YCOOR
add wave -noupdate /nono_graphics_tb/DUT/COLOUR_CODE
add wave -noupdate -divider Internas
add wave -noupdate /nono_graphics_tb/DUT/epres
add wave -noupdate /nono_graphics_tb/DUT/esig
add wave -noupdate /nono_graphics_tb/DUT/CONT_FIG
add wave -noupdate /nono_graphics_tb/DUT/SOL
add wave -noupdate -radix unsigned /nono_graphics_tb/DUT/RXPOS
add wave -noupdate -radix unsigned /nono_graphics_tb/DUT/RYPOS
add wave -noupdate -radix unsigned /nono_graphics_tb/DUT/XINI
add wave -noupdate -radix unsigned /nono_graphics_tb/DUT/RXLINE
add wave -noupdate -radix unsigned /nono_graphics_tb/DUT/RXCUAD
add wave -noupdate -radix unsigned /nono_graphics_tb/DUT/XLINE
add wave -noupdate -radix unsigned /nono_graphics_tb/DUT/XCUAD
add wave -noupdate -radix unsigned /nono_graphics_tb/DUT/YINI
add wave -noupdate -radix unsigned /nono_graphics_tb/DUT/RYLINE
add wave -noupdate -radix unsigned /nono_graphics_tb/DUT/RYCUAD
add wave -noupdate -radix unsigned /nono_graphics_tb/DUT/YLINE
add wave -noupdate -radix unsigned /nono_graphics_tb/DUT/YCUAD
add wave -noupdate -radix unsigned /nono_graphics_tb/DUT/CONT_SOL
add wave -noupdate -radix unsigned /nono_graphics_tb/DUT/CURSOR_SOL
add wave -noupdate /nono_graphics_tb/DUT/SEL_FIG
add wave -noupdate /nono_graphics_tb/DUT/LD_CONT_SOL
add wave -noupdate -radix unsigned /nono_graphics_tb/DUT/DECR_CONT_SOL
add wave -noupdate /nono_graphics_tb/DUT/END_SOL
add wave -noupdate /nono_graphics_tb/DUT/LD_SOL
add wave -noupdate /nono_graphics_tb/DUT/LD_CONT_FIG
add wave -noupdate /nono_graphics_tb/DUT/DECR_CONT_FIG
add wave -noupdate /nono_graphics_tb/DUT/SEL_TRIA
add wave -noupdate /nono_graphics_tb/DUT/SEL_CUAD
add wave -noupdate /nono_graphics_tb/DUT/SEL_LINE
add wave -noupdate /nono_graphics_tb/DUT/LD_LINE
add wave -noupdate /nono_graphics_tb/DUT/LD_CUAD
add wave -noupdate /nono_graphics_tb/DUT/LD_TRIA
add wave -noupdate /nono_graphics_tb/DUT/INCR_XPOS
add wave -noupdate /nono_graphics_tb/DUT/INCR_YPOS
add wave -noupdate /nono_graphics_tb/DUT/LD_XPOS
add wave -noupdate /nono_graphics_tb/DUT/LD_YPOS
add wave -noupdate /nono_graphics_tb/DUT/XLIM_CUAD
add wave -noupdate /nono_graphics_tb/DUT/YLIM_CUAD
add wave -noupdate /nono_graphics_tb/DUT/XLIM_LINE
add wave -noupdate /nono_graphics_tb/DUT/YLIM_LINE
add wave -noupdate /nono_graphics_tb/DUT/CL_FIG
add wave -noupdate -divider DRAWING
add wave -noupdate /nono_graphics_tb/drawing/DEL_SCREEN
add wave -noupdate /nono_graphics_tb/drawing/OP_SETCURSOR
add wave -noupdate /nono_graphics_tb/drawing/OP_DRAWCOLOUR
add wave -noupdate /nono_graphics_tb/drawing/DONE_DEL
add wave -noupdate /nono_graphics_tb/drawing/epres
add wave -noupdate /nono_graphics_tb/drawing/esig
add wave -noupdate /nono_graphics_tb/drawing/DONE_COLOUR
add wave -noupdate /nono_graphics_tb/drawing/DONE_CURSOR
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/clk
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/reset_l
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/UPDATE_CURSOR
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/TOGGLE_CURSOR
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/DONE_FIG
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/sol_out
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/cursorx
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/cursory
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/XCOOR_int
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/YCOOR_int
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/COLOUR_CODE_int
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/DRAW_CUAD_int
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/DRAW_TRIA_int
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/DONE_UPDATE
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/DONE_TOGGLE
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/addr_int
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/rd_sol
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/epres
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/esig
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/v
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/action
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/sel
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/incr_if_same
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/mux_dir
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/dir
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/offset_x_int
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/offset_y_int
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/valor_multiplicacion
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/colour_code_inte
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/rcursorx
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/ld_cursor
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/rcursory
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/in_xcoor_int
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/ld_coords_int
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/in_ycoor_int
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/cont_dir
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/clr_cont
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/incr_cont
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/end_cont
add wave -noupdate -radix unsigned /nono_graphics_tb/DUT/graphics_cursor/same
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/incr_same
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/win
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/wr
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/rd
add wave -noupdate /nono_graphics_tb/DUT/graphics_cursor/data_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12702690000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 147
configure wave -valuecolwidth 91
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
WaveRestoreZoom {12486754967 ps} {13172185430 ps}

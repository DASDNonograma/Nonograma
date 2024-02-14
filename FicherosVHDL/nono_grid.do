onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /nono_graphics_grid_tb/DUT/clk
add wave -noupdate /nono_graphics_grid_tb/DUT/reset_l
add wave -noupdate -divider IN
add wave -noupdate /nono_graphics_grid_tb/DUT/GRID_OP
add wave -noupdate /nono_graphics_grid_tb/DUT/DONE_DEL
add wave -noupdate /nono_graphics_grid_tb/DUT/DONE_FIG
add wave -noupdate -divider OUT
add wave -noupdate /nono_graphics_grid_tb/DUT/XCOOR
add wave -noupdate /nono_graphics_grid_tb/DUT/YCOOR
add wave -noupdate /nono_graphics_grid_tb/DUT/COLOUR_CODE
add wave -noupdate /nono_graphics_grid_tb/DUT/DONE_GRID
add wave -noupdate /nono_graphics_grid_tb/DUT/DEL_SCREEN
add wave -noupdate /nono_graphics_grid_tb/DUT/DRAW_CUAD
add wave -noupdate /nono_graphics_grid_tb/DUT/DRAW_TRIA
add wave -noupdate /nono_graphics_grid_tb/DUT/DRAW_LINE
add wave -noupdate /nono_graphics_grid_tb/DUT/VERTICAL
add wave -noupdate -divider -height 27 Internal
add wave -noupdate /nono_graphics_grid_tb/DUT/epres
add wave -noupdate /nono_graphics_grid_tb/DUT/esig
add wave -noupdate -divider Coordenadas
add wave -noupdate -radix unsigned /nono_graphics_grid_tb/DUT/XCOOR_reg
add wave -noupdate -radix unsigned /nono_graphics_grid_tb/DUT/YCOOR_reg
add wave -noupdate -color Yellow -radix unsigned /nono_graphics_grid_tb/DUT/true_coordx
add wave -noupdate -color Yellow -radix unsigned /nono_graphics_grid_tb/DUT/true_coordy
add wave -noupdate -radix unsigned /nono_graphics_grid_tb/DUT/tradCuad_x
add wave -noupdate -radix unsigned /nono_graphics_grid_tb/DUT/tradCuad_y
add wave -noupdate -radix unsigned /nono_graphics_grid_tb/DUT/mult
add wave -noupdate -radix unsigned /nono_graphics_grid_tb/DUT/in_XCOOR_reg
add wave -noupdate -radix unsigned /nono_graphics_grid_tb/DUT/in_YCOOR_reg
add wave -noupdate -divider Other
add wave -noupdate /nono_graphics_grid_tb/DUT/grid_mode
add wave -noupdate /nono_graphics_grid_tb/DUT/incr_tcoordx
add wave -noupdate /nono_graphics_grid_tb/DUT/clr_tcoordx
add wave -noupdate /nono_graphics_grid_tb/DUT/end_x
add wave -noupdate /nono_graphics_grid_tb/DUT/end_y
add wave -noupdate /nono_graphics_grid_tb/DUT/pr_cuad
add wave -noupdate /nono_graphics_grid_tb/DUT/pr_line
add wave -noupdate /nono_graphics_grid_tb/DUT/pr_tria
add wave -noupdate /nono_graphics_grid_tb/DUT/pr_delscreen
add wave -noupdate /nono_graphics_grid_tb/DUT/ld_XCOOR_reg
add wave -noupdate /nono_graphics_grid_tb/DUT/ld_YCOOR_reg
add wave -noupdate /nono_graphics_grid_tb/DUT/incr_tcoordy
add wave -noupdate /nono_graphics_grid_tb/DUT/clr_tcoordy
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3966667 ps} 0}
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
WaveRestoreZoom {0 ps} {10500 ns}

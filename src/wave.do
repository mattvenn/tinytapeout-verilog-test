onerror {resume}

radix define sevenseg_encoding {
    "8'b0110000" "DISP_1",
    "8'b1101101" "DISP_2",
    "8'b1111001" "DISP_3",
    "8'b0110011" "DISP_4",
    "8'b1011011" "DISP_5",
    "8'b1011111" "DISP_6",
    -default hexadecimal
}

quietly WaveActivateNextPane {} 0
add wave -noupdate /user_module_341446083683025490_tb/DUT/dice_roller_i/i_clk
add wave -noupdate /user_module_341446083683025490_tb/DUT/dice_roller_i/i_rst
add wave -noupdate /user_module_341446083683025490_tb/DUT/dice_roller_i/i_roll
add wave -noupdate /user_module_341446083683025490_tb/DUT/dice_roller_i/i_load
add wave -noupdate /user_module_341446083683025490_tb/DUT/dice_roller_i/i_seed
add wave -noupdate -radix sevenseg_encoding /user_module_341446083683025490_tb/DUT/dice_roller_i/o_led
add wave -noupdate /user_module_341446083683025490_tb/DUT/dice_roller_i/lfsr_en
add wave -noupdate /user_module_341446083683025490_tb/DUT/dice_roller_i/int_lfsr_val
add wave -noupdate -radix sevenseg_encoding /user_module_341446083683025490_tb/DUT/dice_roller_i/int_disp_val
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {164 ps} 0}
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
WaveRestoreZoom {0 ps} {1 ns}

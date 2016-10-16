transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Scrolling {U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Scrolling/Register1Bit.sv}
vlog -sv -work work +incdir+U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Scrolling {U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Scrolling/FrameCounter.sv}
vlog -sv -work work +incdir+U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Scrolling {U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Scrolling/StartScreenMux.sv}
vlog -sv -work work +incdir+U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Scrolling {U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Scrolling/Color_Mapper5Bit.sv}
vlog -sv -work work +incdir+U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Scrolling {U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Scrolling/FrameBuffer.sv}
vlog -sv -work work +incdir+U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Scrolling {U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Scrolling/HexDriver.sv}
vlog -sv -work work +incdir+U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Scrolling {U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Scrolling/GameController.sv}
vlog -sv -work work +incdir+U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Scrolling {U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Scrolling/finalProjectTopLevel.sv}
vlog -sv -work work +incdir+U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Scrolling {U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Scrolling/VGA_controller.sv}
vlog -sv -work work +incdir+U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Scrolling {U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Scrolling/SRAM_Controller.sv}
vlog -sv -work work +incdir+U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Scrolling {U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Scrolling/FramePtrRegister.sv}
vlog -sv -work work +incdir+U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Scrolling {U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Scrolling/frameRAM.sv}
vlog -sv -work work +incdir+U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Scrolling {U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Scrolling/Sprites.sv}

vlog -sv -work work +incdir+U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Scrolling {U:/ece385/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Scrolling/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 550000 ns

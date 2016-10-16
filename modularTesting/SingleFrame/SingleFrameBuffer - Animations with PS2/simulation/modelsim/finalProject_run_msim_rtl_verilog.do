transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Sprites {U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Sprites/playerMovement.sv}
vlog -sv -work work +incdir+U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Sprites {U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Sprites/FrameCounter.sv}
vlog -sv -work work +incdir+U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Sprites {U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Sprites/Color_Mapper5Bit.sv}
vlog -sv -work work +incdir+U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Sprites {U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Sprites/FrameBuffer.sv}
vlog -sv -work work +incdir+U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Sprites {U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Sprites/HexDriver.sv}
vlog -sv -work work +incdir+U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Sprites {U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Sprites/GameController.sv}
vlog -sv -work work +incdir+U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Sprites {U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Sprites/finalProjectTopLevel.sv}
vlog -sv -work work +incdir+U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Sprites {U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Sprites/VGA_controller.sv}
vlog -sv -work work +incdir+U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Sprites {U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Sprites/Player.sv}
vlog -sv -work work +incdir+U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Sprites {U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Sprites/PixelLogic.sv}
vlog -sv -work work +incdir+U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Sprites {U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Sprites/playerSprites.sv}
vlog -sv -work work +incdir+U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Sprites {U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Sprites/frameRAM.sv}
vlog -sv -work work +incdir+U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer\ -\ Sprites {U:/ECE_Classes/ECE-385/Final_Project/modularTesting/SingleFrame/SingleFrameBuffer - Sprites/playerFrameBuffer.sv}


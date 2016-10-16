module testbench();
timeunit 10ns; // Half clock cycle at 50 MHz
// This is the amount of time represented by #1
timeprecision 1ns;
// These signals are internal because the processor will be

// instantiated as a submodule in testbench.
logic Clk, Reset, ScrollEnable;
logic [12:0]  FramePtr;
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
FramePtrRegister fpr0(.*);
// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end
initial begin: CLOCK_INITIALIZATION
Clk = 0;
end
// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
Reset = 1;
ScrollEnable = 0;
#2
Reset = 0;
ScrollEnable = 1;
#7000
ScrollEnable = 0;
#2000
ScrollEnable = 1;



end
endmodule

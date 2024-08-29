// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module booth_multiplier_tb;

  // Inputs
  reg clk;
  reg rst;
  reg signed [7:0] in1;
  reg signed [7:0] in2;


  // Output
  wire signed [15:0] clocked_out;

  // Instantiate the Booth Multiplier
  booth_multiplier uut (
    .clk(clk),
    .rst(rst),
    .in1(in1),
    .in2(in2),
    .clocked_out(clocked_out)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    // Initialize Inputs
    clk = 0;
    rst = 1;
    in1 = 0;
    in2 = 0;

    // Apply reset
    #10;
    rst = 0;


    #10;
    in1 = 8'b11111000; // -8
    in2 = 8'b00001010; // 10
    #20;
    $display("in1 = %0d | in2 = %0d | out = %0d", in1,in2,clocked_out);
 

    // Finish simulation
    #20;
   $finish;
 
  end
endmodule

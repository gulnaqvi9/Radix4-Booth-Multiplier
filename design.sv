`timescale 1ns/1ps
//defining the partial product generator module
module partial_product_generator(input [7:0] multiplicand,
                                 input [2:0] multiplier,
                                 output reg [8:0] ppg_out);
  always@(*)
    begin
  case(multiplier)

      3'b000: ppg_out = 9'b0;
      3'b001: ppg_out = {multiplicand[7],multiplicand};
      3'b010: ppg_out = {multiplicand[7],multiplicand};
      3'b011: ppg_out = multiplicand<<1;
  	  3'b100: ppg_out = (~(multiplicand<<1)) +1'b1;
      3'b101: ppg_out = (~({multiplicand[7],multiplicand})) + 1'b1;
      3'b110: ppg_out = ~({multiplicand[7],multiplicand}) + 1'b1;
      3'b111: ppg_out = 9'b0;
      default: ppg_out = 9'b0;

    
  endcase
    end
endmodule



//defining the booth multiplier module

module  booth_multiplier(input clk,rst,
                         input signed [7:0] in1,
                         input signed [7:0] in2,
                         output reg signed [15:0] clocked_out);
  reg signed [7:0] clocked_in1, clocked_in2;
  reg signed [15:0]  out;
  wire signed [8:0] ppg0_out,ppg1_out,ppg2_out,ppg3_out;
  reg signed [15:0] ppg0_out_final, ppg1_out_final, ppg2_out_final, ppg3_out_final;
 
  always@(posedge clk or rst)
    begin
    if (rst)
      clocked_out <= out;
  	else
   		begin
      		clocked_in1 <= in1;
      		clocked_in2 <= in2;
          clocked_out <= out;
    	end
    end
 
  partial_product_generator ppg0(.multiplicand(clocked_in1),
                                 .multiplier({clocked_in2[1:0],1'b0}),
                                 .ppg_out(ppg0_out));
  
  partial_product_generator ppg1(.multiplicand(clocked_in1),
                                 .multiplier(clocked_in2[3:1]),
                                 .ppg_out(ppg1_out));

  partial_product_generator ppg2(.multiplicand(clocked_in1),
                                 .multiplier(clocked_in2[5:3]),
                                 .ppg_out(ppg2_out));
  
  partial_product_generator ppg3(.multiplicand(clocked_in1),
                                 .multiplier(clocked_in2[7:5]),
                                 .ppg_out(ppg3_out));
  
  assign ppg0_out_final = {{7{ppg0_out[8]}},ppg0_out};
  assign ppg1_out_final = {{5{ppg1_out[8]}},ppg1_out,2'b0};
  assign ppg2_out_final = {{3{ppg2_out[8]}},ppg2_out,4'b0};
  assign ppg3_out_final = {{1{ppg3_out[8]}},ppg3_out,6'b0};
  
  assign out = ppg0_out_final + ppg1_out_final + ppg2_out_final + ppg3_out_final;
  
endmodule
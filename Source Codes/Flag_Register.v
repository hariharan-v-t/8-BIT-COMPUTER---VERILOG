`timescale 1ns / 1ps
module Flag_Register(zero,carry,clk,reset,FE,carry_in,zero_in);
output reg carry,zero;
input clk,reset,FE,carry_in,zero_in;
always @(posedge clk or posedge reset)
begin
if(reset)
begin
carry<=1'b0;
zero<=1'b0;
end
else if(FE)
begin
carry<=carry_in;
zero<=zero_in;
end
end 
endmodule

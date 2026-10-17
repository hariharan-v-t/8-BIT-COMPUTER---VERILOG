`timescale 1ns / 1ps
module Input_Register(bus_out,data_in,clk,reset,INP1,INPO);
output [7:0] bus_out;
input [7:0] data_in;
input clk,reset,INP1,INPO;
reg [7:0] data_reg;
always @(posedge clk or posedge reset)
begin
if(reset)
data_reg <= 8'b0;
else if(INP1)
data_reg <= data_in;
end
assign bus_out = INPO ? data_reg : 8'bz;
endmodule
`timescale 1ns / 1ps
module RAM(bus_out,bus_in,address,RI,RO,
clk,load,in_address,in_data);
output [7:0]bus_out;
input [7:0]bus_in;
input [7:0]in_data;
input [3:0]address;
input [3:0]in_address;
input RO,RI,clk,load;
reg [7:0] memory [0:15];
integer i;
initial
$readmemb ("hram.mem",memory);
always @(posedge clk )
begin
 if(load)
begin
memory[in_address]<=in_data;
end 
else if (RI)
begin
memory[address] <= bus_in;
end
end
assign bus_out =(!load&&RO) ? memory[address]:8'bz;
endmodule

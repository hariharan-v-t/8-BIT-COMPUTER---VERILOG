 `timescale 1ns / 1ps
 
module program_counter(
    input clk,
    input reset, 
    input CE,    
    input CL,
    input CO,
    input [3:0] bus_in,
    output reg [3:0]pc,       
    output [7:0] bus_out
);

always @(posedge clk or posedge reset) begin

 if (reset)
 pc <= 4'b0000;
  else if (CL)
 pc <= bus_in;
 else if (CE)
 pc <= pc + 4'b0001;
end
assign bus_out = CO ?{4'b0000,pc}:8'bz;

endmodule
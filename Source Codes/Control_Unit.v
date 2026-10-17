`timescale 1ns / 1ps
module Control_Unit(CO,CL,CE,OI,BI,SUB1,ALO,AO,AI,INPO,IO,II,RO,RI,MI,HLT1,FE,ADD1,XRA,ANA,INP1,SHL1,SHR1,clk,reset,enable,opcode,c,z);
output reg CO,CL,CE,OI,BI,SUB1,ALO,AO,AI,IO,II,RO,RI,MI,HLT1,ADD1,FE,XRA,ANA,INP1,INPO,SHL1,SHR1;
input clk,reset,c,z;
input enable;
input [3:0] opcode;
parameter [3:0] NOP = 4'b0000,  
                INP = 4'b0001,
                LDA = 4'b0010, 
                STA = 4'b0011, 
                ADD = 4'b0100,
                SUB = 4'b0101, 
                AND = 4'b0110,
                CMP  = 4'b0111,
                XOR = 4'b1000,
                JC = 4'b1001, 
                SHL = 4'b1010,   
                SHR = 4'b1011,
                OUT = 4'b1100,  
                JMP = 4'b1101,  
                JZ  = 4'b1110,
                HLT = 4'b1111;
localparam IDLE = 3'd0,
           T0 = 3'd1,
           T1 = 3'd2,
           T2 = 3'd3,
           T3 = 3'd4,
           T4 = 3'd5,
           T5 = 3'd6,
           HALT = 3'd7;
reg [2:0] state;
reg [2:0] next_state;
         
always @(posedge clk or posedge reset) begin
if (reset)
state <= T0;
else if(!enable)
state<=T0;
else
state <= next_state;
end
always @(*)
begin
next_state=T0;
case(state)
IDLE:
begin
end
T0:begin
next_state = T1;
end
T1:begin
next_state = T2;
end
T2:begin
next_state = T3;
end
T3:begin
next_state = T4;
end
T4:begin
next_state = T5;
end
T5:
begin
if (opcode == HLT)
next_state = HALT;
else
next_state = T0;
end
HALT: 
begin
next_state = HALT;
end
default:
begin
next_state=T0;
end
endcase
end
always @(*)
begin
CO=1'b0;CL=1'b0;
CE=1'b0;OI=1'b0;
BI=1'b0;SUB1=1'b0;
ALO=1'b0;AO=1'b0;AI=1'b0;
IO=1'b0;II=1'b0;RO=1'b0;
RI=1'b0;MI=1'b0;HLT1=1'b0;
FE=1'b0;XRA=1'b0;ANA=1'b0;ADD1=1'b0;
INP1=1'b0;INPO=1'b0;SHL1=1'b0;SHR1=1'b0;
if(enable)
begin
case(state)
IDLE: begin
end
T0: begin
CO=1'b1;
MI=1'b1;
end
T1: begin
RO=1'b1;
II=1'b1;
end
T2: begin
CE=1'b1;
end
T3: begin
case(opcode)
NOP:
begin
end
INP:
begin
INP1=1'b1;
end
LDA:
begin
IO=1'b1;
MI=1'b1;
end
STA:
begin
IO=1'b1;
MI=1'b1;
end 
ADD:
begin
IO=1'b1;
MI=1'b1;
end
SUB:
begin
IO=1'b1;
MI=1'b1;
end
AND:
begin
IO=1'b1;
MI=1'b1;

end
CMP:
begin
IO=1'b1;
MI=1'b1;
end
JC:
begin
if(c)
begin
IO=1'b1;
CL=1'b1;
end 
end
XOR:
begin
IO=1'b1;
MI=1'b1;
end
SHL:
begin
SHL1=1'b1;
ALO=1'b1;
AI=1'b1;
FE=1'b1;
end
SHR:
begin
SHR1=1'b1;
ALO=1'b1;
AI=1'b1;
FE=1'b1;
end
JMP:
begin
IO=1'b1;
CL=1'b1;
end 
JZ:
begin
if(z)
begin
IO=1'b1;
CL=1'b1;
end
end
OUT:
begin
AO=1'b1;
OI=1'b1;
end
default:
begin
end 
endcase
end
T4: begin
case(opcode)
LDA: begin
RO = 1'b1;
AI = 1'b1;
end
INP:begin
INPO=1'b1;
AI=1'b1;
end
STA: begin
AO = 1'b1;
RI = 1'b1;
end
ADD: begin
RO = 1'b1;
BI = 1'b1;
end
SUB: begin
RO = 1'b1;
BI = 1'b1;
end
AND: begin
RO = 1'b1;
BI = 1'b1;
end
CMP: begin
RO = 1'b1;
BI = 1'b1;
end
XOR: begin
RO = 1'b1;
BI = 1'b1;
end
default: begin
end
endcase
end
T5: begin
case(opcode)
ADD: begin
ADD1 =1'b1;
ALO = 1'b1;
FE  = 1'b1;
AI  = 1'b1;
end
SUB: begin
SUB1 = 1'b1;
ALO  = 1'b1;
FE   = 1'b1;
AI   = 1'b1;
end
AND: begin
ANA = 1'b1;
ALO = 1'b1;
AI  = 1'b1;
FE  = 1'b1;
end
CMP: begin
SUB1 = 1'b1;
ALO  = 1'b1;
FE   = 1'b1;
end
XOR: begin
XRA = 1'b1;
ALO = 1'b1;
AI  = 1'b1;
FE  = 1'b1;
end
HLT: begin
HLT1 = 1'b1;
end
default: begin
end
endcase
end
HALT: begin
end
endcase
end
end
endmodule

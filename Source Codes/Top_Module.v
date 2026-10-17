`timescale 1ns / 1ps
module Top_Module(SEG,AN,carry,zero,clk,reset,load,in_address,in_data,password_switches,enter,for_in);
input [7:0] in_data,for_in;
input [3:0] in_address;
input clk,reset,load;
input [3:0] password_switches;
input enter;
output [3:0]AN;
output [7:0]SEG;
output carry,zero;
wire auth_ok;
wire locked;
wire cpu_reset;
wire [7:0] data_out;
wire [7:0]bus;
wire CO, CL, CE, OI, BI, SUB1;
wire ALO, AO, AI, IO, II, RO, RI, MI;
wire HLT1, FE, ADD1, XRA, ANA, INP1, INPO, SHL1, SHR1;
wire [3:0] opcode;
wire carry_in, zero_in;
wire [7:0] A_data,B_data;
wire [3:0] mar_out,pc_out;
wire cpu_enable;
wire clkf;
assign cpu_reset  = reset | ~auth_ok;
assign cpu_enable = auth_ok & ~load;

Clk_Div div1(.clkf(clkf),
             .clk(clk),
             .reset(reset));

program_counter U_PC(
.clk(clkf),
.reset(cpu_reset),
.CE(cpu_enable&CE),
.CL(cpu_enable&CL),
.CO(cpu_enable&CO),
.bus_in(bus[3:0]),
.pc(pc_out),
.bus_out(bus)
);
MAR U_Mar(
.mar_out(mar_out),
.clk(clkf),
.reset(cpu_reset),
.MI(cpu_enable&MI),
.bus_in(bus[3:0])
);
RAM U_Ram(
.bus_out(bus),
.bus_in(bus),
.address(mar_out),
.RI(cpu_enable&RI),
.RO(cpu_enable&RO),
.clk(clkf),
.load(load),
.in_address(in_address),
.in_data(in_data)
);
IR U_Ir(
    .bus_out(bus),
    .opcode(opcode),
    .bus_in(bus),
    .clk(clkf),
    .reset(cpu_reset),
    .II(cpu_enable & II),
    .IO(cpu_enable & IO)
);
A_Register U_A (
    .bus_out(bus),
    .ALU_in(A_data),
    .clk(clkf),
    .reset(cpu_reset),
    .AI(cpu_enable & AI),
    .AO(cpu_enable & AO),
    .bus_in(bus)
);
B_Register U_B (
    .bus_in(bus),
    .ALU_in(B_data),
    .clk(clkf),
    .reset(cpu_reset),
    .BI(cpu_enable & BI)
);
ALU U_ALU (
    .bus_out(bus),
    .c(carry_in),
    .z(zero_in),
    .A(A_data),
    .B(B_data),
    .SUB1(cpu_enable & SUB1),
    .ADD1(cpu_enable & ADD1),
    .ALO(cpu_enable & ALO),
    .FE(cpu_enable & FE),
    .XRA(cpu_enable & XRA),
    .ANA(cpu_enable & ANA),
    .SHL1(cpu_enable & SHL1),
    .SHR1(cpu_enable & SHR1)
);
Flag_Register U_FLAG (
    .zero(zero),
    .carry(carry),
    .clk(clkf),
    .reset(cpu_reset),
    .FE(cpu_enable & FE),
    .carry_in(carry_in),
    .zero_in(zero_in)
);
Input_Register U_INPUT (
    .bus_out(bus),
    .data_in(for_in),
    .clk(clkf),
    .reset(cpu_reset),
    .INP1(cpu_enable & INP1),
    .INPO(cpu_enable & INPO)
);
OR U_OUTPUT (
    .OUT(data_out),
    .bus_in(bus),
    .clk(clkf),
    .reset(cpu_reset),
    .OI(cpu_enable & OI)
);
Control_Unit U_CONTROL (
    .CO(CO),
    .CL(CL),
    .CE(CE),
    .OI(OI),
    .BI(BI),
    .SUB1(SUB1),
    .ALO(ALO),
    .AO(AO),
    .AI(AI),
    .IO(IO),
    .II(II),
    .RO(RO),
    .RI(RI),
    .MI(MI),
    .HLT1(HLT1),
    .FE(FE),
    .ADD1(ADD1),
    .XRA(XRA),
    .ANA(ANA),
    .INP1(INP1),
    .INPO(INPO),
    .SHL1(SHL1),
    .SHR1(SHR1),
    .clk(clkf),
    .reset(cpu_reset),
    .opcode(opcode),
    .c(carry),
    .z(zero),
    .enable(cpu_enable)
);
DC U_dc(
.clk(clk),
.rst(reset),
.cpu_output(data_out),
.AN(AN),
.seg(SEG)
);
Pass #(
    .PASSWORD(4'b1010)
) password_unit (
    .clk(clk),
    .reset(reset),
    .password_switches(password_switches),
    .enter(enter),
    .auth_ok(auth_ok),
    .locked(locked)
);


endmodule
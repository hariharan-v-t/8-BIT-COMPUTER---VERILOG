`timescale 1ns / 1ps

module ALU(
    bus_out, c, z, A, B,
    SUB1, ADD1, ALO, FE, XRA, ANA, SHL1, SHR1
);

output [7:0] bus_out;
output reg c, z;

input [7:0] A, B;
input SUB1, ADD1, ALO, FE, XRA, ANA, SHL1, SHR1;

reg [8:0] result;

always @(*) begin
    result = 9'b0;

    if (ADD1)
        result = {1'b0, A} + {1'b0, B};

    else if (SUB1)
        result = {1'b0, A} - {1'b0, B};

    else if (ANA)
        result = {1'b0, (A & B)};

    else if (XRA)
        result = {1'b0, (A ^ B)};

    else if (SHL1)
        result = {1'b0, A[7:0] << 1} |
                 {8'b0, A[7]};

    else if (SHR1)
        result = {A[0], 1'b0, A[7:1]};
end

assign bus_out = ALO ? result[7:0] : 8'bz;

always @(*) begin
    c = 1'b0;
    z = 1'b0;

    if (FE) begin
        if (ADD1)
            c = result[8];

        else if (SUB1)
            c = (A >= B);  // 1 means no borrow

        else if (SHL1)
            c = A[7];

        else if (SHR1)
            c = A[0];

        z = (result[7:0] == 8'b0);
    end
end

endmodule

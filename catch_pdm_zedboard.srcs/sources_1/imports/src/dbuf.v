module dbuf(
           input wire clk,
           input wire [31:0] din, //input
           input wire [15:0] didx, //address
           input wire RW,
           output reg [31:0] di
       );
`include "Param.v"


reg [31:0] mem [0:bound];

//1 write ; 0 read

// dbuf
always @(posedge clk)
begin

    if(RW)
        mem[didx] <= din;

    // mem[0] <= coefficent00;
    // mem[1] <= coefficent01;
    // mem[2] <= coefficent02;
    // mem[3] <= coefficent03;
    di <= RW ? din : mem[didx];
end

endmodule



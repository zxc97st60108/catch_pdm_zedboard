module dbuf(
           input wire clk,
           input wire [31:0] din, //input
           input wire [15:0] didx, //address
           input wire RW,
           output reg [31:0] di
       );
`include "Param.v"
// wire [31:0] mem1 ;
// wire [31:0] mem0 ;
// wire mem2 [31:0];
// wire mem1 [31:0];
// wire mem1 [31:0];

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

// assign mem0 = mem[999];
// assign mem1 = mem[1000];

endmodule



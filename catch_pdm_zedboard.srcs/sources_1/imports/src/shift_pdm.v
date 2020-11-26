`timescale 1ns / 1ps


module shift_pdm(
           input wire pdm_signal,         //輸入pdm資料
           input wire clock,
           //input wire [31:0] pdm_data,
           output reg [31:0] pdm
       );

// reg [2:0] count = 0;
// reg [31:0] pdm_array [0:`bound];


always @(posedge clock)
begin
    pdm <= {pdm[30:0] , pdm_signal};
end

endmodule

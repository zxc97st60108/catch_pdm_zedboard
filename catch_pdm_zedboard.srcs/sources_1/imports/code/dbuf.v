module dbuf(
	input wire clk, 
	input wire [31:0] din, //input
	input wire [5:0] didx, //address
	input wire RW,
	output reg [31:0] di
);
	reg [31:0] mem [0:`bound];

	// dbuf
	always @(posedge clk) begin 
		if(RW)
			mem[didx] <= din;
		
		di <= RW ? din : mem[didx];
	end

endmodule





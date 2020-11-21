module pdm_m(
           input wire clk,
           input wire rst,
           input wire [1:0] ctrl,
           input wire [31:0] addr,
           input wire pdm_signal,
           output wire [31:0] dout,
           output wire bsy
       );
wire RW;
// wire [3:0] cidx;
wire [15:0]  memory_idx;		//memory addr
wire [31:0] di, douta;//coef, 
// wire [31:0] prod;
// wire [35:0] acc;
// wire acc_en;
wire [15:0] array_idx;		//pdm array的index

//TODO: control module
sysctrl ctrl_m(
            .clk(clk),
            .rst(rst),
            .ctrl(ctrl),
            // .acc(acc),
            .RW(RW),
            .didx(memory_idx),
            // .cidx(cidx),
			// .array_idx(array_idx),
            .douta(douta),
            // .acc_en(acc_en),
            .bsy(bsy)
        );
//TODO: init value
// crom coef_m(
//          .clk(clk),
//          .cidx(cidx),
//          .coef(coef)
//      );

//TODO: memory module
// dbuf buff_m(
// 	.clk(clk),
// 	.din(dout),
// 	.didx(memory_idx),
// 	.RW(RW1),
// 	.di(di)
// );
dbuf buff_in(
         .clk(clk),
         .din((bsy)? douta : pdm_signal),      //if (bsy) then (douta)  else  (pdm_signal)
         .didx((bsy)? memory_idx :addr[17:2]), //不是15:0是因為軟體端送過來是0,4,8,12... 例：32'h8000_0104 ,08,0C... 每次跳4。所以必須除4 拿來做array是17:2
         .RW(RW),
         .di(dout)
     );

//TODO: shift pdm module
shift_pdm shift_m(
              .pdm_signal(pdm_signal),         //輸入pdm資料
              .clock(clk),
              .pdm_data(pdm_array[array_idx]),
              .pdm(pdm_array[array_idx])
          );

// accumulator acc_m(
// 	.clk(clk),
// 	.prod(prod),
// 	.acc(acc),
// 	.acc_en(acc_en)
// );

endmodule

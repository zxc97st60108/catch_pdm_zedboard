
module pdm_m(
           input wire AHBclk,
           input wire PDMclk,
           input wire rst,
           input wire ctrl,
           input wire [31:0] addr,      //outside memory addr;
           input wire pdm_signal,
           output wire [31:0] dout,
           output wire bsy
       );
wire RW;
// wire [3:0] cidx;
wire [15:0]  memory_idx;		//memory addr
// wire [31:0] di, douta;          //coef,
// wire [15:0] array_idx;		    //pdm array的index
wire [31:0] pdm_array;
// wire [31:0] pdm;

//TODO: control module
sysctrl ctrl_m(
            .clk(AHBclk),
            .rst(rst),
            .ctrl(ctrl),
            .RW(RW),
            .didx(memory_idx),
            .bsy(bsy)
        );

dbuf buff_m(
         .clk((bsy) ? PDMclk : AHBclk),
         .din(pdm_array),      //if (bsy) then (douta)  else  (pdm_signal)
         .didx((bsy) ? memory_idx : addr[17:2]), //不是15:0是因為軟體端送過來是0,4,8,12... 例:32'h8000_0104,08,0C每次加4  除4後才是index
         .RW(RW),
         .di(dout)
     );

//TODO: shift pdm module
shift_pdm shift_m(
              .pdm_signal(pdm_signal),         //輸入pdm資料
              .clock(PDMclk),
              //              .pdm_data(pdm_array),
              .pdm(pdm_array)
          );

endmodule

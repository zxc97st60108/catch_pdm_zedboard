
module pdm_m(
           input wire AHBclk,
           input wire PDMclk,
           input wire rst,
           input wire [1:0] ctrl,
           input wire [31:0] addr,      //outside memory addr;
           input wire pdm_signal,
           output wire [31:0] dout,
           output wire bsy
       );
       
wire RW;
wire [15:0]  memory_idx;		//memory addr
wire [31:0] pdm_array;

//TODO: control module
sysctrl ctrl_m(
            .ahb_clk(AHBclk),
            .pdm_clk(PDMclk),
            .rst(rst),
            .ctrl(ctrl),
            .pdm_signal(pdm_signal),         //輸入pdm資料
            .pdm(pdm_array),
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


endmodule

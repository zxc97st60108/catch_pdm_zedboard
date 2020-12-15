module sysctrl(
           input wire ahb_clk,
           input wire pdm_clk,
           input wire rst,
           input wire [1:0]ctrl,
           input wire pdm_signal,         //輸入pdm資料
           output reg [31:0] pdm,
           output reg RW,				//if RW = 1 then 寫入 else
           output reg [15:0] didx,	//memory_idx
           output reg bsy
       );
`include "Param.v"

reg CS, NS;
reg [5:0]counter;
reg cnt_en;

//current state register
always@(posedge ahb_clk or negedge rst) begin
    if(~rst)
        CS<=Idle;
    else
        CS<=NS;
end

//next state logic          change mode
always@(*) begin
    case(CS)
        Idle: begin
            if(ctrl[0])
                NS=Shift;
            else
                NS=Idle;
        end
        Shift: begin
            if(didx == bound)
                NS=Idle;
            else
                NS=Shift;
        end
        default: begin
            NS=Idle;
        end
    endcase
end

always @(negedge pdm_clk or negedge rst) begin
    if(~rst) begin
        pdm <= 32'd0;
    end
    else if(counter == 6'd0  | ctrl[1])       //if counter == 32 then reset 0
    begin
        pdm <= 32'd0;
    end
    else if (cnt_en) begin
        pdm <= {pdm[30:0] , pdm_signal};
    end
end

//output logic
always@(*) begin
    case(CS)
        Idle: begin
            RW = 1'b0;
            cnt_en = 1'b0;
            bsy = 1'b0;
        end
        Shift://enable counter
        begin
            RW =  1'b1 ;  //小於46875
            cnt_en = 1'b1;
            bsy = 1'b1;
            // counter = 6'd0;
        end
        default: begin
            RW = 1'b0;
            cnt_en = 1'b0;
            bsy = 1'b0;
        end
    endcase
end

//counter   改用下數 若用上數 第一次進來的32bit會少1bit
always @(posedge pdm_clk or negedge rst) begin
    if(~rst | ctrl[1]) begin
        counter <= 6'd32;
    end
    else if(counter == 6'd0 )       //if counter == 32 then reset 0     counter[4]&counter[3]&counter[2]&counter[1]&counter[0] | ctrl[1]
    begin
        counter <= 6'd31;
    end
    else if(cnt_en) begin
        counter <= counter - 1'b1;
    end
end

//didx2
always @(posedge pdm_clk or negedge rst) begin
    if(~rst) begin
        didx <= 16'd0;
    end
    else if(ctrl[1]) begin
        didx <= 16'd0;
    end
    else if(counter == 6'd0 ) //if didx<32 then didx++        counter[4]&counter[3]&counter[2]&counter[1]&counter[0]
    begin
        didx <= didx+1'b1;
    end
    // if (counter == 31)
end

endmodule

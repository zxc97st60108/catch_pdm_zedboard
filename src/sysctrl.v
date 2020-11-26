module sysctrl(
           input wire clk,
           input wire rst,
           input wire [1:0]ctrl,
           output reg RW,				//if RW = 1 then 寫入 else
           output reg [15:0] didx,	//memory_idx
           output reg bsy
       );
`include "Param.v"

reg CS, NS;
reg [5:0]counter;
reg cnt_en;

//current state register
always@(posedge clk or negedge rst)
begin
    if(~rst)
        CS<=Idle;
    else
        CS<=NS;
end

//next state logic          change mode
always@(*)
begin
    case(CS)
        Idle:
        begin
            if(ctrl[0])
                NS=Shift;
            else
                NS=Idle;
        end
        Shift:
        begin
            if(didx == bound)
                NS=Idle;
            else
                NS=Shift;
        end
        default:
        begin
            NS=Idle;
        end
    endcase
end

//output logic
always@(*)
begin
    case(CS)
        Idle:
        begin
            RW = 1'b0;
            cnt_en = 1'b0;
            bsy = 1'b0;
        end
        Shift://enable counter
        begin
            RW =  1'b1 ;  //小於46875
            cnt_en = 1'b1;
            bsy = 1'b1;
        end
        default:
        begin
            RW = 1'b0;
            cnt_en = 1'b0;
            bsy = 1'b0;
        end
    endcase
end

//counter
always @(posedge clk or negedge rst)
begin
    if(~rst)
    begin
        counter <= 6'd0;
    end
    else if(counter[5] | ctrl[1])       //if counter == 32 then reset 0
    begin
        counter <= 6'd0;
    end
    else if(cnt_en)
    begin
        counter <= counter + 1'b1;
    end
end

//didx2
always @(posedge clk or negedge rst)
begin
    if(~rst)
    begin
        didx <= 16'd0;
    end
    else if(ctrl[1])
    begin
        didx <= 16'd0;
    end
    else if(counter[4]&counter[3]&counter[2]&counter[1]&counter[0]) //if didx<32 then didx++
    begin
        didx <= didx+1'b1;
    end
    // if (counter == 31)
end

endmodule

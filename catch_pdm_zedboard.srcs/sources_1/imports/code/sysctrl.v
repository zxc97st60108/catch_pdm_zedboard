module sysctrl(
           input wire clk,
           input wire rst,
           input wire [1:0]ctrl,
           input wire [31:0] acc,
           output reg RW1,				//if RW = 1 then 寫入 else
           // output reg RW2,
           output reg [15:0] didx,	//memory_idx
           output reg [3:0] cidx,
           output reg [31:0] douta,
           // output reg acc_en,
           output reg bsy
       );
`include "Param.v"

reg CS, NS;
reg [3:0]counter;
// reg [2:0]count;
reg cnt_en;


always @(posedge clock or negedge rst)
begin
    if(rst)
    begin
        // pdm_array <= 0;
        didx <= 0;
        count <= 0;
        // pdm <= 0;
        // for(i=0;i<=`bound;i=i+1)
        // begin
        //     pdm_array[i] <= 32'b0;
        // end
    end
    else
    begin
        count <= count + 1;
        if (count == 31)
        begin
            didx <= didx + 1;
        end
    end
end


//current state register
always@(posedge clk or negedge rst)
begin
    if(~rst)
        CS<=Idle;
    else
        CS<=NS;
end

//next state logic
always@(*)
begin
    case(CS)
        Idle:
        begin
            if(ctrl[0])
                NS=Calculate;
            else
                NS=Idle;
        end
        Calculate:
        begin
            if(didx2==Depth)
                NS=Idle;
            else
                NS=Calculate;
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
            RW1=1'b0;
            acc_en=1'b0;
            cnt_en=1'b0;
            bsy=1'b0;
            didx = 0;
            count = 0;
            // pdm <= 0;
            // for(i=0;i<=`bound;i=i+1)
            // begin
            //     pdm_array[i] = 32'b0;
            // end
        end
        Calculate:
        begin
            RW1=&(~counter);
            // acc_en=(counter[2])|(~counter[1])|(counter[0]);
            cnt_en=1'b1;
            bsy=1'b1;
        end
        default:
        begin
            RW1=1'b0;
            RW2=1'b0;
            acc_en=1'b0;
            cnt_en=1'b0;
            bsy=1'b0;
        end
    endcase
end

//dout	輸出
// always@(posedge clk)
// begin
//     douta <= acc[31:0];
// end


//counter
always @(posedge clk or negedge rst)
begin
    if(~rst)
    begin
        counter<=4'd0;
    end
    else if(counter[3] | ctrl[1])
    begin
        counter<=4'd0;
    end
    else if(cnt_en)
    begin
        counter<=counter+1'b1;
    end
end

//didx2
always @(posedge clk or negedge rst)
begin
    if(~rst)
    begin
        didx2<= 6'd0;
    end
    else if(ctrl[1])
    begin
        didx2<= 6'd0;
    end
    else if(counter[2]&counter[1]&counter[0])
    begin
        didx2<= didx2+1'b1;
    end
end

//didx1
// always @(posedge clk or negedge rst)begin
//     if(~rst) begin
// 	    didx1<= 6'd8;
// 	end
// 	else if(counter[3]) begin
// 	    didx1<= didx1;
// 	end
// 	else if((~|didx1) | ctrl[1])begin
// 	    didx1<= 6'd8;
// 	end
// 	else begin
// 	    didx1<= didx1-1'b1;
// 	end
// end

//cidx
always @(posedge clk or negedge rst)
begin
    if(~rst)
    begin
        cidx<= 4'd0;
    end
    else if(counter[3] | ctrl[1])
    begin
        cidx<= 4'd0;
    end
    else
    begin
        cidx<= cidx+1'b1;
    end
end




endmodule

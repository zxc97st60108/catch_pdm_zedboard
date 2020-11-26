module sysctrl(
           input wire clk,
           input wire rst,
           input wire ctrl,
           output reg RW,				//if RW = 1 then 寫入 else
           output reg [15:0] didx,	//memory_idx
           //    output reg [31:0] douta,
           output reg bsy
           //    input wire [31:0] acc,
           // output reg RW2,
           //    output reg [3:0] cidx,qaz
           // output reg acc_en,
       );
`include "Param.v"

reg CS, NS;
reg [5:0]counter;
//reg [4:0]counter;
reg cnt_en;


// always @(posedge clock or negedge rst)
// begin
//     if(rst)
//     begin
//         // pdm_array <= 0;
//         didx <= 0;
//         counter <= 0;
//         // pdm <= 0;
//         // for(i=0;i<=`bound;i=i+1)
//         // begin
//         //     pdm_array[i] <= 32'b0;
//         // end
//     end
// end


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
            if(ctrl)
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
            // acc_en=1'b0;
            cnt_en = 1'b0;
            bsy = 1'b0;
            // pdm <= 0;
            // for(i=0;i<=`bound;i=i+1)
            // begin
            //     pdm_array[i] = 32'b0;
            // end
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
            // acc_en=1'b0;
            cnt_en = 1'b0;
            bsy = 1'b0;
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
        counter <= 6'd0;
    end
    else if(counter[5] | ~ctrl)       //if counter == 32 then reset 0
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
    else if(~ctrl)
    begin
        didx <= 16'd0;
    end
    else if(counter[4]&counter[3]&counter[2]&counter[1]&counter[0]) //if didx<32 then didx++
    begin
        didx <= didx+1'b1;
    end
    // if (counter == 31)
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
// always @(posedge clk or negedge rst)
// begin
//     if(~rst)
//     begin
//         cidx<= 4'd0;
//     end
//     else if(counter[3] | ctrl[1])
//     begin
//         cidx<= 4'd0;
//     end
//     else
//     begin
//         cidx<= cidx+1'b1;
//     end
// end




endmodule

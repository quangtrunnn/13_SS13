module counter (
	input clk,
	input rst_n,
	input count_en,
	input count_clr,
	output wire overflow,
	output reg [7:0] count
);
always @(posedge clk or negedge rst_n) begin
	if(rst_n ==1'b0) begin
		count <=8'b00;
		end
	       	else  begin
			if(count_clr ==1'b1) begin
				count <= 8'h00;
			end
		       	else if(count_en ==1'b1) begin 
				count <= count +1;  
			end
		end 
	end
	assign overflow =(count==8'hFF);
		
endmodule

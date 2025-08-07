module register_file (
	input wire clk,
	input wire rst_n,
	input wire wr_en,
	input wire rd_en,
	input wire [9:0] addr,
	input wire [31:0] wdata,
	output reg [31:0] rdata,

	output reg count_en,
	output reg count_clr,
	input wire [7:0] count
);

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		count_en <= 1'b0;
		count_clr <=1'b0;
	end else if(wr_en) begin
		if(addr ==10'd0) begin
			count_en <= wdata[0];
			count_clr <= wdata[1];
		end
	end
end

always @(*) begin
	if(rd_en) begin
		if(addr ==10'd0) begin
			rdata ={30'b0, count_clr, count_en};
		end else if(addr ==10'd4) begin
			rdata={24'b0,count};
		end else begin
			rdata=32'hDEAD_BEEF; // invalid address
			
		end
	end else begin
		rdata =32'h00000000;
	end
end
endmodule

module regset 
(
    input  wire             clk     ,
    input  wire             rst_n   ,
    input  wire             wr_en   ,
    input  wire             rd_en   ,
    input  wire [9:0]       addr    ,
    input  wire [31:0]    wdata   ,
    output wire [31:0]    rdata   
);
    parameter   ADDR_DATA_0 =   10'h0;
    parameter   ADDR_SR0    =   10'h4;
    parameter   ADDR_DATA_1 =   10'h8;
    parameter   ADDR_SR_DATA1   =   10'hC;
    //----------------------
    reg [31:0] DATA0;
    reg [31:0] SR0;
    reg [31:0] DATA1;
    reg [31:0] SR_DATA1;
    //---------------------
	//Ghi data0
    	always @(posedge clk or negedge rst_n) begin
		if(rst_n ==1'b0)begin
			DATA0 <= 32'h0;		
		end else if(wr_en && addr ==ADDR_DATA_0)begin			
				DATA0 <= wdata;
			end
	end
	//Ghi data1
	always @(posedge clk or negedge rst_n) begin
		if(rst_n ==1'b0)begin
			DATA1 <= 32'hFFFF_FFFF;	
		end else if(wr_en && addr ==ADDR_DATA_1)begin
				DATA1 <= wdata;
			end
	end
	//SR0 luon lay tu Data0
	always @(posedge clk or negedge rst_n) begin
		if(rst_n ==1'b0)
			SR0 <= 32'h0;
		else 
			SR0 <= DATA0;
	end
	//SR1 luon lay tu Data1
	always @(posedge clk or negedge rst_n) begin
		if(rst_n ==1'b0)
			SR_DATA1 <= 32'hFFFF_FFFF;
		else 
			SR_DATA1 <= DATA1;
	end
	assign rdata =(rd_en ==1'b1) ? 
		(addr == ADDR_DATA_0) ? DATA0 : 
		(addr ==ADDR_SR0) ? SR0:
		(addr == ADDR_DATA_1) ? DATA1 :
		(addr ==ADDR_SR_DATA1) ? SR_DATA1:
		32'h00 : 32'h00;
endmodule

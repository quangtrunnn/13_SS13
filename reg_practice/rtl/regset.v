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

    //----------------------
    reg [31:0] DATA0;
    reg [31:0] SR0;
 
    //---------------------

    	always @(posedge clk or negedge rst_n) begin
		if(rst_n ==1'b0)begin
			DATA0 <= 32'h0;
			
		end else if(wr_en && addr ==ADDR_DATA_0)begin
			
				DATA0 <= wdata;
			end
	end

	always @(posedge clk) begin
		SR0 <= DATA0;
	end

	assign rdata =(rd_en) ?
		(addr == ADDR_DATA_0) ? DATA0 : (addr ==ADDR_SR0) ? SR0:
		32'h00 : 32'h00;
		



endmodule

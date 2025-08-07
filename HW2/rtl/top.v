module top(
	input wire clk,
	input wire rst_n,
	input wire wr_en,
	input wire rd_en,
	input wire [9:0] addr,
	input wire [31:0] wdata,
	output wire [31:0] rdata,
	output wire overflow
	);

	wire [7:0] count;
	wire count_en, count_clr;

	register_file uut(
		.clk(clk),
		.rst_n(rst_n),
		.wr_en(wr_en),
		.rd_en(rd_en),
		.addr(addr),
		.wdata(wdata),
		.rdata(rdata),
		.count_en(count_en),
		.count_clr(count_clr),
		.count(count)
	);

	counter uut_counter(
		.clk(clk),
		.rst_n(rst_n),
		.count_en(count_en),
		.count_clr(count_clr),
		.count(count),
		.overflow(overflow)
	);S
	endmodule
	


`timescale 1ns/1ns

module test_bench;
  	reg clk;
	reg rst_n;
	reg wr_en;
	reg rd_en;
	reg [9:0] addr;
	reg [31:0] wdata;
	wire [31:0] rdata;
	wire overflow;


	top uut(
		.clk(clk),
		.rst_n(rst_n),
		.wr_en(wr_en),
		.rd_en(rd_en),
		.addr(addr),
		.wdata(wdata),
		.rdata(rdata),
		.overflow(overflow)
	);
	

  	always begin
 		#5 clk=~clk;
	end

	
  	initial begin 
  	  clk = 0;
  	  rst_n =0;
	wr_en =0;
	rd_en =0;
	addr =10'b0;
	wdata =32'b0;

	#20;

	wr_en=1;
	addr=10'd0;
	wdata =32'h00000001;
	#10;
	wr_en=0;
	


	#50;
	repeat(5) begin
		rd_en=1;
		addr=10'd4;
		#10;
		$display("Time =%0t, Count =%h, rdata=	%h, overflow =%b", $time, rdata[7:0],rdata,overflow);
		rd_en=0;
		#10;
	end

	wr_en =1;
	addr =10'b0;
	wdata =32'h00000002;
	#10;
	wr_en =0;


	#10;
	rd_en =1;
	addr=10'd4;
	#10;
	$display("After Clear: Time=%0t, Count =%h, rdata=%h, overflow =%b", $time, rdata[7:0], rdata,overflow);
	rd_en=0;
	#30;

	$finish;
end
endmodule
	

			


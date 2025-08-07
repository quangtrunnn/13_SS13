`timescale 1ns/1ps

module test_bench;

	reg clk;
	reg rst_n;
	reg wr_en;
	reg rd_en;
	reg [9:0]       addr    ;
    	reg [31:0]    wdata   ;
    	wire [31:0]    rdata;

	regset uut(
		.clk(clk),
		.rst_n(rst_n),
		.wr_en(wr_en),
		.rd_en(rd_en),
		.addr(addr),
		.wdata(wdata),
		.rdata(rdata)
	);
	
	always #5 clk=~clk;
	//Write task
	task write_reg(
		input[9:0] a,
		input[31:0] d);
	begin
		@(posedge clk)
		wr_en=1;
		rd_en=0;
		addr=a;
		wdata =d;
		@(posedge clk);
		wr_en=0;
	end
	endtask

	//Read task
	task read_reg(
		input[9:0] a,
		input[31:0] exp);
	begin
		@(posedge clk)
		wr_en=1;
		rd_en=0;
		addr=a;
		@(posedge clk)
		$display(" t=%t:  READ addr=%0h, rdata=%h, exp=%h %s",$time,a,rdata,exp,(rdata==exp)? "PASS" : "FAIL");
		rd_en=0;
	end
	endtask


	initial begin
		$display("===== Start test=====");
		clk=0;
		rst_n=0;
		wr_en=0;
		rd_en=0;
		addr=0;
		wdata=0;

		//Reset
		#10 rst_n=1;

		//Case 1: checkreset
		read_reg(10'h0, 32'h00000000);
		read_reg(10'h4, 32'h00000000);
		read_reg(10'h8, 32'hFFFF_FFFF);
		read_reg(10'hC, 32'hFFFF_FFFF);

		//Case 2: 
		write_reg(10'h8, 32'ha5a5_5a5a);
		@(posedge clk);
		read_reg(10'h8, 32'ha5a5_5a5a);
		read_reg(10'hC, 32'ha5a5_5a5a);

		//Case 3: 
		write_reg(10'h8, 32'h1234_ABCD);
		@(posedge clk);
		read_reg(10'h8, 32'h1234_ABCD);
		read_reg(10'hC, 32'h1234_ABCD);

		#20 $display("==== Finish TEst====");
		$finish;
	end
	endmodule


		
	

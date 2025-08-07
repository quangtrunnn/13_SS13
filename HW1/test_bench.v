
`timescale 1ns/1ns

module test_bench;
  	reg 	clk,	rst_n;
	reg 	wr_en, 	rd_en;
	reg [11:0] addr;
	reg [31:0] wdata;
	wire [31:0] rdata;
	wire overflow;


	top uut(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(wr_en),
		.rd_en		(rd_en),
		.addr		(addr),
		.wdata		(wdata),
		.rdata		(rdata),
		.cnt_overflow	(overflow)
	);
	

  	always begin
		clk =0;
 		#25 clk=~clk;
	end

	
  	initial begin 
  	  	clk 		= 1'b0;
  	  	#25 rst_n 	= 1'b1;
	end


	initial begin
	wr_en =0;
	rd_en =0;
	addr =0;
	wdata =0;
	#100;
	$display ("======================================================");
	$display ("============ Case 1: Check reset value================");
	$display ("======================================================");

	chk_ro_32b(4, 32'h0, 32'hffff_ffff); //addr. exp data, mask
	chk_ro_32b(0, 32'h0, 32'hffff_ffff); //addr. exp data, mask

	#100;
	$display ("======================================================");
	$display ("============ Case 2: Check R/W 0 =====================");
	$display ("======================================================");

	chk_rw_32b(0, 32'h0, 32'h0, 32'hffff_ffff); //addr. exp data, mask
	chk_rw_32b(4, 32'h0, 32'h0, 32'hffff_ffff); //addr. exp data, mask

	#100;
	$display ("======================================================");
	$display ("============ Case 3: Check R/W F =====================");
	$display ("======================================================");

	chk_rw_32b(4, 32'hffff_ffff, 32'h0, 32'hffff_ffff); //addr. exp data, mask
	chk_rw_32b(0, 32'hffff_ffff, 32'h3, 32'hffff_ffff); //addr. exp data, mask
	
	#100;
	$display ("======================================================");
	$display ("============ Case 4: Check R/W 5 =====================");
	$display ("======================================================");

	chk_rw_32b(4, 32'h5555_5555, 32'h0, 32'hffff_ffff); //addr. exp data, mask
	chk_rw_32b(0, 32'h5555_5555, 32'h1, 32'hffff_ffff); //addr. exp data, mask
	
	#100;
	$display ("======================================================");
	$display ("=========== Case 5: Check R/W 5 =====================");
	$display ("======================================================");

	chk_rw_32b(0, 32'haaaa_aaaa, 32'h2, 32'hffff_ffff); //addr. exp data, mask
	chk_rw_32b(4, 32'haaaa_aaaa, 32'h0, 32'hffff_ffff); //addr. exp data, mask
	
	
	#100;

	$finish;
	end

	task chk_rw_32b;
		input [31:0] in_addr;
		input [31:0] in_wdata;
		input [31:0] exp_data;
		input [31:0] mask;

		$display ("[INFO] RW check task");
		$display ("write data =%x at addr: %x", in_wdata, in_addr);
		
		@(posedge clk);
		wr_en =1;
		addr  = in_addr;
		wdata = in_wdata ;
		@(posedge clk);
		addr =0;
		wr_en =0;
		wdata =32'h0;
		@(posedge clk);
		rd_en =1;
		addr=in_addr;

		#1;
		if( (rdata&mask) !== (exp_data &mask) ) begin
			$display("----------------------------------------------------");
			$display ("t=%10d FAIL rdata  at addr: %x is not correct",$time, addr);
			$display(" EXP: %x Actual: %x", exp_data & mask, rdata & mask);
			$display("----------------------------------------------------");
			#100;
			$finish;
		end else begin
			$display("----------------------------------------------------");
			$display ("t=%10d PASS: rdata = %x at addr %x is correct", $time, rdata, addr);
			$display("----------------------------------------------------");
		end
		@(posedge clk);
		rd_en=0;
		addr=0;
	endtask

	task chk_ro_32b;
		input [31:0] in_addr;
		input [31:0] exp_data;
		input [31:0] mask;

endmodule
	

			


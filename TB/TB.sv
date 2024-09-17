`timescale 1ps/1ps

module TB;


    logic clk, reset, ext_intr;

    main DUT (.clk(clk), .reset(reset), .ext_intr(ext_intr));
    
    initial 
	begin 
		clk = 0;
		forever 
			#5 clk = ~clk;
			
    end

    initial 
    begin
       
    DUT.add_out = 0; DUT.add_in = 0; DUT.rdata1 = 0; DUT.rdata2 = 0;
    DUT.waddr = 0; DUT.wdata = 0; DUT.wren = 0; DUT.alu_out = 0; DUT.alu_sel = 0;
    DUT.se_out = 0; DUT.CNTR.count = 1'b0;

    ext_intr = 1'b0;
    reset = 1;
    
    repeat(2) @(posedge clk);
    reset = 0;
    DUT.Reg_File.memory[0] = 0;

    repeat(502) @(posedge clk);
    ext_intr = 1'b1;
    @(posedge clk);
    ext_intr = 1'b0;

    repeat(100) @(posedge clk);
 
    $stop;


    end


endmodule


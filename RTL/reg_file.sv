module reg_file (input logic [4:0] raddr1, raddr2, waddr, input logic [31:0] wdata, input logic wren, clk, reset,output logic [31:0] rdata1, rdata2);

    logic [31:0] memory [31:0];

    assign valid_waddr =| waddr;
    assign valid_raddr1 =| raddr1;
    assign valid_raddr2 =| raddr2;

    
    always_comb
    begin
        // TB
        //rdata1 = memory[raddr1];
        //rdata2 = memory[raddr2];
        rdata1 = (valid_raddr1)? memory[raddr1] : '0;
        rdata2 = (valid_raddr2)? memory[raddr2] : '0;
    end

    always_ff @(negedge clk)
    begin
        if (reset)
        begin
            memory <= '{default: '0};
        end

        else
        begin
            if (wren & valid_waddr)
            begin
                memory[waddr] <= wdata;
            end
        end
    end


endmodule
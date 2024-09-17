module CSR_RF (input logic [31:0] pc, wdata, input logic [11:0] addr, input logic [1:0] intrpt, input logic reg_wr, reg_rd, clk, reset, is_mret, output logic [31:0] rdata, epc, output logic epc_taken);

    logic [31:0] mip, mie, mstatus, mcause, mtvec, mepc;
    logic  flag_mip, flag_mie, flag_mstatus, flag_mcause, flag_mtvec, flag_mepc;

    logic [31:0] reg_mcause;

    always_ff @(posedge clk)
    begin
        if (intrpt == 2'b10) // Timer 
        begin
             mip[7] = 1'b1;
           
            if ((mip[7]) & (mie[7]) & (mstatus[3]))
            begin
                mepc <= pc;
                reg_mcause <= 32'h80000000;
            end
        end

        else if (intrpt == 2'b11) // External 
        begin
             mip[11] = 1'b1;
             
            if ((mip[11]) & (mie[11]) & (mstatus[3]))
            begin
                mepc <= pc;
                reg_mcause <= 32'h80000001;
            end
        end

        else 
        begin
            mip[7] = 1'b0;
            mip[11] = 1'b0;
        end
    end

    always_comb // epc
    begin
        epc = 32'b0;

        if (is_mret)
        begin
            epc = mepc;
        end
        
        if (mip[7]) // Timer 
        begin
            if ((mtvec[1:0] == 2'b01)) // Direct
            begin
                epc = mtvec[31:2] + (reg_mcause[30:0] << 2);
            end

            if ((mtvec[1:0] == 2'b00))
            begin
                epc = mtvec[31:2];
            end
        end

        if (mip[11]) // External
        begin
            if ((mtvec[1:0] == 2'b01)) // Direct
            begin
                epc = mtvec[31:2] + (reg_mcause[30:0] << 2);
            end

            if ((mtvec[1:0] == 2'b00))
            begin
                epc = mtvec[31:2];
            end
        end
    end


    always_comb //epc_taken
    begin
        if ((mip[11]) | (mip[7]) | (is_mret))
        begin 
            epc_taken = 1'b1;
        end

        else 
        begin
            epc_taken = 1'b0;
        end
    end

    always_comb // Read
    begin
        if (reg_rd)
        begin
            case(addr)
            12'h300 : rdata = mstatus;
            12'h304 : rdata = mie;
            12'h305 : rdata = mtvec;
            12'h341 : rdata = mepc;
            12'h342 : rdata = mcause;
            12'h344 : rdata = mip;
            default : rdata = 32'b0;
            endcase
        end
    end

    always_comb // Write
    begin
        flag_mstatus = 1'b0; 
        flag_mie = 1'b0;
        flag_mtvec = 1'b0;
        flag_mepc = 1'b0; 
        flag_mcause = 1'b0; 
        flag_mip = 1'b0;
        
        if (reg_wr)
        begin
            case(addr)
            12'h300 :begin
                        flag_mstatus = 1'b1; 
                        flag_mie = 1'b0;
                        flag_mtvec = 1'b0;
                        flag_mepc = 1'b0; 
                        flag_mcause = 1'b0; 
                        flag_mip = 1'b0;
                     end
            12'h304 :begin
                        flag_mstatus = 1'b0; 
                        flag_mie = 1'b1;
                        flag_mtvec = 1'b0;
                        flag_mepc = 1'b0; 
                        flag_mcause = 1'b0; 
                        flag_mip = 1'b0;
                     end
            12'h305 :begin
                        flag_mstatus = 1'b0; 
                        flag_mie = 1'b0;
                        flag_mtvec = 1'b1;
                        flag_mepc = 1'b0; 
                        flag_mcause = 1'b0; 
                        flag_mip = 1'b0;
                     end
            12'h341 :begin
                        flag_mstatus = 1'b0; 
                        flag_mie = 1'b0;
                        flag_mtvec = 1'b0;
                        flag_mepc = 1'b1; 
                        flag_mcause = 1'b0; 
                        flag_mip = 1'b0;
                     end
            12'h342 :begin
                        flag_mstatus = 1'b0; 
                        flag_mie = 1'b0;
                        flag_mtvec = 1'b0;
                        flag_mepc = 1'b0; 
                        flag_mcause = 1'b1; 
                        flag_mip = 1'b0;
                     end
            12'h344 :begin
                        flag_mstatus = 1'b0; 
                        flag_mie = 1'b0;
                        flag_mtvec = 1'b0;
                        flag_mepc = 1'b0; 
                        flag_mcause = 1'b0; 
                        flag_mip = 1'b1;
                     end
            default: begin
                        flag_mstatus = 1'b0; 
                        flag_mie = 1'b0;
                        flag_mtvec = 1'b0;
                        flag_mepc = 1'b0; 
                        flag_mcause = 1'b0; 
                        flag_mip = 1'b0;
                     end
            endcase
        end
    end

    always_ff @( posedge clk )  // mstatus
    begin 
        if (reset)
        begin
            mstatus <= 32'b0;
        end

        else if (flag_mstatus)
        begin
            mstatus <= wdata;
        end
    end

    always_ff @( posedge clk )  // mie
    begin 
        if (reset)
        begin
            mie <= 32'b0;
        end

        else if (flag_mie)
        begin
            mie <= wdata;
        end
    end

    always_ff @( posedge clk )  // mtvec
    begin 
        if (reset)
        begin
            mtvec <= 32'b0;
        end

        else if (flag_mtvec)
        begin
            mtvec <= wdata;
        end
    end

    always_ff @( posedge clk )  // mepc
    begin 
        if (reset)
        begin
            mepc <= 32'b0;
        end

        else if (flag_mepc)
        begin
            mepc <= wdata;
        end
    end

    always_ff @(posedge clk)  // mcause
    begin 
        if (reset)
        begin
             mcause <= 32'b0;
        end
        
        else if (mip[7]) // Timer
        begin
             mcause <= reg_mcause;
        end 

        else if (mip[11]) // External
        begin
             mcause <= reg_mcause;
        end

        else if (flag_mcause)
        begin
             mcause <= wdata;
        end
    end

    always_ff @( posedge clk )  // mip
    begin 
        if (reset)
        begin
            mip <= 32'b0;
        end

        else if (flag_mip)
        begin
            mip <= wdata;
        end
    end


endmodule
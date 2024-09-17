module data_mem (input logic [31:0] addr, data_wr, input logic cs, rd, clk, input logic [3:0] mask, output logic [31:0] data_rd, output logic valid);

    logic [31:0] data_register [100:0];

    logic [31:0] data;
    
    logic [7:0] data_b;
    logic [15:0] data_h;
    logic [31:0] data_w;

    always_comb
    begin
        assign data = data_register [addr];
    end

    always_comb
    begin
        valid = 1'b0;
        if (~cs) // Data Memory Enbale
        begin
            if (rd) // Read
            begin
                    assign data = data_register [addr];

                    if (mask == 4'b0000) // lb
                    begin
                        case(addr[1:0])
                        2'b00 : data_b = data[7:0];
                        2'b01 : data_b = data[15:8];
                        2'b10 : data_b = data[23:16];
                        2'b11 : data_b = data[31:24];
                        endcase

                        assign data_rd = { {24{ data_b[7] }}, data_b[7:0] }; // SE
                        valid = 1'b1;
                    end

                    else if (mask == 4'b0001) // lh
                    begin
                        case(addr[1])
                        1'b0 : data_h = data[15:0];
                        1'b1 : data_h = data[31:16];
                        endcase

                        assign data_rd = { {16{ data_h[15] }}, data_h[15:0] }; //SE
                        valid = 1'b1;
                    end

                    else if (mask == 4'b0010) // lw
                    begin
                        assign data_rd = data;
                        valid = 1'b1;
                    end

                    else if (mask == 4'b0011) // lbu
                    begin
                        case(addr[1:0])
                        2'b00 : data_b = data[7:0];
                        2'b01 : data_b = data[15:8];
                        2'b10 : data_b = data[23:16];
                        2'b11 : data_b = data[31:24];
                        endcase

                        assign data_rd = { 24'b0 , data_b[7:0] }; //USE
                        valid = 1'b1;
                    end

                    else if (mask == 4'b0100) // lh
                    begin
                        case(addr[1])
                        1'b0 : data_h = data[15:0];
                        1'b1 : data_h = data[31:16];
                        endcase

                        assign data_rd = { 16'b0 , data_h[15:0] }; //USE
                        valid = 1'b1;
                    end
            end
        end
    end

            always_ff @(posedge clk)
            begin
                if (~rd & ~cs)
                begin
                    if (mask[0])
                    begin
                        data_register[addr][7:0] = data_wr [7:0];
                    end
                   
                    if (mask[1])
                    begin
                        data_register[addr][15:8] = data_wr [15:8];
                    end
                   
                    if (mask[2])
                    begin
                        data_register[addr][23:16] = data_wr [23:16];
                    end
                   
                    if (mask[3])
                    begin
                        data_register[addr][31:24] = data_wr [31:24];
                    end
                end
            end

   

endmodule 
module controller (input logic [31:0] instruction, output logic wren, output logic [3:0] alu_sel, output logic alu_b_sel, alu_a_sel, output logic [2:0] br_type, wb_sel, output logic csr_rd, csr_wr, is_mret);

    logic [6:0] F7;
    logic [2:0] F3;
    
    assign F7 = instruction [31:25];
    assign F3 = instruction [14:12];


    always_comb
    begin
        case(instruction[6:0])
            7'b0110011: if ( F7 == 7'b0000000 )  // R-Type
                        begin
                            assign alu_a_sel = 1;
                            assign wb_sel = 2'b01;
                            assign wren = 1;
                            assign alu_b_sel = 0;
                            br_type = 3'b110;
                            csr_rd = 1'b0;
                            csr_wr = 1'b0;
                            is_mret = 1'b0;
                            
                            case(F3)
                            3'b000 : alu_sel = 4'b0000;
                            3'b001 : alu_sel = 4'b0010;
                            3'b010 : alu_sel = 4'b0011;
                            3'b011 : alu_sel = 4'b0100;

                            3'b100 : alu_sel = 4'b0101;
                            3'b101 : alu_sel = 4'b0110;
                            3'b110 : alu_sel = 4'b1000;
                            3'b111 : alu_sel = 4'b1001;
                            endcase
                        end

                        else if ( F7 == 7'b0100000 )
                        begin
                            assign alu_a_sel = 1;
                            assign wb_sel = 2'b01;
                            assign wren = 1;
                            assign alu_b_sel = 0;
                            br_type = 3'b110;
                            csr_rd = 1'b0;
                            csr_wr = 1'b0;
                            is_mret = 1'b0;

                            case(F3)
                            3'b000 : alu_sel = 4'b0001;
                            3'b001 : alu_sel = 4'b0000;
                            3'b010 : alu_sel = 4'b0000;
                            3'b011 : alu_sel = 4'b0000;

                            3'b100 : alu_sel = 4'b0000;
                            3'b101 : alu_sel = 4'b0111;
                            3'b110 : alu_sel = 4'b0000;
                            3'b111 : alu_sel = 4'b0000;
                            endcase
                        end
                        
            7'b0010011:     if (instruction[6:0] == 7'b0010011)   // I-Type
                            begin    
                                assign alu_a_sel = 1; 
                                assign wb_sel = 2'b01;
                                assign wren = 1;    
                                assign alu_b_sel = 1;
                                br_type = 3'b110;
                                csr_rd = 1'b0;
                                csr_wr = 1'b0;
                                is_mret = 1'b0;

                                case(F3)
                                3'b000 : alu_sel = 4'b0000;
                                3'b001 : alu_sel = 4'b0010;
                                3'b010 : alu_sel = 4'b0011;
                                3'b011 : alu_sel = 4'b0100;

                                3'b100 : alu_sel = 4'b0101;
                                3'b101 : alu_sel = 4'b0110;
                                3'b110 : alu_sel = 4'b1000;
                                3'b111 : alu_sel = 4'b1001;
                                endcase  
                            end      
            
            7'b0000011:     begin   // LOAD I-Type 
                                 assign alu_a_sel = 1;
                                 assign wb_sel = 2'b10;
                                 assign wren = 1;
                                 assign alu_b_sel = 1;
                                  alu_sel = 4'b0000;
                                  br_type = 3'b110;
                                  csr_rd = 1'b0;
                                  csr_wr = 1'b0;
                                  is_mret = 1'b0;
                            end
                          
            
            7'b0100011:         begin // S-Type 
                                 assign alu_a_sel = 1;
                                 assign wb_sel = 2'b10;                                            
                                 assign wren = 0;
                                 assign alu_b_sel = 1;
                                  alu_sel = 4'b0000;
                                  br_type = 3'b110;
                                  csr_rd = 1'b0;
                                  csr_wr = 1'b0;
                                  is_mret = 1'b0;
                                end
            
            7'b1100011:         begin // B-Type 
                                 assign alu_a_sel = 0;
                                 assign wb_sel = 2'b01;                                            
                                 assign wren = 0;
                                 assign alu_b_sel = 1;
                                  alu_sel = 4'b0000;
                                  csr_rd = 1'b0;
                                  csr_wr = 1'b0;
                                  is_mret = 1'b0;

                                case(F3)
                                3'b000: br_type = 3'b000;
                                3'b001: br_type = 3'b001;
                                3'b100: br_type = 3'b010;
                                3'b101: br_type = 3'b011;
                                3'b110: br_type = 3'b100;
                                3'b111: br_type = 3'b101;
                                endcase

                                end

            7'b1101111:         begin // JAL-Type 
                                 assign alu_a_sel = 0;
                                 assign wb_sel = 2'b00;                                            
                                 assign wren = 1;
                                 assign alu_b_sel = 1;
                                  alu_sel = 4'b0000;
                                  br_type = 3'b111;
                                  csr_rd = 1'b0;
                                  csr_wr = 1'b0;
                                  is_mret = 1'b0;
                                end
            
            7'b1100111:         begin // JALR I-Type 
                                 assign alu_a_sel = 1;
                                 assign wb_sel = 2'b00;                                            
                                 assign wren = 1;
                                 assign alu_b_sel = 1;
                                  alu_sel = 4'b0000;
                                  br_type = 3'b111;
                                  csr_rd = 1'b0;
                                  csr_wr = 1'b0;
                                  is_mret = 1'b0;
                                end

            7'b0110111:         begin // U-Type 
                                 assign alu_a_sel = 1;
                                 assign wb_sel = 2'b01;                                            
                                 assign wren = 1;
                                 assign alu_b_sel = 1;
                                  alu_sel = 4'b1111;
                                  br_type = 3'b110;
                                  csr_rd = 1'b0;
                                  csr_wr = 1'b0;
                                  is_mret = 1'b0;
                                end
            
            7'b0010111:         begin // auipc U-Type 
                                 assign alu_a_sel = 0;
                                 assign wb_sel = 2'b01;                                            
                                 assign wren = 1;
                                 assign alu_b_sel = 1;
                                  alu_sel = 4'b0000;
                                  br_type = 3'b110;
                                  csr_rd = 1'b0;
                                  csr_wr = 1'b0;
                                  is_mret = 1'b0;
                                end
            
            7'b1110011:         begin // CSRRW 
                                 if (instruction[14:12] == 3'b000)
                                 begin
                                  assign alu_a_sel = 1;
                                  assign wb_sel = 2'b11;                                            
                                  assign wren = 0;
                                  assign alu_b_sel = 1;
                                    alu_sel = 4'b0000;
                                    br_type = 3'b110;
                                    csr_rd = 1'b1;
                                    csr_wr = 1'b0;
                                    is_mret = 1'b1;
                                 end

                                 else 
                                 begin  
                                  assign alu_a_sel = 1;
                                  assign wb_sel = 2'b11;                                            
                                  assign wren = 0;
                                  assign alu_b_sel = 1;
                                    alu_sel = 4'b0000;
                                    br_type = 3'b110;
                                    csr_rd = 1'b1;
                                    csr_wr = 1'b1;
                                    is_mret = 1'b0;
                                 end
                                end
                                
        endcase
    end

endmodule
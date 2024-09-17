module LSU (input logic [31:0] inst, input logic [1:0] alu_out , output logic [3:0] mask, output logic cs, rd);

logic [6:0] F7;
    logic [2:0] F3;
    
    assign F7 = inst [31:25];
    assign F3 = inst [14:12];


    always_comb
    begin
        case(inst[6:0])

            7'b0000011:     begin    // LOAD I-Type 
                                assign cs = 0;
                                assign rd = 1;
                                
                                case(F3)
                                3'b000 : begin 
                                            mask = 4'b0000;
                                         end
                                3'b001 : begin
                                            mask = 4'b0001;
                                         end
                                3'b010 : begin
                                            mask = 4'b0010;
                                         end
                                3'b100 : begin
                                            mask = 4'b0011;
                                         end
                                3'b101 : begin
                                            mask = 4'b0100;
                                         end
                                endcase  
                            end 
            
            7'b0100011:     begin    // S-Type 
                                assign cs = 0;
                                assign rd = 0;
                                
                                case(F3)
                                3'b000 :   begin
                                                case(alu_out)
                                                2'b00 : mask = 4'b0001;
                                                2'b01 : mask = 4'b0010;
                                                2'b10 : mask = 4'b0100;
                                                2'b11 : mask = 4'b1000;
                                                endcase
                                            end
                                         
                                3'b001 :   begin
                                                case(alu_out[1])
                                                1'b0 : mask = 4'b0011;
                                                1'b1 : mask = 4'b1100;
                                                endcase
                                            end
                                        
                                3'b010 :   begin
                                                mask = 4'b1111;
                                            end 
                                         
                                endcase  
                            end 
            
            7'b0110011:     assign cs = 1; // R-Type
                    
            7'b0010011:     assign cs = 1; // I-Type

            7'b1100011:     assign cs = 1; // B-Type 

            7'b0110111:     assign cs = 1; // U-Type 

            7'b0010111:     assign cs = 1; // auipc U-Type 

            default:   begin assign rd = 1; assign cs = 1;  mask = 4'b0000; end
                                
        endcase
    end



endmodule 
module Alu (input logic [31:0] operand_a, operand_b, input logic [3:0] sel, output logic [31:0] alu_out);

    always_comb
    begin
        case(sel)
        
              4'b0000 : alu_out = operand_a + operand_b;
              4'b0001 : alu_out = operand_a - operand_b;
              4'b0010 : alu_out = operand_a << operand_b[4:0];
              4'b0011 : alu_out = $signed (operand_a) < $signed(operand_b);

              4'b0100 : alu_out = operand_a < operand_b;
              4'b0101 : alu_out = operand_a ^ operand_b;
              4'b0110 : alu_out = operand_a >> operand_b[4:0];
              4'b0111 : alu_out = operand_a >>> operand_b;

              4'b1000 : alu_out = operand_a | operand_b;
              4'b1001 : alu_out = operand_a & operand_b;   

              4'b1111 : alu_out = operand_b;  // U-Type
        
        endcase
    end

endmodule 
module imm_gen (input logic [31:0] inst, output logic [31:0] se_out);

    always_comb
    begin
        case(inst [6:0])
        7'b0010011 : se_out = { {20{ inst[31] }}, inst[31:20] };
        7'b0000011 : se_out = { {20{ inst[31] }}, inst[31:20] };
        7'b0100011 : se_out = { {20{ inst[31] }}, inst[31:25], inst[11:7] };
        7'b1100011 : se_out = { {19{ inst[31] }}, inst[7], inst[30:25], inst[11:8], 1'b0 };
        7'b1101111 : se_out = { {19{ inst[31] }}, inst[19:12], inst[20], inst[30:21], 1'b0 };
        7'b1100111 : se_out = { {20{ inst[31] }}, inst[31:20] };
        7'b0110111 : se_out = {  inst[31:12], 12'b0  };
        7'b0010111 : se_out = {  inst[31:12], 12'b0  };
        7'b1110011 : se_out = {  20'b0, inst[31:20] };
        endcase
    end

endmodule

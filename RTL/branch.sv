module branch (input logic [31:0] op_a, op_b, input logic [2:0] br_type, output logic branch_out);

    logic [32:0]  sub;
    logic [31:0] not_zero, overflow;
    logic neg;
    
    assign sub = {1'b0, op_a} - {1'b0, op_b} ;
    assign not_zero =| sub[31:0];
    assign neg = sub[31];
    assign overflow = (neg & ~op_a[31] & op_b[31]) | (~neg & op_a[31] & ~op_b[31]);

    always_comb
    begin
        case(br_type)
        3'b000 : branch_out = ~not_zero;
        3'b001 : branch_out = not_zero;
        3'b010 : branch_out = (neg ^ overflow);
        3'b011 : branch_out = ~(neg ^ overflow);
        3'b100 : branch_out = sub[32];
        3'b101 : branch_out = ~sub[32];
        3'b111 : branch_out = 1;
        default: branch_out = 1'b0;
        endcase
    end


endmodule 
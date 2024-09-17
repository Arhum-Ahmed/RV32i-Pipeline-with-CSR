module mux21 (input logic [31:0] a, b, input logic sel, output logic [31:0] out);

    always_comb
    begin
        assign out = sel? b: a;
    end

endmodule

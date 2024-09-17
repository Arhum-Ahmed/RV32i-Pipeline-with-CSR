module buff_1 (input logic in, input logic clk, reset, en, output logic out);

    always_ff @(posedge clk)
    begin
        if (reset)
        begin
            out <= 0;
        end
        else if (~en)
        begin
            out <= in;
        end
    end

endmodule
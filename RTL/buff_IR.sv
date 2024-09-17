module buff_IR (input logic [31:0] in, input logic clk, reset, en, output logic [31:0] out);

    always_ff @(posedge clk)
    begin
        if (reset)
        begin
            out <= 32'h13;
        end
        else if (~en)
        begin
            out <= in;
        end
    end

endmodule
module Interrupt_Dec (input logic timer, ext, output logic [1:0] intr);

always_comb
begin
    if (timer)
    begin
        intr = 2'b10;
    end
    
    else if (ext)
    begin
        intr = 2'b11;
    end

    else 
    begin
        intr = 2'b00;
    end
end

endmodule 
module adder (input logic [31:0] pc_in, constant, output logic [31:0] adder_out);

    always_comb 
    begin  
        adder_out = pc_in + constant;
    end

endmodule
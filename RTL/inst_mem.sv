module inst_mem (input logic [29:0] mem_in, output logic [31:0] mem_out);

    logic [31:0] memory [100:0];
    initial 
    begin
        $readmemh ("C:/Users/Arhum/Desktop/Assignments/Computer Architecture-Lab/Lab-9/memory.mem", memory);
    end
    assign mem_out = memory [mem_in];


endmodule
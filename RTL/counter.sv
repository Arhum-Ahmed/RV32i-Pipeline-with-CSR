module counter (input logic clk, output logic over_flow);

    logic [5:0] count;
    logic reset;
    
    
    always_ff @(posedge clk)
    begin
        if (reset)
        begin
            count <= 0;
        end

        else 
        begin 
            count <= count + 1'b1;
        end
    end

    always_comb
    begin 
        over_flow = 1'b0;
        reset = 1'b0;
        
        if (count == 6'b11_1111)
        begin
            over_flow = 1'b1;
            reset = 1'b1;
        end
    end 


endmodule
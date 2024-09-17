module main(input logic clk, reset, ext_intr);

    logic [31:0] add_out, add_in, inst, rdata1, rdata2, waddr, wdata, alu_out, se_out,  alu_b, dm_out, m21_pc_1_in, m21_pc_2_in, alu_a, wr_bk, buff_inst, buff_inst_ex, buff_pc_if, buff_pc_ex, buff_alu, buff_rdata2, mux_fsu_a, mux_fsu_b, buff_csr_wdata, csr_rdata, csr_epc, buff_csr_addr;
    logic [3:0] alu_sel, mask;
    logic [2:0] br_type;
    logic [1:0] wb_sel, buff_wb_sel, interrupt;
    logic cs_dm, rd_dm, sel_alu_b, sel_alu_a, br_o, wren, buff_wren, fsu_a, fsu_b, stall_if, stall_ex, flush, buff_br_o, buff_flush, csr_rd, csr_wr, buff_csr_wr, buff_csr_rd, is_mret, buff_is_mret, epc_taken, timer_intr;

    inst_mem Inst_Mem ( .mem_in(add_out[31:2]), .mem_out(inst));
    buff_IR buff_IR_1 (.in(inst), .clk(clk), .reset(buff_flush), .en(stall_if),.out(buff_inst));
    buff_IR buff_IR_2 (.in(buff_inst), .clk(clk), .reset(flush), .en(stall_ex), .out(buff_inst_ex));
    adder ADD (.pc_in(add_out), .constant(32'd4), .adder_out(add_in));
    mux21 m21_pc_1 ( .a(add_in), .b(buff_alu), .sel(buff_br_o), .out(m21_pc_1_in));
    mux21 m21_pc_2 ( .a(m21_pc_1_in), .b(csr_epc), .sel(epc_taken), .out(m21_pc_2_in));
    pc PC (.add_in(m21_pc_2_in), .clk(clk), .reset(reset), .stall(stall_if), .add_out(add_out));
    buff buff_PC_IF (.in(add_out), .clk(clk), .reset(reset), .en(stall_if), .out(buff_pc_if));
    buff buff_PC_Ex (.in(buff_pc_if), .clk(clk), .reset(reset), .en(stall_ex), .out(buff_pc_ex));
    reg_file Reg_File ( .raddr1(buff_inst[19:15]), .raddr2(buff_inst[24:20]), .waddr(buff_inst_ex[11:7]), .wdata(wr_bk), .wren(buff_wren), .clk(clk), .reset(reset),.rdata1(rdata1), .rdata2(rdata2));
    imm_gen IMMG (.inst(buff_inst), .se_out(se_out));
    mux21 m21_alu_fsu_a (.a(buff_alu), .b(rdata1), .sel(fsu_a), .out(mux_fsu_a));
    mux21 m21_alu_a (.a(buff_pc_if), .b(mux_fsu_a), .sel(sel_alu_a), .out(alu_a));
    mux21 m21_alu_fsu_b (.a(buff_alu), .b(rdata2), .sel(fsu_b), .out(mux_fsu_b));
    mux21 m21_alu_b (.a(mux_fsu_b), .b(se_out), .sel(sel_alu_b), .out(alu_b));
    Alu ALU ( .operand_a(alu_a), .operand_b(alu_b), .sel(alu_sel), .alu_out(alu_out));
    buff buff_Alu (.in(alu_out), .clk(clk), .reset(reset), .en(stall_ex), .out(buff_alu));
    LSU lsu ( .inst(buff_inst_ex), .alu_out(buff_alu[1:0]) , .mask(mask), .cs(cs_dm), .rd(rd_dm));
    buff buff_WD (.in(rdata2), .clk(clk), .reset(reset), .en(stall_ex), .out(buff_rdata2));
    data_mem DM ( .addr(buff_alu), .data_wr(buff_rdata2), .cs(cs_dm), .rd(rd_dm), .clk(clk), .mask(mask), .data_rd(dm_out), .valid(valid) );
    mux31 m41 ( .a(buff_pc_ex + 32'd4), .b(buff_alu), .c(dm_out), .d(csr_rdata), .sel(buff_wb_sel) , .out(wr_bk));
    controller CTRL ( .instruction(buff_inst), .wren(wren), .alu_sel(alu_sel), .alu_b_sel(sel_alu_b), .alu_a_sel(sel_alu_a), .br_type(br_type), .wb_sel(wb_sel), .csr_rd(csr_rd), .csr_wr(csr_wr), .is_mret(is_mret));
    buff_1 buff_ctrl_wren ( .in(wren), .clk(clk), .reset(reset), .en(stall_ex), .out(buff_wren));
    buff buff_ctrl_wbsel ( .in(wb_sel), .clk(clk), .reset(reset), .en(stall_ex), .out(buff_wb_sel));
    branch br ( .op_a(rdata1), .op_b(rdata2), .br_type(br_type), .branch_out(br_o));
    buff_1 buff_br ( .in(br_o), .clk(clk), .reset(reset), .en(stall_ex), .out(buff_br_o));
    buff_1 buff_Flush ( .in(flush), .clk(clk), .reset(reset), .en(stall_ex), .out(buff_flush));
    FSU fsu ( .IR_if(buff_inst) , .IR_ex(buff_inst_ex), .buff_wren(buff_wren), .br_taken(br_o), .interrupt(interrupt[1]), .is_mret(is_mret), .valid(valid), .epc_taken(epc_taken), .fsu_a(fsu_a), .fsu_b(fsu_b), .stall_if(stall_if), .stall_ex(stall_ex), .flush(flush));

    buff buff_csr_data (.in(mux_fsu_a), .clk(clk), .reset(reset), .en(stall_ex), .out(buff_csr_wdata));
    buff buff_csr_addrr (.in(se_out), .clk(clk), .reset(reset), .en(stall_ex), .out(buff_csr_addr));
    buff_1 buff1_csr_rd ( .in(csr_rd), .clk(clk), .reset(reset), .en(stall_ex), .out(buff_csr_rd));
    buff_1 buff1_csr_wr ( .in(csr_wr), .clk(clk), .reset(reset), .en(stall_ex), .out(buff_csr_wr));
    buff_1 buff1_csr_is_mret ( .in(is_mret), .clk(clk), .reset(reset), .en(stall_ex), .out(buff_is_mret));
    CSR_RF CSR ( .pc(buff_pc_ex), .addr(buff_csr_addr[11:0]), .wdata(buff_csr_wdata), .intrpt(interrupt), .reg_wr(buff_csr_wr), .reg_rd(buff_csr_rd), .clk(clk), .reset(reset), .is_mret(buff_is_mret), .rdata(csr_rdata), .epc(csr_epc), .epc_taken(epc_taken));
    Interrupt_Dec IDC(.timer(timer_intr), .ext(ext_intr), .intr(interrupt));

    counter CNTR ( .clk(clk), .over_flow(timer_intr));

endmodule
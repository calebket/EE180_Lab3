//=============================================================================
// EE180 Lab 3
//
// Instruction fetch module. Maintains PC and updates it. Reads from the
// instruction ROM.
//=============================================================================

module instruction_fetch (
    input clk,
    input rst,
    input en,
    input jump_target,
    input [31:0] pc_id,
    input [25:0] instr_id,  // Lower 26 bits of the instructiion; J FORMAT
    input jump_branch, //ADDED
    input jump_reg,//ADDED
    input[31:0] jr_pc, //ADDED


    output [31:0] pc
);


    wire [31:0] pc_id_p4 = pc_id + 3'h4;
    wire [31:0] j_addr = {pc_id_p4[31:28], instr_id[25:0], 2'b0};

    //wire [31:0] pc_next = (jump_target) ? j_addr : (pc + 3'h4);

    dffare #(32) pc_reg (.clk(clk), .r(rst), .en(en), .d(pc_next), .q(pc));

    // TODO: Add support for beq, and bne (branch target addr already computed)
    wire [31:0] offset = {{14{instr_id[15]}}, instr_id[15:0], 2'b0}; //sign extended and *4
    wire [31:0] branch_addr = pc_id + 3'h4 + offset; //compute new address

    wire [31:0] jumping_reg = jump_reg ? jr_pc : (pc + 3'h4);
    wire [31:0] jumping_branch = jump_branch ? branch_addr : jumping_reg;
    wire [31:0] pc_next = jump_reg ? jr_pc : jump_target ? j_addr : jumping_branch;

    // TODO: Add support for jr and jal?

endmodule

module parallel
  #(
    parameter TUNING_WIDTH = 16,
    parameter DATA_WIDTH = 16,
    parameter PHASE_WIDTH = 24, // 24 - 48 bits
    parameter AMP_WIDTH = 16
    ) 
   (
    input                    clk, en,
    input [TUNING_WIDTH-1:0] tuning_word,
    output [3*DATA_WIDTH-1:0]  output_data
    );

   wire [PHASE_WIDTH-1:0] phase;
   wire [PHASE_WIDTH-1:0] delta;

   assign delta = {{(PHASE_WIDTH-TUNING_WIDTH){1'b0}}, tuning_word};

   phase_accumulator
     #(
       .TUNING_WIDTH(TUNING_WIDTH), 
       .PHASE_WIDTH(PHASE_WIDTH)
       )
   pa1 
   (
    .clk(clk), 
    .en(en), 
    .tuning_word(3 * tuning_word),
    .phase(phase)
    );

   wire [PHASE_WIDTH-1:0] phase0, phase1, phase2;

   // split phase into three for parrelization
   assign phase0 = phase;
   assign phase1 = phase + delta;
   assign phase2 = phase + (delta << 1);

   wire [DATA_WIDTH-1:0] trunc_phase0, trunc_phase1, trunc_phase2;
   
   quantizer q0 (.in(phase0), .out(trunc_phase0));
   quantizer q1 (.in(phase1), .out(trunc_phase1));
   quantizer q2 (.in(phase2), .out(trunc_phase2));

   reg [AMP_WIDTH-1:0] amp0, amp1, amp2;
   
   phase_to_amp_conv ptac0 (trunc_phase0, amp0);
   phase_to_amp_conv ptac1 (trunc_phase1, amp1);
   phase_to_amp_conv ptac2 (trunc_phase2, amp2);

   assign output_data = (amp0 << (AMP_WIDTH * 2)) + (amp1 << AMP_WIDTH) + amp2;

endmodule // parallel

// Modulo N counter 
module phase_accumulator
  #(
    parameter TUNING_WIDTH = 16,
    parameter PHASE_WIDTH = 24
    )
  (
   input                    clk, en,
   input [TUNING_WIDTH-1:0] tuning_word,
   output reg [3:0] [PHASE_WIDTH-1:0]  phase
   );

   reg [PHASE_WIDTH-1:0] phase_base;

   always @(posedge clk) begin
     if (en == 1'b1)
       begin
          phase <= phase + {{(PHASE_WIDTH-TUNING_WIDTH){1'b0}}, tuning_word};
       end
   end

endmodule // phase_accumulator

module quantizer
  #(
    parameter INPUT_WIDTH = 24,
    parameter OUTPUT_WIDTH = 16
    )
   (
    input [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
    );

   assign out = in [INPUT_WIDTH-1:INPUT_WIDTH-OUTPUT_WIDTH]; // truncate by width difference

endmodule // quantizer
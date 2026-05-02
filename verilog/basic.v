module basic
  #(
    parameter TUNING_WIDTH = 16,
    parameter DATA_WIDTH = 16,
    parameter PHASE_WIDTH = 24, // 24 - 48 bits
    parameter AMP_WIDTH = 16
    ) 
   (
    input                    clk, en,
    input [TUNING_WIDTH-1:0] tuning_word,
    output [DATA_WIDTH-1:0]  output_data
    );

   reg [PHASE_WIDTH-1:0] phase;
   wire [DATA_WIDTH-1:0] trunc_phase;
   wire [AMP_WIDTH-1:0]   amp;

   phase_accumulator
     #(
       .TUNING_WIDTH(TUNING_WIDTH), 
       .PHASE_WIDTH(PHASE_WIDTH)
       )
   pa 
   (
    .clk(clk), 
    .en(en), 
    .tuning_word(tuning_word),
    .phase(phase)
    );

   quantizer quant (.in(phase), .out(trunc_phase));
 
   phase_to_amp_conv #(PHASE_WIDTH, AMP_WIDTH) ptac (trunc_phase, amp);

   assign output_data = amp;
   
endmodule // basic_DDS

// Modulo N counter 
module phase_accumulator
  #(
    parameter TUNING_WIDTH = 16,
    parameter PHASE_WIDTH = 24
    )
  (
   input                    clk, en,
   input [TUNING_WIDTH-1:0] tuning_word,
   output reg [PHASE_WIDTH-1:0]  phase
   );

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

// use lookup table to convert the N bit phase to N bit amplitude
module phase_to_amp_conv
  #(
    parameter DATA_WIDTH = 16,
    parameter AMP_WIDTH = 16,
    )
  (
   input [DATA_WIDTH-1:0] trunc_phase,
   output [AMP_WIDTH-1:0] amp,
   );

   reg [15:0] lut [0:65535];

   initial begin
      $readmemh("lut.mem", lut);
   end

   assign amp = lut[phase_trunc];

endmodule // phase_to_amp_conv 
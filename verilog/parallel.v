module parallel 
  #(
    parameter TUNING_WIDTH = 16,
    parameter DATA_WIDTH = 16,
    parameter PHASE_WIDTH = 24, // 24 - 48 bits
    parameter AMP_WIDTH = 16
    ) 
   (
    input                       clk, en,
    input [TUNING_WIDTH-1:0]    tuning_word,
    output reg [DATA_WIDTH-1:0] output_data
    );
   
   reg [DATA_WIDTH-1:0] phase;
   reg [AMP_WIDTH-1:0]  amp;
   
   phase_accumulator #() pa (clk, en, tuning_word, phase);
   
   flopen #(DATA_WIDTH) fl_phase (phase, imd_phase);
   
   phase_to_amp_conv #(PHASE_WIDTH, AMP_WIDTH) ptac (imd_phase, amp);
                                  
   flopen #(AMP_WIDTH) fl_amp (amp, imd_amp);
   
   da_conv #(AMP_WIDTH, DATA_WIDTH) dac (clk, en, imd_amp, output_data);

endmodule // parallel
                                  
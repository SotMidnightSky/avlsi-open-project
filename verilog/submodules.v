// Modulo N counter 
module phase_accumulator
  #(
    parameter TUNING_WIDTH = 16,
    parameter PHASE_WIDTH = 24, 
    parameter DATA_WIDTH = 16
    )
  (
   input                    clk, en,
   input [TUNING_WIDTH-1:0] tuning_word,
   output reg [DATA_WIDTH-1:0]  trunc_phase
   );

   reg [PHASE_WIDTH-1:0] phase;

   always @(posedge clk) begin
     if (en == 1'b1)
       begin
          phase <= phase + {{(PHASE_WIDTH-TUNING_WIDTH){1'b0}}, tuning_word};
          trunc_phase <= phase [TUNING_WIDTH-1:TUNING_WIDTH-DATA_WIDTH]; // truncate by width difference
       end
   end

endmodule // phase_accumulator

// use lookup table to convert the N bit phase to N bit amplitude
// module phase_to_amp_conv
//   #(
//     parameter PHASE_WIDTH, AMP_WIDTH
//     )
//   (
//    input [PHASE_WIDTH-1:0] phase,
//    output reg [AMP_WIDTH-1:0] amp,
//    );
// 
//    
// 
// endmodule // phase_to_amp_conv
// 
// 
// // 
// module da_conv
//   #(
//   parameter AMP_WIDTH, DATA_WIDTH
//   )
// (
//    input                    clk, en,
//    input [AMP_WIDTH-1:0] amp,
//    output reg [DATA_WIDTH-1:0] output_data
//    );
// 
//    always @(posedge clk)
//      if (en == 1'b1)
//        begin
//        end
// 
// endmodule // da_converter

module flopen
  #(
    parameter WIDTH = 16
    )
   (
    input                  clk, en,
    input [WIDTH-1:0]      d,
    output reg [WIDTH-1:0] q
    );

   always @(posedge clk) begin
      if (en == 1'b1)
        begin
           q <= d;
        end
   end

endmodule // flopen


module testbench();
   parameter TUNING_WIDTH = 16;
   parameter DATA_WIDTH = 16;

   reg       clk;
   reg       en;
   reg [TUNING_WIDTH-1:0] in;
   wire [DATA_WIDTH-1:0]       out;
   
   basic  basic  ( 	.clk(clk),
                	.en(en),
                	.tuning_word(in),
                    .output_data(out));

   always #10 clk = ~clk;

   initial begin
      {clk, en, in} <= 0;
      
      $monitor ("T=%0t rstn=%0b out=0x%0h", $time, en, out);
      repeat(2) @ (posedge clk);
      en <= 1;
                    

      repeat(20) @ (posedge clk);
      $finish;
   end
   
endmodule // testbench

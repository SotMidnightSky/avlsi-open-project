import numpy as np

adr_width = 16  # 2^16 = 65536 entries
data_width = 16  # 16-bit output
out_file = "lut.v"
module_name = "phase_to_amp_conv"

n = 2**adr_width
max = 2**data_width - 1

# Range: 0 to 2*pi (full cycle)
x = np.arange(n)
sine = np.sin(2 * np.pi * x / n)

# Scale from [-1,1] → [0, max]
sine_scaled = ((sine + 1) / 2) * max
sine_quantized = np.round(sine_scaled).astype(int)


with open(out_file, "w") as f:
    f.write(f"module {module_name} #(\n")
    f.write(f"parameter DATA_WIDTH = 16,\n")
    f.write(f"parameter AMP_WIDTH = 16)\n")
    f.write(f"(input [DATA_WIDTH-1:0] trunc_phase,\n")
    f.write(f"output reg [AMP_WIDTH-1:0] amp);\n")
    f.write(f"always @(*) begin\n")
    f.write(f"  case (trunc_phase)\n")
    for adr, val in enumerate(sine_quantized):
        f.write(f"    {adr_width}'d{adr}: amp = {data_width}'d{val};\n")

    f.write(f"    default: amp = {data_width}'h0;\n")
    f.write("  endcase\n")
    f.write("end\n\n")

    f.write("endmodule\n")


print(f"Wrote {out_file}")

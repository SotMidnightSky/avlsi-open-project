import numpy as np

adr_width = 16  # 2^16 = 65536 entries
data_width = 16  # 16-bit output
out_file = "lut.mem"

n = 2**adr_width
max = 2**data_width - 1

# Range: 0 to 2*pi (full cycle)
x = np.arange(n)
sine = np.sin(2 * np.pi * x / n)

# Scale from [-1,1] → [0, max]
sine_scaled = ((sine + 1) / 2) * max
sine_quantized = np.round(sine_scaled).astype(int)


with open(out_file, "w") as f:
    for val in sine_quantized:
        f.write(f"{val:04X}\n")

print(f"Wrote {out_file}")

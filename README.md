# AVLSI Open Project

## Direct Digital Synthesizer

A direct digital synthesizer allows a system to produce digitized samples of a
sinusoid. In this project, we will demonstrate the functionality of one in
verilog and work through the optimization of it.

### Basic Verilog Structure

[picture of basic outline]

The basic process of a direct digital synthesizer is:

1. A tuning word is given to set the desired frequency
2. Every rising edge the phase accumulator adds this value to itself wrapping
   back around when necessary
3. This phase value goes through a quantizer to decrease the size
4. This truncated phase value is now maped to an amplitude value in memory
5. Finally this value is outputed

### Phase Accumulator

For the Direct Digital synthesizer, we begin with the phase accumulator. We take
in an input of a
tuning word to set the step value of the phase accumulator. This then steps the
accumulated value up until hitting the cap, then circles back.

``` verilog
module phase_accumulator #() ();

endmodule
```

### Quantizer

The quantizer takes the output from the phase accumulator and takes the most
significant bits in order to limit the non useful data for a smaller
implementation. In this case it pairs it down from 24 bits to 16 bits.

``` verilog
module quantizer #() ();

endmodule
```

### Phase to Amp Converter

``` verilog
module phase_to_amp_conv #() ();

endmodule
```

### Complete Process

All together we build this out to create the pull outline.

``` verilog
module basic #() ();

endmodule
```

## Section 2

Filter frequency response of the original (un-quantized) filter and quantized
filter, comments/thoughts about the quantization effect, and anything you did to
deal with overflow

## Section 3

Architecture of your pipelined and/or parallelized FIR filter

## Section 4

Detailed hardware implementation results (e.g., area, clock frequency, power
estimation)

## Section 5

Further analysis and conclusion

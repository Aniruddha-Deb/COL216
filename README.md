# COL216

## Assignments
1. **Merge Sort**: Implement merge sort for strings in ARM assembly. The assignment
   was to be done in 3 stages.
2. **ARM CPU implementation in VHDL**: Create a working ARM CPU implementation in
   VHDL in eight stages, with support for all Data Processing (including 
   Multiply), Data Transfer and Branch instructions (and all the relevant 
   variants), and two modes: privileged and user mode (and the ability to switch
   between them via SWI instructions). Each stage has a report to explain exactly
   how all the code works

Other files include some documentation/exploring.

## Toolkits used:
- **GHDL** - Needed for all the VHDL simulations/compiling (I couldn't install 
  Vivado on a mac, sadly, so all simulation was done using GHDL+GtkWave)
- **GtkWave** - goes hand in hand with GHDL. Waveform viewer
- **ARM toolchain** - needed for compiling ARM assembly to .elf executables
- **ARMSim** - Merge sort was implemented in ARMSim (needs a linux VM, apparently
  wine on Mac doesn't support it because some WinForms thing was implemented in 
  Cocoa, and it doesn't run on 64-bit MacOS)
- **EDAPlayground** - online, was used to Synthesize after simulation.

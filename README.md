# Addition and subtraction of multi-precision (multiword) integers
You will need to use a MIPS simulator in order to execute MIPS assembly
language; we recommend the self-contained simulator SPIM, which can be run on all major
operating systems (Windows/Mac/Linux). If you would prefer to use another MIPS simulator,
thats fine, but be warned we may not be as familiar with it as with SPIM. You can
download SPIM at http://spimsimulator.sourceforge.net  

1. Make room in the data section of your code for two vectors A and B, each of size 8
words, and put the initial addresses in registers a0 and a1. As each are 8 words long,
both A and B represent 256-bit integers.  
2. Compute C = A + B in 2’s complement arithmetic, where A and B can be negative
or positive 256-bit (8-word) numbers.  
3. Compute D = A + (−B) in 2’s complement arithmetic, where you compute (−B) in
2’s complement and add.  
4. Put C and D somewhere in memory.  
Since MIPS uses 32-bit operands, there are some subtleties you need to be aware of, such as
the carry bit. Consider  
A = A7 A6 A5 A4 A3 A2 A1 A0  
B = B7 B6 B5 B4 B3 B2 B1 B0  
such that Ai and Bi are 32-bit words. Adding A0 and B0 together produces C0, but also
produces a carry-bit c1. Therefore, the addition of A1 and B1 involves: A1 + B1 + c1, where
A1, B1 are words and c1 is a single bit).  

<img src="https://i.imgur.com/q9Mtunr.gif">

Something I made over a few nights.

Requires [Logisim-Xtended](https://github.com/abc123me/Logisim-Xtended)

ROM is 12 bits per word, the first 4 bits being the opcode, last 8 being operand.

```
add   15

assembles to:
1     0f

resulting in 10f word. 
```
Use TSYS Instructions.txt as a reference to write the hex codes directly.

To use the simple ASM, build `TSYSasm.cr` with the Crystal compiler and run with two arguments, the file of the assembly code, and the name of the output file; e.g.

`./TSYSasm test.tasm output`

You can then load this into the ROM module in Logisim and run it by enabling the clock; `ctrl+k`
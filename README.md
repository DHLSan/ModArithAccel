# ModArithAccel

Efficient modulo arithmetic accelerator design for fixed prime numbers at RTL-level (VHDL).

  Modulo arithmetic is the essential building block for many cryptographic algorithms in post quantum cryptographic (PQC) schemes. There are several fundamental operations including modulo reduction, modulo addition, modulo subtraction, modulo multiplication and modulo exponentiation. These arithmetic operations plays a critical role in the performance of PQC schemes. In the recent open literature, there are several approaches and algorithms to optimize these execution units to speed up the post quantum cryptographic schemes. However, it is not clear which algorithm performs better when considering a parameter set of a PQC scheme. If prime numbers used in these modulo operations is constant and fixed, then a better computational performance in terms of performance can be achieved with a prime-specific hardware design.

  By evaluating the existing barret reduction and reduction for a fixed prime algorithms and converting them to VHDL code at the RTL level as 32x32bits and 64bits respectively, the first phase of the accelerator hardware design process has been completed. Trials of these algorithm were provided on Xilinx Zynq-7000 SoC architecture zedboard development kit, and it was observed on oled screen that on this development kit.

  In line with the directions provided by the barret reduction and reduction for a fixed prime algorithms, algorithms have been developed for a constant prime number. This prime number 7681 was chosen and arranged according to the modular operation of 64 bit numbers. The algorithm written in VHDL language at RTL level was tested and it was seen that the code worked correctly. The main purpose of the project was that creating an efficient modulo arithmetic accelerator. Therefore, as a result of observations of software and hardware tests, it was concluded that the reduction for a fixed prime algorithm was more advantageous when the efficiency of the algorithms applied was evaluated in terms of time, while the barret reduction algorithm was a more advantageous method when evaluated in terms of field.

This study is prepared for XILINX Open Hardware 2021 - Xilinx University Program Design Competition

Youtube link of Video: https://youtu.be/hIh0c6ANM2E



İsmail Alperen AYTEKIN (i.alp.ayt@hotmail.com)
İbrahim TOPALOGLU (ibrahimttopaloglu@gmail.com)


ModArithAccel


Advisor: Assist.Prof.Dr. İsmail SAN (isan@eskisehir.edu.tr)
Eskisehir Technical University

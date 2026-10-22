# FPGA--UART-communication

### Overview
This project implements a UART (Universal Asynchronous Receiver/Transmitter) communication system using VHDL on the Digilent Basys 3 FPGA development board.

The system receives serial data, converts it into parallel data, and retransmits it through a UART transmitter.

### Technical Specifications
- **Hardware:** Digilent Basys 3 FPGA
- **Development Environment:** Xilinx Vivado
- **Hardware Description Language:** VHDL
- **System Clock:** 100 MHz
- **Baud Rate:** 9600 bps
- **Data Format:** 8 data bits, 1 start bit, 1 stop bit

### System Architecture
The design consists of four main modules:

- **Receiver:** Detects incoming UART data and converts the serial bitstream into an 8-bit parallel word.
- **Transmitter:** Converts parallel data into a serial UART frame.
- **Control Logic:** Coordinates the receiver and transmitter, initiating transmission when new data is available.
- **Top-Level Module:** Integrates the components into a complete communication system.

### Verification
The design was tested using VHDL simulation and implemented on the Basys 3 FPGA.

UART communication was verified through PuTTY, demonstrating successful reception and retransmission of serial data.

### Project Files
- `receiver.vhd` — UART receiver
- `transmitter.vhd` — UART transmitter
- `comb_gate.vhd` — Control logic
- `TOP.vhd` — Top-level integration
- `transmitter_TB.vhd` — Transmitter testbench
- `Basys3_Master.xdc` — FPGA constraints

ghdl -a --std=08 -fsynopsys risc16_package.vhd controller.vhd alu.vhd fake_memory.vhd nbitsmux.vhd registers.vhd datapath.vhd testbench_datapath.vhd

ghdl -e --std=08 -fsynopsys testbench_datapath

ghdl -r --std=08 -fsynopsys testbench_datapath --vcd=tb.vcd

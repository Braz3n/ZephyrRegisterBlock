ghdl -i --workdir=work --std=08 *.vhdl
ghdl -m --workdir=work --std=08 register_tb
ghdl -r --workdir=work --std=08 register_tb --wave=wave.ghw --assert-level=note
# gtkwave wave.ghw
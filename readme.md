# Zephyr Register Block

A basic dual port register block with integrated program counter register for the Zephyr CPU project, a simple 8-bit CPU architecture.

## Ports
There are two ports, a 16-bit 'wide' bus, and an 8-bit 'half' bus.

The wide bus can be used to access the whole 16-bits of a register, and is designed to be connected to the address bus. It is read-only.

The half bus can be used to access either the low or high byte of a register, and is designed to be connected to the data bus. It can be read or written to.

## Registers
There are four 16-bit registers as follows:
| Register Designation | Address |
|----------------------|---------|
| `PC`                 |  `00`   |
| `A`                  |  `01`   |
| `B`                  |  `10`   |
| `C`                  |  `11`   |

## Operations
The register block is interacted with via 3-bit wide opcodes that take effect on the rising edge of the clock.

| Operation | Binary Code | Description                                             |
|-----------|-------------|---------------------------------------------------------|
| NOP       |    `000`    | No operation                                            |
| CpyToPC   |    `001`    | Copy a register to `PC`                                 |
| HalfOutL  |    `010`    | Apply low byte of a register to the Half Bus            |
| HalfOutH  |    `011`    | Apply high byte of a register to the Half Bus           |
| HalfInL   |    `100`    | Write the Half Bus value to the low byte of a register  |
| HalfInH   |    `101`    | Write the Half Bus value to the high byte of a register |
| WideOut   |    `110`    | Read the 16-bit value in a register out on the Wide Bus |

In addition to the opcodes, the PC register can be incremented by setting the incPC signal high on a rising edge.
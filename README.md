# Bare metal example for STM32G431KB

This is a simple example of a bare metal project for the STM32G431KB microcontroller. The project can be used with the NUCLEO-G431KB development board.

It only blinks the LED on the board.

## Installation Dependencies

### Vistual Studio Code Dev Container

Open the project in Visual Studio Code and install the `Remote - Containers extension`. Then, open the command palette and run the command `Remote-Containers: Reopen in Container`.
After the container is built, you can run the following commands in the terminal to build & flash using the command pallette and run the command `Tasks: Run Task` or direct invocation of the `make` commands.

#### Build

```bash
make -j$(nproc) build
```

#### Flash

```bash
make flash
```

### Local Installation

Ensure you have the following dependencies installed:
- arm-none-eabi-gcc (>= 13)
- arm-none-eabi-newlib
- stlink


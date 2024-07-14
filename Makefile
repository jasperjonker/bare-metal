# Variables
BUILD_DIR := build
SOURCES := main.c gpio.c
OBJECTS := $(SOURCES:%.c=$(BUILD_DIR)/%.o)

# Compiler
CC := arm-none-eabi-gcc

# Compiler flags
CFLAGS := -W -Wall -Wextra -Werror -Wundef -Wshadow -Wdouble-promotion \
          -Wformat-truncation -fno-common -Wconversion \
          -g3 -ffunction-sections -fdata-sections -I. \
          -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 $(EXTRA_CFLAGS)
LDFLAGS := -Tlink.ld -nostartfiles -nostdlib --specs=nano.specs -lc -lgcc \
           -Wl,--gc-sections -Wl,-Map=$(BUILD_DIR)/firmware.map

# Ensure the build directory exists
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Targets
.PHONY: all build flash clean

default: all

all: build

build: $(BUILD_DIR)/firmware.elf $(BUILD_DIR)/firmware.bin

$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(@D)
	${CC} -c $< $(CFLAGS) -o $@

$(BUILD_DIR)/firmware.elf: $(OBJECTS)
	${CC} $(OBJECTS) $(CFLAGS) $(LDFLAGS) -o $@

$(BUILD_DIR)/firmware.bin: $(BUILD_DIR)/firmware.elf
	arm-none-eabi-objcopy -O binary $< $@

flash: $(BUILD_DIR)/firmware.bin
	st-flash --reset write $< 0x8000000

clean:
	rm -rf $(BUILD_DIR)

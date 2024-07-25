# Variables
EXECUTABLE  := firmware
BUILD_DIR   := build
SRC_DIR     := src
INC_DIR     := include
LIB_DIR     := lib

SOURCES     := $(SRC_DIR)/startup_stm32g431xx.s \
               $(SRC_DIR)/system_stm32g4xx.c \
               $(SRC_DIR)/main.c \
               $(SRC_DIR)/gpio.c

OBJECTS     := $(SOURCES:%.c=$(BUILD_DIR)/%.c.o)
OBJECTS     := $(OBJECTS:%.s=$(BUILD_DIR)/%.s.o)

LIB_CMSIS   	:= $(LIB_DIR)/CMSIS/Include
LIB_CMSIS_CORE 	:= $(LIB_DIR)/CMSIS/CORE/Include

# Compiler
CC          := arm-none-eabi-gcc
AS          := arm-none-eabi-as
OBJCOPY     := arm-none-eabi-objcopy

# Compiler flags
AFLAGS      := -g --warn --fatal-warnings \
               -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=vfpv4

CFLAGS      := -W -Wall -Wextra -Werror -Wundef -Wshadow -Wdouble-promotion \
               -Wformat-truncation -pedantic -fno-common \
               -Og -g -ffunction-sections -fdata-sections -std=gnu23 \
			   -I$(INC_DIR) -I$(LIB_CMSIS) -I$(LIB_CMSIS_CORE) \
               -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=vfpv4 $(EXTRA_CFLAGS)
# -Wconversion

LDFLAGS     := -Tlink.ld -nostartfiles -nostdlib --specs=nano.specs -lc -lgcc \
               -Wl,--gc-sections -Wl,-Map=$(BUILD_DIR)/$(EXECUTABLE).map

# Defines
DEFS 	    := -DSTM32G431xx

# Ensure the build directory exists
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Targets
.PHONY: all build flash clean

default: all

all: build

build: $(BUILD_DIR)/$(EXECUTABLE).elf $(BUILD_DIR)/$(EXECUTABLE).bin

# Assembly source
$(BUILD_DIR)/$(SRC_DIR)/%.s.o: $(SRC_DIR)/%.s
	@mkdir -p $(@D)
	$(AS) $(AFLAGS) -o $@ $<

# C source
$(BUILD_DIR)/$(SRC_DIR)/%.c.o: $(SRC_DIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) $(DEFS) -o $@ -c $<

# Link the object files to create the ELF binary
$(BUILD_DIR)/$(EXECUTABLE).elf: $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) $(DEFS) -o $@ $(OBJECTS)

# Convert ELF to binary format
$(BUILD_DIR)/$(EXECUTABLE).bin: $(BUILD_DIR)/$(EXECUTABLE).elf
	$(OBJCOPY) -O binary $< $@

flash: $(BUILD_DIR)/$(EXECUTABLE).bin
	st-flash --reset write $< 0x8000000

clean:
	rm -rf $(BUILD_DIR)

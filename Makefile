###############################################################################
# Makefile to build the firmware for the STM32G431 microcontroller
#
# Usage:
#   make [debug|release]
#
###############################################################################

###############################################################################
# Variables
###############################################################################
EXECUTABLE  			:= firmware
BUILD_DIR   			:= build
SRC_DIR     			:= src
INC_DIR     			:= include
LIB_DIR     			:= lib
DEBUG 					?= 1 				# 0 = release, 1 = debug


###############################################################################
# Defined symbols
###############################################################################
DEFS 	    			+= -DSTM32G431xx


###############################################################################
# Source files
###############################################################################
SOURCES     			+= $(SRC_DIR)/startup_stm32g431xx.s
SOURCES     			+= $(SRC_DIR)/system_stm32g4xx.c
SOURCES     			+= $(SRC_DIR)/main.c
SOURCES     			+= $(SRC_DIR)/gpio.c


###############################################################################
# Libraries
###############################################################################
LIB_CMSIS   			:= $(LIB_DIR)/CMSIS/Include
LIB_CMSIS_CORE			:= $(LIB_DIR)/CMSIS/CORE/Include


###############################################################################
# Makefile configuration
###############################################################################
OBJECTS     			:= $(SOURCES:%.c=$(BUILD_DIR)/%.c.o)
OBJECTS     			:= $(OBJECTS:%.s=$(BUILD_DIR)/%.s.o)

# Executables
CC						:= arm-none-eabi-gcc
AS          			:= arm-none-eabi-as
OBJCOPY     			:= arm-none-eabi-objcopy

# Flags sent to all tools in the Toolchain
TOOLCHAIN_SETTINGS      := -fmessage-length=0

### CPU/FPU Configuration
CPU   					+= -mcpu=cortex-m4
CPU   					+= -mthumb
CPU   					+= -mfloat-abi=hard
CPU   					+= -mfpu=vfpv4

# Compiler & Linker Flags
CFLAGS					+= $(TOOLCHAIN_SETTINGS) $(DEFS) $(CPU)
CFLAGS					+= -Wall
CFLAGS					+= -Wextra
CFLAGS					+= -Wfatal-errors
CFLAGS					+= -Wundef -Wshadow -Wdouble-promotion
CFLAGS					+= -Wformat-truncation -pedantic
CFLAGS					+= -fno-common
CFLAGS					+= -ffunction-sections -fdata-sections
CFLAGS					+= -std=gnu23
CFLAGS					+= -I$(INC_DIR) -I$(LIB_CMSIS) -I$(LIB_CMSIS_CORE)

LDFLAGS					+= $(TOOLCHAIN_SETTINGS) $(DEFS)
LDFLAGS                 += -Tlink.ld
LDFLAGS                 += -nostartfiles
# LDFLAGS                 += -nostdlib
LDFLAGS                 += --specs=nano.specs
LDFLAGS                 += -lc -lgcc
LDFLAGS                 += -Wl,--gc-sections -Wl,-Map=$(BUILD_DIR)/$(EXECUTABLE).map

AFLAGS					+= $(CPU)
AFLAGS      			+= --warn --fatal-warnings


###############################################################################
# Generate build config using Product Root Directory ($1), Build Type ("debug" or "release") ($2)
###############################################################################
DEFS_DEBUG				:= -DDEBUG
CFLAGS_DEBUG			:= -ggdb -g3 -Og
LDFLAGS_DEBUG 			:=

DEFS_RELEASE       		:=
CFLAGS_RELEASE   		:= -O3
LDFLAGS_RELEASE			:=

ifeq ($(DEBUG), 1)
# @echo "Building for debug..."
    DEFS    += $(DEFS_DEBUG)
    CFLAGS  += $(CFLAGS_DEBUG)
    LDFLAGS += $(LDFLAGS_DEBUG)
else
# @echo "Building for release..."
    DEFS    += $(DEFS_RELEASE)
    CFLAGS  += $(CFLAGS_RELEASE)
    LDFLAGS += $(LDFLAGS_RELEASE)
endif


###############################################################################
# Targets
###############################################################################

# Targets
.PHONY: all build flash clean debug release

default: all

all: build

build: $(BUILD_DIR)/$(EXECUTABLE).elf $(BUILD_DIR)/$(EXECUTABLE).bin


# Assembly source
$(BUILD_DIR)/$(SRC_DIR)/%.s.o: $(SRC_DIR)/%.s
	@mkdir -p $(@D)
	@echo "-> Assembling $<"
	$(AS) $(AFLAGS) -o $@ $<

# C source
$(BUILD_DIR)/$(SRC_DIR)/%.c.o: $(SRC_DIR)/%.c
	@mkdir -p $(@D)
	@echo "-> Compiling $<"
	$(CC) $(CFLAGS) -o $@ -c $<

# Link the object files to create the ELF binary
$(BUILD_DIR)/$(EXECUTABLE).elf: $(OBJECTS)
	@echo ' '
	@echo '-> Building $(@)'
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJECTS)
	@echo ' '
	arm-none-eabi-size $(BUILD_DIR)/$(EXECUTABLE).elf
	@echo 'Finished building: $@'
	@echo ' '

# Convert ELF to binary format
$(BUILD_DIR)/$(EXECUTABLE).bin: $(BUILD_DIR)/$(EXECUTABLE).elf
	$(OBJCOPY) -O binary $< $@

flash: $(BUILD_DIR)/$(EXECUTABLE).bin
	st-flash --reset write $< 0x8000000

clean:
	rm -rf $(BUILD_DIR)

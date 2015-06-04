###########################################################################
## The AVR-Ada Library is free software;  you can redistribute it and/or ##
## modify it under terms of the  GNU General Public License as published ##
## by  the  Free Software  Foundation;  either  version 2, or  (at  your ##
## option) any later version.  The AVR#Ada Library is distributed in the ##
## hope that it will be useful, but  WITHOUT ANY WARRANTY;  without even ##
## the  implied warranty of MERCHANTABILITY or FITNESS FOR A  PARTICULAR ##
## PURPOSE. See the GNU General Public License for more details.         ##
###########################################################################

# This makefile is adapted from the sample Makefile of WinAVR by Eric
# B. Wedington, Jörg Wunsch and others.  As they released it to the
# Public Domain, I could pretend that I wrote it myself.  Honestly, I
# removed many (probably useful) parts to better fit the GNAT project makes.
#

# On command line:
#
# make all = Make software.
#
# make clean = Clean out built project files.
#
# make file.prog = Upload the hex file to the device, using avrdude.
#                Please customize the avrdude settings below first!
#
# make filename.s = Just compile filename.adb into the assembler code only.
#
#
# To rebuild project do "make clean" then "make all".
#----------------------------------------------------------------------------

# MCU name
MCU := atmega2560

# GNAT project file
GPR := build.gpr

# put the names of the target files here (without extension)
TARGETS := rover

# build directory
BUILD := build


#---------------- GNATMAKE Options ----------------
MFLAGS = -XMCU=$(MCU) -p -P$(GPR)
# -p : Create missing obj, lib and exec dirs

#---------------- Programming Options (avrdude) ----------------
# Output format. (can be srec, ihex, binary)
FORMAT = ihex

#---------------- Programming Options (avrdude) ----------------

# wiring preserves the Arduino bootloader, allowing it to be programmed
# over the USB port. The -D option prevents a flash erase; this is required
# because of a limitation in the Mega's bootloader.
AVRDUDE_PROGRAMMER = wiring -D
AVRDUDE_PORT = /dev/ttyACM1 115200 -F 

AVRDUDE_WRITE_FLASH =	-U flash:w:
AVRDUDE_WRITE_EEPROM =	-U eeprom:w:

# This triggers an erase of the bootloader, e.g. for use with an
# AVRISP mk2. It will both erase the flash and clear the bootloader
# fuses so that the board will boot directly from the main program.
AVRDUDE_CLEAR_BOOT =	-e -u -U hfuse:w:0xDD:m

# Reset the bootloader fuses so that the board will boot from the
# bootloader.
AVRDUDE_RESET_BOOT =	-e -u -U hfuse:w:0xD8:m

# Increase verbosity level.  Please use this when submitting bug
# reports about avrdude. See <http://savannah.nongnu.org/projects/avrdude>
# to submit bug reports.
AVRDUDE_VERBOSE = -v -v

AVRDUDE_FLAGS = -p $(MCU) -P $(AVRDUDE_PORT) -c $(AVRDUDE_PROGRAMMER)
AVRDUDE_FLAGS += $(AVRDUDE_VERBOSE)

#============================================================================

# Define programs and commands.
TOOLCHAIN:= /opt/avr-ada-4.7.2/bin
SHELL    := sh
CC       := $(TOOLCHAIN)/avr-gcc
OBJCOPY  := $(TOOLCHAIN)/avr-objcopy
OBJDUMP  := $(TOOLCHAIN)/avr-objdump
SIZE     := $(TOOLCHAIN)/avr-size
NM       := $(TOOLCHAIN)/avr-nm
AVRDUDE  := avrdude
REMOVE   := rm -f
COPY     := cp
RENAME   := mv
WINSHELL := cmd
GNATMAKE := $(TOOLCHAIN)/avr-gnatmake

# Combine all necessary flags and optional flags.
# Add target processor to flags.
ALL_ASFLAGS = -mmcu=$(MCU) -I. -x assembler-with-cpp $(ASFLAGS)

ADA_TARGETS_ELF =$(addprefix $(BUILD)/, $(addsuffix .elf, $(TARGETS)))
ADA_TARGETS_HEX =$(addprefix $(BUILD)/, $(addsuffix .hex, $(TARGETS)))
ADA_TARGETS_EEP =$(addprefix $(BUILD)/, $(addsuffix .eep, $(TARGETS)))
ADA_TARGETS_LSS =$(addprefix $(BUILD)/, $(addsuffix .lss, $(TARGETS)))
ADA_TARGETS_SYM =$(addprefix $(BUILD)/, $(addsuffix .sym, $(TARGETS)))
ADA_TARGETS_SIZE = $(addprefix $(BUILD)/, $(addsuffix .size, $(TARGETS)))
ADA_TARGETS =	$(ADA_TARGETS_ELF) 	\
	      	$(ADA_TARGETS_HEX) 	\
	      	$(ADA_TARGETS_EEP)	\
		$(ADA_TARGETS_LSS)	\
		$(ADA_TARGETS_SYM)	\
		$(ADA_TARGETS_SIZE)

# Default target.
all: build

# Create the necessary sub-directories
SUBDIRS := obj $(BUILD)


build: $(ADA_TARGETS)

%.size: %.elf FORCE
	$(SIZE) --format=avr --mcu=$(MCU) $<

upload: $(TARGETS_HEX) $(TARGETS_EEP)
	$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FLASH)$*.hex

# clear-bootloader wipes the bootloader and causes the board to boot
# from a bare-metal program.
clear-bootloader:
	$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_CLEAR_BOOT)

# reset-bootloader causes the board to boot from a bootloader.
reset-bootloader:
	$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_CLEAR_BOOT)

%.hex: %.elf
	$(OBJCOPY) -O $(FORMAT) -R .eeprom $< $@

OBJCOPY_ARGS =	-j .eeprom --set-section-flags=.eeprom="alloc,load"	\
		--change-section-lma .eeprom=0 

%.eep: %.elf
	-$(OBJCOPY) $(OBJCOPY_ARGS) -O $(FORMAT) $< $@

# Create extended listing file from ELF output file.
%.lss: %.elf
	$(OBJDUMP) -h -S $< > $@

# Create a symbol table from ELF output file.
%.sym: %.elf
	$(NM) -n $< > $@

# build and link using gnatmake, force rebuilding by gnatmake to
# make sure dependencies are resolved
%.elf: $(GPR) $(SUBDIRS) FORCE
	$(GNATMAKE) $(MFLAGS) -XAVRADA_MAIN=$*

# Compile: create assembler files from Ada source files.
%.s : %.adb
	$(GNATMAKE) -f -u $(MFLAGS) $< -cargs -S

%.s : %.ads
	$(GNATMAKE) -f -u $(MFLAGS) $< -cargs -S

# Assemble: create object files from assembler source files.
%.o : %.S
	@echo
	@echo $(MSG_ASSEMBLING) $<
	$(CC) -c $(ALL_ASFLAGS) $< -o $@

$(SUBDIRS):
	$(REMOVE) -r $@
	mkdir $@

# Target: clean project.
clean: clean_gnat clean_list

clean_gnat:
	avr-gnatclean -XMCU=$(MCU) -P$(GPR)

clean_gnat_recursive:
	avr-gnatclean -r -XMCU=$(MCU) -P$(GPR)

clean_list :
	$(REMOVE) *.hex
	$(REMOVE) *.eep
	$(REMOVE) *.elf
	$(REMOVE) *.map
	$(REMOVE) *.sym
	$(REMOVE) *.lss
	$(REMOVE) *.ali
	$(REMOVE) b~*.ad?
	$(REMOVE) -rf $(SUBDIRS)

FORCE:

# Listing of phony targets.
.PHONY : all finish build elf hex eep lss sym clean clean_list program


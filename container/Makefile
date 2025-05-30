# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

# Makefile

export PYTHONPATH := $(PWD)/src

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
WAVES = 1

VERILOG_SOURCES += $(PWD)/src/*.v
SIM_BUILD = $(PWD)/tmp

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = elevator

# MODULE is the basename of the Python test file
MODULE = test_elevator

# COMPILE_ARGS += -DRED_CYCLES=10 -DYELLOW_CYCLES_FORWARD=2 -DYELLOW_CYCLES_BACKWARDS=5 -DGREEN_CYCLES=8

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, ClockCycles
from cocotb.binary import BinaryValue

@cocotb.test()
async def not_called_must_stay_at_the_first_floor(dut):
    tries = 25
    times_at_first_floor = 0

    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())

    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0

    for i in range(tries):
        await ClockCycles(dut.clk, 1, True)
        if dut.current_floor.value == 1:
            times_at_first_floor = times_at_first_floor + 1

    assert times_at_first_floor == tries, "Error"

@cocotb.test()
async def one_flow(dut):
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())

    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0

    dut.origin_floor.value = 2
    dut.destination_floor.value = 5

    await ClockCycles(dut.clk, 1, True) 
    # signal reception

    dut.origin_floor.value = 0
    dut.destination_floor.value = 0

    await ClockCycles(dut.clk, 1, True) 
    # signal registeed, first floor

    await ClockCycles(dut.clk, 1, True)
    # second floor

    assert dut.current_floor.value == 2, "Error: elevator must be at second floor"

    await ClockCycles(dut.clk, 2, True)

    assert dut.current_floor.value == 2, "Error: elevator must be at second floor"

    await ClockCycles(dut.clk, 3, True)

    assert dut.current_floor.value == 5, "Error: elevator must be at fifth floor"

    await ClockCycles(dut.clk, 4, True)

    assert dut.current_floor.value == 5, "Error: elevator must be at fifth floor"

@cocotb.test()
async def two_non_overlapped_flows(dut):
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())

    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0

    dut.origin_floor.value = 7
    dut.destination_floor.value = 8

    await ClockCycles(dut.clk, 1, True) 
    # signal reception

    dut.origin_floor.value = 0
    dut.destination_floor.value = 0

    await ClockCycles(dut.clk, 30, True)

    assert dut.current_floor.value == 8, "Error: elevator must be at eighth floor"

    dut.origin_floor.value = 4
    dut.destination_floor.value = 2

    await ClockCycles(dut.clk, 1, True)
    # signal reception

    dut.origin_floor.value = 0
    dut.destination_floor.value = 0

    await ClockCycles(dut.clk, 1, True)
    # signal registration, eighth floor

    await ClockCycles(dut.clk, 1, True)
    # seventh floor

    assert dut.current_floor.value == 7, "Error: elevator must be at seventh floor"

    await ClockCycles(dut.clk, 30, True)

    assert dut.current_floor.value == 2, "Error: elevator must be at second floor"

@cocotb.test()
async def two_overlapped_flows(dut):
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())

    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0

    dut.origin_floor.value = 7
    dut.destination_floor.value = 8

    await ClockCycles(dut.clk, 2, True) 

    dut.origin_floor.value = 3
    dut.destination_floor.value = 1

    await ClockCycles(dut.clk, 1, True)

    dut.origin_floor.value = 0
    dut.destination_floor.value = 0

    await ClockCycles(dut.clk, 30, True)
    pass # just to check the waves
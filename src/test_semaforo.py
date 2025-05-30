import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, ClockCycles

# COMPILE_ARGS += -DRED_CYCLES=10 -DYELLOW_CYCLES_FORWARD=2 -DYELLOW_CYCLES_BACKWARDS=5 -DGREEN_CYCLES=8

@cocotb.test()
async def test_semaforo_flow(dut):
    cocotb.start_soon(Clock(dut.CLK, 1, units="ns").start())

    # print(dir(dut))

    assert dut.RED_CYCLES.value == 10, "Error: bad initialization"
    assert dut.YELLOW_CYCLES_FORWARD.value == 2, "Error: bad initialization"
    assert dut.YELLOW_CYCLES_BACKWARDS.value == 5, "Error: bad initialization"
    assert dut.GREEN_CYCLES.value == 8, "Error: bad initialization"

    dut.RST.value = 1
    await RisingEdge(dut.CLK)
    dut.RST.value = 0
    await RisingEdge(dut.CLK)

    assert dut.cycles.value == dut.RED_CYCLES.value, "RED, forward: incorrect value for cycles"
    assert dut.state.value == dut.RED_LIGHT.value, "RED, forward: incorrect value for light"
    assert dut.forward.value == 1, "RED, forward: incorrect value for forward"

    await ClockCycles(dut.CLK, dut.RED_CYCLES.value, True)
    assert dut.cycles.value == dut.YELLOW_CYCLES_FORWARD.value, "YELLOW, forward: incorrect value for cycles"
    assert dut.state.value == dut.YELLOW_LIGHT.value, "YELLOW, forward: incorrect value for light"
    assert dut.forward.value == 1, "YELLOW, forward: incorrect value for forward"

    await ClockCycles(dut.CLK, dut.YELLOW_CYCLES_FORWARD.value+1, True)
    assert dut.cycles.value == dut.GREEN_CYCLES.value, "GREEN, forward: incorrect value for cycles"
    assert dut.state.value == dut.GREEN_LIGHT.value, "GREEN, forward: incorrect value for light"
    assert dut.forward.value == 1, "GREEN, forward: incorrect value for forward"

    await ClockCycles(dut.CLK, dut.GREEN_CYCLES.value, True)
    assert dut.cycles.value == dut.YELLOW_CYCLES_BACKWARDS.value, "YELLOW, backwards: incorrect value for cycles"
    assert dut.state.value == dut.YELLOW_LIGHT.value, "YELLOW, backwards: incorrect value for light"
    assert dut.forward.value == 0, "YELLOW, backwards: incorrect value for forward"

    await ClockCycles(dut.CLK, dut.YELLOW_CYCLES_BACKWARDS.value, True)
    assert dut.cycles.value == dut.RED_CYCLES.value, "RED, forward: incorrect value for cycles"
    assert dut.state.value == dut.RED_LIGHT.value, "RED, forward: incorrect value for light"
    assert dut.forward.value == 1, "RED, forward: incorrect value for forward"

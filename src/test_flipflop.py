import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge, Timer

@cocotb.test()
async def test_flipflop(dut):

    d=(1, 0, 1)
    y=(1, 0, 1)

    cocotb.start_soon(Clock(dut.CLK, 1, units="ns").start())

    for i in range(len(y)):
        dut.D.value = d[i]
        await Timer(1.2, units="ns")
        assert dut.Q.value == y[i], "Error"

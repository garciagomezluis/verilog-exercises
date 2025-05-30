import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge, Timer

@cocotb.test()
async def test_sequential_demo(dut):

    a=(0, 1, 0, 0, 1, 1, 0, 1)
    b=(0, 1, 1, 0, 1, 0, 1, 0)
    y=(0, 0, 1, 1, 1, 0, 1, 0)

    cocotb.start_soon(Clock(dut.CLK, 1, units="ns").start())

    for i in range(len(y)):
        dut.A.value = a[i]
        dut.B.value = b[i]
        await Timer(1, units="ns")
        # dut._log.info("%s", dut.Z.value)
        assert dut.Z.value == y[i], "Error"

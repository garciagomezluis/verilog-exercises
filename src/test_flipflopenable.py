import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer

@cocotb.test()
async def test_flipflopenable(dut):

    e=(0, 1, 1, 0, 1, 0)
    d=(1, 0, 1, 1, 0, 1)
    y=('x', 0, 1, 1, 0, 0)

    cocotb.start_soon(Clock(dut.CLK, 1.2, units="ns").start())

    for i in range(len(y)):
        dut.EN.value = e[i]
        dut.D.value = d[i]
        await Timer(1, units="ns")
        assert dut.Q.value == y[i], "Error"
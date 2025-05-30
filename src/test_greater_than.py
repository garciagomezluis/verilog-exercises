import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def test_greater_than(dut):
    a=(0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3)
    b=(0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3)
    y=(0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0)

    for i in range(len(y)):
        dut.A.value=a[i]
        dut.B.value=b[i]
        await Timer(1, 'ns')
        assert dut.F.value == y[i], f"Error {i}"

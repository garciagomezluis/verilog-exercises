import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def test_decoder(dut):
    dut.A.value=0
    await Timer(1, 'ns')
    assert dut.D[0].value == 1, f"Error"
    assert dut.D[1].value == 0, f"Error"

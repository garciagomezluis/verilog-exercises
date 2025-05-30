import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def test_decoder(dut):
    a=(0b00, 0b00, 0b00, 0b00, 0b01, 0b01, 0b01, 0b01, 0b10, 0b10, 0b10, 0b10, 0b11, 0b11, 0b11, 0b11)
    y=(0b0 , 0b0 , 0b0 , 0b1 , 0b0 , 0b0 , 0b1 , 0b0 , 0b0 , 0b1 , 0b0 , 0b0 , 0b1 , 0b0 , 0b0 , 0b0 )

    for i in range(len(y)):
        dut.A.value=a[i]
        await Timer(3, 'ns')
        assert dut.D[i%4].value == y[i], f"Error"


## Traffic Light

With Icarus Verilog + GTKWave

```bash
iverilog -o traffic_light_tb.vvp *.v
vvp traffic_light_tb.vvp
gtkwave *.vcd
```

<img src="./img/traffic_light.jpeg" width="100%" />

## Elevator

With Icarus Verilog + cocotb + GTKWave

Dockerized, Local Ubuntu 22.04. In Repo root:

```bash
make setup
make sim
```

<img src="./img/elevator1.png" width="100%" />

<img src="./img/elevator2.png" width="100%" />




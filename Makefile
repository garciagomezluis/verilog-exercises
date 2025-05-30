DOCKER_RUN := ./container/_run.sh
CONTAINER_MAKE := $(DOCKER_RUN) make
CONTAINER_GTKWAVE := $(DOCKER_RUN) gtkwave

all: sim

setup:
	./container/_build.sh

sim:
	$(CONTAINER_MAKE) sim

waves:
	$(CONTAINER_GTKWAVE) tmp/*.fst

clean:
	rm -rf tmp src/__pycache__

.PHONY: all sim waves clean

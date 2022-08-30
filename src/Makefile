WOKWI_PROJECT_ID=341446083683025490

SHELL := /bin/bash

sim:
	vlog ./user_module_$(WOKWI_PROJECT_ID).v
	vlog ./user_module_$(WOKWI_PROJECT_ID)_tb.v

	vsim user_module_$(WOKWI_PROJECT_ID)_tb -voptargs=+cover=sbfec -coverage \
		-do "run -all"

clean:
	rm -rf transcript
	rm -rf work
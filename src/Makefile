WOKWI_PROJECT_ID=341446083683025490

SHELL := /bin/bash

compile: 
	vlog ./user_module_$(WOKWI_PROJECT_ID).v
	vlog ./user_module_$(WOKWI_PROJECT_ID)_tb.v

sim: compile
	vsim user_module_$(WOKWI_PROJECT_ID)_tb -do "do wave.do; run -all"

clean:
	rm -rf vsim.wlf
	rm -rf transcript
	rm -rf work
	rm -rf wlft5YuHtL
	rm -rf wlftZJPU8G
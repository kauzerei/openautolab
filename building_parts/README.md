# Parts to build OpenAutoLab
## List of components to buy
### Main board
- Arduino Nano
- Mini 360 buck converter, or any suitable 5v converter
- 12mm buzzer
- 5 flyback diodes, for example 1N4004, but almost any diode will do
- 10 screw terminal blocks, for example Phoenix MKDS 3/ 2-5.08 1x2
- 3 6x6mm push switches 
- 2 12VDC relays, for example SRD-12VDC-SL-C or Finder 36.11.9.012
- 2 darlington transistor arrays TD62064APG or analogous
- SPDT ON-ON (or SPST) toggle switch with 5.08mm raster, for example APEM 5026
- 3x1 pin header for connecting servo
- 2 4x1 socket header for connecting display and scale 
Feel free to modify the PCB to fit available components, like changing footprint for different pump switch or DC-DC converter. 
### Electromechanics
- 4-6 normally-closed 12V valves. See the picture as a reference, those are cheap and good enough. Number of valves depends on what process you want to run. 1 valve for water, 1 valve for waste, plus 1 valve for each chemical. 4 in total fro black&white, 5 for c41, 6 for e6.
- ZC-A210 or similar 12V gear pump, capable of running in two directions at a speed of about 2l/min for prolonged times.
- Weight cell and HX711 ADC for it.
- MG90 servo
Optional: 
- Brita filter for water
- Any pump that can work for prolonged periods without overheating
- Float switch
### Other parts to buy
- Flexible hose. The choice depends on the pump and valves, 6mm inner diameter seems to work.
- 3-5 Y-pipes or T-pipes, one for each valve minus one.
- Developing tank. AP developing tank is recommended
- Beakers for chemicals
Optional:
Sous Vide and some water-tight container for heating the beakers with water.
## Problems to solve
1. Developing tank needs to be connected to the hose and to be somehow agitated. Those problems could be solved in a number of ways, I suggest the following way. Drill a hole in a bottom of the tank and insert a hose adapter with built-in light trap, which lets liquids through, but does not let the light in. Agitate using agitation rod attached to servo. In the `mechanics` subdirectory there are part desidns of a light-tight adapter and servo-powered agitator compatible with AP developing tank. Parts compatible with other tanks should be designed individually for each one.

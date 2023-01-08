# Parts list, electronic schematics, PCB layouts.
## Schematics and PCB layouts
Schematics and PCB layouts are stored in KiCAD 6.0 format. `openautolab_2layer.kicad_pcb` is automatically routed double-layered version of the board with plated through holes aimed at having it produced by professionals.  
`openautolab.kicad_pcb` is hand-routed single-layer version, optimized for DIY production at home. Jumper wires on signal lines could be avoided by routing some tracks between pads, but it requires better precision than toner transfer technique can provide. Two jumper wires on power lines however are a necessity.  
## List of components
### Main board
- Arduino Nano
- Mini 360 buck converter, or any suitable 5v converter
- 12mm buzzer
- 5 flyback diodes, for example 1N4004, but almost any diode will do
- 10 screw terminal blocks, for example Phoenix MKDS 3/ 2-5.08 1x2
- 3 6x6mm push switches 
- 2 12VDC relays, for example SRD-12VDC-SL-C or Finder 36.11.9.012
- 2 darlington transistor arrays TD62064APG
- SPDT ON-ON (or SPST) toggle switch with 5.08mm raster, for example APEM 5026
- 3x1 pin header for connecting servo
- 2 4x1 socket header for connecting display and scale 
Feel free to modify the PCB to fit available components, like changing footprint for different pump switch or DC-DC converter. 
### Electromechanics
- ZC-A210 or similar 12V gear pump, capable of running in two directions at a speed of about 2l/min for prolonged times.
- 4-6 valves depending on what process you want to run. 1 valve for water, 1 valve for waste, plus 1 valve for each chemical. 4 in total fro black&white, 5 for c41, 6 for e6.

# Parts to build OpenAutoLab
## Components to buy
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
- 5 normally-closed 12V valves. See the picture as a reference, those are cheap and good enough. Number of valves depends on what process you want to run. 1 valve for water, 1 valve for waste, plus 1 valve for each chemical. 4 in total fro black&white, 5 for c41, 6 for e6.
- ZC-A210 or similar 12V gear pump, capable of running in two directions at a speed of about 2l/min for prolonged times.
- Weight cell and HX711 ADC for it.
- MG90 servo
Optional: 
- Brita filter for water
- Any pump that can work for prolonged periods without overheating
- Float switch
### Other parts to buy
- M8 threaded rod and nuts.
- Flexible silicone hose. 6mm ID 9mm OD is recommended.
- Silicon rubber rings. I suggest 8mm ID, same as thread diameter (mentioned later)
- 5 Y-pipes or T-pipes, one for each valve minus one.
- Developing tank. AP developing tank is recommended
- Vessels for chemicals. I suggest STANDARDMÅTT from IKEA
- Borrow or buy M8 tap, a tap holder and M8 die for cutting threads. I wouldn't even try to make 3d-printed water-tight hose connections, so tapping and threading should be done by hand. 
Optional:  
- Sous Vide and some water-tight container for heating the vessels with water.
## Parts to 3d-print
STL files for all mentioned parts can be generated using script, that calls OpenSCAD or downloaded from Thingiverse. STL don't belong in github.  
### Frame
To build the frame composed of threaded rods you need vertices that hold it together and mounts that hold other parts. Those are generated from threaded_rod_frame.scad and can be customized to build a higher or lower machine or to use different threaded rod diameter. STL files are available at Thingiverse.  
- 2x bottom_corner
- 2x bottom_corner_mirrored
- 2x top_corner
- 1x mounting_block - to hold front plate with PCB
- 6x rail_mount - to hold extra rods for mounting valves, vessels and developing tank
### Vessel and tank interfaces and mounts
To connect the vessels and the developing tank to valves and the pump you need magnetic hose interfaces, and magnetic holders to attach those interfaces to the frame. The interface for the tank has also a light-trap that prevents fogging the film through the hole, to which the hose is connected. Magnetic holder for the tank is mounted to the weight gauge for measuring amount of fluid in it. All of those parts are generated from magnetic_hose_adapters.scad and can be customized to fit magnets of different size and force.  
- 4x hollow_screw - to mount hose interface to vessels and tank through a hole.
- 3x main_body - the interfaces for the vessels
- main_body_light_trap - larger interface with light trap for the developing tank
- 4x main_body_magnet_cover - mounts magnet to the interface
- 4x hose_adapter and hose_sleeve to make hose fittings.
- 3x magnetic_holder to attach vessels to the frame
- magnetic_holder_wg to attach developing tank to the frame
- 4x holder_magnet_cover to mount magnet to the holder
- 2x weight_gauge_mount to mount weight gauge to the frame
To mount valves and pump(s) on the frame - TODO.  
### Agitation
To agitate the chemicals inside the developing tank servo-powered rod should be attached to the top of the tank. Parts compatible with AP developing tank are provided. Parts compatible with other tanks should be designed individually for each one.  
It can be hard to cut good threads in small hard plastic parts, to simplify this process, there are tapping and threading helping tools in the optinoal folder.


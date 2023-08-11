# Parts to build OpenAutoLab
## Components to buy
### Main board
- Arduino Nano
- 100uH 1A coil
- 100uF 16V capacitor
- 1000uF 16V capacitor
- 12mm buzzer
- 6 diodes, for example 1N4004, but almost any diode will do
- 10 screw terminal blocks, for example Phoenix MKDS 3/ 2-5.08 1x2
- 3 6x6mm push switches
- 2 12VDC relays, for example SRD-12VDC-SL-C or Finder 36.11.9.012
- 2 darlington transistor arrays TD62064APG or analogous
- SPDT ON-ON (or SPST) toggle switch, for example APEM 5026
- 3x1 right-angle pin header for connecting servo
- 2x1 pin header for connecting fresh water pimp switch
- 4x1 socket header for connecting the scale
- 4x1 socket header wire for connecting display
If the parts listed are unavailable, feel free to modify the PCB to fit the components you want to use instead, like relays, darlington arrays, etc.
### Electromechanics
- 6 normally-closed 12V valves. See the picture as a reference, those are cheap and good enough. Number of valves depends on what process you want to run. 1 valve for water, 1 valve for waste, plus 1 valve for each chemical. 6 is the maximum number supported by the board and it's nice to have all 6 connected even for simplified 3-bath processes: it's nice to have Fotoflo solution in the fourth vessel  
- ZC-A210 or similar 12V gear pump, capable of running in two directions at a speed of about 2l/min for prolonged times.
- Weight cell and HX711 ADC for it.
- MG90 servo
- Brita filter for water
- Any pump that can work for prolonged periods without overheating
- Float switch
### Other parts to buy
- M8 threaded rod and nuts.
- Flexible silicone hose. 6mm ID 9mm OD is recommended.
- Silicon rubber rings. I suggest 8mm ID, same as thread diameter (mentioned later)
- 5 T-pipes, one for each valve minus one.
- Developing tank. AP developing tank is recommended
- 4 Vessels for chemicals. I suggest STANDARDMÅTT from IKEA
- 12 12x2 cylindrical neodymium magnets
- Borrow or buy M8 tap, a tap holder and M8 die for cutting threads. I wouldn't even try to make 3d-printed water-tight hose connections, so tapping and threading should be done by hand.
- 6 M8x8 plastic screws and 4mm drill as a more practical alternative to 3d-printed screws. More on that in lower_rail section.
- Sous Vide and a water-tight container for heating the vessels with water.
## Parts to 3d-print
STL files for all mentioned parts can be generated using script, that calls OpenSCAD or downloaded from Thingiverse. STL files don't belong in github.  
### Frame
The machine consists of an L-shaped frame, which holds two rails: the lower rail holds the vessels and tank, the upper rail holds pumps, valves and electronics. The frame 3d-printable parts are generated from frame.scad and can be customized to use different threaded rod diameter.  
- 16x x-mount. Each pair of parts holds two rods together, two rods are mounted on each of two sides of each of two rails, therefore 16 parts in total.
- 4x t-mount. Each pair holds two rods at a right angle, the frame needs 2 such L-shaped structures to hold the rails.
### Lower rail: vessel and tank interfaces and mounts
To connect the vessels and the developing tank to valves and the pump magnetic hose interfaces are used. To attach those interfaces to the lower rail magnetic holders are used. The interface for the tank has also a light-trap that prevents fogging the film through the hole, to which the hose is connected. Magnetic holder for the tank is mounted to the weight gauge for measuring amount of fluid in it. All of those parts are generated from lower_rail.scad and can be customized to fit magnets of different size and force.  
- 6x hollow_screw - to mount hose interface to vessels and tank through a hole.
- 5x main_body - the interfaces for the vessels
- main_body_light_trap - larger interface with light trap for the developing tank.
- 6x main_magnet_cover - mounts magnet to the interface.
- 6x hose_adapter and hose_sleeve to make hose fittings.
- 5x magnetic_holder to attach vessels to the rail.
- magnetic_holder_wg to attach developing tank to the weight gauge.
- 6x holder_magnet_cover to mount magnet to the holder
- 2x(Print one mirrored!) weight_gauge_mount to mount weight gauge to the rail
### Upper rail: mounts for valves, pumps and electronic box

### Agitation
To agitate the chemicals inside the developing tank servo-powered rod should be attached to the top of the tank. Parts compatible with AP developing tank are provided. Parts compatible with other tanks should be designed individually for each one.  
It can be hard to cut good threads in small hard plastic parts, to simplify this process, there are tapping and threading helping tools in the optinoal folder.

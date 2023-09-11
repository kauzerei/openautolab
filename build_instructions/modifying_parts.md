# Modifying parts
All 3d-printable parts of the machine are designed in OpenSCAD and the original .scad files are included in this repository. That means that you can modify the parts using OpenSCAD or FreeCAD with OpenSCAD extension.  
You do not need to be familiar with any CAD software to fine tune the parts. Most of the dimensions you may wish to change such as inner and outer diameters of the hoses or height of the frame etc, can be edited using graphic interface. The shape of each part is calculated from the parameters that have default value, but can be changed to fit your needs.  
To make a 3d-printable .stl file you need to open .openscad file that contains the model, make "Parameters" section visible if it is hidden, choose the part you need from the drop-down list and change the parameters you want.  
Depending on OpenSCAD version and your computer, the process of generating the part from parameters may take some time. Usually after you change some parameter, preview is automatically generated. Preview is a way to estimate if the changes that you make are the changes you want, it is faster, than generating the printable part but can contain some artifacts like missing or extra faces. Preview generation is also triggered by pressing F5.  
To generate the actual part, press F6. It is usually slower than preview, but generates nice parts without artifacts. To speed up this process, use the latest nightly-build of OpenSCAD and turn on Manifold library usage, it is so much faster, that you can ignore preview and always render the part completely after each change.  
To save the rendered part to an .stl file press F7.   
## Upper rail
***rod diameter*** outer diameter of the threaded rod.  
***rods distance*** distance between rods of the upper rail.  
### Brackets
***part width*** width of the holders. Twice the size of the hole is a good start.  
***part thickness*** Thickness of the brackets. About twice as thick as your comfortable wall thickness for not loaded parts.  
***air gap*** a gap between two halves of the mount. Gives a room for tightening them together on a rail and for printing two halves as one part without having them stuck together.  
***valve offset*** used to place the valves at certain distance from the plane of upper rail, for example to free some space for a decorative panel that covers parts of the machine.  
***pump offset*** how far mounting points of the pump are lifted above the surface of the brackets  
***mount hole*** diameter of the screws that hold the valves.  
***mount hole distance*** distance between screws that hold the valve.  
***pcb angle*** angle in degrees at which electronic enclosure is inclined relative to vertical  
***pcb holes distance*** vertical distance between pcb mounting points  
***extra_room*** how far is mounting hole of the electronic enclosure from  
### Filter attachment
***filter wall*** size of air gap of the holding clip.  
***offset v*** vertical offset, distance from mounting plane of the floating switch to the top of the filter.  
***offset h*** horizontal offset, distance from the axis of the floating switch to the inner filter wall.  
***hole*** diameter of the mounting diameter of the floating switch.  
### Advanced upper rail modification
There are brackets for mounting two types of pumps for filling the filter. If you have some special pump you can edit ***pump shape*** function and add your own 2d shape.  
## Lower rail
***cut view*** just a visualization tool, only half of the part is rendered, so you can see the inner structure inside of OpenSCAD interface.  
***rod diameter*** diameter of the threaded rod  
***override dbr*** force specific distance between rods (DBR) for the lower rail. Optimal DBR is calculated to minimize height of magnetic holder, however depending on magnet size and machine depth it may be impossible to fit the rail of optimal size inside the frame.  
***distance between rods*** if the previous parameter is set to true, sets the DBR for the lower rail. Make sure it is smaller, than the value returned by the frame.scad.  
***air gap*** affects several parts. It's distance between the walls of parts that are meant to go one inside another with some slack. Provides extra space for magnets, makes placing the vessels and the tank in their holders easier and allows helping tools for threading and tapping not to be stuck on the parts they help holding.  
### Interface
***light trap*** if the parameter is set, the hose interface is generated with extra bends inside, so the light can not pass through. Check for the developing tank interface, uncheck for all others.  
***main part holes*** diameter of inner tube of the interface. Set this to inner diameter of the thread you want to cut in this part.  
***seal length*** length of the threaded part.  
***hor wall*** minimal thickness of a horizontal wall between inner tube and bottom in tank interface. Does not affect other vessel interfaces.  
***offset*** used only for the tank interface, makes effect only if light trap is checked. Since developing tanks usually have some axis in the center it is impossible to mount the interface directly there. Offset is the distance between the center of the tank and where you drill the hole. If set correctly, the tank will be supported with its magnetic holder directly in the middle, although the interfacing hole is offset.  
### Printed thread and magnet
Those are the parameters of the 3d-printed threads used for mounting magnets. They do not affect the finer hose-mounting threads, which you need to cut with a tap and a die.  
It is recommended to turn off layer expansion correction in the slicer and fine tune the tolerances here in the model itself. The reason is to have guaranteed minimal wall thickness. If the tolerance in the model is too small and you make it larger while slicing, the wall between the valley of the inner thread and the opposite wall of the part can become too thin for printing. To better understand the thickness of walls and tolerances between all of the parts, render the part called "testfit" with the "cut view" option on, it will provide a visual clue.  
***thread pitch*** is the distance between two neighboring coils of the thread. It affects also how much horizontal space the thread takes, 3mm seems to be a good compromise between ease of print and material usage.  
***thread expend*** horizontal distance between inner wall of outer thread and outer wall of inner thread in models, that guarantee their fit after printing. It should be at least twice the horizontal expansion of the print and smaller than thread pitch. Half of the thread pitch seems to be safely far from both limits.  
***magnet diameter*** diameter of the magnet, no extra tolerance needed.  
***magnet height*** height of the magnet, no extra tolerance needed.  
***wall between magnets*** thickness of a horizontal magnet-separating wall. Keep in mind that there are two of those walls between magnets. The parameter affects maximal attraction force between magnets. This force should be just strong enough to hold an empty vessel when it is partially submerged into temperature stabilizing water bath and to keep it from floating. However the walls need to be strong enough to hold the magnets, so avoid weak magnets. 12x2mm neodymium magnets with 0.8mm wall seem to hold 500ml vessels and are two layers thick even when printing with 0.4mm layer height.  
***wall*** minimal thickness of walls. Affects distance from thread valley to the nearest opposite wall, thickness of weight gauge mount on magnetic holder, position of rod mounting holes.  
### Hose adapter and hollow screw
***screw shape*** shape of the head. "Allen" option has only hexagonally-shaped inner hole for allen key and cylindrical head. "Hexagonal" and "Square" make polygon-shaped head in addition to hexagonally-shaped inner hole for allen key.  
***adapter shape*** changes the shape of hose adapter and sleeve. Square takes more space which increases the height of interfaces, but is easier to grab. Round one is the most compact.  
***hose inner diameter*** and ***hose outer diameter*** are self-explanatory.  
***insert diameter*** and ***screw diameter*** are the diameters of hose adapter and hollow screw. Make it the outer diameter of the thread.  
***adapter inner diameter*** and ***screw inner diameter*** are the diameters of inner channels inside hose adapter and hollow screw.  
### Magnetic holder
***rod mount*** true for mounting points for threaded rods, false for mounting onto weight gauge. The tank does not need rail mounts since it is mounted on a weight gauge.  
***nut width*** space for tightening the holder on the rail, largest width of the nut (from edge to edge).  
### Weight gauge
***wg hole size*** diameter of the thread on the loaded side.  
***wg hole distance*** center distance between threaded holes on the loaded side.  
***wg ms hole size*** diameter of the thread on the clamped side.  
***wg ms hole distance*** center distance between threaded holes on the clamped side.  
***wg height*** and ***wg width*** are the dimensions of the force gauge.  
### Helper tools
***onside*** checked generates tapping tool for the side thread. Unchecked generates the tool for the top thread.  
***leader length*** length of cylindrical part of the tap.  
***tap length*** length of the threaded part of the tap.  
***tap diameter*** diameter of a hole to fit the cutting part of the tap.  
***leader diameter*** diameter of the cylindrical part of the tap.  
***holding depth*** depth of the part inpression into the helping tool.  
***die diameter*** outer diameter of threading die.  
***die height*** height (thickness) of the die.  
***handle length*** length of the bar that is used to turn the tool.  
***handle thickness*** how thick is the turning bar.  
***rounded handle*** the bar is round in cross section instead of square. Nicer to hold, harder to print.  
## Frame
OpenAutoLab is designed in such a way that it could be partially submerged into container with water, which is held at a particular temperature. If you want to use cheap off-the-shelf container, rectangular plant container is a good option.  
***rod diameter*** diameter of threaded rod used to build the frame. M8 seems reasonable, but you can try thinner or thicker rods.  
***nut width*** is a largest width (from edge to edge) of the nut for the chosen rod diameter from with some tolerance.  
***nut height*** is a height of the nut for the chosen rod diameter with some tolerance.  
***air gap*** is here mostly for hole shrinkage compensation.  
***tightening gap*** width of cut between halves of mounts, the more the tighter the halves can be pressed together.  
## Ecnlosure
Careful with last three parameters, it is supposed, that mounting rectangle and viewing window share a center. If one is offset, make the slot bigger.  
***tolerance*** tolerances for the board itself, for halves of the panel, for the buttons.  
***pcb width*** with of the main board  
***pcb height*** height of the main board  
***pcb offset*** distance from the top of the board (component side) to the front side of the front panel. There should be enough clearance for both the components soldered on the board and for external ones: display and switch.  
***pcb thickness*** thickness of the board material itself  
***solder thickness*** distance from the bottom surface of the board to the furthest point on that side. Space occupied by soldered connections.  
***pcb mount holes*** diameter of mounting points of the PCB  
***walls*** wall thickness.  
***buttons outer*** diameter of the buttons as seen from the outside.  
***buttons inner*** outer diameter of inner structure holding those buttons. Twice the inner diameter is a good start.  
***buttons height*** the height of the switches themselves. Distance between the component side of the board and the tip of the switch.  
***buttons height*** height of the actual switch on the surface of the board  
***switches diameter*** mounting diameter of the filter pump switch.  
***screen pos*** coordinates of the center of the screen.  
***screen mount*** vertical and horizontal distance between the mounting holes of the screen.  
***screen mount holes*** diameter of the screws that hold the screen.  
***screen rect*** the size of the protruding part of the screen, for which a rectangular slot should be cut on the front panel.  
### Advanced enclosure modification
Most of the parameters for this part are the positions of different components on the main board. If you modified the board layout, measure X and Y coordinates of the components (and holes) from the upper-left corner of the board and write them inside the code. Unfortunately such arrays of values cannot be set with GUI. However if you understand how to modify the board in such a way it does not fit the box anymore, you'll manage to modify the array also :).  
***pcb_holes pos*** array with coordinates of centers of the drilled holes on the PCB used for mounting it.  
***buttons pos*** array with coordinates of the centers of buttons.  
***connectors top*** array with coordinates of the centers of screw terminals. This model is made for connectors along the upper side of the board.  
***connectors left*** array with coordinates of the necessary holes on the left side of the enclosure  
***connectors right*** array with coordinates of the necessary holes on the right side of the enclosure  
***switches pos*** array with coordinates of the centers of switches. There's only one switch currently, but there may be more in future.  
## Agitation
### Cap
***outer diameter*** is an outer diameter of cylindrical part of the tank where the lid is normally mounted. No correction for part thickness is required.  
***outer depth*** how deep the lid is.  
***extra lip width*** height of elevation inside the cap that provides extra tension which increases the friction between the tank and the cap. Does not need to be high, it's here mostly to make sure, that the contact point remains at the rim of the cap when the flaps are bent, not at the rim of the tank.  
***extra lip height*** how high does the elevation go from the rim of the cap.  
***parts thickness*** wall thickness of the part. Affects both strength and stiffness. If you want your part to be really strong, print it with thicker walls, you can compensate increased stiffness with other parameters.  
***cutouts*** amount of cuts that allow the cap to stretch.  
***cut width*** width of each cut. Doesn't need to be wide, just large enough to guarantee separation on printing.  
***cut depth*** how far from the rim the cutouts go. When smaller, than *outer depth* the cut affects only the side of the cap. If the stiffness of the part needs to be further decreased, larger cut depth will make it to the flat part also.  
### Rod
***servo offset*** how far is the mounting plane of the servo from the rod.  
***servo mount*** optimal diameter of the hole for servo axis. This parameter is better found experimentally by printing a gauge with the same printer settings that you plan to use for the rod itself. The diameter needs to be large enough so the axis can be forced in, but small enough so the axis cuts splines inside of it, keeping it from free rotation.  
***rod diameter*** outer diameter of an agitating rod.  
***distance to coupling*** distance from the plane going through the upper rim of the tank to the coupling inside the spiral. For the tanks that use protrusions inside the tube that holds spirals (or just a wall dividing this tube in half at some depth) to engage with the rod to agitate through rotation. Distance from this protrusion or wall to the cap.  
***coupling length*** length of the slot, which moves the spirals. Can be over-sized without real consequences.  
***coupling width*** width of the slot. Should be larger than protrusion/wall it engages with.  

# Modifying parts
All 3d-printable parts of the machine are designed in OpenSCAD and the original .scad files are included in this repository. That means that you can modify the parts using OpenSCAD or OpenSCAD extension for FreeCAD.  
You do not need to be familiar with any CAD software to fine tune the parts, because they are parametric. Most of the dimensions you may wish to change such as inner and outer diameters of the hoses or height of the frame etc, can be edited using graphic interface. The shape of each part is calculated from the parameters that have default value, but can be changed to fit your needs.  
To make a 3d-printable .stl file you need to open .openscad file that contains the model, make "Parameters" section visible if it is hidden, choose the part you need from the drop-down list and change the parameters you want.  
Depending on OpenSCAD version and your computer, the process of generating the part from parameters may take some time. Usually after you change some parameter, preview is automatically generated. Preview is a way to estimate if the changes that you make are the changes you want, it is faster, than generating the printable part but can contain some artifacts like missing or extra faces. Preview generation is also triggered by pressing F5.  
To generate the actual part, press F6. It is usually slower than preview, but generates nice parts without artifacts. To speed up this process, use the latest nightly-build of OpenSCAD and turn on Manifold library usage, it is so much faster, that you can ignore preview and always render the part completely after each change.  
To save the rendered part to an .stl file press F7.  
## Frame
OpenAutoLab is designed in such a way that it could be partially submerged into container with water, which is held at a particular temperature. If you want to use cheap off-the-shelf container, rectangular plant container is a good option. The frame is generated from the inner measurements of the container to fit inside perfectly.  
**machine depth** is the inner smaller size of the container (distance from front to back in the narrowest part inside container). Using shallow plant containers has drawbacks, but they are all managed in the design, at least for 14cm-deep containers this machine was tested on.  
**machine width** is the inner larger size of the container (distance from left to right in the narrowest part inside container). Does not influence the shape of th parts, for visualization purposes only.  
**inclined rod length** is length of the inclined part of the frame, which is about the height of the machine. This is the parameter, defining the height and not the other way around, because of the decisions made on earlier stages of development which are not relevant anymore :)  
**Length of shorter horizontal rods** is not a parameter and is calculated with the script from other parameters. You can see the length to which to cut the rod in the output console of OpenSCAD.  
**threaded rod diameter** diameter of threaded rod used to build the frame. M8 seems reasonable, but you can try thinner or thicker rods.  
**nut height** is a height of the nut for the chosen rod diameter with some tolerance.  
**nut width** is a largest width (from edge to edge) of the nut for the chosen rod diameter from with some tolerance.  
**mount holes** is the diameter of the holes on vertices. They are used to mount main board and can potentially be used for mounting decorative panels, power supply, offset feet or to mount the frame to some base plate. Put slightly undersized diameter of the screw or of the threaded insert you want to use.  
**umad** is here mostly just for fun. When rendering frame visualization (part "all") all threaded rods are drawn with actual threads. It demonstrates the capabilities of the newest version of OpenSCAD: if Manifold library is used, rendering is so much faster, that it allows such unnecessary details. Maybe I'll use Umad mode to render illustrations later.  
## Magnetic hose adapters
**cut view** just a visualization tool, only half of the part is rendered, so you can see the inner structure inside of OpenSCAD interface.  
**override dbr** force specific distance between rods (DBR) for the lower rail. Optimal DBR is calculated to minimize height of magnetic holder, however depending on magnet size and machine depth it may be impossible to fit the rail of optimal size inside the frame. See the console output when generating the frame to find out the maximum DBR it allows. If the optimal DBR calculated by this module is higher, you need to use this override function.  
**distance between rods** if the previous parameter is set to true, sets the DBR for the lower rail. Make sure it is smaller, than the value returned by the frame.scad.
**air gap** affects several parts. It's distance between the walls of parts that are meant to go one inside another with some slack. Provides extra space for magnets, makes placing the vessels and the tank in their holders easier and allows helping tools for threading and tapping not to be stuck on the parts they help holding.   
### Main body
**light trap** if the parameter is set, the hose interface is generated with extra bends inside, so the light can not pass through. Check for the developing tank interface, uncheck for all others.  
**main part holes**
diameter of inner tube of the interface. Set this to inner diameter of the thread you want to cut in this part.  
**seal length** length of the threaded part.  
**hor wall** minimal thickness of a horizontal wall between inner tube and bottom in tank interface. Does not affect other vessel interfaces.  
**offset** used only for the tank interface, makes effect only if light trap is checked. Since developing tanks usually have some axis in the center it is impossible to mount the interface directly there. Offset is the distance between the center of the tank and where you drill the hole. If set correctly, the tank will be supported with its magnetic holder directly in the middle, although the interfacing hole is offset.  
### Printed tread and magnet
Those are the parameters of the 3d-printed threads used for mounting magnets. They do not affect the finer hose-mounting threads, which you need to cut with a tap and a die.  
It is recommended to turn off layer expansion correction in the slicer and fine tune the tolerances here in the model itself. The reason is to have guaranteed minimal wall thickness. If the tolerance in the model is too small and you make it larger while slicing, the wall between the valley of the inner thread and the opposite wall of the part can become too thin for printing.  
**thread pitch** is the distance between two neighboring coils of the thread. It affects also how much horizontal space the thread takes, 3mm seems to be a good compromise between ease of print and material usage.  
**thread expend** horizontal distance between inner wall of outer thread and outer wall of inner thread in models, that guarantee their fit after printing. It should be at least twice the horizontal expansion of the print and smaller than thread pitch. Half of the thread pitch seems to be safely far from both limits.  
**magnet diameter** diameter of the magnet, no extra tolerance needed.  
**magnet height** height of the magnet, no extra tolerance needed.  
**wall between magnets** thickness of a horizontal magnet-separating wall. Keep in mind that there are two of those walls between magnets. The parameter affects maximal attraction force between magnets. This force should be just strong enough to hold an empty vessel when it is partially submerged into temperature stabilizing water bath and to keep it from floating. However the walls need to be strong enough to hold the magnets, so avoid weak magnets. 12x1mm neodymium magnets with 0.8mm wall seem to hold 500ml vessels and are two layers thick even when printing with 0.4mm layer height.  
**wall** minimal thickness of walls. Affects distance from thread valley to the nearest opposite wall, thickness of weight gauge mount on magnetic holder, position of rod mounting holes.  
### Hollow screw
**screw shape** shape of the head. "Allen" option has only hexagonally-shaped inner hole for allen key and cylindrical head. "Hexagonal" and "Square" make polygon-shaped head in addition to hexagonally-shaped inner hole for allen key.  
**adapter shape** changes the shape of hose adapter and sleeve. Square takes more space which increases the height of interfaces, but is easier to grab. Round one is the most compact.  
**hose inner diameter** and **hose outer diameter** are self-explanatory.  
**insert diameter** and **screw diameter** are the diameters of hose adapter and hollow screw. Make it the outer diameter of the thread.  
**adapter inner diameter** and **screw inner diameter** are the diameters of inner channels inside hose adapter and hollow screw.  
### Magnetic holder
**rod mount** turns on and off mounting points to the lower rail.  
**nut width** space for tightening the holder on the rail, largest width of the nut (from edge to edge).  
**mount hole** diameter of threaded rods of lower rail.  
**weight gauge mount** turns on and off mounting point to the force gauge.
## Tank adapter
## Front panel
## Valve holder
## Filter_sensor
**filter_wall** size of air gap of the holding clip.  
**holder wall** thickness of the part itself.  
**offset v** vertical offset, distance from mounting plane of the floating switch to the top of the filter.  
**offset h** horizontal offset, distance from the axis of the floating switch to the inner filter wall.  
**hole** diameter of the mounting diameter of the floating switch.  

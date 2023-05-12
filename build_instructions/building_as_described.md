# Building OpenAutoLab
This is a detailed description of building OpenAutoLab. If you have any prebuilt modules like main board or magnetic rail, just skip the section. If you are 3d-printing the parts yourself, please refer to "making_parts.MD", it contains useful information about postprocessing of the parts. If you want to modify the size of the frame itself, or of the modules, due to differently sized magnets, hoses, or other components, refer to "modifying parts.MD", it describes how to modify parametric models of all 3d-printable parts to meet your needs.   
## Building frame
By the end of this chapter you will have skeleton of the machine with most components mounted on the frame.   
### Building rail for valves and pumps
By the end of this section you will have non-water-tight top part of the machine. The distances on the picture are for reference only, because of individual differences in size of conponents sourced from different manufacturers.    
Parts list:  
- Main pump  
- Two-part bracket for the main pump  
- Fresh water pump  
- Two-part bracket for the fresh water pump  
- 4x magnetic valves
- 4x two-part brackets for the valves  
- 8x M3x8 screws and 8x M3 nuts for mounting valves
- 4x M3x20 screws and 2x M3 nuts for mounting main pump
- 2x M3x20 screws and 2x M3 nuts for mounting fresh water pump
- 2x M8 threaded rods  
Take one of the valves, a pair of brackets and assemble them together loosely.
Push the threaded rods through and tighten the screws fixing the position of the valve. Rods must have about 5cm free from the end to where it meets the bracket.  
Now that the assembly is somewhat rigid, asseble the rest of the valves on their respective brackets loosely and place them about 1cm apart of each other.  
Take the main pump and mount it on its bracket. Mount the pump on the rail about 1cm away from the last valve.  
Take the fresh water pump and mount it on its bracket. Mount the fresh water pump on the rail about 1cm away from the main pump.   

### Building rail for magnetic holders
By the end of this section you will have a water-tight bottom part of the machine. The distances on the picture are for reference only, because depending on width of the frame, size of the magnets and the space required for vessels, holders may be mounted differently. For shallow frames that could fit 14cm-deep plant containers it may be preferable to mount the holders individually on pairs of rods, mounted perpendicularly to the main structure. If the the frame has sufficient depth it is easier to mount all magnetic holders on two rods parallel to the main structure, which is the default layout described here.  
If the force gauge was not the part of the kit, follow the instructions in making_parts.MD to make it waterproof.  
Parts list:  
- 3x rod-mountable magnetic holders
- Bar-mountable magnetic holder
- 2x force-gauge mounting brackets
- 4x larger magnet covers with outer thread
- 4x smaller magnet covers with inner thread
- 3x straight vessel interfaces  
- Tank interface with a light-trap
- 8x magnets
- Watereproof force gauge
- 2x threaded rods M8
- 12x M8 nuts
- 2x M6 screws for mounting the force gauge
- 2x M5 screws for mounting magnetic holder to the force gauge
Take the threaded rods and push them through one of the magnetic holders. Place the nuts on each side of the holder on each rod. There should be about 5cm from the end of each rod to the nut. Place two more nuts on the longer ends of the rods about 12cm from the other nuts, then another holder, then 4 more nuts, one more holder and two more nuts. The idea is that each of three holders is fixed on both sides to the rods with 4 nuts.  
Take the force gauge, and the pair of mounting brackets and fix the gauge to the rods by threading each screw through two brackets into the gauge. Mind the orientation of the gauge, the arrow must be on the free side and should point in the direction of rods.  
Mount the last holder to the other side of the gauge with two M5 screws.
Place magnets in the same orientation into all four holders.  
Screw the magnet covers into the holders. Magnets are simply put into the smaller cover and are held down with screwed on interfaces. The orientation of all the magnets should be the same in all holders and interfaces, so that they are attracted.  

### Building frame and rails together.  
Parts list:  
- 2x upper vertex
- 4x lower vertex
- 2x upper rail holder
- 4x lower rail holder
- M8 threaded rods
- M8 nut
Put two nuts on the rods about 5cm from ends. Insert those ends into upper vertex in such a way that the nuts are on diverging sides of the rods. Put two more nuts on shorter sides of the rods and fasten them tight in such a way, that rod ends are flush with nuts.  
Put a nut, an upper rail holder and one more nut on one of the rods, so that the holder can be fixed of the rod between two nuts.  
Put two more nuts on diverging sides of the rods about 5cm from their ends. Insert those ends into lower vertices such that two free holes on them are forming one continious line: another rod will be put through them later. Fix them with two more nuts just like the upper ones.  
Put a shorter rod through one of the lower vertices and put parts on it between vertices in the following order: two nuts, lower rail holder, two nuts, lower rail, two nuts. In the end both vertices and both rail holders must be fixed to the rod with two nuts each. Do not tighten the lower rail holders yet, since the distance between them depends on dimensions of the lower rail itself.  
Repeat the process to build a second triangle.  
Take six nuts, two long rods and two rails and put one nut on each of the threads about 3cm from the end. Insert 6 rods into respective holes on the triangle and fasten them from the other side like depicted. Repeat the process on the other side.  

## Mounting main board
If you want to make the board yourself, to understand its work better better, refer to "main_board" subdirectory of this repo. It contains schematics and board layout in Kicad format, and some insights about its production. First, place top cover of the front panel upside down and mount the screen and the pump switch to it. Connect the screen and the switch to the boadr. Place the buttons into their holes and put the board on top. Now close the front panel with its back cover and fix everything with screws. Now you can mount the whole assembly on the frame as shown on pictures.
## Building agitation module
Mount the servo on tank cap in such a way, that its axis is in the center of the cap. Take a long screwdriver and fix the mixing rod to the servo.
## Connecting electronics  
If you did not receive valves and pumps as a part of the kit, you need to prepare the wires to be connected to the board. The optimal way is crimping the ferrules. Covering ends of wires with solder using soldering iron is not optimal, since the solder slowly deforms under pressure with time and connection may become loose, but better than nothing. Screwing the wires as is is strongly not recommended.  
Put each pair of wires of each valve into holes in screw terminals and tighten them with screws. Polarity does not matter in case of valves. Terminals 1 through 4 are supposed to correspond to developer, fixer, clean water and dirty water respectively. Connect the rightmost teFrminal to the power supply, here the polarity is important, make sure that the negative contact is on the left, and the positive is on the right.
To the left of the power terminal is magnetic sensor for the filter and further to the left is th filter pump, both cave no incorrect polarity, unless you are using a different bidirectional pump.  
Fourth terminal to the right is the main pump. Polarity is important here, but your pump **may** theoretically have different polarity. In case it does, don't worry, just do the test run in the end and check that the pump moves the water in the right direction and change the polarity of this pump. If the hoses are connected as depicted, connect the wires as depicted. Connect the force gauge, to 4-pin connector and the agitation module to a 3-pin connector as depicted, the polarity is very important.  

## Connecting hoses
The vessels and the developing tank are connected to the hoses with interfaces, which are fancy L-shaped tubes with inner M8 threads on each end and a magnet on the bottom. The top thread is for the hollow screw, that is put through the hole in the bottom of the vessel, a gasket ring and then tightened to the interface itself.
The side thread is for the hose adapter. This part is designed to be interchangeable, because of how easily it could be accidentally broken. For the same reason it is designed with redundant sleeve that holds the hose and adds to the strength of the part.      
Parts list:
- Silicone hose 6mm ID, 9mm OD
- 3x T-connectors for 6mm hose
- 4x hose adapters
- 4x hose adapter sleeves
- 4x hollow hollow screws
- 4x silicone rings
- 13x cable binders
### Mounting hose adapters
Cut 4 hoses for vessels, filter and tank. Their length needs to be enough to connect the upper rail and the lower rail and to allow comfortable handling of vessels, mounted to them. Recommended length is about diagonal of the frame. Now connect each hose to adapter as follows.    
First, the sleeve is put on the hose, the side with hexagonal cutout facing the end of the hose. Then the narrow side of the adapter is put over the hose. Then holding the hose with one hand, the sleeve to cover contact area with the second hand. The pulling force will stretch the hose so it becomes narrower and it is easier to fit the sleeve on top of it, however it should be done carefully not to pull the hose away from the assembled adapter.  
Screw those adapters on the sides of the interfaces (not on top part which is opposite to the magnet). Use TPFE tape, silicone of other glue to make threaded connection water-tight. Keep in mind, that in case adapter is broken, you need to be able to unscrew the thread.  
### Preparing vessels and tank  
The machine is designed with AP developing tank, Ikea 500mL shakers and Brita water filter in mind. If you are building the machine from scratch you need to drill 8mm holes in each of those items, 20mm offset from center for the tank and dead center for the others. Then for each one of those repeat similar mounting process. Put the hollow screw through the hole from the inner side, such that the thread is sticking outside. Put a silicone gasket on the thread. Screw the interface on, magnetic side down. Do not over-tight, especially if you have a 3d-printed screw. Tighten just that the interface is not unscrewing itself when forces are applied by the dangling hose during normal operation.
### Finishing the connections
Cut 3 pieces of hose, each of which is just long enough to connect a T-piece with a valve and put 3 T-pieces on top of three valves which are closer to the center of machine. Cut one more slightly longer hose to connect the last valve to the side of the T-piece of the neighboring one. From now on measure the length of the hose to be cut judging from the distance of components that it connects. Cut two more short hoses and connect 3 T-pieces together. Connect the main pump to the only T-piece left. Connect the other side of the pump to the tank. Connect the four hoses attached to two vessels, water filter to valves 1 through 3, the fourth valve is for dirty water output. Connect the pump to the tank. Secure each end of each hose with a cable-binder.

# Building OpenAutoLab
This is a detailed description of building OpenAutoLab from scratch. If you have any prebuilt modules like main board or magnetic rail, just skip the section. If you are 3d-printing the parts yourself, please refer to the section "building parts" of this repo, it contains useful information about postprocessing of the parts. If you want to modify the size of the frame itself, of of the modules, due to differently sized magnets, hoses, or other components, also refer to the section "building parts" of this repo, it contains parametric models of all parts and instructions how to modify their parameters to meet your needs.   
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
Screw the magnet covers into the holders.   
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

## Building main board

## Building agitation module

## Connecting electronics  

## Connecting hoses
The vessels and the developing tank are connected to the hoses with interfaces, which are fancy L-shaped tubes with inner M8 threads on each end and a magnet on the bottom. The top thread is for the hollow screw, that is put through the hole in the bottom of the vessel, a gasket ring and then tightened to the interface itself. The machine is designed with AP developing tank, Ikea 500mL shakers and Brita water filter in mind. If you are building the machine from scratch you need to drill 8mm holes in each of those items, 20mm offset fro
The side one is for the hose adapter. This part is designed to be interchangable, because of how easily it could be accidentally broken. For the same reason it is designed with redundant sleeve that holds the hose and adds to the strength of the part.    
Parts list:
- Silicone hose 6mm ID, 9mm OD
- 3x T-connectors for 6mm hose
-  

First, the sleeve is put on the hose, the side with hexagonal cutout facing the end of the hose. Then the narrow side of the adapter is put over the hose. Then holding the hose with one hand, the second pulls the sleeve to cover contact area. The pulling force will stretch the hose so it becomes narrower and it is easier to fit the sleeve on top of it, however it should be done carefully not to pull the hose away from the assembled adapter.  
Magnets are simply put into the smaller cover and are held down with screwed on interfaces. The orientation of all the magnets should be the same in all holders and interfaces, so that they are attracted.  
Cut 4 pieces of 

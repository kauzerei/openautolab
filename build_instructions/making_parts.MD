# Making parts
This is a detailed description of making parts for the OpenAutoLab yourself. It contains useful information about 3d-printing and post-processing of the printed parts as well as making force-gauge water-tight for submerging.  
Most of the plastic parts can be 3d-printed with any filament, such as ABS, PLA or PETG. All of those filaments absorb water to some degree, so have in mind, that they may fail at some moment. ABS seems to be fine after 2 years of testing in real conditions, which means some residue water and chemicals was always inside the machine. PLA seems fine after 6 months of use, however I had bad experience of using parts printed with PLA in bathroom. PETG is to be tested. This part will be updated as the time goes.
As an owner of a cheap 3d-printer, that is incapable of high print speeds, I often recommend to increase nozzle size and layer height for some parts as a way of printing them faster. If you have only one nozzle or don't need to decrease the time of printing, you can of course print everything with one.  
If you are not sure if the dimensions of some components like valves and pumps are the same with the ones that were used to design the parts and you don't feel like editing the models, you may print all of the mounting parts with 100% infill and then cut, drill and file the parts if necessary, I did that a lot while prototyping.
## Hollow screws
The trickiest part is the hollow screw, as it is relatively highly loaded for its thickness and preferable print orientation. To make sure it's strong enough you may try several strategies:  
* print it sideways (supports needed and it may be tricky to cut thread on them afterwards)
* to keep layers thin, speed low and temperature high, without cooling (make sure that layers are squished together and have enough time and temperature to fuse)
* remelt in powder salt (tricky to fine tune the temperature and time, but may be worth it)
However consider buying M8 plastic screws, drilling 4mm holes in them and shortening their heads, that may be way easier.  
After printing, drill the inner hole to 4mm and thread the cylindrical part with an m8 die.  
If you struggle with threading there are two helping tools for holding a dye and keeping the screw straight. They also work for the threaded hose adapter.
## Frame vertices
The frame vertices are not very heavily loaded given their thickness and orientation of layers, and their dimensions do not need to be precise. You can print the parts with any resolution (I tried up to 0.5mm layer with 0.8mm nozzle) with 2-layer shell and 20% infill and be fine. Just drill the holes to size after printing.
## Magnetic holders
If you have calibrated layer expansion of your printer, you may want to turn it off for this print. It's better in this case to have guaranteed wall thickness and change expansion correction in the model itself. Default values are high enough that the threads move good even with large nozzles and layer heights; thread pitch is so large that the threads can be tightened even if the print expansion is small and there is a lot of tolerance between parts. I suggest 0.4mm nozzle and 0.2mm layer.
### Main part  
The main part of magnetic interface should be printed with the wall, top and bottom thickness of a couple millimeters to allow thread cutting and keeping the part water-tight. If it is hard to keep the tap aligned with the hole direction, you can print some helping tools that will guide the tap. There are 4 of them, for the tank interface and for vessel interfaces, for each of two threads on them. If you print with PLA, avoid cutting too fast, it is **really** easy to overheat the plastic with the friction alone and ruin the thread, one half-turn every 2 seconds is about the optimal speed.
### Magnet covers
Other parts have no strong requirements, just avoid high speeds, wet filament and anything that could make the walls of 3d-printed threads too ugly.
### Magnetic holder
You may want to save plastic on this one by setting a low infill percentage, as this part is bulky and not really heavily loaded.
## Weight gauge mount
Keep the wall thickness high (1.2-1.6mm), so you don't break the part when screwing. This part does not to be precise, so you can go with 0.8mm nozzle and 0.4mm layer height if you want.  
## Hose adapter
Similar to hollow screw mentioned in the beginning, but not as heavily loaded. You can avoid salt-remelting this one, but keep the layer height low to increase layer adhesion anyway.  
After printing you need to thread wider part of the adapter with an m8 die and drill the inner hole with a 4mm drill. For threading this adapter you can also use the helping tools mentioned earlier.
## Hose sleeve
There are some thin walls on top, usually they are not a problem if you print several at once, but if you are having troubles printing only one, set some minimal layer time and use print cooling for this part.
## Tapping tool, threading tool, wrench
Those are not really necessary, especially if you already have experience and tooling for tapping and threading, but I made them because during developing and prototyping I had to do **a lot** of threading and tapping of those particular parts, and I also may start making OpenAutoLab kits for sale, which means even more threading and tapping. After printing drill the holes in tapping tools so the tap can move along but without significant slack. For the die-holding tool attach a long m4 screw which will rest inside a die, it helps guiding the work so that the thread is coaxial with the inner tube.
## Filter sensor
You may want to heat up the clip a little with a lighter and bend it to the shape of the filter. I found it easier rather than modifying the model and printing until it fits ideally without modifications. Hold it about 15cm above the flame for about 10 seconds until you notice it becomes soft (you can notice that moment visually as the part becomes more glossy when PLA softens)
## Front panel and rear cover
You can put 3mm thread inserts into mounting holes or just screw m4 screw directly into plastic. Use a 0.8-1mm nozzle and 0.4-0.5mm layer height to really speed up the printing process, as the parts doesn't need to be precise or strong.
## Buttons
They are easier printed in bulk with print cooling on max. That way you don't need to worry that each layer has enough time to cool before the next layer is printed. Print with smaller layer height about 0.1mm to increase layer bonding and the strength of the parts will be sufficient.
## Tank cap
You may have to experiment and tweak the parameters of the model (see "modifying_parts.MD") depending on the filament and the printer. In case you **really** don't want to touch any of the parametric models, sometimes you can manage small changes in part size just with scaling and small changes in wall thickness just with layer expansion in your slicer. Otherwise, refer to modifying_parts.MD to learn using parametric model for generating the perfect STL.  
The cap should hold on to the tank by itself and not rotate when the torque of at least 0.25 N·m is applied, but not too tight so you can put it on and off without struggling and overloading the force gauge, to which the tank is mounted. Since the flaps of this part are loaded in the worst way possible you may have to change the parameters anyway to balance between their strength and resilience. Print with 0.1 layer thickness to reduce probability of breaking it between layers.
## Agitating rod
It is really important to get the size of the mounting hole correct. The spline on the servo shaft needs to cut grooves inside the rod during first mounting and hold there tightly during operations. If the hole is too small, you can't put the shaft at all, if it is too big, the rod will rotate freely. In order to find an optimal hole size you may want to print the servo gauge with several hole sizes to find the optimum. Print the gauge with exactly same settings as you plan to use on the rod itself. If you **really** don't want to touch any of the parametric models, you may play with layer expansion setting in your slicer or heat up the shaft a little in case the hole is too small, so it melts into the rod easier, or use some glue if mmthe hole is too big. Otherwise, read the modifying_parts.MD, there is the detailed description of using parametric model to generate the perfect STL for your part.   
Speeding up the print can make this part really ugly. If you don't care about the looks, go for it, the part is not visible during developing, only during film loading. Otherwise it is recommended to use 0.2mm layer height and half of maximum printing speed for nice walls. The part is loaded with a tiny 0.25 N·m servo, which rotates the film reel, so the strength is not an issue.
## Valve holder
There are no particular requirements for this part, it's small, but there are a lot of those, so you may speed up the print with a larger 0.8mm nozzle and 0.5mm layer height.
## Main and filter pump holders.
You may want to save material and time by printing with 20% infill, two-layer walls, 1.0mm extrusion width and 0.5 layer height.

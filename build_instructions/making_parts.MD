# Making parts
This is a detailed description of making parts for the OpenAutoLab yourself. It contains useful information about 3d-printing and post-processing of the printed parts as well as making force-gauge water-tight for submerging.  
Most of the plastic parts can be 3d-printed with any filament, such as ABS, PLA or PETG. All of those filaments absorb water to some degree, so have in mind, that they may fail at some moment. ABS seems to be fine after 2 years of testing in real conditions, which means some residue water and chemicals was always inside the machine. PLA seems fine after 6 months of use, however I had bad experience of using parts printed with PLA in bathroom. PETG is to be tested. This part will be updated as the time goes.
As an owner of a cheap 3d-printer, that is incapable of high print speeds, I often recommend to increase nozzle size and layer height for some parts as a way of printing them faster. If you have only one nozzle or don't need to decrease the time of printing, you can of course print everything with one.  
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

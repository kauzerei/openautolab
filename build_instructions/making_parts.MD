# Making parts
This is a detailed description of making parts for the OpenAutoLab yourself. It contains useful information about 3d-printing and post-processing of the printed parts as well as making force-gauge water-tight for submerging.  
Most of the plastic parts can be 3d-printed with any filament, such as ABS, PLA or PETG. All of those filaments absorb water to some degree, so have in mind, that they may fail at some moment. ABS seems to be fine after 2 years of testing in real conditions, which means some residue water and chemicals was always inside the machine. PLA seems fine after 6 months of use, however I had bad experience of using parts printed with PLA in bathroom. PETG is to be tested. This part will be updated as the time goes.  
## Hollow screws
The trickiest part is the hollow screw, as it is relatively highly loaded for its thickness and preferable print orientation. To make sure it's strong enough you may try several strategies:  
* print it sideways (supports needed and it may be tricky to cut thread on them afterwards)
* to keep layers thin, speed low and temperature high, without cooling (make sure that layers are squished together and have enough time and temperature to fuse)
* remelt in powder salt (tricky to fine tune the temperature and time, but may be worth it)
However consider buying M8 plastic screws, drilling 4mm holes in them and shortening their heads, that may be way easier.  
# Frame
## Vertices
The frame vertices are not very heavily loaded given their thickness and orientation of layers, and their dimensions do not need to be precise. You can print the parts with any resolution (I tried up to 0.5mm layer with 0.8mm nozzle) with 2-layer shell and 20% infill and be fine. Just drill the holes to size after printing.
## Magnetic holders
If you have calibrated layer expansion of your printer, you may want to turn it off for this print. It's better in this case to have guaranteed part thickness and change expansion correction in the model itself. Default values are high enough that the threads move good even with large nozzles and layer heights and thread pitch is so large that threads can be tightened even if the nozzle is small.

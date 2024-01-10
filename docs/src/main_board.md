# Mainboard PCB

Schematics and PCB layouts are stored in KiCAD 6.0 format.

 - `openautolab_2layer.kicad_pcb` is automatically routed double-layered version of the board with plated through holes aimed at having it produced by professionals.

 - `openautolab.kicad_pcb` is hand-routed single-layer version, optimized for DIY production at home.
 Jumper wires on signal lines could be avoided by routing some tracks between pads, but it requires better precision than toner transfer technique can provide.
 Two jumper wires on power lines however are a necessity.

You can find pre-generated gerber files for PCB fabrication attached to the [latest GitHub Release](https://github.com/kauzerei/openautolab/releases).

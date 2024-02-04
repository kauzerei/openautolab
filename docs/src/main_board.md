# Mainboard PCB

Schematics and PCB layouts are stored in KiCAD 7.0 format.

## Ordering the board online

Although the board is optimized for DIY production at home, you can order it online at well-known board-producing places.
You can find pre-generated gerber files for PCB fabrication attached to the [latest GitHub Release](https://github.com/kauzerei/openautolab/releases).

## Making the board at home

Almost all of the traces are on the back side of the board, requiring only several jumper wires on the front side to be soldered to complete the circuit.
There are no traces thinner than 0.5mm and no critically close elements.
You can use toner transfer method or apply photoresist to produce the board out of one-sided clad.
Look up online how to etch the board using those methods if you are unfamiliar with them.

The jumper wires are visualized as front copper layer in the Kicad file.
I suggest not soldering the parts with lots of pins (such as Arduino board and motor driver) directly, but rather use header sockets.
If you still want to solder Arduino directly, solder jumper wires first, because they go under it.
Thick power-delivering wires in the area of darlington arrays are supposed to go over the ICs.

Doesn't matter if you don't have the drills thin enough to make the "vias" between layers, or the wires that can go through.
Make the holes bigger and bend the jumper wires' ends in the direction of the trace rather then soldering them at one point.

## Bill of materials

| No | Part | Quantity | Digikey-id |
| --- | --- | --- | --- |
|  | Arduino Nano | 1 |  |
|  | LM2596T-5.0 | 1 | LM2596T-5.0/NOPB-ND |
|  | ULN2065B | 2 | 497-2349-5-ND |
|  | Pololu DRV8874 | 1 | - |
|  | Inductor 330uH | 1 | AIUR-06-331K-ND |
|  | Schottky diode | 2 | 1655-SB140CT-ND |
|  | Capacitor 330uF | 1 | P10378TB-ND |
|  | Capacitor 100uF | 1 | P10413TB-ND |
|  | Tactile switch 6mm | 3 | 450-1650-ND |
|  | Terminal block small | 8 | A98036-ND |
|  | Terminal block large | 4 | 277-1667-ND |
|  | Pin sockets | 2 | 2057-SMC-1-40-1-GT-ND |
|  | Pin headers | 1 |2057-PH1-07-UA-ND |

# OpenAutoLab

Free and open-source automatic film development machine.

![Firmware](https://github.com/kauzerei/openautolab/actions/workflows/compile.yml/badge.svg)
![STLs](https://github.com/kauzerei/openautolab/actions/workflows/scad.yml/badge.svg)
![Documentation](https://github.com/kauzerei/openautolab/actions/workflows/deploy.yml/badge.svg)

[![Demo video](https://img.youtube.com/vi/qe7pgEp7S68/maxresdefault.jpg)<br>Demo video](https://www.youtube.com/watch?v=Ryzbz89Sy8g)

OpenAutoLab is an attempt at making a cheap and simple film developing machine.
Inspired by Jobo Autolab, but cheaper, more repairable and open source.
Agitation is done by periodically moving fully submerged film, not rotating the drum constantly, so it is also more flexible, as it supports black-and-white processes.

Please take a look at the [OpenAutoLab documentation](https://kauzerei.github.io/openautolab/) for build and usage instructions.

- [Parts](https://kauzerei.github.io/openautolab/parts.html) contains information about all used electronic and mechanical components.
- [Build Instructions](https://kauzerei.github.io/openautolab/build_instructions.html) explains how to build the machine from scratch.
  - [Main Board](https://kauzerei.github.io/openautolab/main_board.html) concentrates on main board schematics and PCB layouts.
  - [Arduino Code](https://kauzerei.github.io/openautolab/arduino_code.html) contains build instructions for the source code of the controller of the machine.
- [Usage Instructions](https://kauzerei.github.io/openautolab/usage_instructions.html) explains how to use the finished machine.
- [Web Updater](https://kauzerei.github.io/openautolab/web_update.html) allows firmware upgrades on the main board.

You can find the latest released STL files and firmware binaries on the [GitHub releases page](https://github.com/kauzerei/openautolab/releases).

# Disclaimer

I do not take any responsibility for any damage done by mishandling chemicals.

For most processes rubber gloves suffice to keep you safe, but please refer to documents provided with each chemical you use, some are more toxic than others. This document explains the details of using the machine itself, without much attention towards the handling of chemicals. Research online if you are unsure, use your brain and be safe.

# License

The firmware, the design of 3d-printable files, the hardware design are licensed as GPLv3.
The firmware links to Arduino Servo library which is licensed under LGPL-2.1, LiquidCrystal I2C by Frank de Brabander which is licensed under LGPL-2.1, the HX711 by Bogdan Necula which is licensed under MIT.
For generation of 3d-printable .stl files Openscad is used, which is licensed under GPLv2.
The project also uses avrgirl-arduino licensed under MIT and zip.js licensed under BSD for the possibility of flashing from browser.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <https://www.gnu.org/licenses/>.

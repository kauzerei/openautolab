#!/bin/bash

# Script that generates PCB Gerber and Drill files for fabrication.
#
# Copyright (c) 2023-2024 Kauzerei <mailto:openautolab@kauzerei.de>
# Copyright (c) 2023 - 2024 Thomas Buck <thomas@xythobuz.de>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

# enter directory of script (main_board)
cd "$(dirname "$0")"

OUTDIR="fabrication"
INFILE="openautolab.kicad_pcb"

echo "Creating output directory"
rm -rf $OUTDIR
mkdir -p $OUTDIR

echo "Exporting drill files"
#kicad-cli pcb export drill -o $OUTDIR/ --format excellon --generate-map --map-format pdf $INFILE
kicad-cli pcb export drill -o $OUTDIR/ --format gerber --generate-map --map-format gerberx2 $INFILE

echo "Exporting gerber files"
#kicad-cli pcb export gerbers -o $OUTDIR/ $INFILE
kicad-cli pcb export gerbers -o $OUTDIR/ -l F.Cu,B.Cu,F.Mask,B.Mask,F.Paste,B.Paste,F.Silkscreen,B.Silkscreen,Edge.Cuts $INFILE

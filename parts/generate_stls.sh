#!/bin/bash
#
# Script that generates 3d-printable .stl files from parametric .SCAD
# models for OpenAutoLab
#
# Copyright (c) 2023-2024 Kauzerei <mailto:openautolab@kauzerei.de>
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

# enter directory of script (parts)
cd "$(dirname "$0")"

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Mac OS X detected"
  SCAD="open -n -a OpenSCAD --args"
else
  echo "Linux detected"
  SCAD="openscad"
fi

echo "Deleting previous build output"
rm -rf stl
mkdir -p stl/optional

for MODULE in agitation enclosure frame lower_rail upper_rail
do
  PARTS=$(grep -o "part.*//.*\[.*]" ${MODULE}.scad | sed 's/,/ /g' | sed 's/.*\[\([^]]*\)\].*/\1/g')
  echo "generating from ${MODULE}:"
  for PART in ${PARTS}
  do
    echo ${PART}
    if [[ "${PART}" != "OPTIONAL"* ]]; then
      FILENAME=$(echo stl/${MODULE}_${PART}.stl | tr '[:upper:]' '[:lower:]')
      $SCAD $(pwd)/${MODULE}.scad --D part=\"${PART}\" --o $(pwd)/${FILENAME}
    fi
  done
done

#hack for parts with modifyers
$SCAD $(pwd)/lower_rail.scad --D part=\"Interface\" --D light_trap=\"true\" --o $(pwd)/stl/lower_rail_interface_light_trap.stl
$SCAD $(pwd)/lower_rail.scad --D part=\"Magnetic_holder\" --D rod_mount=false --o $(pwd)/stl/lower_rail_magnetic_holder_wg.stl

#hack for optional instruments
$SCAD $(pwd)/lower_rail.scad --D part=\"OPTIONAL_tapping_tool\" --o $(pwd)/stl/optional/tapping_tool_top_vessel.stl
$SCAD $(pwd)/lower_rail.scad --D part=\"OPTIONAL_tapping_tool\" --D onside=true --o $(pwd)/stl/optional/tapping_tool_side_vessel.stl
$SCAD $(pwd)/lower_rail.scad --D part=\"OPTIONAL_tapping_tool\" --D light_trap=true --o $(pwd)/stl/optional/tapping_tool_top_tank.stl
$SCAD $(pwd)/lower_rail.scad --D part=\"OPTIONAL_tapping_tool\" --D light_trap=true --D onside=true --o $(pwd)/stl/optional/tapping_tool_side_tank.stl
$SCAD $(pwd)/agitation.scad --D part=\"OPTIONAL_servo_gauge\" --o $(pwd)/stl/optional/servo_gauge.stl
$SCAD $(pwd)/frame.scad --D part=\"OPTIONAL_nut_spinner\" --o $(pwd)/stl/optional/nut_spinner.stl
$SCAD $(pwd)/lower_rail.scad --D part=\"OPTIONAL_threading_tool\" --o $(pwd)/stl/optional/threading_tool.stl
$SCAD $(pwd)/lower_rail.scad --D part=\"OPTIONAL_wrench\" --o $(pwd)/stl/optional/wrench.stl

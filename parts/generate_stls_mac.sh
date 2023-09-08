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
    fi
    open -n -a OpenSCAD --args $(pwd)/${MODULE}.scad --D part=\"${PART}\" --o $(pwd)/${FILENAME}
  done
done
#hack for parts with modifyers
open -n -a OpenSCAD --args $(pwd)/lower_rail.scad --D part=\"Interface\" --D light_trap=\"true\" --o $(pwd)/stl/lower_rail_interface_light_trap.stl
open -n -a OpenSCAD --args $(pwd)/lower_rail.scad --D part=\"Magnetic_holder\" --D rod_mount=false --o $(pwd)/stl/lower_rail_magnetic_holder_wg.stl
#hack for optional instruments
open -n -a OpenSCAD --args $(pwd)/lower_rail.scad --D part=\"OPTIONAL_Tapping_tool\" --o $(pwd)/stl/optional/tapping_tool_top_vessel.stl
open -n -a OpenSCAD --args $(pwd)/lower_rail.scad --D part=\"OPTIONAL_Tapping_tool\" --D onside=true --o $(pwd)/stl/optional/tapping_tool_side_vessel.stl
open -n -a OpenSCAD --args $(pwd)/lower_rail.scad --D part=\"OPTIONAL_Tapping_tool\" --D light_trap=true --o $(pwd)/stl/optional/tapping_tool_top_tank.stl
open -n -a OpenSCAD --args $(pwd)/lower_rail.scad --D part=\"OPTIONAL_Tapping_tool\" --D light_trap=true --D onside=true --o $(pwd)/stl/optional/tapping_tool_side_tank.stl

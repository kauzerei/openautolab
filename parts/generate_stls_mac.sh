mkdir -p stl
for MODULE in agitation enclosure frame lower_rail upper_rail
do
  PARTS=$(grep -o "part.*//.*\[.*]" ${MODULE}.scad | sed 's/,/ /g' | sed 's/.*\[\([^]]*\)\].*/\1/g')
  echo "generating from ${MODULE}:"
  for PART in ${PARTS}
  do
    echo ${PART}
    FILENAME=$(echo stl/${MODULE}_${PART}.stl | tr '[:upper:]' '[:lower:]')
    open -W -a OpenSCAD --args $(pwd)/${MODULE}.scad --D part=\"${PART}\" --o $(pwd)/${FILENAME}
#    /Users/kauzerei/dev/openscad/build/OpenSCAD.app/Contents/MacOS/OpenSCAD $(pwd)/${MODULE}.scad --D part=\"${PART}\" --o $(pwd)/${FILENAME}
  done
done

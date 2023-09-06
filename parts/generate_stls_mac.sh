mkdir -p stl/optional
for MODULE in agitation enclosure frame lower_rail upper_rail
do
  PARTS=$(grep -o "part.*//.*\[.*]" ${MODULE}.scad | sed 's/,/ /g' | sed 's/.*\[\([^]]*\)\].*/\1/g')
  echo "generating from ${MODULE}:"
  for PART in ${PARTS}
  do
    echo ${PART}
    if [[ "${PART}" == "OPTIONAL"* ]]; then
      FILENAME=$(echo stl/optional/${PART}.stl | tr '[:upper:]' '[:lower:]')
    else
      FILENAME=$(echo stl/${MODULE}_${PART}.stl | tr '[:upper:]' '[:lower:]')
    fi
    open -n -a OpenSCAD --args $(pwd)/${MODULE}.scad --D part=\"${PART}\" --o $(pwd)/${FILENAME}
  done
done

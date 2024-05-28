//3d-printable 4x18650 holder with flexing contacts

bissl = 1 / 100;
$fn = 64 / 1;

wall = 1.6;
contact_thickness = 1.6;
contact_depth = 1.6;
battery_d = 19;
battery_l = 65;
unit = (battery_d + wall) / 14;

module arc(radius, thickness, start, end, $fn = $fn) {
  points = [
    for (a = [start:360 / $fn:end])[(radius + wall / 2) * sin(a),
                                    (radius + wall / 2) * cos(a)],
    for (a = [-end:360 / $fn:-start])[(radius - wall / 2) * sin(-a),
                                      (radius - wall / 2) * cos(-a)]
  ];
  polygon(points);
}

module arcs(params) {
  for (param = params)
    translate([ param[0], param[1] ])
        arc(param[2], param[3], param[4], param[5]);
}

module spring_flat() {
  translate([ -wall / 2, wall / 2 ]) arcs([
    [ -3 * unit, 3 * unit, 3 * unit, wall, -180, 0 ],
    [ -3 * unit, 11 * unit, 3 * unit, wall, -180, 0 ],
    [ -3 * unit, 3 * unit, 1 * unit, wall, -180, 0 ],
    [ -3 * unit, 11 * unit, 1 * unit, wall, -180, 0 ],
    [ -3 * unit, 5 * unit, 1 * unit, wall, 0, 180 ],
    [ -3 * unit, 9 * unit, 1 * unit, wall, 0, 180 ],
    [ -3 * unit, 9 * unit, 3 * unit, wall, 0, 90 ],
    [ -3 * unit, 5 * unit, 3 * unit, wall, 90, 180 ]
  ]);
  translate([ -wall, wall / 2 + 5 * unit ]) square([ wall, 4 * unit ]);
  translate([ -3 * unit - wall / 2, 0 ]) square([ 3 * unit + wall / 2, wall ]);
  translate([ -3 * unit - wall / 2, unit * 14 ])
      square([ 3 * unit + wall / 2, wall ]);
}

module spring() {
  contact_width = battery_d * 2 / 7;
  difference() {
    linear_extrude(height = battery_d + wall, convexity = 8) spring_flat();
    translate([
      -wall - bissl, (battery_d - contact_width) / 2 + wall,
      (battery_d - contact_width) / 2 + wall +
      contact_width
    ]) cube([ wall + 2 * bissl, contact_width, contact_thickness ]);
    translate([
      -wall - bissl, (battery_d - contact_width) / 2 + wall,
      (battery_d - contact_width) / 2 + wall -
      contact_thickness
    ]) cube([ wall + 2 * bissl, contact_width, contact_thickness ]);
  }
  translate([ 0, wall + battery_d / 2, wall + battery_d / 2 ])
      rotate([ 90, 0, 0 ]) linear_extrude(height = contact_width, center = true)
          polygon([
            [ 0, contact_width / 2 ], [ 0, -contact_width / 2 ], [ contact_depth, 0 ]
          ]);
}

module holder() {
  difference() {
    union() {
      cube([ battery_l + 2 * contact_depth, wall, battery_d + wall ]);
      translate([ 0, battery_d + wall, 0 ])
          cube([ battery_l + 2 * contact_depth, wall, battery_d + wall ]);
    }
    translate([ battery_l / 2, -bissl, battery_l / 2 + battery_d / 3 ])
        rotate([ -90, 0, 0 ]) cylinder(d = battery_l + contact_depth,
                                       h = battery_d + 2 * wall + 2 * bissl);
  }
  translate([ wall, wall, 0 ])
      cube([ battery_l - 2 * wall + 2 * contact_depth, battery_d, wall ]);
  translate([ battery_l + 2 * contact_depth, 0, 0 ]) mirror([ 1, 0, 0 ])
      spring();
  spring();
}

module holders(n) {
  for (i = [0:n - 1])
    translate([ 0, i * (battery_d + wall), 0 ]) holder();
}

holders(4);
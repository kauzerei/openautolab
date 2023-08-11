$fs=1/2;
part="x-mount";// [x-mount,t-mount,nut_spinner]
rod_diameter=8;
nut_width=16;
air_gap=0.5;
tightening_gap=2;
d=rod_diameter+air_gap*2;

module xmount(thickness=16,diameter=8,half=false,slot=2) {
  difference() {
    cube([thickness, 1.5*thickness+diameter/2,thickness]);
    translate([thickness/2,thickness/2,-0.01])cylinder(d=diameter,h=thickness+0.02);
    translate([-0.01,thickness+diameter/2,thickness/2])rotate([0,90,0])cylinder(d=diameter,h=thickness+0.02);
    if(half) {
      translate([-0.01,-0.01,(thickness)/2])cube([thickness+0.02, 1.5*thickness+diameter/2+0.02,thickness]);
      translate([-0.01,(thickness-diameter)/2,(thickness-slot)/2])cube([thickness+0.02, 1.5*thickness+diameter/2+0.02,thickness]);
    }
  }
}

module tmount(thickness=16,diameter=8,half=false,slot=2) {
  difference() {
    cube([thickness, 1.5*thickness+diameter/2,thickness]);
    translate([thickness/2,thickness/2,-0.01])cylinder(d=diameter,h=thickness+0.02);
    translate([thickness/2,thickness/2,thickness/2])rotate([-90,0,0])cylinder(d=diameter,h=thickness*2);
    if(half) {
      translate([-0.01,-0.01,(thickness)/2])cube([thickness+0.02, 1.5*thickness+diameter/2+0.02,thickness]);
      translate([-0.01,(thickness-diameter)/2,(thickness-slot)/2])cube([thickness+0.02, 1.5*thickness+diameter/2+0.02,thickness]);

    }
  }
}

if (part=="x-mount") {
  xmount(thickness=nut_width,diameter=d,half=true,slot=tightening_gap);
}
if (part=="t-mount") {
  tmount(thickness=nut_width,diameter=d,half=true,slot=tightening_gap);
}

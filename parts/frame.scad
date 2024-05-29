// Frame parts for OpenAutoLab
// X-mount connects two rods with non-complanar perpendicular axes, forming a shape similar to letter X
// T-mount holds two rods with complanar axes, forming a shape similar to letter T
// Nut spinner is a circular wrench, which may speed up threading nuts on long rods
//
// Copyright (c) 2023-2024 Kauzerei <mailto:openautolab@kauzerei.de>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>. 

$fs=1/2;
$fa=1/1;
bissl=1/100;
part="X-mount";// [X-mount, T-mount, Small_bracket, OPTIONAL_nut_spinner]
rod_diameter=8;
nut_width=9;
mount_hole=4.5;
thin_wall=2;
thick_wall=4;
tightening_gap=2;
tolerance=0.5;

module hole(mount_hole=4.5,layer=0.4) { //hole for clamping with threaded screw
  translate([0,0,layer])cylinder(d=mount_hole,h=100);
  mirror([0,0,1])cylinder(d=mount_hole*2,h=100,$fn=6);
}

module xmount(thickness=16,diameter=8,tightening_gap=0.5,half=false,slot=2,tolerance=0.5) {
  difference() {
    cube([thickness, 1.5*thickness+diameter/2,thickness]);
    translate([thickness/2,thickness/2,-bissl])cylinder(d=diameter+tolerance,h=thickness+2*bissl);
    translate([-bissl,thickness+diameter/2,thickness/2])rotate([0,90,0])cylinder(d=diameter,h=thickness+2*bissl);
    translate([-bissl,-bissl,(thickness)/2])cube([thickness+2*bissl, 1.5*thickness+diameter/2+2*bissl,thickness]);
    translate([-bissl,(thickness-diameter-tolerance)/2,(thickness-slot)/2])cube([thickness+2*bissl, 1.5*thickness+diameter/2+2*bissl,thickness]);
  }
}

module tmount(thickness=16,diameter=8,slot=2) {
  difference() {
    hull() {
      cube([thickness*2,thickness,thickness],center=true);
      translate([0,thickness,0])cube([thickness,thickness*2,thickness],center=true);
    }
    rotate([-90,0,0])cylinder (d=diameter,h=thickness*2+bissl);
    rotate([0,90,0])cylinder (d=diameter,h=thickness*2+bissl,center=true);
    translate([thickness/2,thickness/2,-tightening_gap-thickness/4]) hole(mount_hole=mount_hole);
    translate([-thickness/2,thickness/2,-tightening_gap-thickness/4]) hole(mount_hole=mount_hole);
    translate([-thickness-bissl,-thickness/2-bissl,-slot/2])cube([2*thickness+2*bissl, 2.5*thickness+2*bissl,thickness]);
  }
}

module small_bracket(nut_width=9,wall=2) {
  difference() {
    translate([-(rod_diameter+2*nut_width+2*wall)/2,-wall-rod_diameter/2,0]) cube([rod_diameter+2*nut_width+2*wall,2*wall+rod_diameter,nut_width+2*wall]);
    translate([0,0,-1/100])cylinder(d=rod_diameter,h=nut_width+2*wall+1/50);
    translate([-(rod_diameter+2*nut_width+2*wall)/2-1/100,-tightening_gap/2,-1/100]) cube([rod_diameter+2*nut_width+2*wall+1/50,tightening_gap,nut_width+2*wall+1/50]);
    translate([rod_diameter/2+nut_width/2,tightening_gap/2+wall,wall+nut_width/2])rotate([90,0,0])hole(layer=-1/100);
    translate([-rod_diameter/2-nut_width/2,tightening_gap/2+wall,wall+nut_width/2])rotate([90,0,0])hole(layer=-1/100);
  }
}

module nutspinner(d1,d2,d3,d4,d5,h) {
  difference() {
    cylinder(d=d1,h=h,center=true);
    hull() {
      cylinder(d=d5,h=h+2*bissl,center=true);
      translate([0,d1,0])cylinder(d=d5,h=h+2*bissl,center=true);
    }
    difference() {
      cylinder(d=d2,h=h+2*bissl,center=true);
      cylinder(d=d3,h=h+4*bissl,center=true);
      hull() {
        cylinder(d=d5+6,h=h+4*bissl,center=true);
        translate([0,d1,0])cylinder(d=d5+6,h=h+4*bissl,center=true);
      }
    }
    cylinder(d=d4,h=h,$fn=6);
  }
}

if (part=="X-mount") {
  xmount(thickness=rod_diameter+2*thick_wall,diameter=rod_diameter,tightening_gap=tightening_gap,slot=tightening_gap);
}
if (part=="T-mount") {
  tmount(thickness=rod_diameter+2*thick_wall,diameter=rod_diameter,slot=tightening_gap);
}
if (part=="Small_bracket") {
  small_bracket(nut_width=nut_width,wall=thin_wall);
}
if (part=="OPTIONAL_nut_spinner") {
  nutspinner(50,40,rod_diameter*2+2*thick_wall,rod_diameter*2+2*tolerance,rod_diameter+tolerance*2,rod_diameter*1.5);
}
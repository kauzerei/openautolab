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

$fs=0.5/1;
$fa=1/1;
part="X-mount";// [X-mount, T-mount, Small_bracket, OPTIONAL_nut_spinner]
rod_diameter=8;
nut_width=9;
wall=2;
air_gap=0.5;
mount_hole=4.5;
tightening_gap=2;

module hole(mount_hole=4.5,layer=0.4) { //hole for clamping with threaded screw
  translate([0,0,layer])cylinder(d=mount_hole,h=100);
  mirror([0,0,1])cylinder(d=mount_hole*2,h=100,$fn=6);
}

module xmount(thickness=16,diameter=8,air_gap=0.5,half=false,slot=2) {
  difference() {
    cube([thickness, 1.5*thickness+diameter/2,thickness]);
    translate([thickness/2,thickness/2,-0.01])cylinder(d=diameter+2*air_gap,h=thickness+0.02);
    translate([-0.01,thickness+diameter/2,thickness/2])rotate([0,90,0])cylinder(d=diameter,h=thickness+0.02);
    translate([-0.01,-0.01,(thickness)/2])cube([thickness+0.02, 1.5*thickness+diameter/2+0.02,thickness]);
    translate([-0.01,(thickness-diameter)/2,(thickness-slot)/2])cube([thickness+0.02, 1.5*thickness+diameter/2+0.02,thickness]);
  }
}

module tmount(thickness=16,diameter=8,slot=2) {
  difference() {
    hull() {
      cube([thickness*2,thickness,thickness],center=true);
      translate([0,thickness,0])cube([thickness,thickness*2,thickness],center=true);
    }
    rotate([-90,0,0])cylinder (d=diameter,h=thickness*2+0.01);
    rotate([0,90,0])cylinder (d=diameter,h=thickness*2+0.01,center=true);
    translate([thickness/2,thickness/2,-air_gap-thickness/4]) hole(mount_hole=mount_hole);
    translate([-thickness/2,thickness/2,-air_gap-thickness/4]) hole(mount_hole=mount_hole);
    translate([-thickness-0.01,-thickness/2-0.01,-slot/2])cube([2*thickness+0.02, 2.5*thickness+0.02,thickness]);
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
      cylinder(d=d5,h=h+0.02,center=true);
      translate([0,d1,0])cylinder(d=d5,h=h+0.02,center=true);
    }
    difference() {
      cylinder(d=d2,h=h+0.02,center=true);
      cylinder(d=d3,h=h+0.04,center=true);
      hull() {
        cylinder(d=d5+6,h=h+0.04,center=true);
        translate([0,d1,0])cylinder(d=d5+6,h=h+0.04,center=true);
      }
    }
    cylinder(d=d4,h=h,$fn=6);
  }
}

if (part=="X-mount") {
  xmount(thickness=rod_diameter+2*wall,diameter=rod_diameter,air_gap=air_gap,slot=tightening_gap);
}
if (part=="T-mount") {
  tmount(thickness=rod_diameter+2*wall,diameter=rod_diameter,slot=tightening_gap);
}
if (part=="Small_bracket") {
  small_bracket(nut_width=nut_width,wall=wall);
}
if (part=="OPTIONAL_nut_spinner") {
  nutspinner(50,40,nut_width+6,nut_width+2*air_gap,rod_diameter+air_gap*2,nut_width);
}
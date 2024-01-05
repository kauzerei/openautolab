// Agitation module for OpenAutoLab
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
part="Cap"; //[Cap, Rod, OPTIONAL_servo_gauge]
outer_diameter= 70;
outer_depth=17;
extra_lip_width=1.5;
extra_lip_height=5;
parts_thickness=1.5;
cutouts=10;
cut_width=2;
cut_depth=15;
servo_offset=7;
servo_mount=5.5;
rod_diameter=14;
distance_to_coupling=74;
coupling_length=20;
coupling_width=3;

module quarter_rotation(width=10,height=10) {
  intersection() {
    linear_extrude(height = height, convexity = 10, twist = 90, slices = 20, $fn = 16) {
      intersection() {
        circle(d=width);
        translate([-width/2,0])square([width/2,width/2]);
      }
    }
    cube([width/2,width/2,height]);
  }
}

module four_quarters(width,height){
  quarter_rotation(width,height);
  mirror([1,0,0])quarter_rotation(width,height);
  mirror([0,1,0]){
  quarter_rotation(width,height);
  mirror([1,0,0])quarter_rotation(width,height);}
}

module cap() {
  difference() {
    cylinder(d=outer_diameter+2*parts_thickness,h=outer_depth+parts_thickness);
    translate([0,0,parts_thickness])cylinder(d=outer_diameter,h=outer_depth-extra_lip_height+0.01);
    translate([0,0,parts_thickness+outer_depth-extra_lip_height])cylinder(d1=outer_diameter,d2=outer_diameter-2*extra_lip_width,h=extra_lip_height/3+0.01);
    translate([0,0,parts_thickness+outer_depth-2*extra_lip_height/3])cylinder(d=outer_diameter-2*extra_lip_width,h=extra_lip_height/3+0.01);
    translate([0,0,parts_thickness+outer_depth-extra_lip_height/3])cylinder(d1=outer_diameter-2*extra_lip_width,d2=outer_diameter,h=extra_lip_height/3+0.01);
    for (a=[0:360/cutouts:360-360/cutouts])rotate([0,0,a])translate([0,outer_diameter/2+parts_thickness,outer_depth+parts_thickness])rotate([45,0,0])cube([cut_width,cut_depth*sqrt(2),cut_depth*sqrt(2)],center=true);
    translate([0,5.5,parts_thickness/2]) {
      cube([13,24,parts_thickness+2],center=true);
      translate([0,27.5/2,0])cylinder(h=parts_thickness+2,d=2,center=true);
      translate([0,-27.5/2,0])cylinder(h=parts_thickness+2,d=2,center=true);
    }
  }
}

module rod() {
  difference() {
    cylinder(d=rod_diameter,h=distance_to_coupling+coupling_length-servo_offset-0.01);
    translate([0,0,4])cylinder(d=rod_diameter-2*parts_thickness,h=distance_to_coupling+coupling_length);
    hull(){translate([0,0,distance_to_coupling-servo_offset])rotate([90,0,0])cylinder(d=coupling_width,h=2+rod_diameter,center=true);
    translate([0,0,distance_to_coupling+coupling_length+2-servo_offset])rotate([90,0,0])cylinder(d=coupling_width,h=2+rod_diameter,center=true);}
    translate([0,0,distance_to_coupling+coupling_length/2-servo_offset])four_quarters(rod_diameter+2,coupling_length/2);
    translate([0,0,-1])cylinder(d=servo_mount,h=4);
    translate([0,0,0])cylinder(d=3,h=5);
  }
}

if (part=="Cap") cap();
if (part=="Rod") rod();
if (part=="OPTIONAL_servo_gauge") {
  difference() {
    translate([0,0,2.5])cube([70,10,5],center=true);
    for (i=[-3:1:3]) {
      translate([i*10,0,2])cylinder(d=5+i*0.25,h=4);
      translate([i*10,0,-1])cylinder(d=3,h=7);
      translate([i*10,-5,2.5])rotate([90,0,0])linear_extrude(2,center=true)text(str(5+i*0.25),size=2,halign="center",valign="center",font="OPTIEdgarBold\\-Extended:style=Bold");
    }
  }
}

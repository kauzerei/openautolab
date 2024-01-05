// Upper rail parts of OpenAutoLab: mounting brackets for valves, for pumps and for electronic enclosure
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
part = "Valve_bracket"; // [Valve_bracket, Main_pump_bracket, Filter_pump_type1_bracket, Filter_pump_type2_bracket, Filter_attachment, Enclosure_bracket, battery_bracket, battery_holder]
/* [Rail general parameters] */
rod_diameter=8;
rods_distance=62;

/* [mounts parameters] */
part_width=10;
part_thickness=3;
air_gap=1;
valve_offset=0;
pump_offset=5;
mount_hole=4;
mount_hole_distance=38;
pcb_angle=15;
pcb_holes_distance=81;
extra_room=7;

/* [Filter attachment options] */
filter_wall=6;
offset_v=20;
offset_h=12;
hole=9;

module whole() {
  translate([rods_distance/2,0,0])cylinder(d=rod_diameter+2*part_thickness, h=part_width, center=true);
  translate([-rods_distance/2,0,0])cylinder(d=rod_diameter+2*part_thickness, h=part_width, center=true);
  translate([0,valve_offset,0])cube([rods_distance-rod_diameter+2*part_thickness+2*air_gap,2*part_thickness+air_gap,part_width],center=true);
  translate([rods_distance/2-rod_diameter/2+air_gap/2,(valve_offset-part_thickness-air_gap/2)/2,0])cube([2*part_thickness+air_gap,valve_offset-part_thickness-air_gap/2,part_width],center=true);
  translate([-rods_distance/2+rod_diameter/2-air_gap/2,(valve_offset-part_thickness-air_gap/2)/2,0])cube([2*part_thickness+air_gap,valve_offset-part_thickness-air_gap/2,part_width],center=true);
}

module holes() {
  translate([rods_distance/2,0,0])cylinder(d=rod_diameter,h=part_width+2,center=true);
  translate([-rods_distance/2,0,0])cylinder(d=rod_diameter,h=part_width+2,center=true);
  translate([-mount_hole_distance/2,valve_offset,0])rotate([90,0,0])cylinder(d=mount_hole, h=2*part_thickness+air_gap+2, center=true);
   translate([mount_hole_distance/2,valve_offset,0])rotate([90,0,0])cylinder(d=mount_hole, h=2*part_thickness+air_gap+2, center=true);
}

module bigger() {
  difference(){
    whole();
    holes();
    cutter(air_gap);
  }
}

module smaller() {
  intersection(){
    difference(){
      whole();
      holes();
    }
    cutter(0);
  }
}

module cutter(gap) {
  translate([(rod_diameter-rods_distance)/2-gap,-rod_diameter/2-part_thickness,-part_width/2-1])cube([rods_distance-rod_diameter+2*gap,part_thickness+rod_diameter/2+valve_offset-air_gap/2+gap,part_width+2]);
  translate([-(rods_distance+rod_diameter+2*part_thickness)/2-1,-rod_diameter/2-part_thickness,-part_width/2-1])cube([rods_distance+rod_diameter+2*part_thickness+2,part_thickness+rod_diameter/2-air_gap/2+gap,part_width+2]);
  translate([rods_distance/2-rod_diameter/2,-rod_diameter/2-max(0,air_gap/2-valve_offset),-(part_width+2)/2])cube([rod_diameter/2,rod_diameter/2,part_width+2]);
  translate([-rods_distance/2,-rod_diameter/2-max(0,air_gap/2-valve_offset),-(part_width+2)/2])cube([rod_diameter/2,rod_diameter/2,part_width+2]);
}

module divider(gap) {
  translate([0,valve_offset-part_thickness-gap/2,0])cube([rods_distance-rod_diameter,2*part_thickness+air_gap,part_width],center=true);
  cube([rods_distance-rod_diameter,2*valve_offset,part_width],center=true);
}

module pumpholes() {
  translate([rods_distance/2,0,0])circle(d=rod_diameter);
  translate([-rods_distance/2,0,0])circle(d=rod_diameter);
  translate([0,10])rotate([0,0,-50]) {
    translate([31,0])circle(d=4);
    translate([-21,0])circle(d=4);
    translate([0,0])circle(d=34);
  }
}

module pump() {
  pumpmounts=[[21,0],[-31,0]];
  rodmounts=[[rods_distance/2,0],[-rods_distance/2,0]];
  shift=[-5,-6];
  rotation=140;
  pumpdiameter=34;
  difference() {
    union() {
      hull() {
        translate(shift)rotate([0,0,rotation])for (i=pumpmounts) translate(i)cylinder(h=part_width,d=mount_hole+2*part_thickness,center=true);
        for (i=rodmounts) translate(i)cylinder(h=part_width,d=rod_diameter+2*part_thickness,center=true);
        translate(shift)rotate([0,0,rotation])cylinder(h=part_width,d=pumpdiameter+2*part_thickness,center=true);
      }
      translate(shift)rotate([0,0,rotation])for (i=pumpmounts) translate(i)translate([0,0,pump_offset/2])cylinder(h=part_width+pump_offset,d=mount_hole+2*part_thickness,center=true);
    }
    translate(shift)rotate([0,0,rotation])for (i=pumpmounts) translate(i)cylinder(h=part_width+2*pump_offset+0.02,d=mount_hole,center=true);
    for (i=rodmounts) translate(i)cylinder(h=part_width+0.02,d=rod_diameter,center=true);
    translate(shift)rotate([0,0,rotation])cylinder(h=part_width+2*pump_offset+0.02,d=pumpdiameter,center=true);
    cube([2*rods_distance,air_gap,part_width+2],center=true);
    translate([20,0,0])rotate([90,0,0])cylinder (d=4,h=45,center=true);
  }
}

module pump_shape(type) {
  if (type==1) hull(){
    circle(d=34);
    translate([17,-9])circle(d=8);
    translate([17,9])circle(d=8);
    translate([-17,-9])circle(d=8);
    translate([-17,9])circle(d=8);
  }
  if (type==2) hull(){
    translate([14,-14])circle(d=8);
    translate([-14,-14])circle(d=8);
    translate([14,14])circle(d=8);
    translate([-14,14])circle(d=8);
  }
}

module filterpump(type) {
  difference() {
    linear_extrude(height=part_width,convexity=4)difference() {
      offset (r=part_thickness) hull() {
        pump_shape(type);
        translate([rods_distance/2,9])circle(d=rod_diameter);
        translate([-rods_distance/2,9])circle(d=rod_diameter);
      }
    pump_shape(type);
    translate([rods_distance/2,9])circle(d=rod_diameter);
    translate([-rods_distance/2,9])circle(d=rod_diameter);
    translate([0,9])square([2*rods_distance,1],center=true);
    }
  translate([rods_distance/2-rod_diameter/2-3,0,part_width/2])rotate([90,0,0])cylinder(d=4,h=rods_distance,center=true);
  translate([-rods_distance/2+rod_diameter/2+3,0,part_width/2])rotate([90,0,0])cylinder(d=4,h=rods_distance,center=true);
  }
}

module filter_attachment() {
  cube([part_thickness,2*hole,offset_v+part_thickness]);
  tail=min(20,offset_v+part_thickness);
  translate([-part_thickness-filter_wall,0,offset_v+part_thickness-tail])cube([part_thickness,2*hole,tail]);
  translate([-filter_wall,0,offset_v])cube([filter_wall,2*hole,part_thickness]);
  difference() {
    cube([offset_h+hole ,2*hole,part_thickness]);
    translate([offset_h,hole,part_thickness/2])cylinder(h=part_thickness+0.02,d=hole,center=true);
  }
}

module pcbholder(holes_distance) {
  difference() {
    linear_extrude(part_width,convexity=3){
      difference(){
        union() {
          hull() {
            circle(d=part_thickness*2+air_gap);
            rotate(pcb_angle)translate([-rods_distance,0])circle(d=part_thickness*2+air_gap);
          }
        translate([0,-part_thickness-air_gap/2])square([holes_distance+rod_diameter/2+part_thickness+2*extra_room,2*part_thickness+air_gap]);
        circle(d=part_thickness*2+air_gap+rod_diameter);
        rotate(pcb_angle)translate([-rods_distance,0])circle(d=part_thickness*2+air_gap+rod_diameter);
        }
        hull() {
          circle(d=air_gap);
          rotate(pcb_angle)translate([-rods_distance-rod_diameter-part_thickness,0])circle(d=air_gap);
          }
        translate([0,-air_gap/2])square([holes_distance+rod_diameter/2+part_thickness+2*extra_room,air_gap]);
        circle(d=rod_diameter+air_gap);
        rotate(pcb_angle)translate([-rods_distance,0])circle(d=rod_diameter+air_gap);
      }
    }
    translate([rod_diameter/2+part_thickness+extra_room,0,part_width/2])rotate([90,0,0])cylinder(d=mount_hole,h=2*part_thickness+2*air_gap,center=true);
    translate([holes_distance+rod_diameter/2+part_thickness+extra_room,0,part_width/2])rotate([90,0,0])cylinder(d=mount_hole,h=2*part_thickness+2*air_gap,center=true);
    rotate([0,0,pcb_angle])translate([-rods_distance/2-mount_hole_distance/2,0,part_width/2])rotate([90,0,0])cylinder(d=mount_hole,h=2*part_thickness+2*air_gap,center=true);
    rotate([0,0,pcb_angle])translate([-rods_distance/2+mount_hole_distance/2,0,part_width/2])rotate([90,0,0])cylinder(d=mount_hole,h=2*part_thickness+2*air_gap,center=true);
  }
}

module battery_holder() {
  difference() {
    union() {
      cube([76+part_thickness,23+part_thickness,78+part_thickness/2]);
      translate([-part_width,0,0])cube([76+part_thickness+2*part_width,part_thickness/2,78+part_thickness/2]);
    }
    translate([part_thickness/2,part_thickness/2,part_thickness/2+0.01]) cube([76,23,78]);
    for (tr=[[-part_width/2,-0.01,extra_room],
             [-part_width/2,-0.01,78-extra_room+part_thickness/2],
             [part_thickness+part_width/2+76,-0.01,extra_room],
             [part_thickness+part_width/2+76,-0.01,78-extra_room+part_thickness/2]])
      translate(tr)rotate([-90,0,0]) cylinder(d=mount_hole,h=part_thickness/2+0.02);
  }

}

if (part=="Valve_bracket") {
  bigger();
  smaller();
}
if (part=="Main_pump_bracket") pump();
if (part=="Filter_pump_type1_bracket") filterpump(1);
if (part=="Filter_pump_type2_bracket") filterpump(2);
if (part=="Filter_attachment") filter_attachment();
if (part=="Enclosure_bracket") pcbholder(pcb_holes_distance);
if (part=="battery_bracket") pcbholder(78-2*extra_room+part_thickness/2);
if (part=="battery_holder") battery_holder();

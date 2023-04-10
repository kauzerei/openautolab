part = "two_halves"; // [bigger,smaller,two_halves, main_pump_holder,filter_pump_holder]
rod_diameter=8;
rods_distance=62;
offset=8;
mount_hole=5;
mount_hole_distance=38;
part_width=10;
part_thickness=3;
air_gap=1;
$fn=$preview?32:64;
module whole(){
    translate([rods_distance/2,0,0])cylinder(d=rod_diameter+2*part_thickness, h=part_width, center=true);
             translate([-rods_distance/2,0,0])cylinder(d=rod_diameter+2*part_thickness, h=part_width, center=true);
     translate([0,offset,0])cube([rods_distance-rod_diameter+2*part_thickness+2*air_gap,2*part_thickness+air_gap,part_width],center=true);
       translate([rods_distance/2-rod_diameter/2+air_gap/2,(offset-part_thickness-air_gap/2)/2,0])cube([2*part_thickness+air_gap,offset-part_thickness-air_gap/2,part_width],center=true);
      translate([-rods_distance/2+rod_diameter/2-air_gap/2,(offset-part_thickness-air_gap/2)/2,0])cube([2*part_thickness+air_gap,offset-part_thickness-air_gap/2,part_width],center=true);
    }
module holes(){
    translate([rods_distance/2,0,0])cylinder(d=rod_diameter,h=part_width+2,center=true);
    translate([-rods_distance/2,0,0])cylinder(d=rod_diameter,h=part_width+2,center=true);
    translate([-mount_hole_distance/2,offset,0])rotate([90,0,0])cylinder(d=mount_hole, h=2*part_thickness+air_gap+2, center=true);         
             translate([mount_hole_distance/2,offset,0])rotate([90,0,0])cylinder(d=mount_hole, h=2*part_thickness+air_gap+2, center=true);
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
module cutter(gap){
    translate([(rod_diameter-rods_distance)/2-gap,-rod_diameter/2-part_thickness,-part_width/2-1])cube([rods_distance-rod_diameter+2*gap,part_thickness+rod_diameter/2+offset-air_gap/2+gap,part_width+2]);
    translate([-(rods_distance+rod_diameter+2*part_thickness)/2-1,-rod_diameter/2-part_thickness,-part_width/2-1])cube([rods_distance+rod_diameter+2*part_thickness+2,part_thickness+rod_diameter/2-air_gap/2+gap,part_width+2]);
    translate([rods_distance/2-rod_diameter/2,-rod_diameter/2-max(0,air_gap/2-offset),-(part_width+2)/2])cube([rod_diameter/2,rod_diameter/2,part_width+2]);
    translate([-rods_distance/2,-rod_diameter/2-max(0,air_gap/2-offset),-(part_width+2)/2])cube([rod_diameter/2,rod_diameter/2,part_width+2]);
}
module divider(gap)
{
    translate([0,offset-part_thickness-gap/2,0])cube([rods_distance-rod_diameter,2*part_thickness+air_gap,part_width],center=true);
    cube([rods_distance-rod_diameter,2*offset,part_width],center=true);
    }
module pumpholes(){
  translate([rods_distance/2,0,0])circle(d=rod_diameter);
  translate([-rods_distance/2,0,0])circle(d=rod_diameter);
  translate([0,10])rotate([0,0,-50]){
    translate([31,0])circle(d=4);
  translate([-21,0])circle(d=4);
  translate([0,0])circle(d=34);
    }
  }

module pump() {
  difference(){
    union(){
      linear_extrude(part_width)  offset(r=part_thickness+air_gap)translate([0,10])rotate([0,0,-50]){
    translate([31,0])circle(d=4);
  translate([-21,0])circle(d=4);
    }
 linear_extrude(part_width,center=true)hull()offset(r=part_thickness+air_gap)pumpholes();
    }
linear_extrude(2*part_width+2,center=true)offset(r=0)pumpholes();
    cube([2*rods_distance,air_gap,part_width+2],center=true);
    translate([30,12,0])rotate([90,0,-40])cylinder (d=4,h=30);
    translate([-20,8,0])rotate([90,0,-15])cylinder (d=4,h=20);
  }
}
module filterpump() {
  difference(){
    linear_extrude(part_width)difference(){
        offset (r=part_thickness) hull() {
      circle(d=34);
      translate([17,-9])circle(d=8);
      translate([17,9])circle(d=8);
      translate([-17,-9])circle(d=8);
      translate([-17,9])circle(d=8);
      translate([rods_distance/2,9])circle(d=rod_diameter);
      translate([-rods_distance/2,9])circle(d=rod_diameter);
    }
    hull() {
      circle(d=34);
      translate([17,-9])circle(d=8);
      translate([17,9])circle(d=8);
      translate([-17,-9])circle(d=8);
      translate([-17,9])circle(d=8);
    }
    translate([rods_distance/2,9])circle(d=rod_diameter);
    translate([-rods_distance/2,9])circle(d=rod_diameter);
    translate([0,9])square([2*rods_distance,1],center=true);
  }  
  translate([rods_distance/2-rod_diameter/2-3,0,part_width/2])rotate([90,0,0])cylinder(d=4,h=rods_distance,center=true);  
  translate([-rods_distance/2+rod_diameter/2+3,0,part_width/2])rotate([90,0,0])cylinder(d=4,h=rods_distance,center=true);
}}
if (part=="test") {
    difference(){whole();holes();}
}
if (part=="bigger") {
bigger();
}
if (part=="smaller") {
    smaller();
}
if (part=="two_halves")
{
    bigger();
    smaller();
    }
if (part=="main_pump_holder")
{
    pump();
    }
if (part=="filter_pump_holder")
{
    filterpump();
    }
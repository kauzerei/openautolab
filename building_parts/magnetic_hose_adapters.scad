// OpenSCAD Threads
// http://dkprojects.net/openscad-threads/
include <threads.scad>;
part = "Hollow_screw"; // [Hollow_screw, Main_body, Main_magnet_cover, Hose_adapter, Hose_sleeve,Magnetic_holder, Holder_magnet_cover,All]
screw_shape="Allen"; //[Allen,Square,Hexagonal]
adapter_shape="Round"; //[Round,Square,Hexagonal]
light_trap=false;
hose_inner_diameter=6;
hose_outer_diameter=9;
main_part_holes=7;
insert_diameter=8;
screw_diameter=8;
seal_length=8;
magnet_diameter=15;
magnet_height=5;
wall_between_magnets=1;
thread_pitch=3;
thread_expand=0.4;
adpter_inner_diameter=4;
screw_inner_diameter=4;
offset=0;
$fn= $preview ? 32 : 64;

module inner() {
  metric_thread(magnet_diameter+2*0.541*pitch-2* printer_tolerance,pitch,pitch*2);
    translate([0,0,6]){
        cylinder(6,(magnet_diameter+pitch+3+printer_tolerance)/2,(magnet_diameter+pitch+3+printer_tolerance)/2);}
}
module outer() {
  difference(){
    translate([0,0,-magnet_height-wall_thickness]){cylinder(magnet_height+pitch*2+wall_thickness,(magnet_diameter+pitch+3+printer_tolerance)/2,(magnet_diameter+pitch+3+printer_tolerance)/2);
  }
 translate([0,0,-magnet_height]){metric_thread(magnet_diameter+2*0.541*pitch+2* printer_tolerance,pitch,magnet_height+pitch*2,internal=true);}
  }
}
module hollow_screw(){}

module main_body(){
    difference(){
       union(){cylinder(d=main_part_holes+2*seal_length,h=seal_length+main_part_holes/2+hose_outer_diameter/2+2);
           translate([0,-hose_outer_diameter/2-2,0]) cube([seal_length+main_part_holes/2, hose_outer_diameter+4,seal_length+main_part_holes/2+hose_outer_diameter/2+2]);
 *          translate([0,0,seal_length+main_part_holes/2+hose_outer_diameter/2+2]) metric_thread(magnet_diameter+2*0.541*thread_pitch,thread_pitch,thread_pitch*2);
           }
        cylinder(d=main_part_holes,h=seal_length+main_part_holes/2);
           translate([0,0,seal_length+main_part_holes/2])rotate([0,90,0])cylinder(d=main_part_holes, h=seal_length+main_part_holes/2);
           translate([0,0,seal_length+main_part_holes/2])intersection(){cylinder(d=main_part_holes, h=main_part_holes,center=true);rotate([0,90,0])cylinder(d=main_part_holes, h=main_part_holes,center=true);}
    }

    }
module main_magnet_cover(){}
module hose_adapter(){}
module hose_sleeve(){}
module magnetic_holder(){}
module holder_magnet_cover(){}
if (part=="Hollow_screw") {
    hollow_screw();
}
if (part=="Main_body") {
    main_body();
}
if (part=="Main_magnet_cover") {
    main_magnet_cover();
}
if (part=="Hose_adapter") {
    hose_adapter();
}
if (part=="Hose_sleeve") {
    hose_sleeve();
}
if (part=="Magnetic_holder") {
    magnetic_holder();
}
if (part=="Holder_magnet_cover") {
    holder_magnet_cover();
}
if (part=="All") {
color("red")translate([10,0,0])hollow_screw();
color("green")translate([0,10,0])main_body();
color("blue")translate([0,0,10])main_magnet_cover();
hose_adapter();
hose_sleeve();
magnetic_holder();
holder_magnet_cover();
}
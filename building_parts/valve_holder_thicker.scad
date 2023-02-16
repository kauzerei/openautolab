part = "all"; // [bigger,smaller,all]
rod_diameter=8;
rods_distance=60;
offset=3;
mount_hole=5;
mount_hole_distance=24;
part_width=15;
part_thickness=2.5;
air_gap=1;
$fn=64;
module bigger(){
     difference(){
    union()
         {
             translate([rods_distance/2,0,0])cylinder(d=rod_diameter+4*part_thickness+2*air_gap, h=part_width, center=true);
             translate([-rods_distance/2,0,0])cylinder(d=rod_diameter+4*part_thickness+2*air_gap, h=part_width, center=true);
             translate([0,offset,0])cube([rods_distance-rod_diameter,2*part_thickness+air_gap,part_width],center=true);
             translate([rods_distance/2-rod_diameter/2-part_thickness-air_gap/2,(offset-part_thickness-air_gap/2)/2,0])cube([2*part_thickness+air_gap,offset-part_thickness-air_gap/2,part_width],center=true);
             translate([-rods_distance/2+rod_diameter/2+part_thickness+air_gap/2,(offset-part_thickness-air_gap/2)/2,0])cube([2*part_thickness+air_gap,offset-part_thickness-air_gap/2,part_width],center=true);
             }
             translate([rods_distance/2,0,0])cylinder(d=rod_diameter, h=part_width+2, center=true);
    translate([-mount_hole_distance/2,offset,0])rotate([90,0,0])cylinder(d=mount_hole, h=2*part_thickness+air_gap+2, center=true);         
             translate([mount_hole_distance/2,offset,0])rotate([90,0,0])cylinder(d=mount_hole, h=2*part_thickness+air_gap+2, center=true);
             translate([-rods_distance/2,0,0])cylinder(d=rod_diameter, h=part_width+2, center=true);
    cube([rods_distance-rod_diameter-2*part_thickness,2*offset+air_gap,part_width+2],center=true);
    translate([0,air_gap/2-(rod_diameter+4*part_thickness+2*air_gap)/2,0])cube([rods_distance+rod_diameter+4*part_thickness+2*air_gap+1,rod_diameter+4*part_thickness+2*air_gap,part_width+2],center=true);         
     }
}
module smaller(){
    intersection(){ 
    difference(){
    union()
         {
             translate([rods_distance/2,0,0])cylinder(d=rod_diameter+4*part_thickness+2*air_gap, h=part_width, center=true);
             translate([-rods_distance/2,0,0])cylinder(d=rod_diameter+4*part_thickness+2*air_gap, h=part_width, center=true);
             translate([0,offset,0])cube([rods_distance-rod_diameter,2*part_thickness+air_gap,part_width],center=true);
             translate([rods_distance/2-rod_diameter/2-part_thickness-air_gap/2,(offset-part_thickness-air_gap/2)/2,0])cube([2*part_thickness+air_gap,offset-part_thickness-air_gap/2,part_width],center=true);
             translate([-rods_distance/2+rod_diameter/2+part_thickness+air_gap/2,(offset-part_thickness-air_gap/2)/2,0])cube([2*part_thickness+air_gap,offset-part_thickness-air_gap/2,part_width],center=true);
             }
             translate([rods_distance/2,0,0])cylinder(d=rod_diameter, h=part_width+2, center=true);
             translate([-rods_distance/2,0,0])cylinder(d=rod_diameter, h=part_width+2, center=true);
             translate([-mount_hole_distance/2,offset,0])rotate([90,0,0])cylinder(d=mount_hole, h=2*part_thickness+air_gap+2, center=true);         
             translate([mount_hole_distance/2,offset,0])rotate([90,0,0])cylinder(d=mount_hole, h=2*part_thickness+air_gap+2, center=true);
     }
     union(){
     cube([rods_distance-rod_diameter-2*part_thickness-2*air_gap,2*offset-air_gap,part_width+2],center=true);
    translate([0,-air_gap/2-(rod_diameter+4*part_thickness+2*air_gap)/2,0])cube([rods_distance+rod_diameter+4*part_thickness+2*air_gap+1,rod_diameter+4*part_thickness+2*air_gap,part_width+2],center=true);
     }
 }
}
if (part=="bigger") {
    bigger();
}
if (part=="smaller") {
    smaller();
}
if (part=="all")
{
    bigger();
    smaller();
    }
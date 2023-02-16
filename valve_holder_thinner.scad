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
    
    /*
    cube([rods_distance-rod_diameter+air_gap-gap,(2*offset-gap),part_width+2],center=true);
    translate([0,(-rod_diameter/2-part_thickness-1-gap)/2,0])cube([rods_distance,rod_diameter/2+part_thickness+1,part_width+2],center=true);
    translate([0,-rod_diameter/2-part_thickness-gap/2,0])cube([rods_distance+rod_diameter+2*part_thickness+1,rod_diameter+2*part_thickness,part_width+2],center=true);
    */
    }
if (part=="test") {
    difference(){whole();holes();}
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
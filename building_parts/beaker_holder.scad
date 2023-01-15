// OpenSCAD Threads
// http://dkprojects.net/openscad-threads/
include <threads.scad>;
printer_tolerance=0.4; //[0.0:0.1:1.0]
magnet_diameter=15; //[3.0:1.0:30.0]
magnet_height=5; //[1.0:1.0:10.0]
wall_thickness=1.5; //[0.8:0.2:2]
part = "Inner"; // [Inner, Outer, Screw, Hose_holder]
pitch=3;//[1:1:5]
$fn= $preview ? 32 : 64;
module inner() {
  metric_thread(magnet_diameter+2*0.541*pitch-2* printer_tolerance,pitch,pitch*2);
    translate([0,0,6]){
        cylinder(6,(magnet_diameter+pitch+3+printer_tolerance)/2,(magnet_diameter+pitch+3+printer_tolerance)/2);}
}
module outer() {
  difference(){
    translate([0,0,-magnet_height-wall_thickness]){cylinder(magnet_height+pitch*2+wall_thickness,(magnet_diameter+pitch+3+printer_tolerance)/2,(magnet_diameter+pitch+3+printer_tolerance)/2);}
 translate([0,0,-magnet_height]){metric_thread(magnet_diameter+2*0.541*pitch+2* printer_tolerance,pitch,magnet_height+pitch*2,internal=true);}
  }
}
module screw() {

}
module hose_holder() {

}
if (part=="Inner") {
    inner(); 
}
else if (part=="Outer") {
    outer();
}
else if (part=="Screw") {
    screw();
}
else if (part=="Hose_holder") {
    hose_holder();
}
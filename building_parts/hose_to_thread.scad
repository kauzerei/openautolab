printer_tolerance=0.3; //[0.0:0.1:1.0]
part = "Inner"; // [Inner, Outer, Screw, Hose_holder]
pitch=3;//[1:1:5]
module inner() {
  metric_thread(magnet_diameter+2*0.541*pitch-2* printer_tolerance,pitch,pitch*2);
    translate([0,0,6]){
        cylinder(6,(magnet_diameter+pitch+3+printer_tolerance)/2,(magnet_diameter+pitch+3+printer_tolerance)/2);}
}
module outer() {
  difference(){
    translate([0,0,-magnet_height-1.5]){cylinder(magnet_height+pitch*2+1.5,(magnet_diameter+pitch+3+printer_tolerance)/2,(magnet_diameter+pitch+3+printer_tolerance)/2);}
 translate([0,0,-magnet_height]){metric_thread(magnet_diameter+2*0.541*pitch+2* printer_tolerance,pitch,magnet_height+pitch*2,internal=true);}
  }
}
if (part=="Inner") {
    inner(); 
}
else if (part=="Outer") {
    outer();
}
else if (part=="Both") {
    inner();
    outer(); 
}
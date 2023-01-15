part = "Inner"; // [Inner, Outer, Both]
outer_design = "Round"; // [Round, Square]
diameter_to_adapt=8;//[5:1:16]
length_to_adapt=8;//[5:1:16]
internal_diameter=4;//[2:1:10]
hose_id=6;//[2:1:10]
hose_od=9;//[4:1:12]
hose_hold_length=10;//[4:1:20]
$fn= $preview ? 32 : 64;
module inner() {
  difference(){
      cylinder(length_to_adapt,diameter_to_adapt/2,diameter_to_adapt/2);
      cylinder(length_to_adapt,internal_diameter/2,internal_diameter/2);}
  translate([0,0,length_to_adapt]) difference(){
      cylinder(2,hose_od/2,hose_od/2);
      cylinder(2,internal_diameter/2,internal_diameter/2);}
     translate([0,0,length_to_adapt+2]) difference(){
      cylinder(hose_hold_length,hose_id/2,hose_id/2);
      cylinder(hose_hold_length,internal_diameter/2,internal_diameter/2);}
}
module outer() {
    if (outer_design=="Round")
translate([0,0,length_to_adapt]) difference(){
      cylinder(2+hose_hold_length,(hose_od+4)/2,(hose_od+4)/2);
      cylinder(2+hose_hold_length,hose_od/2,hose_od/2);}
      else translate([0,0,length_to_adapt]) difference(){
      translate([0,0,(2+hose_hold_length)/2])cube(2+hose_hold_length,(hose_od+4)/2,(hose_od+4)/2,center=true);
      cylinder(2+hose_hold_length,hose_od/2,hose_od/2);}

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
$fn=64;
part="Cap"; //[Cap,Rod,all]
outer_diameter= 72;
outer_depth=20;
extra_lip_width=0.5;
extra_lip_height=2;
rod_diameter=11;
distance_to_coupling=73;
coupling_length=20;
coupling_width=2;
parts_thickness=1.5;
cutouts=20;
cut_width=1;
cut_depth=5;

module cap() {
  difference() {
    cylinder(d=outer_diameter+2*parts_thickness,h=outer_depth+parts_thickness);
    translate([0,0,parts_thickness])cylinder(d=outer_diameter,h=outer_depth-extra_lip_height);
    translate([0,0,parts_thickness+outer_depth-extra_lip_height-1])cylinder(d=outer_diameter-2*extra_lip_width,h=extra_lip_height+2);
    for (a=[0:360/cutouts:360-360/cutouts])rotate([0,0,a])translate([0,-outer_diameter/2-parts_thickness-1,-1])cube([cut_width,cut_depth+1,outer_depth+parts_thickness+2]);
  }
}
module rod() {
  intersection(){
    difference() {
    cylinder(d=rod_diameter,h=distance_to_coupling+coupling_length);
    translate([0,0,-1])cylinder(d=rod_diameter-2*parts_thickness,h=distance_to_coupling+coupling_length+2);
    hull(){translate([0,0,distance_to_coupling])rotate([90,0,0])cylinder(d=coupling_width,h=2+rod_diameter,center=true);
    translate([0,0,distance_to_coupling+coupling_length+2])rotate([90,0,0])cylinder(d=coupling_width,h=2+rod_diameter,center=true);}
//    translate([0,0,parts_thickness])cylinder(d=outer_diameter,h=outer_depth-extra_lip_height);
//    translate([0,0,parts_thickness+outer_depth-extra_lip_height-1])cylinder(d=outer_diameter-2*extra_lip_width,h=extra_lip_height+2);
  }
 hull(){translate([-rod_diameter/2,-rod_diameter/2,0])cube([rod_diameter,rod_diameter,distance_to_coupling+coupling_length-rod_diameter]);
  #translate([0,0,distance_to_coupling+coupling_length])rotate([90,0,90])cylinder(d=0.001,h=2+rod_diameter,center=true);}
}
}
if (part=="Cap") {
  cap();
  }
  if (part=="Rod") {
  rod();
  }
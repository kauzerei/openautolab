$fn= $preview ? 32 : 64;
part="Cap"; //[Cap,Rod,OPTIONAL_servo_gauge,all]
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
module quarter_rotation(width=10,height=10) {
  intersection() {
    linear_extrude(height = height, convexity = 10, twist = 90, slices = 10, $fn = 16) {
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
    translate([0,0,parts_thickness])cylinder(d=outer_diameter,h=outer_depth-extra_lip_height);
    translate([0,0,parts_thickness+outer_depth-extra_lip_height-1])cylinder(d=outer_diameter-2*extra_lip_width,h=extra_lip_height+2);
    for (a=[0:360/cutouts:360-360/cutouts])rotate([0,0,a])translate([0,-outer_diameter/2-parts_thickness-1,-1])cube([cut_width,cut_depth+1,outer_depth+parts_thickness+2]);
  }
}
module rod() {
    difference() {
    cylinder(d=rod_diameter,h=distance_to_coupling+coupling_length);
    translate([0,0,-1])cylinder(d=rod_diameter-2*parts_thickness,h=distance_to_coupling+coupling_length+2);
    hull(){translate([0,0,distance_to_coupling])rotate([90,0,0])cylinder(d=coupling_width,h=2+rod_diameter,center=true);
    translate([0,0,distance_to_coupling+coupling_length+2])rotate([90,0,0])cylinder(d=coupling_width,h=2+rod_diameter,center=true);}
    translate([0,0,distance_to_coupling+coupling_length/2])four_quarters(rod_diameter+2,coupling_length/2);
    }
  }
if (part=="Cap") {
  cap();
  }
  if (part=="Rod") {
  rod();
  }
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
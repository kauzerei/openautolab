// Liquid management parts for OpenAutoLab

// This project uses
// OpenSCAD Threads
// http://dkprojects.net/openscad-threads/
include <threads.scad>;
part = "Hollow_screw"; // [Hollow_screw, Main_body, Main_magnet_cover, Hose_adapter, Hose_sleeve,Magnetic_holder, Holder_magnet_cover,Weight_gauge_mount,OPTIONAL_Tapping_tool,OPTIONAL_Threading_tool,OPTIONAL_adapter_wrench,OPTIONAL_hollow_screw_wrench]

/* [Main body options] */
light_trap=false;
main_part_holes=7;
seal_length=8;
offset=20;

/* [Printed thread and magnet options] */
thread_pitch=3;
thread_expand=2.0;
magnet_diameter=15;
magnet_height=5;
wall_between_magnets=1;

/* [Hose adapter and hollow screw options] */
screw_shape="Hexagonal"; //[Allen,Hexagonal,Square]
adapter_shape="Hexagonal"; //[Round,Square,Hexagonal]
hose_inner_diameter=6;
hose_outer_diameter=9;
insert_diameter=8;
screw_diameter=8;
adapter_inner_diameter=4;
screw_inner_diameter=4;

/* [Magnetic holder options] */
rod_mount=false;
nut_width=16;
mount_hole=8;
weight_gauge_mount=false;

/* [Weight gauge measurements] */
wg_hole_size=4;
wg_hole_distance=15;
wg_ms_hole_size=6;
wg_ms_hole_distance=15;
wg_height=13;
wg_width=13;


/* [Thread cutting helpers options] */
onside=false;
leader_length=5;
tap_length=22;
leader_diameter=7;
tap_diameter=10;
air_gap=0.5;
holding_depth=3;
die_diameter=25;
die_height=9;
handle_length=50;
handle_thickness=10;

$fn= $preview ? 32 : 64;
degre=onside?90:0;
shape=(adapter_shape=="Round")?64:(adapter_shape=="Square")?4:6;
coeff=  (adapter_shape == "Round") ? 1:(adapter_shape == "Square") ? 1.42:1.16;
shiftx=light_trap?-(max(offset+(magnet_diameter+2*0.541*thread_pitch)/2,2.5*main_part_holes+seal_length)):-(seal_length+main_part_holes/2);
shiftz=light_trap?coeff*(hose_outer_diameter+4)/2:seal_length+main_part_holes/2;
shift=onside?shiftz:shiftx;
instrument_length=leader_length+tap_length+holding_depth;
diameter_to_hold=magnet_diameter+2*0.541*thread_pitch+thread_expand+3;
height_to_hold=magnet_height+thread_pitch*2+wall_between_magnets;
dbr=1+3+diameter_to_hold+2*0.541*thread_pitch+thread_expand+nut_width;

module hollow_screw(){
  difference(){
    union(){
      cylinder(h=1.5,d=(screw_shape=="Hexagonal")?(screw_diameter+4)*1.16:(screw_shape=="Square")?(screw_diameter+4)*1.42:screw_diameter+4,$fn=(screw_shape=="Hexagonal")?6:(screw_shape=="Square")?4:32);
      translate([0,0,1.5])cylinder(h=seal_length+4,d=screw_diameter);}
      cylinder(d=screw_inner_diameter,h=seal_length+6);
      cylinder(seal_length*0.7,screw_inner_diameter*0.6,screw_inner_diameter*0.5, $fn=6);
    }
  }

module main_body(nothread=false){
  if (light_trap==false) translate([shiftx,0,0])difference(){
    union(){
      cylinder(d=max(main_part_holes+2*seal_length,magnet_diameter+2*0.541*thread_pitch),h=seal_length+main_part_holes/2+hose_outer_diameter/2+2);
      translate([0,-hose_outer_diameter/2-2,0]) cube([seal_length+main_part_holes/2, hose_outer_diameter+4,seal_length+main_part_holes/2+hose_outer_diameter/2+2]);
      translate([0,0,seal_length+main_part_holes/2+hose_outer_diameter/2+2]) metric_thread(magnet_diameter+2*0.541*thread_pitch,thread_pitch,thread_pitch*2,test=nothread);
    }
    translate([0,0,-1])cylinder(d=main_part_holes,h=seal_length+main_part_holes/2+1);
    translate([0,0,seal_length+main_part_holes/2])rotate([0,90,0])cylinder(d=main_part_holes, h=seal_length+main_part_holes/2+1);
    translate([0,0,seal_length+main_part_holes/2])intersection(){cylinder(d=main_part_holes, h=main_part_holes,center=true);rotate([0,90,0])cylinder(d=main_part_holes, h=main_part_holes,center=true);}
  }
  else translate([shiftx,0,0])difference(){
    union(){
      cylinder(d=hose_outer_diameter+4,h=(hose_outer_diameter/2+4)*coeff+2*main_part_holes+2);
      translate([offset,0,0])cylinder(d=magnet_diameter+2*0.541*thread_pitch,h=(hose_outer_diameter/2+4)*coeff+2*main_part_holes+2);
      translate([0,-hose_outer_diameter/2-2,0]) cube([max(offset+(magnet_diameter+2*0.542*thread_pitch)/2,2.5*main_part_holes+seal_length),hose_outer_diameter+4,(hose_outer_diameter/2+4)*coeff+2*main_part_holes+2]);
      translate([offset,0,(hose_outer_diameter/2+4)*coeff+2*main_part_holes+2]) metric_thread(magnet_diameter+2*0.541*thread_pitch,thread_pitch,thread_pitch*2,test=nothread);
    }
    translate([0,0,-1])cylinder(d=main_part_holes,h=coeff*(hose_outer_diameter+4)/2+2*main_part_holes+1);
    translate([0,0,coeff*(hose_outer_diameter+4)/2+2*main_part_holes])rotate([0,90,0])cylinder(d=main_part_holes,h=2*main_part_holes);
    translate([2*main_part_holes,0,coeff*(hose_outer_diameter+4)/2])cylinder(d=main_part_holes,h=2*main_part_holes);
    translate([2*main_part_holes,0,coeff*(hose_outer_diameter+4)/2])rotate([0,90,0])cylinder(d=main_part_holes,h=offset+magnet_diameter/2+0.541*thread_pitch+seal_length);
    translate([0,0,coeff*(hose_outer_diameter+4)/2+2*main_part_holes])intersection(){cylinder(d=main_part_holes, h=main_part_holes,center=true);rotate([0,90,0])cylinder(d=main_part_holes, h=main_part_holes,center=true);}
    translate([2*main_part_holes,0,coeff*(hose_outer_diameter+4)/2+2*main_part_holes])intersection(){cylinder(d=main_part_holes, h=main_part_holes,center=true);rotate([0,90,0])cylinder(d=main_part_holes, h=main_part_holes,center=true);}
    translate([2*main_part_holes,0,coeff*(hose_outer_diameter+4)/2])intersection(){cylinder(d=main_part_holes, h=main_part_holes,center=true);rotate([0,90,0])cylinder(d=main_part_holes, h=main_part_holes,center=true);}
  }
}

module main_magnet_cover(nothread=false){
  difference(){
    cylinder(d=magnet_diameter+2*0.541*thread_pitch+thread_expand+3,h=magnet_height+thread_pitch*2+wall_between_magnets);
    translate([0,0,wall_between_magnets]){metric_thread(magnet_diameter+2*0.541*thread_pitch+thread_expand,thread_pitch,magnet_height+thread_pitch*2,internal=true,test=nothread);}
  }
}

module hose_adapter(){
  difference(){
    union(){
      cylinder(h=seal_length,d=insert_diameter);
      translate([0,0,seal_length])cylinder(h=4,d=(hose_outer_diameter+1)*coeff,$fn=shape);
      translate([0,0,seal_length+4])cylinder(h=seal_length,d=hose_inner_diameter);
    }
    cylinder(d=adapter_inner_diameter,h=4+2*seal_length);
  }
}

module hose_sleeve(){
  difference(){
    cylinder(h=seal_length+4,d=coeff*(hose_outer_diameter+4),$fn=shape);
    cylinder(h=seal_length+4,d=hose_outer_diameter);
    translate([0,0,seal_length])cylinder(h=4,d=(hose_outer_diameter+2)*coeff,$fn=shape);
  }
}

module holder_magnet_cover(nothread=false){
  difference(){
    metric_thread(1+3+diameter_to_hold+2*0.541*thread_pitch,thread_pitch,height_to_hold+wall_between_magnets,test=nothread);
    translate([0,0,wall_between_magnets])cylinder(d=diameter_to_hold+1,h=height_to_hold);
    translate([0,0,height_to_hold+wall_between_magnets-1])cube([2,6+diameter_to_hold+2*0.541*thread_pitch,2],center=true);
  }
}

module magnetic_holder(nothread=false){
  difference(){
    union(){
      cylinder(h=2+magnet_height+wall_between_magnets+height_to_hold, d=1+3+diameter_to_hold+2*0.541*thread_pitch+thread_expand+3);
      if(rod_mount) translate([0,0,min(nut_width,2+magnet_height+wall_between_magnets+height_to_hold)/2]) cube([1+3+diameter_to_hold+2*0.541*thread_pitch+thread_expand+2*nut_width,nut_width,min(nut_width,2+magnet_height+wall_between_magnets+height_to_hold)],center=true);
    }
    translate([0,0,2])cylinder(h=magnet_height,d=magnet_diameter+2);
    translate([0,0,2+magnet_height])metric_thread(1+3+diameter_to_hold+2*0.541*thread_pitch+thread_expand,thread_pitch,height_to_hold+wall_between_magnets,internal=true,test=nothread);
    translate([-(1+3+diameter_to_hold+2*0.541*thread_pitch+thread_expand+nut_width)/2,0,nut_width/2])rotate([90,0,0])cylinder(h=nut_width+2,d=mount_hole,center=true);
    translate([(1+3+diameter_to_hold+2*0.541*thread_pitch+thread_expand+nut_width)/2,0,nut_width/2])rotate([90,0,0])cylinder(h=nut_width+2,d=mount_hole,center=true);
  }
  if (weight_gauge_mount) {
    difference(){
      translate([0,0,-wg_height-2])cylinder(h=wg_height+2,d=1+3+diameter_to_hold+2*0.541*thread_pitch+thread_expand+3);
      translate([0,0,-wg_height/2])cube([wg_width,1+3+diameter_to_hold+2*0.541*thread_pitch+thread_expand+3+1,wg_height], center=true);
      translate([0,wg_hole_distance/2,-wg_height])cylinder(d=wg_hole_size,h=6,center=true);
      translate([0,-wg_hole_distance/2,-wg_height])cylinder(d=wg_hole_size,h=6,center=true);
    }
  }
}

module wg_holder() {
  difference() {
    union() {
      cube([wg_ms_hole_distance+wg_width,dbr,nut_width],center=true);
      translate([0,dbr/2,0])rotate([0,90,0])cylinder(d=nut_width, h=wg_ms_hole_distance+wg_width, center=true);
      translate([0,-dbr/2,0])rotate([0,90,0])cylinder(d=nut_width, h=wg_ms_hole_distance+wg_width, center=true);
    }
    translate([0,dbr/2,0])rotate([0,90,0])cylinder(d=mount_hole, h=wg_ms_hole_distance+wg_width+2, center=true);
    translate([0,-dbr/2,0])rotate([0,90,0])cylinder(d=mount_hole, h=wg_ms_hole_distance+wg_width+2, center=true);
    translate([wg_ms_hole_distance/2,0,0])cylinder(h=nut_width+2,d=wg_ms_hole_size, center=true);
    translate([-wg_ms_hole_distance/2,0,0])cylinder(h=nut_width+2,d=wg_ms_hole_size,center=true);
    translate([0,0,-nut_width/4-0.5])cube([wg_ms_hole_distance+wg_width+2,dbr+nut_width+2,nut_width/2+1],center=true);
  }
}

module instrument(){
  difference(){
    linear_extrude(instrument_length)minkowski(){
      projection(cut=true)rotate([0,degre,0])main_body(nothread=true);
      circle(air_gap+holding_depth);
    }
    translate([0,0,instrument_length-holding_depth])minkowski(){
      cube(2*air_gap,center=true);
      intersection(){
        rotate([0,degre,0])main_body(nothread=true);
        cylinder(d=500,h=holding_depth);
      }
    }
    translate([shift,0,0]){
      translate([0,0,-1])cylinder(d=leader_diameter,h=leader_length+2);
      translate([0,0,leader_length])cylinder(d=tap_diameter,h=instrument_length);
      if(!onside)translate([(3+tap_diameter/2),0,4])rotate([90,0,0])cylinder(d=4,h=500,center=true);
    }
  }
}

module dieholder(){
  difference(){
   union(){
     translate([0,0,handle_thickness/2])cube([handle_thickness,handle_length,handle_thickness],center=true);
     translate([0,handle_length/2,0])cylinder(h=handle_thickness,d=handle_thickness);
     translate([0,-handle_length/2,0])cylinder(h=handle_thickness,d=handle_thickness);
     cylinder(h=die_height+10,d=die_diameter+2*holding_depth);}
    translate([0,0,10])cylinder(d=die_diameter,h=die_height+1);
    translate([0,0,5])cylinder(d=die_diameter-2*holding_depth,h=6); 
    translate([0,0,-1])cylinder(h=7,d=screw_inner_diameter);
    translate([0,0,10+die_height/2])rotate([0,90,0])cylinder(d=3,h=die_diameter+holding_depth*2+2,center=true);
  }
  rotate([0,0,45])translate([0,die_diameter/2,10])cylinder(d=2,h=die_height);
}

module wrench(){
  difference(){
   union(){
     translate([0,0,handle_thickness/2])cube([handle_thickness,handle_length,handle_thickness],center=true);
     translate([0,handle_length/2,0])cylinder(h=handle_thickness,d=handle_thickness);
     translate([0,-handle_length/2,0])cylinder(h=handle_thickness,d=handle_thickness);
     cylinder(h=die_height+10,d=die_diameter+2*holding_depth);}
  }
}

module hswrench() {
  difference() {
    union(){
      translate([0,0,handle_thickness/2])cube([handle_thickness,handle_length,handle_thickness],center=true);
      translate([0,handle_length/2,0])cylinder(h=handle_thickness,d=handle_thickness);
      translate([0,-handle_length/2,0])cylinder(h=handle_thickness,d=handle_thickness);
      cylinder(h=seal_length+6+2+2,d=die_diameter+2*holding_depth);
    }
    linear_extrude(seal_length+6)minkowski() {
      projection(cut=true)hollow_screw();
      circle(air_gap);
    }
    translate([0,0,seal_length+6+2])linear_extrude(2)minkowski() {
      projection(cut=true)hollow_screw();
      circle(air_gap);
    }
    cylinder(h=seal_length+6+2+2,d=screw_inner_diameter);
  }
}

module hawrench() {
  difference() {
    union(){
      translate([0,0,handle_thickness/2])cube([handle_thickness,handle_length,handle_thickness],center=true);
      translate([0,handle_length/2,0])cylinder(h=handle_thickness,d=handle_thickness);
      translate([0,-handle_length/2,0])cylinder(h=handle_thickness,d=handle_thickness);
      cylinder(h=seal_length+6+2+2,d=die_diameter+2*holding_depth);
    }
    linear_extrude(seal_length+6)minkowski() {
      projection(cut=true)translate([0,0,-seal_length])hose_adapter();
      circle(air_gap);
    }
    translate([0,0,seal_length+6])linear_extrude(2)minkowski() {
      projection(cut=true)translate([0,0,-seal_length-4.1])hose_adapter();
      circle(air_gap);
    }
    translate([0,0,seal_length+6+2])linear_extrude(2)minkowski() {
      projection(cut=true)translate([0,0,-seal_length])hose_adapter();
      circle(air_gap);
    }
    cylinder(h=seal_length+6+2+2,d=insert_diameter);
  }
}

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
if (part=="Weight_gauge_mount") {
  rotate([0,90,0])wg_holder();
}
if (part=="OPTIONAL_Tapping_tool") {
  instrument();
}
if (part=="OPTIONAL_Threading_tool") {
  dieholder();
}
if (part=="OPTIONAL_hollow_screw_wrench") {
  hswrench();    
}
if (part=="OPTIONAL_adapter_wrench") {
  hawrench();    
}
echo(str("distance between rods ",(1+3+diameter_to_hold+2*0.541*thread_pitch+thread_expand+nut_width)));

// Lower rail parts for OpenAutoLab: magnetic holders, hose connections, supports, helper tools, etc
//
// Copyright (c) 2023-2024 Kauzerei <mailto:openautolab@kauzerei.de>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.
//
// This project uses threads-scad
// https://github.com/rcolyer/threads-scad
use <threads.scad>;

$fs=0.5/1;
$fa=1/1;
part = "Interface"; // [Interface, Interface_cover, Magnetic_holder, Magnetic_holder_cover, Weight_gauge_bracket, Hose_adapter, Hose_sleeve, Hollow_screw, Filter_support, OPTIONAL_tapping_tool, OPTIONAL_threading_tool, OPTIONAL_wrench]
cut_view=false;
override_dbr=false;
rod_diameter=8;
distance_between_rods=24;
air_gap=0.50;

/* [Interface options] */
light_trap=false;
main_part_holes=7;
seal_length=8;
hor_wall=3;
offset=17;

/* [Printed thread and magnet options] */
thread_pitch=3;
thread_expand=1.5;
magnet_diameter=12;
magnet_height=2;
wall_between_magnets=0.4;
wall=1.5;

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
rod_mount=true;
nut_width=16;
mount_hole=rod_diameter+1*air_gap;
weight_gauge_mount = !rod_mount;

/* [Weight gauge measurements] */
wg_hole_size=4;
wg_hole_distance=15;
wg_ms_hole_size=6;
wg_ms_hole_distance=15;
wg_height=13.5;
wg_width=13.5;

/* [Helper tools options] */
onside=false;
leader_length=5;
tap_length=22;
leader_diameter=7;
tap_diameter=10;
holding_depth=3;
die_diameter=25.5;
die_height=9;
handle_length=50;
handle_thickness=10;
rounded_handle=false;
degre=onside?90:0;
shape=(adapter_shape=="Round")?64:(adapter_shape=="Square")?4:6;
coeff=  (adapter_shape == "Round") ? 1:(adapter_shape == "Square") ? 1.42:1.16;
shiftx=light_trap?-(max(offset+(magnet_diameter+2*0.541*thread_pitch)/2,2.5*main_part_holes+seal_length)):-(seal_length+main_part_holes/2);
shiftz=light_trap?coeff*(hose_outer_diameter+4)/2:seal_length+main_part_holes/2;
shift=onside?shiftz:shiftx;
instrument_length=leader_length+tap_length+holding_depth;
height_to_hold=magnet_height+thread_pitch*2+wall_between_magnets;

//calculating threads and cylinder diameters that fit nicely
thread_add=2*thread_pitch*cos(30);
thread1=magnet_diameter+thread_add-2*thread_expand+2*air_gap;
thread2=thread1+2*thread_expand;
cyl1=thread2+2*wall;
cyl2=cyl1+2*air_gap;
thread3= cyl2+2*wall+thread_add;
thread4=thread3+2*thread_expand;
cyl3=thread4+2*wall;
dbr=override_dbr?distance_between_rods:thread4+2*wall+mount_hole;
holeh=(dbr<magnet_diameter+2*air_gap+2*wall+mount_hole)?-mount_hole/2:
      (dbr<thread4+2*wall+mount_hole)?-mount_hole/2+magnet_height:
      min(nut_width/2,hor_wall+magnet_height+wall_between_magnets+height_to_hold-nut_width/2);
echo(dbr);

module hollow_screw() {
  difference() {
    union() {
      cylinder(h=1.5,d=(screw_shape=="Hexagonal")?(screw_diameter+4)*1.16:(screw_shape=="Square")?(screw_diameter+4)*1.42:screw_diameter+4,$fn=(screw_shape=="Hexagonal")?6:(screw_shape=="Square")?4:32);
      translate([0,0,1.5])cylinder(h=seal_length+4,d=screw_diameter);
    }
    cylinder(d=screw_inner_diameter,h=seal_length+6);
    translate([0,0,-0.01])cylinder(seal_length*0.7,screw_inner_diameter*0.6,screw_inner_diameter*0.5, $fn=6);
  }
}

module supports() {
  sl=-holeh+hor_wall+magnet_height+wall_between_magnets+height_to_hold+seal_length+main_part_holes/2+coeff*(hose_outer_diameter+4)/2;
  difference() {
    cube([dbr+nut_width,nut_width/2,sl+nut_width/2]);
    hull() {
      translate([nut_width/2,-0.01,0])rotate([-90,0,0])cylinder(h=nut_width/2+0.02,d=mount_hole);
      translate([nut_width/2,-0.01,nut_width/2])rotate([-90,0,0])cylinder(h=nut_width/2+0.02,d=mount_hole);
    }
    hull() {
      translate([dbr+nut_width/2,-0.01,nut_width/2])rotate([-90,0,0])cylinder(h=nut_width/2+0.02,d=mount_hole);
      translate([dbr+nut_width/2,-0.01,0])rotate([-90,0,0])cylinder(h=nut_width/2+0.02,d=mount_hole);
    }
  }
}

module main_body(nothread=false){
  if (light_trap==false) difference() {
    union() {
      cylinder(d=max(main_part_holes+2*seal_length,cyl1),h=seal_length+main_part_holes/2+coeff*(hose_outer_diameter+4)/2);
      translate([0,-hose_outer_diameter/2-2,0]) cube([max(seal_length+main_part_holes/2,cyl1/2), hose_outer_diameter+4,seal_length+main_part_holes/2+coeff*(hose_outer_diameter+4)/2]);
      translate([0,0,seal_length+main_part_holes/2+coeff*(hose_outer_diameter+4)/2]) ScrewThread(outer_diam=thread1,pitch=thread_pitch,height=thread_pitch*2);
      if(nothread) translate([0,0,seal_length+main_part_holes/2+hose_outer_diameter/2+2]) cylinder(d=thread1+0.01,h=thread_pitch*2);
    }
    translate([0,0,-1])cylinder(d=main_part_holes,h=seal_length+main_part_holes/2+1);
    translate([0,0,seal_length+main_part_holes/2])rotate([0,90,0])cylinder(d=main_part_holes, h=max(cyl1/2,seal_length+main_part_holes/2)+1);
    translate([0,0,seal_length+main_part_holes/2])intersection(){cylinder(d=main_part_holes, h=main_part_holes,center=true);rotate([0,90,0])cylinder(d=main_part_holes, h=main_part_holes,center=true);}
  }
  else difference() {
    union() {
      cylinder(d1=cyl1,d2=hose_outer_diameter+4,h=coeff*(hose_outer_diameter+4)/2+1.5*main_part_holes+seal_length+hor_wall);
      translate([offset,0,0])cylinder(d1=0,d2=cyl1,h=coeff*(hose_outer_diameter+4)/2+1.5*main_part_holes+seal_length+hor_wall);
      translate([0,-hose_outer_diameter/2-2,0]) cube([max(offset+cyl1/2,2.5*main_part_holes+seal_length),hose_outer_diameter+4,coeff*(hose_outer_diameter+4)/2+1.5*main_part_holes+seal_length+hor_wall]);
      translate([offset,0,coeff*(hose_outer_diameter+4)/2+1.5*main_part_holes+seal_length+hor_wall]) ScrewThread(outer_diam=thread1,pitch=thread_pitch,height=thread_pitch*2);
      if(nothread)translate([offset,0,coeff*(hose_outer_diameter+4)/2+1.5*main_part_holes+seal_length+hor_wall]) cylinder(d=thread1+0.01,h=thread_pitch*2);
    }
    translate([0,0,-1])cylinder(d=main_part_holes,h=coeff*(hose_outer_diameter+4)/2+main_part_holes+seal_length+1);
    translate([0,0,coeff*(hose_outer_diameter+4)/2+main_part_holes+seal_length])rotate([0,90,0])cylinder(d=main_part_holes,h=2*main_part_holes);
    translate([2*main_part_holes,0,coeff*(hose_outer_diameter+4)/2])cylinder(d=main_part_holes,h=main_part_holes+seal_length);
    translate([2*main_part_holes,0,coeff*(hose_outer_diameter+4)/2])rotate([0,90,0])cylinder(d=main_part_holes,h=offset+magnet_diameter/2+0.541*thread_pitch+seal_length);
    translate([0,0,coeff*(hose_outer_diameter+4)/2+main_part_holes+seal_length])intersection(){cylinder(d=main_part_holes, h=main_part_holes,center=true);rotate([0,90,0])cylinder(d=main_part_holes, h=main_part_holes,center=true);}
    translate([2*main_part_holes,0,coeff*(hose_outer_diameter+4)/2+main_part_holes+seal_length])intersection(){cylinder(d=main_part_holes, h=main_part_holes,center=true);rotate([0,90,0])cylinder(d=main_part_holes, h=main_part_holes,center=true);}
    translate([2*main_part_holes,0,coeff*(hose_outer_diameter+4)/2])intersection(){cylinder(d=main_part_holes, h=main_part_holes,center=true);rotate([0,90,0])cylinder(d=main_part_holes, h=main_part_holes,center=true);}
  }
}

module main_magnet_cover() {
  difference() {
    cylinder(d=cyl1,h=magnet_height+thread_pitch*2+wall_between_magnets);
    translate([0,0,wall_between_magnets]){ScrewThread(outer_diam=thread2,pitch=thread_pitch,height=magnet_height+thread_pitch*2+0.01);}
  }
}

module hose_adapter() {
  difference() {
    union() {
      cylinder(h=seal_length,d=insert_diameter);
      translate([0,0,seal_length])cylinder(h=4,d=(hose_outer_diameter+1)*coeff,$fn=shape);
      translate([0,0,seal_length+4])cylinder(h=seal_length,d=hose_inner_diameter);
    }
    translate([0,0,-0.01])cylinder(d=adapter_inner_diameter,h=4+2*seal_length+0.02);
  }
}

module hose_sleeve() {
  difference() {
    cylinder(h=seal_length+4,d=coeff*(hose_outer_diameter+4),$fn=shape);
    translate([0,0,-0.01])cylinder(h=seal_length+4,d=hose_outer_diameter);
    translate([0,0,seal_length])cylinder(h=4+0.01,d=(hose_outer_diameter+2)*coeff,$fn=shape);
  }
}

module holder_magnet_cover() {
  difference() {
    ScrewThread(outer_diam=thread3,pitch=thread_pitch,height=height_to_hold+wall_between_magnets);
    translate([0,0,wall_between_magnets])cylinder(d=cyl2,h=height_to_hold+0.01);
    translate([0,0,height_to_hold+wall_between_magnets-1])cube([2,thread3+0.01,2.01],center=true);
  }
}

module magnetic_holder() {
  cubew=max(10,2*((cyl3/2)^2-(max(dbr,nut_width)/2-nut_width/2)^2)^0.5);
  difference() {
    union() {
      cylinder(h=hor_wall+magnet_height+wall_between_magnets+height_to_hold, d=cyl3);
      if(rod_mount) {
        translate([0,0,holeh])cube([dbr+nut_width,cubew,nut_width],center=true);
        translate([0,0,-nut_width/2+holeh])cylinder(d=cyl3,h=nut_width/2-holeh);
      }
    }
    translate([0,0,hor_wall])cylinder(h=magnet_height+0.01,d=magnet_diameter+2*air_gap);
    translate([0,0,hor_wall+magnet_height])ScrewThread(outer_diam=thread4,pitch=thread_pitch,height=height_to_hold+wall_between_magnets+0.01);
    if(rod_mount) {
      translate([dbr/2,0,holeh])rotate([90,0,0])cylinder(h=cyl3+0.01,d=mount_hole,center=true);
      translate([-dbr/2,0,holeh])rotate([90,0,0])cylinder(h=cyl3+0.01,d=mount_hole,center=true);
      }
  }
  if (weight_gauge_mount) {
    difference() {
      translate([0,0,-wg_height-wall])cylinder(h=wg_height+wall,d=cyl3);
      translate([0,0,-wg_height/2])cube([wg_width,cyl3+0.01,wg_height], center=true);
      translate([0,wg_hole_distance/2,-wg_height])cylinder(d=wg_hole_size,h=6,center=true);
      translate([0,-wg_hole_distance/2,-wg_height])cylinder(d=wg_hole_size,h=6,center=true);
    }
  }
}

module wg_holder() {
  wgh_h=wg_ms_hole_distance+wg_width;
  difference() {
    union() {
      cube([wgh_h,dbr,nut_width],center=true);
      translate([0,dbr/2,0])rotate([0,90,0])cylinder(d=nut_width, h=wgh_h, center=true);
      translate([0,-dbr/2,0])rotate([0,90,0])cylinder(d=nut_width, h=wgh_h, center=true);
    }
    translate([0,dbr/2,0])rotate([0,90,0])cylinder(d=mount_hole, h=wg_ms_hole_distance+wg_width+2, center=true);
    translate([0,-dbr/2,0])rotate([0,90,0])cylinder(d=mount_hole, h=wg_ms_hole_distance+wg_width+2, center=true);
   hull() {
     translate([wg_ms_hole_distance/2,(dbr-nut_width-wg_ms_hole_size)/2,0])cylinder(h=nut_width+2,d=wg_ms_hole_size, center=true);
     translate([wg_ms_hole_distance/2,-(dbr-nut_width-wg_ms_hole_size)/2,0])cylinder(h=nut_width+2,d=wg_ms_hole_size, center=true);
     }
    hull() {
     translate([-wg_ms_hole_distance/2,(dbr-nut_width-wg_ms_hole_size)/2,0])cylinder(h=nut_width+2,d=wg_ms_hole_size, center=true);
     translate([-wg_ms_hole_distance/2,-(dbr-nut_width-wg_ms_hole_size)/2,0])cylinder(h=nut_width+2,d=wg_ms_hole_size, center=true);
     }
    translate([0,0,-nut_width/4-0.5])cube([wg_ms_hole_distance+wg_width+2,dbr+nut_width+2,nut_width/2+1],center=true);
  }
}

module instrument() {
  difference() {
    union() {
      handle();
      translate([-shift,0,0])linear_extrude(instrument_length)minkowski(){
        projection(cut=true)rotate([0,degre,0])translate([shiftx,0,0])main_body();
        circle(air_gap+holding_depth);
      }
    }
    translate([-shift,0,instrument_length-holding_depth])minkowski(){
      cube(2*air_gap,center=true);
      intersection() {
        rotate([0,degre,0])translate([shiftx,0,0])main_body(nothread=true);
        cylinder(d=500,h=holding_depth+1);
      }
    }
    translate([0,0,-1])cylinder(d=leader_diameter,h=leader_length+2);
    translate([0,0,leader_length])cylinder(d=tap_diameter,h=instrument_length);
  }
}

module dieholder() {
  difference() {
    union() {
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

module handle() {
  if(rounded_handle)hull() {
    translate([0,-handle_length/2,handle_thickness/2])sphere(d=handle_thickness);
    translate([0,handle_length/2,handle_thickness/2])sphere(d=handle_thickness);
  }
  else {
    translate([0,0,handle_thickness/2])cube([handle_thickness,handle_length,handle_thickness],center=true);
    translate([0,handle_length/2,0])cylinder(h=handle_thickness,d=handle_thickness);
    translate([0,-handle_length/2,0])cylinder(h=handle_thickness,d=handle_thickness);
  }
}

module wrench() {
  difference() {
    union() {
      handle();
      cylinder(h=handle_thickness,d=die_diameter+2*holding_depth);
    }
    translate([0,0,-1])linear_extrude(handle_thickness/3+1)minkowski() {
      projection(cut=true)translate([0,0,-seal_length])hose_adapter();
      circle(air_gap);
    }
    translate([0,0,-1])linear_extrude(handle_thickness+2)minkowski() {
      projection(cut=true)translate([0,0,-seal_length-4.1])hose_adapter();
      circle(air_gap);
    }
    translate([0,0,-1])linear_extrude(handle_thickness+2)minkowski() {
      projection(cut=true)translate([0,0,-1.5-seal_length])hollow_screw();
      circle(air_gap);
    }
    translate([0,0,2*handle_thickness/3])linear_extrude(handle_thickness/3+1)minkowski() {
      projection(cut=true)translate([0,0,0])hollow_screw();
      circle(air_gap);
    }
    translate([0,0,-1])cylinder(h=handle_thickness+2,d=max(adapter_inner_diameter,screw_inner_diameter));
  }
}
difference() {
if (part=="Interface") main_body();
if (part=="Interface_cover") main_magnet_cover();
if (part=="Magnetic_holder") magnetic_holder();
if (part=="Magnetic_holder_cover") holder_magnet_cover();
if (part=="Weight_gauge_bracket") rotate([0,90,0])wg_holder();
if (part=="Hose_adapter") hose_adapter();
if (part=="Hose_sleeve") hose_sleeve();
if (part=="Hollow_screw") hollow_screw();
if (part=="Filter_support") supports();
if (part=="OPTIONAL_tapping_tool") instrument();
if (part=="OPTIONAL_threading_tool") dieholder();
if (part=="OPTIONAL_wrench") wrench();
if (part=="TEST_fit") {
  magnetic_holder();
  translate([0,0,magnet_height+hor_wall+0.1]) {
    holder_magnet_cover();
    translate([0,0,wall_between_magnets+0.1]) {
      main_magnet_cover();
      translate([0,0,wall_between_magnets+magnet_height])rotate([0,0,360*magnet_height/thread_pitch])difference() {
        ScrewThread(outer_diam=thread1,pitch=thread_pitch,height=thread_pitch*2);
        cylinder(d=4,h=2*thread_pitch);
      }
    }
  }
}
if (cut_view) translate([-50,0,-50])cube([100,100,100]);
}

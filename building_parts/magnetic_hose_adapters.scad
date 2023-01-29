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
adapter_inner_diameter=4;
screw_inner_diameter=4;
offset=0;
$fn= $preview ? 32 : 64;

module hollow_screw(){
    difference(){
        union(){
            cylinder(h=1.5,d=screw_diameter+4);
            translate([0,0,1.5])cylinder(h=seal_length,d=screw_diameter);}
            cylinder(d=screw_inner_diameter,h=seal_length+2);
            cylinder(seal_length*0.7,screw_inner_diameter*0.6,screw_inner_diameter*0.5, $fn=6);
        }
    }
module main_body(){
    coeff=  (adapter_shape == "Round") ? 1:(adapter_shape == "Square") ? 1.42:1.16;
    if (light_trap==false)
    difference(){
      union(){cylinder(d=max(main_part_holes+2*seal_length,magnet_diameter+2*0.541*thread_pitch),h=seal_length+main_part_holes/2+hose_outer_diameter/2+2);
      translate([0,-hose_outer_diameter/2-2,0]) cube([seal_length+main_part_holes/2, hose_outer_diameter+4,seal_length+main_part_holes/2+hose_outer_diameter/2+2]);
   translate([0,0,seal_length+main_part_holes/2+hose_outer_diameter/2+2]) metric_thread(magnet_diameter+2*0.541*thread_pitch,thread_pitch,thread_pitch*2);
      }
      cylinder(d=main_part_holes,h=seal_length+main_part_holes/2);
      translate([0,0,seal_length+main_part_holes/2])rotate([0,90,0])cylinder(d=main_part_holes, h=seal_length+main_part_holes/2);
      translate([0,0,seal_length+main_part_holes/2])intersection(){cylinder(d=main_part_holes, h=main_part_holes,center=true);rotate([0,90,0])cylinder(d=main_part_holes, h=main_part_holes,center=true);}
    }
else //light trap
        difference(){
       union(){cylinder(d=max(main_part_holes+2*seal_length,magnet_diameter+2*0.541*thread_pitch),h=(hose_outer_diameter/2+2)*coeff+2*main_part_holes+2);
           translate([0,-max(main_part_holes+2*seal_length,magnet_diameter+2*0.541*thread_pitch)/2,0]) cube([max(offset+(magnet_diameter+2*0.541*thread_pitch)/2,2.5*main_part_holes+seal_length),max(main_part_holes+2*seal_length,magnet_diameter+2*0.541*thread_pitch),(hose_outer_diameter/2+2)*coeff+2*main_part_holes+2]);
     translate([offset,0,(hose_outer_diameter/2+2)*coeff+2*main_part_holes+2]) metric_thread(magnet_diameter+2*0.541*thread_pitch,thread_pitch,thread_pitch*2);
           }
      cylinder(d=main_part_holes,h=coeff*hose_outer_diameter/2+2*main_part_holes);
      
       translate([0,0,coeff*hose_outer_diameter/2+2*main_part_holes])rotate([0,90,0])cylinder(d=main_part_holes,h=2*main_part_holes);     
           
      translate([2*main_part_holes,0,coeff*hose_outer_diameter/2])cylinder(d=main_part_holes,h=2*main_part_holes);
          
       translate([2*main_part_holes,0,coeff*hose_outer_diameter/2])rotate([0,90,0])cylinder(d=main_part_holes,h=offset+magnet_diameter/2+0.541*thread_pitch+seal_length); 
      
           translate([0,0,coeff*hose_outer_diameter/2+2*main_part_holes])intersection(){cylinder(d=main_part_holes, h=main_part_holes,center=true);rotate([0,90,0])cylinder(d=main_part_holes, h=main_part_holes,center=true);}
            translate([2*main_part_holes,0,coeff*hose_outer_diameter/2+2*main_part_holes])intersection(){cylinder(d=main_part_holes, h=main_part_holes,center=true);rotate([0,90,0])cylinder(d=main_part_holes, h=main_part_holes,center=true);}
            translate([2*main_part_holes,0,coeff*hose_outer_diameter/2])intersection(){cylinder(d=main_part_holes, h=main_part_holes,center=true);rotate([0,90,0])cylinder(d=main_part_holes, h=main_part_holes,center=true);}
    }
    }
module main_magnet_cover(){
  difference(){
   cylinder(d=magnet_diameter+2*0.541*thread_pitch+thread_expand+3,h=magnet_height+thread_pitch*2+wall_between_magnets);
       translate([0,0,wall_between_magnets]){metric_thread(magnet_diameter+2*0.541*thread_pitch+thread_expand,thread_pitch,magnet_height+thread_pitch*2,internal=true);}
  }
}
module hose_adapter(){
    difference(){
        union(){
            cylinder(h=seal_length,d=insert_diameter);
            translate([0,0,seal_length])cylinder(h=4,d=hose_outer_diameter);
            translate([0,0,seal_length+4])cylinder(h=seal_length,d=hose_inner_diameter);
            }
            cylinder(d=adapter_inner_diameter,h=4+2*seal_length);
        }
    }
module hose_sleeve(){
    shape=(adapter_shape=="Round")?64:(adapter_shape=="Square")?4:6;
    coeff=  (adapter_shape == "Round") ? 1:(adapter_shape == "Square") ? 1.42:1.16;
    difference(){
        cylinder(h=seal_length+4,d=coeff*(hose_outer_diameter+2),$fn=shape);
        cylinder(h=seal_length+4,d=hose_outer_diameter);
    }
    }
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
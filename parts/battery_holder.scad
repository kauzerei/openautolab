//parametric battery cell holder
//Project: released for camera stab, designed for drill battery pack
$fs=0.7/1;
$fa=0.01/1;
diameter=19;
number=4;
module holder(diameter=18,battery_length=65,piptik_height=1,piptik_width=6,slit=2,wall=2,floor=2) {
length=battery_length+2*piptik_height;
difference() {
  union() {
    cube([diameter,length+2*wall,diameter/2+floor]);
    translate([diameter/2,0,diameter/2+floor])rotate([-90,0,0])cylinder(d=diameter,h=length+2*wall);
    translate([diameter/2,wall,diameter/2+floor])linear_extrude(piptik_width,center=true)polygon([[-piptik_width/2,0],[piptik_width/2,0],[0,piptik_height]]);
  }
  translate([diameter/2,wall,diameter/2+floor])rotate([-90,0,0])cylinder(d=diameter+0.01,h=length);
  translate([diameter/2-piptik_width/2,-0.01,floor+diameter/2-piptik_width/2-slit])cube([piptik_width,wall+0.02,slit]);
  translate([diameter/2-piptik_width/2,-0.01,floor+diameter/2+piptik_width/2])cube([piptik_width,wall+0.02,slit]);
  translate([diameter/2-piptik_width/2,-0.01+wall+length,floor+diameter/2-piptik_width/2-slit])cube([piptik_width,wall+0.02,slit]);
  translate([diameter/2-piptik_width/2,-0.01+wall+length,floor+diameter/2+piptik_width/2])cube([piptik_width,wall+0.02,slit]);
*  translate([diameter/2,diameter/2,-0.01])cylinder(d=piptik_width,h=diameter);
}
translate([diameter/2,wall,diameter/2+floor])rotate([0,90,0])linear_extrude(piptik_width,center=true)polygon([[-piptik_width/2,0],[piptik_width/2,0],[0,piptik_height]]);
translate([diameter/2,wall+length,diameter/2+floor])rotate([0,90,0])linear_extrude(piptik_width,center=true)polygon([[-piptik_width/2,0],[piptik_width/2,0],[0,-piptik_height]]);
}
module holders(diameter=18,battery_length=65,piptik_height=2,piptik_width=6,slit=2,wall=2,floor=2,number=1) {
  for (i=[0:1:number-1]) {
    translate([i*diameter,0,0])holder(diameter=diameter,battery_length=battery_length,piptik_height=piptik_height,piptik_width=piptik_width,slit=slit,wall=wall,floor=floor);
  }
}
holders(diameter=diameter,number=number);
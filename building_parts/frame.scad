$fn= $preview ? 32 : 64;
part="lower_vertex";// [lower_vertex,upper_vertex,Upper_rail_holder,Lower_rail_holder,PCB_holder,all,test]
threaded_rod_diameter=9;
nut_height=8;
nut_width=16;
d=threaded_rod_diameter;
h=nut_height;
w=nut_width;
mount_holes=4;
inclined_rod_length=400;
machine_depth=150;
machine_width=400;
inclination_angle=2*atan((inclined_rod_length-sqrt(pow(inclined_rod_length,2)+pow(w,2)-pow((machine_depth/2),2)))/(w+machine_depth/2));
ua=inclination_angle;
la=(90-inclination_angle)/2;
a=(part=="upper_vertex")?ua:la;
short_rod=machine_depth-2*w*cos(ua); //vertex_width((90-a)/2)+2*vertex_thickness((90-a)/2)+2*h;

function vertex_thickness(a)=w*cos(a);
function vertex_pivot_long(a)=0.5*w/sin(a)+h*cos(a)+w/2;
function vertex_pivot_short(a)=0.5*w/tan(a)+h+w*cos(a)/2;
function vertex_width(a)=-cos(2*a)*0.5*w/tan(a)+0.5*w*sin(2*a)+vertex_pivot_short(a)+vertex_thickness(a)/2;
function between_rods(a)=vertex_pivot_long(a)*sin(a);
//perpendicular offset vertex_pivot_long(a)*cos(a)
module vertex(a,rod1=0,rod2=0,rod3=0,nuts=false){
  difference() {
    union() {
      rotate([0,0,-a])translate([0,vertex_pivot_long(a),0])cube([2*h*sin(a),w,w],center=true);
      translate([0,vertex_pivot_short(a),0])cube([w,w*cos(a),w],center=true);
      translate([w*sin(a),vertex_pivot_short(a),0])cube([w,w*cos(a),w],center=true);
      rotate([0,0,-2*a])translate([0,vertex_pivot_short(a),0])cube([w,w*cos(a),w],center=true);
      rotate([0,0,-2*a])translate([-w*sin(a),vertex_pivot_short(a),0])cube([w,w*cos(a),w],center=true);
      *rotate([0,0,-2*a])translate([0,0.5*w/tan(a)+h/2,0])cube([w,h,w],center=true);
      *translate([0,0.5*w/tan(a)+h/2,0])cube([w,h,w],center=true);
      if (nuts) color("lightgrey") {
    translate([0,vertex_pivot_short(a)+h/2+w*cos(a)/2,0])rotate([90,0,0])cylinder(h=h,d=w,center=true,$fn=6);
    translate([0,vertex_pivot_short(a)-h/2-w*cos(a)/2,0])rotate([90,0,0])cylinder(h=h,d=w,center=true,$fn=6);
    rotate([0,0,-2*a])translate([0,vertex_pivot_short(a)+h/2+w*cos(a)/2,0])rotate([90,0,0])cylinder(h=h,d=w,center=true,$fn=6);
    rotate([0,0,-2*a])translate([0,vertex_pivot_short(a)-h/2-w*cos(a)/2,0])rotate([90,0,0])cylinder(h=h,d=w,center=true,$fn=6);
    rotate([0,0,-a])translate([0,vertex_pivot_long(a),w/2+h/2])cylinder(h=h,d=w,center=true,$fn=6);
    rotate([0,0,-a])translate([0,vertex_pivot_long(a),-w/2-h/2])cylinder(h=h,d=w,center=true,$fn=6);
    }
    }
    translate([0,vertex_pivot_short(a),0])rotate([90,0,0])cylinder(h=2*h+w+2,d=d,center=true);
    translate([0,vertex_pivot_short(a),0])rotate([90,0,90])cylinder(h=w+1,d=mount_holes,center=true);
    rotate([0,0,-2*a])translate([0,vertex_pivot_short(a),0])rotate([90,0,90])cylinder(h=w+1,d=mount_holes,center=true);
    rotate([0,0,-2*a])translate([0,vertex_pivot_short(a),0])rotate([90,0,0])cylinder(h=2*h+w+2,d=d,center=true);
    rotate([0,0,-a])translate([0,vertex_pivot_long(a),0])cylinder(h=2*h+w+2,d=d,center=true);
  }
  
    color("gray"){
    translate([0,vertex_pivot_short(a)-w*cos(a)/2-h,0])rotate([-90,0,0])cylinder(h=rod1,d=d);  
    rotate([0,0,-2*a])translate([0,vertex_pivot_short(a)-w*cos(a)/2-h,0])rotate([-90,0,0])cylinder(h=rod2,d=d);
    if (rod3>0) rotate([0,0,-a])translate([0,vertex_pivot_long(a),-w/2-h])cylinder(h=abs(rod3),d=d);
      else mirror([0,0,1])rotate([0,0,-a])translate([0,vertex_pivot_long(a),-w/2-h])cylinder(h=abs(rod3),d=d);
      }
}
module rodholder(dist=d+1) {
  difference(){
    cube([w,w,w+dist],center=true);
    translate([0,0,+dist/2])rotate([90,0,0])cylinder(d=d,h=w+2,center=true);
    translate([0,0,-dist/2])rotate([0,90,0])cylinder(d=d,h=w+2,center=true);
    cylinder(d=mount_holes,h=w+dist+2,center=true);
  }
  }
  module smallholder() {
  difference(){
    cube([w,w,w],center=true);
    cylinder(d=d,h=w+2,center=true);
    rotate([0,90,0])cylinder(d=mount_holes,h=w+2,center=true);
  }
  }

if (part=="upper_vertex") {
  translate([0,-vertex_pivot_short(a),0])vertex(a);
}
if (part=="lower_vertex") {
  translate([0,-vertex_pivot_short(a),0])vertex(a);
}
if (part=="Upper_rail_holder") {rotate([90,0,0])rodholder(dist=between_rods(ua));}
if (part=="Lower_rail_holder") {rotate([90,0,0])rodholder(dist=between_rods(la));}
if (part=="PCB_holder") {smallholder();}
if (part=="test") {vertex(15);}
if (part=="all") {
translate([0,-vertex_pivot_short(la),0])rotate([0,-90,0])vertex(la,nuts=true,rod1=short_rod,rod3=-machine_width,rod2=inclined_rod_length);
translate([0,short_rod-vertex_thickness(a)-h*2,0])mirror([0,1,0])translate([0,-vertex_pivot_short(la),0])rotate([0,-90,0])vertex(la,nuts=true,rod3=-machine_width,rod2=inclined_rod_length);
translate([machine_width-2*h-w,-vertex_pivot_short(la),0])rotate([0,-90,0])vertex(la,nuts=true,rod1=short_rod,rod2=inclined_rod_length);
translate([machine_width-2*h-w,short_rod-vertex_thickness(a)-h*2,0])mirror([0,1,0])translate([0,-vertex_pivot_short(la),0])rotate([0,-90,0])vertex(la,nuts=true,rod2=inclined_rod_length);
translate([0,-vertex_pivot_short(la),0])rotate([0,-90,0])rotate([0,0,-2*a])rotate([0,180,0])translate([0,vertex_pivot_short(a)-w*cos(a)/2-h,0])rotate([-90,0,0])translate([0,0,+vertex_pivot_short(ua)-vertex_thickness(ua)/2-h+inclined_rod_length])rotate([-90,0,0])vertex(ua,nuts=true);
  translate([machine_width-2*h-w,-vertex_pivot_short(la),0])rotate([0,-90,0])rotate([0,0,-2*a])rotate([0,180,0])translate([0,vertex_pivot_short(a)-w*cos(a)/2-h,0])rotate([-90,0,0])translate([0,0,+vertex_pivot_short(ua)-vertex_thickness(ua)/2-h+inclined_rod_length])rotate([-90,0,0])vertex(ua,nuts=true,rod3=machine_width);
//translate([0,0,vertex_pivot_long(ua)])rotate([-90,ua,90])vertex(ua);
  }



/*
translate([0,-vertex_pivot_short((90-a)/2),0])rotate([0,-90,0])vertex((90-a)/2);
translate([0,short_rod-vertex_thickness((90-a)/2)-h*2,0])mirror([0,1,0])translate([0,-vertex_pivot_short((90-a)/2),0])rotate([0,-90,0]){vertex((90-a)/2);color("grey")rotate([0,0,-(90-a)/2])translate([0,vertex_pivot_long((90-a)/2),h+w/2])mirror([0,0,1])cylinder(d=d,h=machine_width);};
color("grey")translate([0,-vertex_thickness((90-a)/2)/2-h,0])rotate([-90,0,0])cylinder(d=d,h=short_rod);

translate([machine_width-2*h-w,0,0]){translate([0,-vertex_pivot_short((90-a)/2),0])rotate([0,-90,0])vertex((90-a)/2);
translate([0,short_rod-vertex_thickness((90-a)/2)-h*2,0])mirror([0,1,0])translate([0,-vertex_pivot_short((90-a)/2),0])rotate([0,-90,0])vertex((90-a)/2);
color("grey")translate([0,-vertex_thickness((90-a)/2)/2-h,0])rotate([-90,0,0])cylinder(d=d,h=short_rod);}

*vertex(a,nuts=true);
vertex(a,rod1=100,rod2=200,rod3=300,nuts=true);

*/
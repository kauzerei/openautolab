h=8;
w=16;
a=15;
d=9;
machine_width=150;
function vertex_thickness(a)=w*cos(a);
function vertex_pivot_long(a)=0.5*w/sin(a)+h*cos(a)+w/2;
function vertex_pivot_short(a)=0.5*w/tan(a)+h+w*cos(a)/2;
function vertex_width(a)=cos(2*a)*0.5*w/tan(a)-0.5*w*sin(2*a)-vertex_pivot_short(a)-vertex_thickness(a)/2;
function between_rods(a)=vertex_pivot_long(a)*sin(a);
module vertex(a){
  difference() {
    union() {
      rotate([0,0,-a])translate([0,vertex_pivot_long(a),0])cube([2*h*sin(a),w,w],center=true);
      translate([0,vertex_pivot_short(a),0])cube([w,w*cos(a),w],center=true);
      translate([w*sin(a),vertex_pivot_short(a),0])cube([w,w*cos(a),w],center=true);
      rotate([0,0,-2*a])translate([0,vertex_pivot_short(a),0])cube([w,w*cos(a),w],center=true);
      rotate([0,0,-2*a])translate([-w*sin(a),vertex_pivot_short(a),0])cube([w,w*cos(a),w],center=true);
      *rotate([0,0,-2*a])translate([0,0.5*w/tan(a)+h/2,0])cube([w,h,w],center=true);
    }
    translate([0,vertex_pivot_short(a),0])rotate([90,0,0])cylinder(h=w+2,d=d,center=true);
    rotate([0,0,-2*a])translate([0,vertex_pivot_short(a),0])rotate([90,0,0])cylinder(h=w+2,d=d,center=true);
    #rotate([0,0,-a])translate([0,vertex_pivot_long(a),0])cylinder(h=w+2,d=d,center=true);
  }
}
translate([0,0,-between_rods(a)])rotate([0,-90,0])vertex(a);

part = "bottom_corner"; // [bottom_corner, bottom_corner_mirrored,top_corner]
h=8.0;
d=8.0;
w=18.0;
width=150.0;
a=15.0;

module bottom_corner(){
    difference(){
        union(){
            linear_extrude(w)polygon([[0,w-w*sin(a)-h*cos(a)],[0,0],[w,w*tan(a)],[w,w*tan(a)+w-w*sin(a)-h*cos(a)]]);
            translate([0,0,-w])cube([w,2*w,w]);
    }
    translate([w/2,1.5*w,-w-1])cylinder(h=w+2,d=d);
    translate([-1,w/2,-w/2])rotate([0,90,0])cylinder(h=w+2,d=d);
    translate([w/2,(w*tan(a)+w-w*sin(a)-h*cos(a))/2,w/2])rotate([90,0,a])cylinder(h=2*w,d=d,center=true);
}
}
    Ax=h*sin(a);
    Ay=w;
    Dy=0;
    Dx=(h+w/cos(a))*sin(a);
    Bx=Ax+w*cos(a);
    By=Ay+w*sin(a);
    Cx=Dx+w*cos(a);
    Cy=Dy+w*sin(a);
$fn=36;
Hy=By+h*cos(a);
module top_corner(){
    Ax=h*sin(a);
    Ay=w;
    Dy=0;
    Dx=(h+w/cos(a))*sin(a);
    Bx=Ax+w*cos(a);
    By=Ay+w*sin(a);
    Cx=Dx+w*cos(a);
    Cy=Dy+w*sin(a);
     difference(){
    linear_extrude(w)polygon([[Ax,Ay],[Bx,By],[Cx,Cy],[Dx,Dy],[-Dx,Dy],[-Cx,Cy],[-Bx,By],[-Ax,Ay]]);
    translate([0,w/2,-1])cylinder(h=w+2, d=d);
    translate([(Ax+Cx)/2,(Ay+Cy)/2,w/2])rotate([90,0,a])cylinder(h=w+2, d=d,center=true);    
    translate([(-Ax-Cx)/2,(Ay+Cy)/2,w/2])rotate([90,0,-a])cylinder(h=w+2, d=d,center=true);
     }
}
if (part=="bottom_corner") {
    rotate([0,-90,0])bottom_corner();
}
if (part=="bottom_corner_mirrored") {
    mirror([1,0,0])rotate([0,-90,0])bottom_corner();
}
if (part=="top_corner") {
    top_corner();
}
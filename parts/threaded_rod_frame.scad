$fn= $preview ? 32 : 64;
part = "bottom_corner"; // [bottom_corner, bottom_corner_mirrored,top_corner,mounting_block,rail_mount,top_hook,all]
nut_width_with_margin=18;
nut_height_with_margin=8;
rod_diameter=8;
angle_of_inclanation=10;
h=nut_height_with_margin;
w=nut_width_with_margin;
d=rod_diameter;
mounting_hole=5;
width=150.0;
length=400;
a=angle_of_inclanation;

module bottom_corner(){
    difference(){
        union(){
            linear_extrude(w)polygon([[0,w-w*sin(a)-h*cos(a)],[0,0],[w,w*tan(a)],[w,w*tan(a)+w-w*sin(a)-h*cos(a)]]);
            translate([0,0,-w])cube([w,2*w,w]);
    }
    translate([w/2,1.5*w,-w-1])cylinder(h=w+2,d=d);
    translate([-1,w/2,-w/2])rotate([0,90,0])cylinder(h=w+2,d=d);
    translate([w/2,(w*tan(a)+w-w*sin(a)-h*cos(a))/2,w/2])rotate([90,0,a])cylinder(h=2*w,d=d,center=true);
    *mirror([0,0,1])cube([h,w,w]);
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
    dw=(Cx+Ax)/2;
Hy=By+h*cos(a);
dh1=2*w-(w*tan(a)+w-w*sin(a)-h*cos(a))/2;
dh2=Hy-By/2;
h0=((width-2*h-w)/2-dw)/tan(a);
height=h0+dh1+dh2;
td=(w-w*sin(a)-h*cos(a))*cos(a);
rl=2*h+h0/cos(a)+0.5*w/cos(a)+td/2;
dist=(sqrt((Cx+Ax)*(Cx+Ax)+(By-w)*(By-w)))/2;
echo(dist);
module top_corner(){
     difference(){
    linear_extrude(w)polygon([[Ax,Ay],[Bx,By],[Cx,Cy],[Dx,Dy],[-Dx,Dy],[-Cx,Cy],[-Bx,By],[-Ax,Ay]]);
    translate([0,w/2,-1])cylinder(h=w+2, d=d);
    translate([(Ax+Cx)/2,(Ay+Cy)/2,w/2])rotate([90,0,a])cylinder(h=w/cos(a)+2, d=d,center=true);    
    translate([(-Ax-Cx)/2,(Ay+Cy)/2,w/2])rotate([90,0,-a])cylinder(h=w/cos(a)+2, d=d,center=true);
    translate([(Cx+Bx)/2,(Cy+By)/2,w/2])rotate([-a,90,0])cylinder(h=w,d=mounting_hole,center=true);
     }
}
module top_hook(){
     difference(){
    linear_extrude(w)polygon([[Ax,Ay],[Bx,By],[Cx,Cy],[Dx,Dy],[-Dx,Dy],[-nut_width_with_margin/2,Dy],[-nut_width_with_margin/2,Ay],[-Ax,Ay]]);
    hull(){
    translate([0,w/2,-1])cylinder(h=w+2, d=d);
    translate([0,0,-1])cylinder(h=w+2, d=d);
    }
    translate([(Ax+Cx)/2,(Ay+Cy)/2,w/2])rotate([90,0,a])cylinder(h=w/cos(a)+2, d=d,center=true);    
    *translate([(-Ax-Cx)/2,(Ay+Cy)/2,w/2])rotate([90,0,-a])cylinder(h=w/cos(a)+2, d=d,center=true);
    translate([(Cx+Bx)/2,(Cy+By)/2,w/2])rotate([-a,90,0])cylinder(h=w,d=mounting_hole,center=true);
     }
}
module mounting_block()
{
    difference()
    {
        cube([w,w,w]);
        translate([w/2,w/2,w/2])cylinder(h=w+2,d=d,center=true);
         translate([0,w/2,w/2])rotate([0,90,0])cylinder(h=w+1,d=mounting_hole,center=true);
    }
    }
module rail_mount()
    {
       rotate([90,0,0]) difference(){
       rotate([0,0,180/8])cylinder(d=w/cos(180/8),h=w+dist,$fn=8);
       translate([0,0,dist+w/2])rotate([90,0,45]) cylinder(d=d,h=w+2,center=true);
       translate([0,0,0.5*w])rotate([90,0,-45]) cylinder(d=d,h=w+2,center=true);
           cylinder(h=w,d=mounting_hole,center=true);
            }
        }
if (part=="bottom_corner") {
    rotate([0,90,0])bottom_corner();
}
if (part=="bottom_corner_mirrored") {
    mirror([1,0,0])rotate([0,-90,0])bottom_corner();
}
if (part=="top_corner") {
    top_corner();
}
if (part=="mounting_block") {
    mounting_block();
}
if (part=="rail_mount") {
    rail_mount();
}
if (part=="top_hook") {
    top_hook();
}
if (part=="all")
{
    mirror([0,1,1])bottom_corner();
    translate([width-2*h,0,0])mirror([1,0,0])mirror([0,1,1])bottom_corner();
    translate([0,length,0])mirror([0,1,0])mirror([0,1,1])bottom_corner();
    translate([width-2*h,length,0])mirror([0,1,0])mirror([1,0,0])mirror([0,1,1])bottom_corner();
    translate([width/2-h,0,h0-By/2-(w*tan(a)+w-w*sin(a)-h*cos(a))/2])rotate([90,0,0])top_corner();
    translate([width/2-h,length+w,h0-By/2-(w*tan(a)+w-w*sin(a)-h*cos(a))/2])rotate([90,0,0])top_corner();
    color("blue")
    {
        translate([w/2,-h,-1.5*w])rotate([-90,0,0])cylinder(d=d,h=length+2*h);
        translate([width-2*h-w/2,-h,-1.5*w])rotate([-90,0,0])cylinder(d=d,h=length+2*h);
        translate([width/2-h,-h-w,w/2+h0-By/2-(w*tan(a)+w-w*sin(a)-h*cos(a))/2])rotate([-90,0,0])cylinder(d=d,h=length+2*w+2*h);
        translate([-h,w/2,-w/2])rotate([0,90,0])cylinder(d=d,h=width);
        translate([-h,length-w/2,-w/2])rotate([0,90,0])cylinder(d=d,h=width);
        translate([w/2,-w/2,-(w*tan(a)+w-w*sin(a)-h*cos(a))/2])rotate([0,a,0])translate([0,0,-h-0.5*td])cylinder(d=d,h=rl);
        
        translate([width-2*h,0,0])mirror([1,0,0])translate([w/2,-w/2,-(w*tan(a)+w-w*sin(a)-h*cos(a))/2])rotate([0,a,0])translate([0,0,-h-cos(a)*(w-w*sin(a)-h*cos(a))/2])cylinder(d=d,h=rl);
        
        translate([0,length,0])mirror([0,1,0])translate([w/2,-w/2,-(w*tan(a)+w-w*sin(a)-h*cos(a))/2])rotate([0,a,0])translate([0,0,-h-cos(a)*(w-w*sin(a)-h*cos(a))/2])cylinder(d=d,h=rl);
        
        translate([width-2*h,length,0])mirror([0,1,0])mirror([1,0,0])translate([w/2,-w/2,-(w*tan(a)+w-w*sin(a)-h*cos(a))/2])rotate([0,a,0])translate([0,0,-h-cos(a)*(w-w*sin(a)-h*cos(a))/2])cylinder(d=d,h=rl);

        }
    }

echo("-----------------------------");
echo(str("Machine height = ", height,"mm"));
echo(str("Rod length = ",rl,"mm"));
echo("-----------------------------");
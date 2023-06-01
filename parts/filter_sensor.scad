filter_wall=6;
holder_wall=3;
offset_v=45;
offset_h=20;
hole=9;
cube([holder_wall,2*hole,offset_v+holder_wall]);
tail=min(20,offset_v+holder_wall);
translate([-holder_wall-filter_wall,0,offset_v+holder_wall-tail])cube([holder_wall,2*hole,tail]);
translate([-filter_wall,0,offset_v])cube([filter_wall,2*hole,holder_wall]);
difference() {
cube([offset_h+hole ,2*hole,holder_wall]);
translate([offset_h,hole,holder_wall/2])cylinder(h=holder_wall+0.02,d=hole,center=true);
}
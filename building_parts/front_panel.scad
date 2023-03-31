$fs=1/2;
part="Front";//[Front,Back,Buttons]
tolerance=0.5;
pcb_width=157.5;
pcb_height=124.5;
pcb_offset=18;
pcb_thickness=5;//with soldering
pcb_holes=[[5,5],[155,5],[5,119],[155,119]];
walls=1;
buttons_pos=[[18,115],[48,115],[79,115]];
buttons_outer=10;
buttons_inner=5;
buttons_height=10;
connectors_pos=[[13,16],[32,16],[51,16],[70,16],[89,16],[108,16],[127,16],[146,16],[144,96],[144,111]];
switches_pos=[[126,103]];
switches_diameter=7;
screen_pos=[50,86];
screen_mount=[75,32];
screen_mount_holes=4;
screen_rect=[72,25];
module front() {
difference() {
translate([0,0,0.01]) union() {
translate([-2*tolerance-2*walls,-2*tolerance-2*walls,0])cube([pcb_width+4*tolerance+4*walls,pcb_height+4*tolerance+4*walls,walls]);
for (tr = buttons_pos) translate(tr) cylinder(d=buttons_outer,h=pcb_offset-buttons_height-2+walls);
}
for(tr=buttons_pos) translate(tr) cylinder(d=buttons_inner,h=pcb_offset-buttons_height-2+walls+0.02);
for(tr=switches_pos) translate(tr) cylinder(d=switches_diameter,h=walls+0.02);
for (i=[[[1,0],[0,1]],[[-1,0],[0,1]],[[1,0],[0,-1]],[[-1,0],[0,-1]]])translate(screen_pos)translate(i*screen_mount/2)cylinder(d=screen_mount_holes,h=walls+0.02);
translate(screen_pos-screen_rect/2)cube([screen_rect[0],screen_rect[1],walls+0.02]);
for (i=connectors_pos)translate(i)cube(16,center=true);
}
difference(){
translate([-walls-tolerance,-walls-tolerance,0.01])cube([pcb_width+2*tolerance+2*walls,pcb_height+2*tolerance+2*walls,pcb_offset+pcb_thickness]);
translate([-tolerance,-tolerance])cube([pcb_width+2*tolerance,pcb_height+2*tolerance,pcb_offset+pcb_thickness+0.02]);
}
translate([0,0,0.01])difference() {
for (i=pcb_holes)translate(i)translate([0,0,walls])cylinder(d=8,h=pcb_offset);
for (i=pcb_holes)translate(i)translate([0,0,walls])cylinder(d=4,h=pcb_offset+0.02);
}
}
module back() {
difference(){
translate([-2*tolerance-2*walls,-2*tolerance-2*walls,0])cube([pcb_width+4*tolerance+4*walls,pcb_height+4*tolerance+4*walls,walls]);
for (i=pcb_holes)translate(i)cylinder(d=4,h=walls);
}
difference(){
translate([-2*walls-2*tolerance,-2*walls-2*tolerance])cube([pcb_width+4*tolerance+4*walls,pcb_height+4*tolerance+4*walls,pcb_offset+pcb_thickness]);
translate([-2*tolerance-walls,-2*tolerance-walls])cube([pcb_width+4*tolerance+2*walls,pcb_height+4*tolerance+2*walls,pcb_offset+pcb_thickness]);
}
#for (i=[[-18,-3],[159,-3],[-18,111],[159,111]])translate(i)difference() {
cube([16,16,walls]);
translate([8,8,0])cylinder(d=4,h=walls);
}
}

module buttons() {
cylinder(d=buttons_outer,h=2);
translate([0,0,2])cylinder(d=buttons_inner-2*tolerance,h=buttons_height+3);
}

if (part=="Front") front();
if (part=="Backt") back();
if (part=="Buttons") buttons();
tolerance=0.5;
pcb_width=157.5;
pcb_height=124.5;
pcb_offset=10;
walls=1;
buttons_pos=[[18,115],[48,115],[79,115]];
buttons_outer=10;
buttons_inner=5;
buttons_height=5;
connectors_pos=[[13,16],[32,16],[51,16],[70,16],[89,16],[108,16],[127,16],[146,16],[144,96],[144,111]];
switches_pos=[[126,103]];
switches_diameter=7;
screen_pos=[50,86];
screen_mount=[75,32];
screen_mount_holes=4;
screen_rect=[72,25];
module front() {
difference() {
union() {
translate([-2*tolerance-2*walls,-2*tolerance-2*walls,0])cube([pcb_width+4*tolerance+4*walls,pcb_height+4*tolerance+4*walls,walls]);
for (tr = buttons_pos) translate(tr) cylinder(d=buttons_outer,h=pcb_offset+walls);
}
for(tr=buttons_pos) translate(tr) cylinder(d=buttons_inner,h=pcb_offset+walls);
for(tr=switches_pos) translate(tr) cylinder(d=switches_diameter,h=walls);
for (i=[[[1,0],[0,1]],[[-1,0],[0,1]],[[1,0],[0,-1]],[[-1,0],[0,-1]]])translate(screen_pos)translate(i*screen_mount/2)cylinder(d=screen_mount_holes,h=walls);
translate(screen_pos-screen_rect/2)cube([screen_rect[0],screen_rect[1],walls]);
}
difference(){
translate([-walls-tolerance,-walls-tolerance])cube([pcb_width+2*tolerance+2*walls,pcb_height+2*tolerance+2*walls,20]);
translate([-tolerance,-tolerance])cube([pcb_width+2*tolerance,pcb_height+2*tolerance,20]);
}
}
front();
$fs=1/2;
part="Front";//[Front,Back,Buttons]
tolerance=0.5;
pcb_width=145;
pcb_height=89;
pcb_offset=18;
pcb_thickness=5;//with soldering
pcb_holes=[[3.8,3.8],[141,3.8],[3.8,85],[141,85]];
walls=1;
buttons_pos=[[40,83],[70,83],[101,83]];
buttons_outer=10;
buttons_inner=5;
buttons_height=10;
connectors_top=[[15,8],[27.66,8],[40.33,8],[53,8],[65.66,8],[78.33,8],[91,8],[103.66,8],[116.33,8],[129,8]];
connectors_left=[[0,32],[0,52]];
connectors_right=[[144,67]];
switches_pos=[[11,77]];
switches_diameter=7;
screen_pos=[70,47];
screen_mount=[92,55];
screen_mount_holes=4;
screen_rect=[92,40];
module front() {
difference() {
translate([0,0,0.01]) union() {
difference(){
translate([-walls-tolerance,-walls-tolerance,0.01])cube([pcb_width+2*tolerance+2*walls,pcb_height+2*tolerance+2*walls,pcb_offset+pcb_thickness]);
translate([-tolerance,-tolerance])cube([pcb_width+2*tolerance,pcb_height+2*tolerance,pcb_offset+pcb_thickness+0.02]);
}
translate([-2*tolerance-2*walls,-2*tolerance-2*walls,0])cube([pcb_width+4*tolerance+4*walls,pcb_height+4*tolerance+4*walls,walls]);
for (tr = buttons_pos) translate(tr) cylinder(d=buttons_outer,h=pcb_offset-buttons_height-2+walls);
}
for(tr=buttons_pos) translate(tr) cylinder(d=buttons_inner,h=pcb_offset-buttons_height-2+walls+0.02);
for(tr=switches_pos) translate(tr) cylinder(d=switches_diameter,h=walls+0.02);
for (i=[[[1,0],[0,1]],[[-1,0],[0,1]],[[1,0],[0,-1]],[[-1,0],[0,-1]]])translate(screen_pos)translate(i*screen_mount/2)cylinder(d=screen_mount_holes,h=walls+0.02);
translate(screen_pos-screen_rect/2)cube([screen_rect[0],screen_rect[1],walls+0.02]);
for (i=connectors_top)translate(i)translate([0,-5,pcb_offset/2])cube([10,18,pcb_offset],center=true);
for (i=connectors_left)translate(i)translate([0,0,pcb_offset/2])cube([20,10,pcb_offset-walls*3],center=true);
for (i=connectors_right)translate(i)translate([0,0,pcb_offset/2])cube([20,10,pcb_offset-walls*3],center=true);
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
for (i=[[-18,-3],[159,-3],[-18,111],[159,111]])translate(i)difference() {
cube([16,16,walls]);
translate([8,8,0])cylinder(d=4,h=walls);
}
}

module buttons() {
cylinder(d=buttons_outer,h=2);
translate([0,0,2])cylinder(d=buttons_inner-2*tolerance,h=buttons_height+3);
}

if (part=="Front") front();
if (part=="Back") back();
if (part=="Buttons") buttons();
$fs=1/2;
part="Box";//[Front,Box,Buttons]
tolerance=0.5;
pcb_width=145;
pcb_height=89;
pcb_offset=30;
pcb_thickness=2;
solder_thickness=2;
pcb_holes=[[3.8,3.8],[141,3.8],[3.8,85],[141,85]];
walls=1.5;
buttons_pos=[[40,83],[70,83],[101,83]];
buttons_outer=10;
buttons_inner=4;
buttons_height=5;
connectors_top=[[15,8],[27.66,8],[40.33,8],[53,8],[65.66,8],[78.33,8],[91,8],[103.66,8],[116.33,8],[129,8]];
connectors_left=[[0,32],[0,52]];
connectors_right=[[144,67]];
switches_pos=[[11,77]];
switches_diameter=7;
screen_pos=[70,47];
screen_mount=[92,55];
mount_holes=4;
screen_rect=[92,40];

module front() {
difference() {
translate([-tolerance-walls,-tolerance-walls,0.01])cube([pcb_width+2*tolerance+2*walls,pcb_height+2*tolerance+2*walls,walls]);
for(tr=switches_pos) translate(tr) cylinder(d=switches_diameter,h=walls+0.02);
for (i=[[[1,0],[0,1]],[[-1,0],[0,1]],[[1,0],[0,-1]],[[-1,0],[0,-1]]])translate(screen_pos)translate(i*screen_mount/2)cylinder(d=mount_holes,h=walls+0.02);
translate(screen_pos-screen_rect/2)cube([screen_rect[0],screen_rect[1],walls+0.02]);
for(tr=buttons_pos) translate(tr) cylinder(d=buttons_inner+2*tolerance,h=pcb_offset-buttons_height-2+walls+0.02);
}
difference(){
translate([0,0,walls])cube([pcb_width,pcb_height,mount_holes/2]);
translate([walls,walls,walls-0.01])cube([pcb_width-2*walls,pcb_height-2*walls,mount_holes/2+0.02]);
}
difference() {
for (i=[[0,0,walls],[0,pcb_height-2*mount_holes,walls],[pcb_width-2*mount_holes,0,walls],[pcb_width-2*mount_holes,pcb_height-2*mount_holes,walls]]) translate(i) difference() {
  cube([2*mount_holes,2*mount_holes,2*mount_holes]);
  translate([-0.01,mount_holes,mount_holes])rotate([0,90,0])cylinder(h=2*mount_holes+0.02,d=mount_holes);}
}
difference() {
translate([0,0,walls])for (tr = buttons_pos) translate(tr) cylinder(d=buttons_outer,h=pcb_offset-buttons_height+pcb_thickness+solder_thickness-2);
translate([0,0,walls-0.01])for(tr=buttons_pos) translate(tr) cylinder(d=buttons_inner+2*tolerance,h=pcb_offset-buttons_height+pcb_thickness+solder_thickness+0.02);
}

difference() {
translate([0,0,walls]) for (i=[[[1,0],[0,1]],[[-1,0],[0,1]],[[1,0],[0,-1]],[[-1,0],[0,-1]]])translate(screen_pos)translate(i*screen_mount/2) cylinder(d=mount_holes*2,h=solder_thickness);
translate([0,0,walls-0.01])for (i=[[[1,0],[0,1]],[[-1,0],[0,1]],[[1,0],[0,-1]],[[-1,0],[0,-1]]])translate(screen_pos)translate(i*screen_mount/2) cylinder(d=mount_holes,h=solder_thickness+0.02);
}
}


module box() {
difference(){
translate([-tolerance-walls,-tolerance-walls,0])
cube([pcb_width+2*walls+2*tolerance,pcb_height+2*walls+2*tolerance,pcb_offset+2*pcb_thickness+2*solder_thickness+2*walls]);
difference() {
  translate([-tolerance,-tolerance,-0.01])cube([pcb_width+2*tolerance,pcb_height+2*tolerance,pcb_offset+2*pcb_thickness+2*solder_thickness+walls+0.01]);
  translate([0,0,pcb_offset+2*pcb_thickness+solder_thickness+walls+0.01])for (i=pcb_holes)translate(i)cylinder(d=mount_holes*2,h=solder_thickness);
}
translate([0,0,pcb_offset+2*pcb_thickness+solder_thickness+walls-0.01])for (i=pcb_holes)translate(i)cylinder(d=mount_holes,h=walls+solder_thickness+0.02);
for (i=connectors_top)translate(i)translate([0,-5,pcb_offset+pcb_thickness+solder_thickness+walls-5])cube([10,18,10],center=true);
for (i=connectors_left)translate(i)translate([0,0,pcb_offset+pcb_thickness+solder_thickness+walls-5])cube([20,10,10],center=true);
for (i=connectors_right)translate(i)translate([0,0,pcb_offset+pcb_thickness+solder_thickness+walls-5-7])cube([20,10,19],center=true);
}
}

module buttons() {
cylinder(d=buttons_outer,h=2);
translate([0,0,2])cylinder(d=buttons_inner,h=pcb_offset-buttons_height+pcb_thickness+solder_thickness+walls+2);
}

if (part=="Front") front(); 
if (part=="Box") rotate([180,0,0])box();
if (part=="Buttons") buttons();
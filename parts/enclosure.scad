// Box that encloses OpenAutoLab electronics.
//
// Copyright (c) 2023-2024 Kauzerei <mailto:openautolab@kauzerei.de>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

$fs=0.5/1;
$fa=1/1;
part="Front"; //[Front, Back, Buttons]
tolerance=0.5;
pcb_width=145;
pcb_height=89;
pcb_offset=26;
pcb_thickness=2;
solder_thickness=2;
pcb_mount_holes=4;
pcb_holes_pos=[[3.8,3.8],[141,3.8],[3.8,85],[141,85]];
walls=1.5;
buttons_pos=[[40,83],[70,83],[101,83]];
buttons_outer=10;
buttons_inner=4;
buttons_height=5;
connectors_top=[[15,8],[27.66,8],[40.33,8],[53,8],[65.66,8],[78.33,8],[91,8],[103.66,8],[116.33,8],[129,8]];
connectors_left=[[0,32],[0,52]];
connectors_right=[[144,67]];
switches_pos=[[100,10],[85,10]];
switches_diameter=7;
screen_pos=[70,47];
screen_mount=[93,55];
screen_mount_holes=3;
screen_rect=[98.5,41];

module front() {
  difference() {
    translate([-tolerance-walls,-tolerance-walls,0.01])cube([pcb_width+2*tolerance+2*walls,pcb_height+2*tolerance+2*walls,walls]);
    for(tr=switches_pos) translate(tr) cylinder(d=switches_diameter,h=walls+0.02);
    for (i=[[[1,0],[0,1]],[[-1,0],[0,1]],[[1,0],[0,-1]],[[-1,0],[0,-1]]])translate(screen_pos)translate(i*screen_mount/2)cylinder(d=screen_mount_holes,h=walls+0.02);
    translate(screen_pos-screen_rect/2)cube([screen_rect[0],screen_rect[1],walls+0.02]);
    for(tr=buttons_pos) translate(tr) cylinder(d=buttons_inner+2*tolerance,h=pcb_offset-buttons_height-2+walls+0.02);
  }
  difference() {
    translate([0,0,walls])cube([pcb_width,pcb_height,pcb_mount_holes/2]);
    translate([walls,walls,walls-0.01])cube([pcb_width-2*walls,pcb_height-2*walls,pcb_mount_holes/2+0.02]);
  }
  difference() {
    for (i=[[0,0,walls],[0,pcb_height-2*pcb_mount_holes,walls],[pcb_width-2*pcb_mount_holes,0,walls],[pcb_width-2*pcb_mount_holes,pcb_height-2*pcb_mount_holes,walls]]) translate(i) difference() {
    cube([2*pcb_mount_holes,2*pcb_mount_holes,2*pcb_mount_holes]);
    translate([-0.01,pcb_mount_holes,pcb_mount_holes])rotate([0,90,0])cylinder(h=2*pcb_mount_holes+0.02,d=pcb_mount_holes);}
  }
  difference() {
    translate([0,0,walls])for (tr = buttons_pos) translate(tr) cylinder(d=buttons_outer,h=pcb_offset-buttons_height+pcb_thickness+solder_thickness-2);
    translate([0,0,walls-0.01])for(tr=buttons_pos) translate(tr) cylinder(d=buttons_inner+2*tolerance,h=pcb_offset-buttons_height+pcb_thickness+solder_thickness+0.02);
  }
  difference() {
    translate([0,0,walls]) for (i=[[[1,0],[0,1]],[[-1,0],[0,1]],[[1,0],[0,-1]],[[-1,0],[0,-1]]])translate(screen_pos)translate(i*screen_mount/2) cylinder(d=screen_mount_holes*2,h=solder_thickness);
    translate([0,0,walls-0.01])for (i=[[[1,0],[0,1]],[[-1,0],[0,1]],[[1,0],[0,-1]],[[-1,0],[0,-1]]])translate(screen_pos)translate(i*screen_mount/2) cylinder(d=screen_mount_holes,h=solder_thickness+0.02);
  }
}

module box() {
  difference() {
    translate([-tolerance-walls,-tolerance-walls,0])
    cube([pcb_width+2*walls+2*tolerance,pcb_height+2*walls+2*tolerance,pcb_offset+2*pcb_thickness+2*solder_thickness+2*walls]);
    difference() {
      translate([-tolerance,-tolerance,-0.01])cube([pcb_width+2*tolerance,pcb_height+2*tolerance,pcb_offset+2*pcb_thickness+2*solder_thickness+walls+0.01]);
      translate([0,0,pcb_offset+2*pcb_thickness+solder_thickness+walls+0.01])for (i=pcb_holes_pos)translate(i)cylinder(d=pcb_mount_holes*2,h=solder_thickness);
    }
  translate([0,0,pcb_offset+2*pcb_thickness+solder_thickness+walls-0.01])for (i=pcb_holes_pos)translate(i)cylinder(d=pcb_mount_holes,h=walls+solder_thickness+0.02);
  for (i=connectors_top)translate(i)translate([0,-5,pcb_offset+pcb_thickness+solder_thickness+walls-5])cube([10,18,10],center=true);
  for (i=connectors_left)translate(i)translate([0,0,pcb_offset+pcb_thickness+solder_thickness+walls-5-4])cube([20,10,18],center=true);
  for (i=connectors_right)translate(i)translate([0,0,pcb_offset+pcb_thickness+solder_thickness+walls-5-7])cube([20,10,19],center=true);
  for (i=[[-walls-tolerance-0.01,0,0],[-walls-tolerance-0.01,pcb_height-2*pcb_mount_holes,0],[pcb_width+tolerance-0.01,0,0],[pcb_width+tolerance-0.01,pcb_height-2*pcb_mount_holes,0]]) translate(i) translate([-0.01,pcb_mount_holes,pcb_mount_holes])rotate([0,90,0])cylinder(h=walls+0.04,d=pcb_mount_holes);
  }
}

module buttons() {
  cylinder(d=buttons_outer,h=2);
  translate([0,0,2])cylinder(d=buttons_inner,h=pcb_offset-buttons_height+pcb_thickness+solder_thickness+walls+2);
}

if (part=="Front") front();
if (part=="Back") rotate([180,0,0])box();
if (part=="Buttons") buttons();

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

$fs=1/2;
$fa=1/1;
part="Front"; //[Front, Back, Buttons, Battery enclosure]
tolerance=0.5;
pcb_width=109.22;
pcb_height=74.93;
pcb_offset=26;
pcb_thickness=2;
solder_thickness=2;
mount_hole=4.5;
pcb_holes_pos=[[3.81,3.81],[105.41,3.8],[3.8,71.12],[105.41,71.12]];
walls=1.6;
buttons_pos=[[22,69.6],[54.6,69.6],[86.8,69.6]];
buttons_outer=10;
buttons_inner=4;
buttons_height=5;
//array of connectors, each connector=[[posx,posy,posz],[sizex,sizey,sizez]]
small_offset_z=pcb_offset+pcb_thickness+solder_thickness+walls-5;
wide_offset_z=pcb_offset+pcb_thickness+solder_thickness+walls-9;
connectors=[ //top:
             [[10.67,0,small_offset_z],[7,18,10]],
             [[19.56,0,small_offset_z],[7,18,10]],
             [[28.45,0,small_offset_z],[7,18,10]],
             [[37.34,0,small_offset_z],[7,18,10]],
             [[46.23,0,small_offset_z],[7,18,10]],
             [[55.12,0,small_offset_z],[7,18,10]],
             [[64,0,small_offset_z],[7,18,10]],
             [[72.0,0,small_offset_z],[7,18,10]],
             [[83.82,0,small_offset_z],[7,18,10]],
             [[96.52,0,small_offset_z],[7,18,10]],
             //left:
             [[0,30.5,small_offset_z],[20,10,10]],
             [[0,48.26,wide_offset_z],[20,10,18]],
             //right:
             [[109,21.59,small_offset_z],[20,10,10]],
             [[109,40.64,wide_offset_z],[20,10,18]],
             [[109,55.88,small_offset_z],[20,10,10]]
           ];
switches_pos=[[91,0,11],[78,0,11]];
switches_diameter=7;
screen_pos=[54.5,35];
screen_mount=[93,55];
screen_mount_holes=3;
screen_rect=[98.5,41];

battery_h=78;
battery_w=78;
battery_d=23;

module front() {
  difference() {
    translate([-tolerance-walls,-tolerance-walls,0.01])cube([pcb_width+2*tolerance+2*walls,pcb_height+2*tolerance+2*walls,walls]);
    for (i=[[[1,0],[0,1]],[[-1,0],[0,1]],[[1,0],[0,-1]],[[-1,0],[0,-1]]])translate(screen_pos)translate(i*screen_mount/2)cylinder(d=screen_mount_holes,h=walls+0.02);
    translate(screen_pos-screen_rect/2)cube([screen_rect[0],screen_rect[1],walls+0.02]);
    for(tr=buttons_pos) translate(tr) cylinder(d=buttons_inner+2*tolerance,h=pcb_offset-buttons_height-2+walls+0.02);
  }
  difference() {
    translate([0,0,walls])cube([pcb_width,pcb_height,mount_hole/2]);
    translate([walls,walls,walls-0.01])cube([pcb_width-2*walls,pcb_height-2*walls,mount_hole/2+0.02]);
  }
  difference() {
    for (i=[[0,0,walls],[0,pcb_height-2*mount_hole,walls],[pcb_width-mount_hole,0,walls],[pcb_width-mount_hole,pcb_height-2*mount_hole,walls]]) translate(i) difference() {
    cube([mount_hole,2*mount_hole,2*mount_hole]);
    translate([-0.01,mount_hole,mount_hole])rotate([0,90,0])cylinder(h=2*mount_hole+0.02,d=mount_hole);}
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
      translate([0,0,pcb_offset+2*pcb_thickness+solder_thickness+walls+0.01])for (i=pcb_holes_pos)translate(i)cylinder(d=mount_hole*2,h=solder_thickness);
    }
  translate([0,0,pcb_offset+2*pcb_thickness+solder_thickness+walls-0.01])for (i=pcb_holes_pos)translate(i)cylinder(d=mount_hole,h=walls+solder_thickness+0.02);
  for (i=connectors) {
    pose=i[0];
    size=i[1];
    translate(pose) cube(size,center=true);
  }
  for (pose=switches_pos) translate(pose) rotate([90,0,0])cylinder(d=8,h=10,center=true); //switches
  for (i=[[-walls-tolerance-0.01,0,0],[-walls-tolerance-0.01,pcb_height-2*mount_hole,0],[pcb_width+tolerance-0.01,0,0],[pcb_width+tolerance-0.01,pcb_height-2*mount_hole,0]]) translate(i) translate([-0.01,mount_hole,mount_hole])rotate([0,90,0])cylinder(h=walls+0.04,d=mount_hole);
  }
}

module buttons() {
  cylinder(d=buttons_outer,h=2);
  translate([0,0,2])cylinder(d=buttons_inner,h=pcb_offset-buttons_height+pcb_thickness+solder_thickness+walls+2);
}

module battery_enclosure() {
  part_width=2*mount_hole;
  part_thickness=walls;
  difference() {
    union() {
      cube([battery_w+part_thickness,battery_d+part_thickness,battery_h+part_thickness/2]);
      translate([-part_width,0,0])cube([battery_w+part_thickness+2*part_width,part_thickness/2,battery_h+part_thickness/2]);
    }
    translate([part_thickness/2,part_thickness/2,part_thickness/2+0.01]) cube([battery_w,battery_d,battery_h]);
    for (tr=[[-part_width/2,-0.01,part_width/2],
             [part_thickness+part_width/2+battery_w,-0.01,part_width/2],
             ])
      translate(tr)rotate([-90,0,0]) cylinder(d=mount_hole,h=part_thickness/2+0.02);
  }
}

if (part=="Front") front();
if (part=="Back") rotate([180,0,0])box();
if (part=="Buttons") buttons();
if (part=="Battery enclosure") battery_enclosure();

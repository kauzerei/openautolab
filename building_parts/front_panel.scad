tolerance=0.5;
pcb_width=161;
pcb_height=120;
pcb_standoff=10;
walls=1;
screen_offset=[50,38];
button1_offset=[18,10];
button2_offset=[48.5,10];
button3_offset=[79,10];
button_height=5;
switch_offset=[127,19];
switch_diameter=10;
module front() {
difference() {
union() {
translate([-2*tolerance-2*walls,-2*tolerance-2*walls,0])cube([pcb_width+4*tolerance+4*walls,pcb_height+4*tolerance+4*walls,walls]);
translate([button1_offset[0],button1_offset[1],walls])cylinder(d=10,h=pcb_standoff-button_height);
translate([button2_offset[0],button2_offset[1],walls])cylinder(d=10,h=pcb_standoff-button_height);
translate([button3_offset[0],button3_offset[1],walls])cylinder(d=10,h=pcb_standoff-button_height);
}
translate(button1_offset)cylinder(d=5,h=pcb_standoff-button_height+walls);
translate(button2_offset)cylinder(d=5,h=pcb_standoff-button_height+walls);
translate(button3_offset)cylinder(d=5,h=pcb_standoff-button_height+walls);
translate(switch_offset)cylinder(d=10,h=walls);


}
}
front();
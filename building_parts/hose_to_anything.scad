$fn= $preview ? 32 : 64;
cylinder(20,5,5);
rotate([90,0,0]) cylinder(20,5,5);
intersection() {translate([0,0,-5])cylinder(20,5,5);
    translate([0,5,0])rotate([90,0,0]) cylinder(20,5,5);}

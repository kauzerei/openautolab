module quarter_rotation(width=10,height=10) {
  intersection() {
    linear_extrude(height = height, convexity = 10, twist = 90, slices = 10, $fn = 16) {
      intersection() {
        circle(d=width);
        translate([-width/2,0])square([width/2,width/2]);
      }
    }
    cube([width/2,width/2,height]);
  }
}
module four_quarters(width,height){
quarter_rotation(width,height);
mirror([1,0,0])quarter_rotation(width,height);
mirror([0,1,0]){
  quarter_rotation(width,height);
mirror([1,0,0])quarter_rotation(width,height);}
}
four_quarters(width=10.0,height=10.0);
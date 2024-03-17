
// a tilt of 1 and 4 mm with a height of 12 produces legs that allow the case to sit flat on the table
tilt = 1;
height = 12;

difference() {
    cylinder(r1=7, r2=8, h=height + tilt);
    translate([0, 0, 3]) cylinder(r=2.3, h=20, $fn=16);
    
    translate([-7, 0, 0]) rotate([0, -atan(tilt/14), 0]) translate([0, -10, -20]) #cube([20, 20, 20]);
}
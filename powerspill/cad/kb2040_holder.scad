// utility for keeping wires organized and not touching for the kb2040 inside

difference() {
    cube([37, 23, 6], center=true);
    translate([0, 0, 1]) cube([33.5, 18, 6], center=true);
    
    for (i = [0:12]) {
        translate([2.54*(i - 6), 0, 1]) #cube([1.5, 24, 6], center=true);
    }
    translate([2.54*(-7), 0, 1]) #cube([5, 24, 6], center=true);
    translate([2.54*(7), 0, 1]) #cube([5, 24, 6], center=true);
}
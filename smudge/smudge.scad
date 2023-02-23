// this version has excellent geometry
// from here on, it's just about aesthetics
// and build nice-ity

u = 19.05;
bh = 5.0;

module keywell(margin=0, depth=5) {
    union() {
        translate([0, 0, 10]) cube([u, u, 20], center=true);
        translate([-7, -7, -depth - 1]) cube([14 + 2*margin, 14 + 2*margin, depth + 2]);
        
        translate([-2.2, -8.5, - depth - 1]) cube([4.4, 17, depth]);
    }
}

module keywell_top(margin=0.2) {
    union() {
        translate([0, 0, 10]) cube([u + 2*margin, u + 2*margin, 20], center=true);
    }
}

module ccube(xyz, c=1, center=false) {
    isq2 = 2.0/sqrt(2);
    translate([0, 0, -xyz[2]/2]) linear_extrude(xyz[2]) minkowski() {
        rotate(45) square([c, c], center=center);
        square([xyz[0] - isq2*c, xyz[1] - isq2*c], center=center);
    }
}

module ccube2(xyz, c=1, nw=false, ne=false, sw=false, se=false, center=false) {
    isq2 = 2.0/sqrt(2);
    translate([0, 0, -xyz[2]/2]) linear_extrude(xyz[2]) minkowski() {
        rotate(45) square([c, c], center=center);
        square([xyz[0] - isq2*c, xyz[1] - isq2*c], center=center);
    }
}
            
module screw() {
    union() {
        cylinder(r=1.6, h=16, $fn=30);
        translate([0, 0, -1]) cylinder(r=3.2, h=5.4, $fn=30);
        translate([0, 0, 7]) cylinder(r=2.4, h=6, $fn=30);
    }
}


radii = [70, 70, 80, 70, 60, 60];

centers = [
    [  0 + sin(4)*(70 - 2*bh), -0.25*u, 12 + 0.5], // find the formula for the 0.57
    [1*u,      0, 12],
    [2*u, 0.5*u, 8],
    [3*u + sin(4)*(70 - 2*bh) + 0.35,    0, 10 - 0.6],
    [4*u + sin(8)*(60 - 2*bh) + 0.3, -1*u, 12],
    [5*u + sin(4)*(60 - 2*bh) + 0.3, -1*u - 1.09, 12 - 1.6], // find the formula for the 2/3 and 5/3
];
rotations = [
    [0, 4, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 4, -2],
    [0.5*asin(u/(60 - bh)), 8, -4],
    [0.5*asin(u/(60 - bh)), 4, -4],
];

tent_rotation = [0, 6, 0];
tent_translation = [0, 0, 9];

firstkey = [-1, -1, -2, -2, -1, -1];
lastkey = [1, 1, 1, 1, 0, 0];

t_tent_rotation = [10, -30, 30];
t_tent_translation = [-10, -52, 16];

t_locations = [
    [1.5*u + 3, -0.5*u - 2, 4],
    [-0.5*u - 2, -0.25*u, 1.5],
    [0.5*u, 0*u, 0],
];
t_rotations = [
    [-10, -20, 0],
    [0, 10, 0],
    [0, 0, 0],
];

//modelchoice = "keyblock";
modelchoice = "cutout";

if (modelchoice == "keyblock") {
    // keyblock, useful to print when testing out the key geometry
    hrim = 1.2;
    vrim = 1.2;
    cmf = 3.0;
    difference() {

        // create a block for the key to sit in
        union() { 
            for (i = [0:5]) {
                for (j = [firstkey[i]:lastkey[i]]) {
                    r = radii[i];    
                    hull() {
                        translate(tent_translation) rotate(tent_rotation)
                        translate(centers[i]) translate([0, 0, r]) 
                        rotate(rotations[i]) rotate([j*asin(u/(r - bh)), 0, 0])
                        translate([0, 0, -r]) translate([0, 0, -5]) 
                        ccube([u + 2*hrim, u + 2*vrim, 10], cmf, center=true);
                        
                        translate([0, 0, -100]) 
                        translate(tent_translation) rotate(tent_rotation)
                        translate(centers[i]) translate([0, 0, r]) 
                        rotate(rotations[i]) rotate([j*asin(u/(r - bh)), 0, 0])
                        translate([0, 0, -r]) translate([0, 0, -5]) 
                        ccube([u + 2*hrim, u + 2*vrim, 10], cmf, center=true);
                    }
                }
            }
            
            // thumb keys
            for (i = [0:2]) {
                hull() {
                    translate(t_tent_translation) rotate(t_tent_rotation) 
                    translate(t_locations[i]) rotate(t_rotations[i]) translate([0, 0, -5]) 
                    ccube([u + 2*hrim, u + 2*vrim, 10], cmf, center=true);
                    
                    translate([0, 0, -100]) 
                    translate(t_tent_translation) rotate(t_tent_rotation) 
                    translate(t_locations[i]) rotate(t_rotations[i]) translate([0, 0, -5]) 
                    ccube([u + 2*hrim, u + 2*vrim, 10], cmf, center=true);
                }
            }
            
        }

        // cut out a hole for the key
        translate(tent_translation) rotate(tent_rotation) union() { for (i = [0:5]) {
            translate(centers[i])
            for (j = [firstkey[i]:lastkey[i]]) {
                r = radii[i];
                translate([0, 0, r]) rotate(rotations[i]) rotate([j*asin(u/(r - bh)), 0, 0])
                translate([0, 0, -r]) keywell();
            }
        }}
        
        // cut out an arch for each column to avoid wedges between keys
        translate(tent_translation) rotate(tent_rotation) union() { for (i = [0:5]) {
            translate(centers[i]) hull() {
            for (j = [firstkey[i]:lastkey[i]]) {
                r = radii[i];
                translate([0, 0, r]) rotate(rotations[i]) rotate([j*asin(u/(r - bh)), 0, 0])
                translate([0, 0, -r]) keywell_top();
            }}
        }}
        
        
        // thumb keys
        translate(t_tent_translation) rotate(t_tent_rotation) union() { for (i = [0:2]) {
            translate(t_locations[i]) rotate(t_rotations[i]) keywell();
        }}
        
        translate([0, 0, -250]) cube([500, 500, 500], center=true);

    }
}



if (modelchoice == "cutout") {
    // block used for subtractive manipulation of blender model
    hrim = 5.0;
    vrim = 5.0;
    cmf = 4.0;
    km = 0.7;
    difference() {

        // create a block for the key to sit in
        union() { 

            // cut out a hole for the key
            translate(tent_translation) rotate(tent_rotation) union() { for (i = [0:5]) {
                translate(centers[i])
                for (j = [firstkey[i]:lastkey[i]]) {
                    r = radii[i];
                    translate([0, 0, r]) rotate(rotations[i]) rotate([j*asin(u/(r - bh)), 0, 0])
                    translate([0, 0, -r]) keywell();
                }
            }}
            
            // thumb keys
            translate(t_tent_translation) rotate(t_tent_rotation) union() { for (i = [0:2]) {
                translate(t_locations[i]) rotate(t_rotations[i]) keywell();
            }}
            
            // cut out an arch for each column to avoid wedges between keys
            translate(tent_translation) rotate(tent_rotation) union() { for (i = [0:5]) {
                translate(centers[i]) hull() {
                for (j = [firstkey[i]:lastkey[i]]) {
                    r = radii[i];
                    translate([0, 0, r]) rotate(rotations[i]) rotate([j*asin(u/(r - bh)), 0, 0])
                    translate([0, 0, -r]) keywell_top(km);
                }}
            }}
            
            // thumb keys
            translate(t_tent_translation) rotate(t_tent_rotation) union() { for (i = [0:2]) {
                translate(t_locations[i]) rotate(t_rotations[i]) keywell_top(km);
            }}
            
            // fill some holes
            translate(tent_translation) rotate(tent_rotation) union() { for (i = [1:1]) {
                translate(centers[i]) hull() {
                for (j = [-1:-1]) {
                    r = radii[i];
                    translate([0, 0, r]) rotate(rotations[i]) rotate([j*asin(u/(r - bh)), 0, 0])
                    translate([-1, 0, -r]) keywell_top(km);
                }}
            }}
            translate(tent_translation) rotate(tent_rotation) union() { for (i = [0:0]) {
                translate(centers[i]) hull() {
                for (j = [0:1]) {
                    r = radii[i];
                    translate([0, 0, r]) rotate(rotations[i]) rotate([j*asin(u/(r - bh)), 0, 0])
                    translate([1, 0, -r]) keywell_top(km);
                }}
            }}
            translate(tent_translation) rotate(tent_rotation) union() { for (i = [2:2]) {
                translate(centers[i]) hull() {
                for (j = [-2:-1]) {
                    r = radii[i];
                    translate([0, 0, r]) rotate(rotations[i]) rotate([j*asin(u/(r - bh)), 0, 0])
                    translate([0.5, 0, -r]) keywell_top(km);
                }}
            }}
            translate(tent_translation) rotate(tent_rotation) union() { for (i = [3:3]) {
                translate(centers[i]) hull() {
                for (j = [0:1]) {
                    r = radii[i];
                    translate([0, 0, r]) rotate(rotations[i]) rotate([j*asin(u/(r - bh)), 0, 0])
                    translate([-1, 0, -r]) keywell_top(km);
                }}
            }}
            translate(tent_translation) rotate(tent_rotation) union() { for (i = [4:5]) {
                translate(centers[i]) hull() {
                for (j = [-1:0]) {
                    r = radii[i];
                    translate([0, 0, r]) rotate(rotations[i]) rotate([j*asin(u/(r - bh)), 0, 0])
                    translate([-0.2, 0, -r]) keywell_top(km);
                }}
            }}
            
            translate(t_tent_translation) rotate(t_tent_rotation) union() { for (i = [0]) {
                translate(t_locations[i]) rotate(t_rotations[i]) 
                translate([-3, 0, 0]) intersection() {
                    keywell_top(km);
                    translate([0, 51.5, 0]) cube([100, 100, 100], center=true);
                }
            }}
            translate(t_tent_translation) rotate(t_tent_rotation) union() { for (i = [1]) {
                translate(t_locations[i]) rotate(t_rotations[i]) 
                translate([1, 0, 0]) intersection() {
                    keywell_top(km);
                    translate([0, 45.1, 0]) cube([100, 100, 100], center=true);
                }
            }}
            
            translate([-6, -48, -1]) cube([61, 21, 15]);
            
            // electronics compartment
            union() { 
                for (i = [0:5]) {
                    for (j = [firstkey[i]:lastkey[i]]) {
                        r = radii[i];    
                        hull() {
                            translate(tent_translation) rotate(tent_rotation)
                            translate(centers[i]) translate([0, 0, r]) 
                            rotate(rotations[i]) rotate([j*asin(u/(r - bh)), 0, 0])
                            translate([0, 0, -r]) translate([0, 0, -5]) 
                            if ((j < lastkey[i]) && (j > firstkey[i])) {
                                // extend up and down
                                ccube([u - 1*hrim, 3*u - 1*vrim, 2], cmf, center=true);
                            } else if ((j < lastkey[i])) {
                                translate([0, u/2, 0]) ccube([u - 1*hrim, 2*u - 1*vrim, 2], cmf, center=true);
                            } else if ((j > firstkey[i])) {
                                translate([0, -u/2, 0]) ccube([u - 1*hrim, 2*u - 1*vrim, 2], cmf, center=true);
                            } else {
                                ccube([u - 1*hrim, u - 1*vrim, 2], cmf, center=true);
                            }
                            
                            translate([0, 0, -100]) 
                            translate(tent_translation) rotate(tent_rotation)
                            translate(centers[i]) translate([0, 0, r]) 
                            rotate(rotations[i]) rotate([j*asin(u/(r - bh)), 0, 0])
                            translate([0, 0, -r]) translate([0, 0, -5]) 
                            ccube([u - 1*hrim, u - 1*vrim, 2], cmf, center=true);
                        }
                    }
                }
                
                for (i = [0:4]) {
                    intersection() {
                        for (j = [firstkey[i]:lastkey[i]]) {
                            hull() {
                                r = radii[i];    
                                translate(tent_translation) rotate(tent_rotation)
                                translate(centers[i]) translate([0, 0, r]) 
                                rotate(rotations[i]) rotate([j*asin(u/(r - bh)), 0, 0])
                                translate([0, 0, -r]) translate([0, 0, -5]) 
                                if ((j < lastkey[i]) && (j > firstkey[i])) {
                                    // extend up and down
                                    translate([u/2, 0, 0]) ccube([2*u - 1*hrim, 3*u - 1*vrim, 2], cmf, center=true);
                                } else if ((j < lastkey[i])) {
                                    translate([u/2, u/2, 0]) ccube([2*u - 1*hrim, 2*u - 1*vrim, 2], cmf, center=true);
                                } else if ((j > firstkey[i])) {
                                    translate([u/2, -u/2, 0]) ccube([2*u - 1*hrim, 2*u - 1*vrim, 2], cmf, center=true);
                                } else {
                                    translate([u/2, 0, 0]) ccube([2*u - 1*hrim, u - 1*vrim, 2], cmf, center=true);
                                }
                                
                                translate([0, 0, -100]) 
                                translate(tent_translation) rotate(tent_rotation)
                                translate(centers[i]) translate([0, 0, r]) 
                                rotate(rotations[i]) rotate([j*asin(u/(r - bh)), 0, 0])
                                translate([0, 0, -r]) translate([0, 0, -5]) 
                                ccube([u - 1*hrim, u - 1*vrim, 2], cmf, center=true);
                            }
                        }
                        for (j = [firstkey[i + 1]:lastkey[i + 1]]) {
                            hull() {
                                r = radii[i + 1];    
                                translate(tent_translation) rotate(tent_rotation)
                                translate(centers[i + 1]) translate([0, 0, r]) 
                                rotate(rotations[i + 1]) rotate([j*asin(u/(r - bh)), 0, 0])
                                translate([0, 0, -r]) translate([0, 0, -5]) 
                                if ((j < lastkey[i + 1]) && (j > firstkey[i + 1])) {
                                    // extend up and down
                                    translate([-u/2, 0, 0]) ccube([2*u - 1*hrim, 3*u - 1*vrim, 2], cmf, center=true);
                                } else if ((j < lastkey[i + 1])) {
                                    translate([-u/2, u/2, 0]) ccube([2*u - 1*hrim, 2*u - 1*vrim, 2], cmf, center=true);
                                } else if ((j > firstkey[i + 1])) {
                                    translate([-u/2, -u/2, 0]) ccube([2*u - 1*hrim, 2*u - 1*vrim, 2], cmf, center=true);
                                } else {
                                    translate([-u/2, 0, 0]) ccube([2*u - 1*hrim, u - 1*vrim, 2], cmf, center=true);
                                }
                                
                                translate([0, 0, -100]) 
                                translate(tent_translation) rotate(tent_rotation)
                                translate(centers[i + 1]) translate([0, 0, r]) 
                                rotate(rotations[i + 1]) rotate([j*asin(u/(r - bh)), 0, 0])
                                translate([0, 0, -r]) translate([0, 0, -5]) 
                                ccube([u - 1*hrim, u - 1*vrim, 2], cmf, center=true);
                            }
                        }
                    }
                }
                
                // thumb keys
                for (i = [0:2]) {
                    hull() {
                        translate(t_tent_translation) rotate(t_tent_rotation) 
                        translate(t_locations[i]) rotate(t_rotations[i]) translate([0, 0, -5]) 
                        if (i == 0) {
                            translate([-0.5*u, 0, 0]) ccube([2*u - 1*hrim, u - 1*vrim, 2], cmf, center=true);
                        } else if (i == 1) {
                            translate([0.5*u, 0, 0]) ccube([2*u - 1*hrim, u - 1*vrim, 2], cmf, center=true);
                        } else if (i == 2) {
                            ccube([u - 1*hrim, u - 1*vrim, 2], cmf, center=true);
                        }
                        
                        translate([0, 0, -100]) 
                        translate(t_tent_translation) rotate(t_tent_rotation) 
                        translate(t_locations[i]) rotate(t_rotations[i]) translate([0, 0, -5]) 
                        ccube([u - 1*hrim, u - 1*vrim, 2], cmf, center=true);
                    }
                }
            }
            
            
            // cable holes
            translate([-3, 17, -1]) rotate([0, 0, 15]) cube([30, 10, 19]);
            translate([-5, 23.75, -1]) rotate([0, 0, 15]) cube([20, 3, 21]);
            translate([5, 24, 11]) rotate([-90, 0, 15]) union() {
                cylinder(r=6, h=11, $fn=60);
                translate([0, 0, 10]) cylinder(r=8, h=20, $fn=60);
            }
            
            translate([65, 13, 0]) rotate([0, 0, -41]) union() {
                translate([-5, -10, 0]) cube([30, 31, 6]);
                translate([-0.3, -1, 0]) cube([18.6, 21.6, 12]);
                translate([3.7, -10, 0]) cube([10.6, 21.6, 12]);
                translate([9, 20, 7.5]) rotate([-90, 0, 0]) hull() {
                    translate([-3, 0, 0]) cylinder(r=1.6, h=10, $fn=20);
                    translate([3, 0, 0]) cylinder(r=1.6, h=10, $fn=20);
                }
                translate([9, 22, 7.5]) rotate([-90, 0, 0]) hull() {
                    translate([-3, 0, 0]) cylinder(r=3.5, h=10, $fn=20);
                    translate([3, 0, 0]) cylinder(r=3.5, h=10, $fn=20);
                }
            }
        }
        
        
        
        
        translate([0, 0, -247.5]) cube([500, 500, 500], center=true);
    }

    // screw holes
    translate([-14, -35, 0]) screw();
    // translate([23, 35, 0]) screw();
    translate([57, 35, 0]) screw();
    translate([75, -45, 0]) screw();
    translate([5, -65, 0]) screw();
}
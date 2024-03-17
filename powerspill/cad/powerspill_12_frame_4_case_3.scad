

u = 19.05;

module xda() {
    // a very approximate xda profile with cutout for a cherry switch
    hull() {
        translate([0, 0, -9.5/2]) cube([13.8, 13.8, 9.5], center=true);
        translate([0, 0, -9]) cube([18.2, 18.2, 1], center=true);
    }
    
    translate([0, 0, -13.5]) cube([14, 14, 16], center=true);
    translate([0, 0, -19.75]) cube([6, 16.2, 3.5], center=true);
    
    translate([0, 0, -22.3]) cube([u, u, 1.6], center=true);
    
    translate([0, 0, -21]) cube([13, 13, 11], center=true);
}

module xda_travel(u=0, d=0, l=0, r=0) {
    // space for the keycap travel
//    translate([r/2 - l/2, u/2 - d/2, -7]) cube([20 + l + r, 20 + u + d, 59], center=true);
    // reduced variant that doesn't cover below-plate areas
    translate([r/2 - l/2, u/2 - d/2, 0]) cube([20 + l + r, 20 + u + d, 45], center=true);
}

module xda_wiring(tol=0.2) {
    // space for wiring beneath
    // in particular, for single key pcbs
    translate([0, 0, -25]) cube([u + tol, u + tol, 9], center=true);
}

module testsocket(u=0, d=0, l=0, r=0) {
    translate([r/2 - l/2, u/2 - d/2, -19]) cube([18 + l + r, 18 + u + d, 5], center=true);
}

module casesocket(u=0, d=0, l=0, r=0) {
    translate([r/2 - l/2, u/2 - d/2, -18]) cube([18 + l + r, 18 + u + d, 17], center=true);
}

starts = [-1, -1, -1, -1, -1, -1];
ends = [2, 2, 2, 2, 1, 1];

angles = [[-23.609659619023915, 0.008702217161754788, 14.44614596154696, 24.905191866145216], [-23.609659619023915, 0.008702217161754788, 14.44614596154696, 24.905191866145216], [-23.609659619023915, 0.008702217161754788, 14.44614596154696, 24.905191866145216], [-23.609659619023915, 0.008702217161754788, 14.44614596154696, 24.905191866145216], [-21.755474200464832, 0.008702217161754788, 13.762077554696603, 23.843085655484245], [-21.755474200464832, 0.008702217161754788, 13.762077554696603, 23.843085655484245]];
arc_offsets = [[[-17.210314922228584, 3.217036166278822], [0.0, 0.0], [17.357249548231927, 2.34110526323877], [33.85664243765502, 8.318413124313896]], [[-17.210314922228584, 3.217036166278822], [0.0, 0.0], [17.357249548231927, 2.34110526323877], [33.85664243765502, 8.318413124313896]], [[-17.210314922228584, 3.217036166278822], [0.0, 0.0], [17.357249548231927, 2.34110526323877], [33.85664243765502, 8.318413124313896]], [[-17.210314922228584, 3.217036166278822], [0.0, 0.0], [17.357249548231927, 2.34110526323877], [33.85664243765502, 8.318413124313896]], [[-16.264874471941795, 2.8220331376158203], [0.0, 0.0], [16.396835007576115, 2.0997743892700385], [32.02414581319361, 7.488058142901055]], [[-16.264874471941795, 2.8220331376158203], [0.0, 0.0], [16.396835007576115, 2.0997743892700385], [32.02414581319361, 7.488058142901055]]];

trans = [
    [-1*u - 0.5, 0, u*sin(2.5)],
    [0*u - 0.5, 0, u*sin(0)],
    [1*u, 9, -6],
    [2*u + u*sin(3), 0, -1],
    [3*u + u*sin(6), -11, 5 + u*sin(0)],
    [4*u + u*sin(6), -11 -  + u*sin(6), 5 + u*sin(2.50)],
];
rots = [
    [0, 5, 0],
    [0, 0, 0],
    [5, 0, 0],
    [0, 0, -3],
    [5, 0, -6],
    [5, -5, -6],
];

module cutout_thumb_v4() {
    r = 70;
    g = 10;
    h = 17.5;
    
    translate([-26.5, -50.2, 1.5]) rotate([-9, -13, 17.4]) for (i = [-1:1]) {
        translate([0, -r, 0]) rotate([-g, 0, 0]) rotate([0, 0, h*i]) rotate([g, 0, 0]) translate([0, r, 0]) 
            rotate([10, 0, 0]) xda();
    }
}

module wiring_cutout_thumb_v4() {
    r = 70;
    g = 10;
    h = 17.5;
    
    translate([-26.5, -50.2, 1.5]) rotate([-9, -13, 17.4]) for (i = [-1:1]) {
        translate([0, -r, 0]) rotate([-g, 0, 0]) rotate([0, 0, h*i]) rotate([g, 0, 0]) translate([0, r, 0]) 
            rotate([10, 0, 0]) xda_wiring();
    }
}

module testblock_thumb_v4() {
    r = 70;
    g = 10;
    h = 17.5;
    
    translate([-26.5, -50.2, 1.5]) rotate([-9, -13, 17.4]) for (i = [-1:1]) {
        
        r2 = i == -1 ? 2 : 0;
        l = i == 1 ? 2 : 0;
        u2 = i == 1 ? 2 : 0;
        
        translate([0, -r, 0]) rotate([-g, 0, 0]) rotate([0, 0, h*i]) rotate([g, 0, 0]) translate([0, r, 0]) 
            rotate([10, 0, 0]) testsocket(d=2, r=r2, l=l, u=u2);
    }
}

module cutout() {
    for (i = [0:5]) {
        tr = trans[i];
        rt = rots[i];
        
        translate(tr) rotate(rt) for (j = [starts[i]:ends[i]]) {
            a = angles[i][j+1];
            y = arc_offsets[i][j+1][0];
            z = arc_offsets[i][j+1][1];
            
            translate([0, y, z]) rotate([a, 0, 0]) xda();
            
            if (i == 3 && j == 2) {
                translate([0, 0, -u*sin(2.5)]) rotate([0, -5, 0]) translate([u, y, z]) rotate([a, 0, 0]) xda();
            }
        }
    }
}

module wiring_cutout() {
    for (i = [0:5]) {
        tr = trans[i];
        rt = rots[i];
        
        translate(tr) rotate(rt) for (j = [starts[i]:ends[i]]) {
            a = angles[i][j+1];
            y = arc_offsets[i][j+1][0];
            z = arc_offsets[i][j+1][1];
            
            translate([0, y, z]) rotate([a, 0, 0]) xda_wiring();
            
            if (i == 3 && j == 2) {
                translate([0, 0, -u*sin(2.5)]) rotate([0, -5, 0]) translate([u, y, z]) rotate([a, 0, 0]) xda_wiring();
            }
        }
    }
}

module testblock() {
    for (i = [0:5]) {
        tr = trans[i];
        rt = rots[i];
        
        for (j = [starts[i]:ends[i]]) {
            a = angles[i][j+1];
            y = arc_offsets[i][j+1][0];
            z = arc_offsets[i][j+1][1];
            
            l = i == 0 && j != starts[i] ? 2 : 0;
            r = i == 5 ? 2 : 0;
            u2 = j == ends[i] && i != 4 ? 2 : 0;
            d = j == starts[i] && i > 1 ? 2 : 0;
            
            hull() {
                translate(tr) rotate(rt) translate([0, y, z]) rotate([a, 0, 0]) testsocket(l=l, r=r, u=u2, d=d);
            }
            
            if (i == 3 && j == 2) {
                hull() {
                    translate(tr) rotate(rt) 
                        translate([0, 0, -u*sin(2.5)]) rotate([0, -5, 0]) translate([u, y, z]) rotate([a, 0, 0]) testsocket(u=2, r=2);
                }
            }
        }
    }
}

module caseblock() {
    for (i = [0:5]) {
        tr = trans[i];
        rt = rots[i];
        
        for (j = [starts[i]:ends[i]]) {
            a = angles[i][j+1];
            y = arc_offsets[i][j+1][0];
            z = arc_offsets[i][j+1][1];
            
            l = i == 0 ? 5 : 0;
            r = i == 5 ? 5 : 0;
            u2 = j == ends[i] && i != 4 ? 5 : 0;
            d = j == starts[i] && i > 1 ? 5 : 0;
            
            if (i != 1 || j != -1) hull() {
                translate(tr) rotate(rt) translate([0, y, z]) rotate([a, 0, 0]) casesocket(l=l, r=r, u=u2, d=d);
            }
            
            if (i == 3 && j == 2) {
                hull() {
                    translate(tr) rotate(rt) 
                        translate([0, 0, -u*sin(2.5)]) rotate([0, -5, 0]) translate([u, y, z]) rotate([a, 0, 0]) casesocket(u=5, r=5);
                }
            }
        }
    }
}

module caseblock_thumb_v4() {
    r = 70;
    g = 10;
    h = 17.5;
    
    translate([-26.5, -50.2, 1.5]) rotate([-9, -13, 17.4]) for (i = [-1:1]) {
        
        r2 = i == -1 ? 5 : 0;
        l = i == 1 ? 5 : 0;
        u2 = i == 1 ? 5 : 0;
        
        translate([0, -r, 0]) rotate([-g, 0, 0]) rotate([0, 0, h*i]) rotate([g, 0, 0]) translate([0, r, 0]) 
            rotate([10, 0, 0]) casesocket(d=5, r=r2, l=l, u=u2);
    }
}

module cutout_thumb_travel_v4() {
    r = 70;
    g = 10;
    h = 17.5;
    
    translate([-26.5, -50.2, 1.5]) rotate([-9, -13, 17.4]) for (i = [-1:1]) {
        
        l2 = i == -1 ? 12 : 
             i == 0 ? 1.5 :
             0;
        r2 = i == 1 ? 25 : 
             i == 0 ? 1.5 :
             0;
        u2 = 0;// i == 1 ? 5 : 0;
        d2 = 0;// i == 1 ? 5 : 0;
        
        translate([0, -r, 0]) rotate([-g, 0, 0]) rotate([0, 0, h*i]) rotate([g, 0, 0]) translate([0, r, 0]) 
            rotate([10, 0, 0]) xda_travel(l=l2, r=r2, u=u2, d=d2);
        
        if (i == -1) {
            translate([0, -r, 0]) rotate([-g, 0, 0]) rotate([0, 0, h*i]) rotate([g, 0, 0]) translate([0, r, 0]) 
                rotate([10, 0, 0]) xda_travel(u=15);
        }
    }
}

module cutout_travel() {
    for (i = [0:5]) {
        tr = trans[i];
        rt = rots[i];
        
        translate(tr) rotate(rt) for (j = [starts[i]:ends[i]]) {
            a = angles[i][j+1];
            y = arc_offsets[i][j+1][0];
            z = arc_offsets[i][j+1][1];
            
            l2 = i == 5 && (j == -1 || j == 1) ? 15 :
                 i == 2 && j == -1 ? 15 :
                 i == 3 && j == 2 ? 15 :
                 i == 1 && j == 2 ? 15 :
                 0;
            r2 = i == 3 && j == -1 ? 15 :
                 i == 2 && j == -1 ? 15 :
                 i == 3 && j == 2 ? 15 :
                 i == 1 && j == 2 ? 15 :
                 i == 4 && j == -1 ? 15 :
                 0;
            u2 = i == 5 && j == 0 ? 15 : 
                 i == 0 && (j == 0 || j == 1) ? 15 : 
                 0;
            d2 = i == 5 && j == 0 ? 15 : 
                 i == 0 && (j == -1 || j == 0 || j == 1) ? 15 : 
                 0;
            
            translate([0, y, z]) rotate([a, 0, 0]) xda_travel(l=l2, r=r2, u=u2, d=d2);
            
            if (i == 3 && j == 2) {
                translate([0, 0, -u*sin(2.5)]) rotate([0, -5, 0]) translate([u, y, z]) rotate([a, 0, 0]) 
                    xda_travel(d=15);
            }
        }
    }
}

difference() {
//    union() {
//        translate([0, 0, 35]) rotate([-5.008702217161754788, 0, 0]) caseblock();
//        translate([0, 0, 35]) rotate([-5.008702217161754788, 0, 0]) caseblock_thumb_v4();
//    }
//    union() {
//        translate([0, 0, 35]) rotate([-5.008702217161754788, 0, 0]) testblock();
//        translate([0, 0, 35]) rotate([-5.008702217161754788, 0, 0]) testblock_thumb_v4();
//    }
    union() {
        #translate([0, 0, 35]) rotate([-5.008702217161754788, 0, 0]) cutout();
        #translate([0, 0, 35]) rotate([-5.008702217161754788, 0, 0]) cutout_thumb_v4();
    }
//    union() {
//        #translate([0, 0, 35]) rotate([-5.008702217161754788, 0, 0]) wiring_cutout();
//        #translate([0, 0, 35]) rotate([-5.008702217161754788, 0, 0]) wiring_cutout_thumb_v4();
//    }
//    union() {
//        #translate([0, 0, 35]) rotate([-5.008702217161754788, 0, 0]) cutout_travel();
//        #translate([0, 0, 35]) rotate([-5.008702217161754788, 0, 0]) cutout_thumb_travel_v4();
//    }
    
//    translate([0, 0, -1000]) cube([2000, 2000, 2000], center=true);
}
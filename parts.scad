// A robot wheel
module wheel(diameter, width) {
    translate([0,0,diameter/2]) rotate([0,90,0]) cylinder(width, d=diameter, $fn=40);
}

// The WCP 2-CIM dog-style gearbox.
module not_reversed_shifting_gearbox(num_cims=3) {
    translate([0,-5.39/2,-1.75]) {
        if(num_cims == 2) cube([6.92,5.39,4.6]);
        else if(num_cims == 3) cube([6.92,5.39,7.66]);
    }
}

// The WCP 2-CIM dog-style gearbox.
module shifting_gearbox() {
    translate([0,-7.7/2,-1.75]) cube([3.61,7.7,6.1]);
}

// The 2/3-CIM single stage 5.33:1 gearbox.
module non_shifting_gearbox(num_cims=2) {
    translate([0,-6.33/2,-2.07]) {
       if(num_cims == 2) cube([5.95,6.33,4.7]);
       else if(num_cims == 3) cube([5.95,6.33,5.24]);
    }
}

// The required robot battery.
module battery() {
    translate([-7.1/2,0,0]) cube([7.1,6.58,3]);
}

// The Andymark 0.88 CFM compressor
module little_compressor() {
    translate([-2.11/2,0,0]) cube([2.11,5.94,4.53]);
}

// The Andymark 1.1 CFM compressor
module big_compressor() {
    translate([-3.27/2,0,0]) cube([3.27,6.75,5.25]);
}

// CIM motor
module cim() {
    rotate([0,90,0]) cylinder(4.34,d=2.5, $fn=40);
}

// Mini-CIM motor
module minicim() {
    rotate([0,90,0]) cylinder(3.36,d=2.5, $fn=40);
}

// A p80 gearbox with a Mini-CIM attached
module p80_minicim() {
    translate([0,-1.25,0]) cube([3.2,2.5,2.5]);
    translate([3.2,0,1.25]) minicim();
}

// 30 tooth HTD pulley
module pulley_30t() {
    rotate([0,90,0]) cylinder(.866, d=2.01, $fn=40);
}

// 574 mL air tank
module tank() {
    union() {
        translate([0,0,2]) rotate([0,90,0]) cylinder(12.5, d=2.75, $fn=40);
        translate([0,-2.75/2,0]) cube([12.5,2.75,2]);
    }
}
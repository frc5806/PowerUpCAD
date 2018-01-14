// Power cube!
module box() {
    translate([-6.5,-6.5]) cube([13,13,11]);
}

// The bump for the wire protector, hackily done.
module bump() {
    hull() {
    translate([0,0,0]) cube([28,1,.01]);
    translate([0,0.5,.74]) cube([28,.01,.01]);
    }
}

// A 15 degree ramp.
module ramp() {
    rotate([15,0]) cube([30,30,.01]);
}

// The fence for the switch
module fence() {
    translate([-10,0]) cube([48,0.25,18]);
}
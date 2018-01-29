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
    rotate([15.35,0]) cube([35,13.22,.01]);
}

// The fence for the switch
module switch_fence() {
    translate([-10,0]) cube([48,0.25,18]);
}

// An equivalent fence for the scale.
// Parameter is one of "DOWN", "MID", or "UP"
module scale_fence(position) {
    translate([-10,0]) cube([48,0.25, position == "UP" ? 72 : position == "DOWN" ? 48 : 60]);
}

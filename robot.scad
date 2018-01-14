include <field.scad>;
include <parts.scad>;

// Chassis parameters
CHASSIS_WIDTH = 28;
CHASSIS_LENGTH = 28;
CHASSIS_CUTOUT_WIDTH = 16;
CHASSIS_FRONT_BUMPER_WIDTH = (CHASSIS_WIDTH-CHASSIS_CUTOUT_WIDTH) / 2;
CHASSIS_CUTOUT_DEPTH = 10;

// Chassis box tube parameters
BOX_TUBE_WIDTH = 1;
BOX_TUBE_HEIGHT = 2;

// Bumper parameters
BUMPER_THICK = 3.25;
BUMPER_HEIGHT = 5;

// Wheel parameters
WHEEL_DIAMETER = 6;
WHEEL_WIDTH = 1.5;
WHEEL_X_SPACING = 0.125; // Distance from edge of wheel to left and right box tubing.
WHEEL_Y_SPACING = 0.25; // Distance from wheel to front and rear box tubing.
WHEEL_CENTER_OFFSET = 0.375; // Vertical offset for the wheels into the box tube.

module bumpers(width, length, cutout_width, thick, height) {
    translate([-thick,-thick,0]) cube([thick,length+2*thick,height]);
    translate([-thick,-thick,0]) cube([width+2*thick,thick,height]);
    translate([width,-thick,0])  cube([thick,length+2*thick,height]);
    
    translate([-thick,length,0])cube([thick+(width-cutout_width)/2,thick,height]);
    translate([(width+cutout_width)/2,length,0])cube([thick+(width-cutout_width)/2,thick,height]);
}

module box_chassis(width, length, cutout_width, cutout_depth) {
    
    bumper_width = (width-cutout_width)/2;
    
    cube([width,BOX_TUBE_WIDTH,BOX_TUBE_HEIGHT]);
    
    translate([0,length-BOX_TUBE_WIDTH,0]) cube([bumper_width,BOX_TUBE_WIDTH,BOX_TUBE_HEIGHT]);
    translate([width-bumper_width,length-BOX_TUBE_WIDTH,0]) cube([bumper_width,BOX_TUBE_WIDTH,BOX_TUBE_HEIGHT]);

    translate([0,0,0]) cube([BOX_TUBE_WIDTH,length,BOX_TUBE_HEIGHT]);
    translate([width-BOX_TUBE_WIDTH,0,0]) cube([BOX_TUBE_WIDTH,length,BOX_TUBE_HEIGHT]);

    translate([bumper_width-BOX_TUBE_WIDTH,0,0]) cube([BOX_TUBE_WIDTH,length,BOX_TUBE_HEIGHT]);
    translate([width-bumper_width,0,0]) cube([BOX_TUBE_WIDTH,length,BOX_TUBE_HEIGHT]);
    translate([bumper_width,length-cutout_depth-BOX_TUBE_WIDTH,0]) cube([cutout_width,BOX_TUBE_WIDTH,BOX_TUBE_HEIGHT]);
}

module full_chassis() {
    
    // Box tube chassis
    color([.2,.2,.2]) {
        translate([0,0,(WHEEL_DIAMETER-BOX_TUBE_HEIGHT)/2-WHEEL_CENTER_OFFSET])box_chassis(CHASSIS_WIDTH, CHASSIS_LENGTH, CHASSIS_CUTOUT_WIDTH, CHASSIS_CUTOUT_DEPTH);
    }
    // Bumpers
    color([0.7,0,0]) {
        translate([0,0,WHEEL_DIAMETER/2-BOX_TUBE_HEIGHT/2-WHEEL_CENTER_OFFSET]) bumpers(CHASSIS_WIDTH, CHASSIS_LENGTH, CHASSIS_CUTOUT_WIDTH, BUMPER_THICK, BUMPER_HEIGHT);
    }
    
    // (Lots) of wheels
    color([0,0,.3]) {
        translate([BOX_TUBE_WIDTH+WHEEL_X_SPACING,WHEEL_DIAMETER/2+BOX_TUBE_WIDTH+WHEEL_Y_SPACING,0]) wheel(WHEEL_DIAMETER, WHEEL_WIDTH);
        translate([BOX_TUBE_WIDTH+WHEEL_X_SPACING,CHASSIS_LENGTH-(WHEEL_DIAMETER/2+BOX_TUBE_WIDTH+WHEEL_Y_SPACING),0]) wheel(WHEEL_DIAMETER, WHEEL_WIDTH);
        translate([BOX_TUBE_WIDTH+WHEEL_X_SPACING,WHEEL_DIAMETER/2+BOX_TUBE_WIDTH+WHEEL_Y_SPACING+(CHASSIS_LENGTH-(WHEEL_DIAMETER+2.5))/2,0]) wheel(WHEEL_DIAMETER, WHEEL_WIDTH);
        
        translate([CHASSIS_WIDTH-WHEEL_WIDTH-BOX_TUBE_WIDTH-WHEEL_X_SPACING,WHEEL_DIAMETER/2+BOX_TUBE_WIDTH+WHEEL_Y_SPACING,0]) wheel(WHEEL_DIAMETER, WHEEL_WIDTH);
        translate([CHASSIS_WIDTH-WHEEL_WIDTH-BOX_TUBE_WIDTH-WHEEL_X_SPACING,CHASSIS_LENGTH-(WHEEL_DIAMETER/2+BOX_TUBE_WIDTH+WHEEL_Y_SPACING),0]) wheel(WHEEL_DIAMETER, WHEEL_WIDTH);
        translate([CHASSIS_WIDTH-WHEEL_WIDTH-BOX_TUBE_WIDTH-WHEEL_X_SPACING,WHEEL_DIAMETER/2+BOX_TUBE_WIDTH+WHEEL_Y_SPACING+(CHASSIS_LENGTH-(WHEEL_DIAMETER+2.5))/2,0]) wheel(WHEEL_DIAMETER, WHEEL_WIDTH);
    }
    
    color([0,0.4,0]) {
        if("shifting" == "shifting") {
            // Add dog-shifting gearboxes (tentatively)
            translate([CHASSIS_FRONT_BUMPER_WIDTH,CHASSIS_LENGTH/2,WHEEL_DIAMETER/2]) shifting_gearbox();
            translate([CHASSIS_WIDTH-CHASSIS_FRONT_BUMPER_WIDTH,CHASSIS_LENGTH/2,WHEEL_DIAMETER/2]) mirror([1,0,0]) shifting_gearbox();
        }
        else {
            // Add non-shifting gearboxes (tentatively)
            translate([CHASSIS_FRONT_BUMPER_WIDTH,CHASSIS_LENGTH/2,WHEEL_DIAMETER/2]) non_shifting_gearbox();
            translate([CHASSIS_WIDTH-CHASSIS_FRONT_BUMPER_WIDTH,CHASSIS_LENGTH/2,WHEEL_DIAMETER/2]) mirror([1,0,0]) non_shifting_gearbox();
        }
    }
    
    COMPRESSOR_TYPE = "little";
    COMPRESSOR_WIDTH = (COMPRESSOR_TYPE == "little") ? 2.11 : 3.27;
    
    // Add in a battery?
    color([0.15,0.15,0.15]) {
        translate([CHASSIS_WIDTH/2,BOX_TUBE_WIDTH,1.625]) battery();
    }
    
    // And compressor?
    color([0.2,0.2,0.2]) {
        translate([CHASSIS_WIDTH/2-(7.1+COMPRESSOR_WIDTH)/2-.25,BOX_TUBE_WIDTH+0.25,1.625]) if(COMPRESSOR_TYPE == "little") little_compressor();
        else big_compressor();
    }
    
    // Build the arm
    ARM_ANGLE = 0;
    PIVOT_POINT_Y = 4.25;
    PIVOT_POINT_Z = 3;
    translate([0,PIVOT_POINT_Y,PIVOT_POINT_Z])
    rotate([ARM_ANGLE,0,0])
    translate([0,-PIVOT_POINT_Y,-PIVOT_POINT_Z])
    {
        // Mark the axis of rotation for convenience
        color([1,1,1]) {
            translate([0,PIVOT_POINT_Y,PIVOT_POINT_Z]) rotate([0,90,0]) cylinder(CHASSIS_WIDTH,d=0.5, $fn=60);
        }
    
        // Put a pretty box there for visualization
        color([.9,1,0.2]) {
            translate([CHASSIS_WIDTH/2,25.5,0]) box();
        }
    }
}

// ---- Robot stuff ----

// Robot chassis
full_chassis();

// For determining the height of the chassis
// cube([1,1,1.625]);

// ---- Field elements ----

// Can we shoot to the switch?
// translate([0,32]) fence();

// Can we pass over the wire protector?
// translate([0,25.5]) bump();
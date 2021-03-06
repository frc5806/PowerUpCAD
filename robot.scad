include <field.scad>;
include <parts.scad>;

// Chassis parameters
CHASSIS_WIDTH = 28;
CHASSIS_LENGTH = 28;
CHASSIS_CUTOUT_WIDTH = 16;
CHASSIS_FRONT_BUMPER_WIDTH = (CHASSIS_WIDTH-CHASSIS_CUTOUT_WIDTH) / 2;
CHASSIS_CUTOUT_DEPTH = 9;

// Chassis box tube parameters
BOX_TUBE_WIDTH = 1;
BOX_TUBE_HEIGHT = 2;

// Superstructure box tube parameters
SUPER_TUBE_WIDTH = 1;
SUPER_TUBE_HEIGHT = 1;
SUPER_HEIGHT = 3;

// Bumper parameters
BUMPER_THICK = 3.25;
BUMPER_HEIGHT = 5;

// Wheel parameters
WHEEL_DIAMETER = 6;
WHEEL_WIDTH = 1.5;
WHEEL_X_SPACING = 0.125; // Distance from edge of wheel to left and right box tubing.
WHEEL_Y_SPACING = 0.1875; // Distance from wheel to front and rear box tubing.
WHEEL_CENTER_OFFSET = 0.375; // Vertical offset for the wheels into the box tube.

// Climber parameters
CLIMBER_Y_LOC = 8.75;
CLIMBER_Z_OFFSET = SUPER_HEIGHT-2.5;
CLIMBER_CENTER_WIDTH = 2.5;
CLIMBER_WINCH_DIAMETER = 1.5;

// Other derived, useful parameters
BASE_CHASSIS_HEIGHT = (WHEEL_DIAMETER-BOX_TUBE_HEIGHT)/2-WHEEL_CENTER_OFFSET;
BUMPER_WIDTH = (CHASSIS_WIDTH-CHASSIS_CUTOUT_WIDTH)/2;

// Extra bar parameters
BAR_DIAMETER = 1;
BAR_HEIGHT = 4;
BAR_X_LOC = BUMPER_WIDTH; //+SUPER_TUBE_WIDTH;
BAR_Y_LOC = 5;

IO_ARM_X_POS = 4;
IO_ARM_Y_POS = 24;
IO_ARM_LENGTH = 11;
        
module io_arm(){
    color([0.5,0.5,0.5]) translate([-.5,-.5,0]) cube([1,IO_ARM_LENGTH-.5,1]);
    color([0.1,0.1,0.1]) translate([-.5,IO_ARM_LENGTH-1,0]) cube([2,2,1]);
    color([0.9,0,0.9])translate([.5,IO_ARM_LENGTH,-.5]) cylinder(1, d=4, center=true, $fn=40);
}
module bumpers(width, length, cutout_width, thick, height) {
    translate([-thick,-thick,0]) cube([thick,length+2*thick,height]);
    translate([-thick,-thick,0]) cube([width+2*thick,thick,height]);
    translate([width,-thick,0])  cube([thick,length+2*thick,height]);
    
    translate([-thick,length,0])cube([thick+(width-cutout_width)/2,thick,height]);
    translate([(width+cutout_width)/2,length,0])cube([thick+(width-cutout_width)/2,thick,height]);
}

module box_chassis(width, length, cutout_width, cutout_depth, climber_y_loc, climber_center_width) {
    
    bumper_width = (width-cutout_width)/2;
    
    // ---- CHASSIS ----
    
    // Outer 3 beams
    cube([width,BOX_TUBE_WIDTH,BOX_TUBE_HEIGHT]);
    translate([0,0,0]) cube([BOX_TUBE_WIDTH,length,BOX_TUBE_HEIGHT]);
    translate([width-BOX_TUBE_WIDTH,0,0]) cube([BOX_TUBE_WIDTH,length,BOX_TUBE_HEIGHT]);

    // Front 2 bumpers
    translate([0,length-BOX_TUBE_WIDTH,0]) cube([bumper_width,BOX_TUBE_WIDTH,BOX_TUBE_HEIGHT]);
    translate([width-bumper_width,length-BOX_TUBE_WIDTH,0]) cube([bumper_width,BOX_TUBE_WIDTH,BOX_TUBE_HEIGHT]);
    
    // Inner two channels
    translate([bumper_width-BOX_TUBE_WIDTH,0,0]) cube([BOX_TUBE_WIDTH,length,BOX_TUBE_HEIGHT]);
    translate([width-bumper_width,0,0]) cube([BOX_TUBE_WIDTH,length,BOX_TUBE_HEIGHT]);

    // Cutout bridge
    translate([bumper_width,length-cutout_depth-BOX_TUBE_WIDTH,0]) cube([cutout_width,BOX_TUBE_WIDTH,BOX_TUBE_HEIGHT]);
    
    // Climber bottom beam
    translate([bumper_width,climber_y_loc-BOX_TUBE_HEIGHT/2,CLIMBER_Z_OFFSET]) cube([cutout_width,BOX_TUBE_HEIGHT,BOX_TUBE_WIDTH]);
    
    // ---- SUPER ----
    translate([0,0,BOX_TUBE_HEIGHT]) {
        // -- Pillars --
        
        // Back pillars
        cube([SUPER_TUBE_WIDTH,SUPER_TUBE_HEIGHT,SUPER_HEIGHT]);
        translate([CHASSIS_WIDTH-BOX_TUBE_WIDTH,0,0]) cube([SUPER_TUBE_WIDTH,SUPER_TUBE_HEIGHT,SUPER_HEIGHT]);
        translate([(CHASSIS_WIDTH-BOX_TUBE_WIDTH)/2,0,0]) cube([SUPER_TUBE_WIDTH,SUPER_TUBE_HEIGHT,SUPER_HEIGHT]);
        
        FRONT_PILLAR_Y = 9; //length-cutout_depth-2*SUPER_TUBE_WIDTH;
        
        // Front outer pillars
        translate([0,FRONT_PILLAR_Y,0]) cube([SUPER_TUBE_WIDTH,SUPER_TUBE_HEIGHT,SUPER_HEIGHT]);
        translate([CHASSIS_WIDTH-SUPER_TUBE_WIDTH,FRONT_PILLAR_Y,0]) cube([SUPER_TUBE_WIDTH,SUPER_TUBE_HEIGHT,SUPER_HEIGHT]);
        
        // Front inner pillars
        translate([bumper_width-SUPER_TUBE_WIDTH,FRONT_PILLAR_Y,0]) cube([SUPER_TUBE_WIDTH,SUPER_TUBE_HEIGHT,SUPER_HEIGHT]);
        translate([width-bumper_width,FRONT_PILLAR_Y,0]) cube([SUPER_TUBE_WIDTH,SUPER_TUBE_HEIGHT,SUPER_HEIGHT]);
        
        // Side beams
        translate([width-SUPER_TUBE_WIDTH,0,SUPER_HEIGHT-SUPER_TUBE_HEIGHT]) cube([SUPER_TUBE_WIDTH,FRONT_PILLAR_Y,SUPER_TUBE_HEIGHT]);
        translate([0,0,SUPER_HEIGHT-SUPER_TUBE_HEIGHT]) cube([SUPER_TUBE_WIDTH,FRONT_PILLAR_Y,SUPER_TUBE_HEIGHT]);
        
        // Back beam
        translate([0,0,SUPER_HEIGHT-SUPER_TUBE_HEIGHT]) cube([width,SUPER_TUBE_WIDTH,SUPER_TUBE_HEIGHT]);
        
        // Front beams
        translate([0,FRONT_PILLAR_Y,SUPER_HEIGHT-SUPER_TUBE_HEIGHT]) cube([(width-CLIMBER_CENTER_WIDTH)/2,SUPER_TUBE_WIDTH,SUPER_TUBE_HEIGHT]);
        translate([(width+CLIMBER_CENTER_WIDTH)/2,FRONT_PILLAR_Y,SUPER_HEIGHT-SUPER_TUBE_HEIGHT]) cube([(width-CLIMBER_CENTER_WIDTH)/2,SUPER_TUBE_WIDTH,SUPER_TUBE_HEIGHT]);
        
        // Inner beams
        translate([(width-CLIMBER_CENTER_WIDTH)/2-SUPER_TUBE_WIDTH,0,SUPER_HEIGHT-SUPER_TUBE_HEIGHT]) cube([SUPER_TUBE_WIDTH,FRONT_PILLAR_Y,SUPER_TUBE_HEIGHT]);
        translate([(width+CLIMBER_CENTER_WIDTH)/2,0,SUPER_HEIGHT-SUPER_TUBE_HEIGHT]) cube([SUPER_TUBE_WIDTH,FRONT_PILLAR_Y,SUPER_TUBE_HEIGHT]);
        
        // Back bar pillars
        translate([BAR_X_LOC-SUPER_TUBE_HEIGHT,0,SUPER_HEIGHT]) cube([SUPER_TUBE_WIDTH,SUPER_TUBE_HEIGHT,BAR_HEIGHT]);
        translate([width-BAR_X_LOC,0,SUPER_HEIGHT]) cube([SUPER_TUBE_WIDTH,SUPER_TUBE_HEIGHT,BAR_HEIGHT]);
        
        // Front bar pillars
        translate([BAR_X_LOC-SUPER_TUBE_HEIGHT,FRONT_PILLAR_Y,SUPER_HEIGHT]) cube([SUPER_TUBE_WIDTH,SUPER_TUBE_HEIGHT,BAR_HEIGHT]);
        translate([width-BAR_X_LOC,FRONT_PILLAR_Y,SUPER_HEIGHT]) cube([SUPER_TUBE_WIDTH,SUPER_TUBE_HEIGHT,BAR_HEIGHT]);
        
        // Bar beams
        translate([BAR_X_LOC-SUPER_TUBE_HEIGHT,0,SUPER_HEIGHT+BAR_HEIGHT-SUPER_TUBE_HEIGHT]) cube([SUPER_TUBE_WIDTH,FRONT_PILLAR_Y,SUPER_TUBE_HEIGHT]);
        translate([width-BAR_X_LOC,0,SUPER_HEIGHT+BAR_HEIGHT-SUPER_TUBE_HEIGHT]) cube([SUPER_TUBE_WIDTH,FRONT_PILLAR_Y,SUPER_TUBE_HEIGHT]);
        
        // Cross tube
        translate([BAR_X_LOC,BAR_Y_LOC,SUPER_HEIGHT+BAR_HEIGHT-SUPER_TUBE_HEIGHT/2]) rotate([0,90,0]) cylinder(CHASSIS_WIDTH-2*BAR_X_LOC,d=BAR_DIAMETER, $fn=60);
    }
}

module full_chassis(POSITION) {
    
    // Box tube chassis
    color([.2,.2,.2]) {
        translate([0,0,BASE_CHASSIS_HEIGHT]) box_chassis(CHASSIS_WIDTH, CHASSIS_LENGTH, CHASSIS_CUTOUT_WIDTH, CHASSIS_CUTOUT_DEPTH, CLIMBER_Y_LOC, CLIMBER_CENTER_WIDTH);
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
    
    // Corresponding (lots of pulleys)
    color([0,0.6,1.0]) {
        translate([BOX_TUBE_WIDTH+WHEEL_X_SPACING+WHEEL_WIDTH,WHEEL_DIAMETER/2+BOX_TUBE_WIDTH+WHEEL_Y_SPACING,WHEEL_DIAMETER/2]) pulley_30t();
    }
    
    color([0,0.4,0]) {
        GEARBOX_STYLE = "shifting";
        if(GEARBOX_STYLE == "shifting") {
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
    
    // Add in a battery?
    color([0.15,0.15,0.15]) {
        translate([CHASSIS_WIDTH/2,CHASSIS_LENGTH-CHASSIS_CUTOUT_DEPTH-BOX_TUBE_WIDTH-6.58-.25,(WHEEL_DIAMETER-BOX_TUBE_HEIGHT)/2-WHEEL_CENTER_OFFSET]) battery();
    }
    
    // And compressor?
    COMPRESSOR_TYPE = "little";
    COMPRESSOR_WIDTH = (COMPRESSOR_TYPE == "little") ? 2.11 : 3.27;
    color([0.2,0.2,0.2]) {
        translate([(CHASSIS_WIDTH+CHASSIS_CUTOUT_WIDTH)/2-BOX_TUBE_WIDTH-.5,BOX_TUBE_WIDTH+0.25,(WHEEL_DIAMETER-BOX_TUBE_HEIGHT)/2-WHEEL_CENTER_OFFSET]) if(COMPRESSOR_TYPE == "little") little_compressor();
        else big_compressor();
    }
    
    // Add in air tanks, too (config 1)
    color([0.4,0.4,0.4]) {
        translate([(CHASSIS_WIDTH-CHASSIS_CUTOUT_WIDTH)/2+.5,BOX_TUBE_WIDTH+.25+2.75/2,BASE_CHASSIS_HEIGHT]) tank();
        translate([(CHASSIS_WIDTH-CHASSIS_CUTOUT_WIDTH)/2+.5,BOX_TUBE_WIDTH+.5+3*2.75/2,BASE_CHASSIS_HEIGHT]) tank();
    }
    
    // Put in the climber winch
    color([0.6,0,1]) {
        translate([0,0,CLIMBER_Z_OFFSET]) {
            // P80s
            translate([CHASSIS_WIDTH/2+CLIMBER_CENTER_WIDTH/2,CLIMBER_Y_LOC,(WHEEL_DIAMETER-BOX_TUBE_HEIGHT)/2+BOX_TUBE_WIDTH-WHEEL_CENTER_OFFSET]) p80_minicim();
            translate([CHASSIS_WIDTH/2-CLIMBER_CENTER_WIDTH/2,CLIMBER_Y_LOC,(WHEEL_DIAMETER-BOX_TUBE_HEIGHT)/2+BOX_TUBE_WIDTH-WHEEL_CENTER_OFFSET]) mirror([1,0,0]) p80_minicim();
            // Winch
            translate([CHASSIS_WIDTH/2,CLIMBER_Y_LOC,(WHEEL_DIAMETER-BOX_TUBE_HEIGHT)/2+BOX_TUBE_WIDTH-WHEEL_CENTER_OFFSET+1.25]) rotate([0,90,0]) cylinder(CLIMBER_CENTER_WIDTH, d=CLIMBER_WINCH_DIAMETER, center=true, $fn=60);
        }
        // Hex shaft
        translate([CHASSIS_WIDTH/2,CLIMBER_Y_LOC-5,BASE_CHASSIS_HEIGHT+BOX_TUBE_HEIGHT+SUPER_HEIGHT-SUPER_TUBE_HEIGHT/2]) rotate([0,90,0]) cylinder(CLIMBER_CENTER_WIDTH, r=.5/sqrt(3), center=true, $fn=6);
        // Mechanism on that shaft
        translate([CHASSIS_WIDTH/2,CLIMBER_Y_LOC-5,BASE_CHASSIS_HEIGHT+BOX_TUBE_HEIGHT+SUPER_HEIGHT-SUPER_TUBE_HEIGHT/2]) rotate([0,90,0]) cylinder(.75, r=.75, center=true, $fn=60);
        translate([CHASSIS_WIDTH/2-.5,CLIMBER_Y_LOC-5,BASE_CHASSIS_HEIGHT+BOX_TUBE_HEIGHT+SUPER_HEIGHT-SUPER_TUBE_HEIGHT/2]) rotate([0,90,0]) cylinder(.2, r=1, center=true, $fn=60);
        translate([CHASSIS_WIDTH/2+.5,CLIMBER_Y_LOC-5,BASE_CHASSIS_HEIGHT+BOX_TUBE_HEIGHT+SUPER_HEIGHT-SUPER_TUBE_HEIGHT/2]) rotate([0,90,0]) cylinder(.2, r=1, center=true, $fn=60);
    }
    
    // Add in the climber's ratcheting mechanism
    // lol will do it someday
    
    // Build the arm
    MAX_ARM_ANGLE = 70;
    ARM_ANGLE = POSITION == "loading" || POSITION == "stowed" ? 0 : MAX_ARM_ANGLE;
    ARM_ANGLE = 70; // Reassign the angle for testing purpose if desired
    PIVOT_POINT_Y = 0.5; //4.25;
    PIVOT_POINT_Z = 10;//7.125;
    LAC_ANGLE = 20;
    translate([0,PIVOT_POINT_Y,PIVOT_POINT_Z])
    rotate([ARM_ANGLE,0,0])
    translate([0,-PIVOT_POINT_Y,-PIVOT_POINT_Z])
    {
        // Mark the axis of rotation for convenience
        color([1,1,1]) {
            translate([0,PIVOT_POINT_Y,PIVOT_POINT_Z]) rotate([0,90,0]) cylinder(CHASSIS_WIDTH,d=0.5, $fn=60);
        }
        // Chromoly
        color([0.4,.4,0.6]) {
            // Long beams
            translate([BAR_X_LOC-SUPER_TUBE_WIDTH-0.5,0,PIVOT_POINT_Z-.5]) cube([0.5,CHASSIS_LENGTH-CHASSIS_CUTOUT_DEPTH,1]);
            translate([CHASSIS_WIDTH-BAR_X_LOC+SUPER_TUBE_WIDTH,0,PIVOT_POINT_Z-.5]) cube([0.5,CHASSIS_LENGTH-CHASSIS_CUTOUT_DEPTH,1]);
            
            // Back vertical pieces
            translate([BUMPER_WIDTH,CHASSIS_LENGTH-CHASSIS_CUTOUT_DEPTH,0]) cube([0.5,1,PIVOT_POINT_Z+.5]);
            translate([CHASSIS_WIDTH-BUMPER_WIDTH-.5,CHASSIS_LENGTH-CHASSIS_CUTOUT_DEPTH,0]) cube([0.5,1,PIVOT_POINT_Z+.5]);
            
            // Front vertical pieces
            translate([BUMPER_WIDTH,CHASSIS_LENGTH-1,0]) cube([0.5,1,PIVOT_POINT_Z+.5]);
            translate([CHASSIS_WIDTH-BUMPER_WIDTH-.5,CHASSIS_LENGTH-1,0]) cube([0.5,1,PIVOT_POINT_Z+.5]);
            
            // Upper beams
            translate([BUMPER_WIDTH,CHASSIS_LENGTH-CHASSIS_CUTOUT_DEPTH,PIVOT_POINT_Z-.5]) cube([0.5,CHASSIS_CUTOUT_DEPTH,1]);
            translate([CHASSIS_WIDTH-BUMPER_WIDTH-.5,CHASSIS_LENGTH-CHASSIS_CUTOUT_DEPTH,PIVOT_POINT_Z-.5]) cube([0.5,CHASSIS_CUTOUT_DEPTH,1]);
            
            // Lower crossbar
            translate([BUMPER_WIDTH,CHASSIS_LENGTH-CHASSIS_CUTOUT_DEPTH-.5,5.125]) cube([CHASSIS_CUTOUT_WIDTH,.5,1]);
            
            // Upper crossbar
            translate([BAR_X_LOC-SUPER_TUBE_WIDTH,CHASSIS_LENGTH-CHASSIS_CUTOUT_DEPTH-.5,PIVOT_POINT_Z-.5]) cube([CHASSIS_WIDTH-2*(BAR_X_LOC-SUPER_TUBE_WIDTH),.5,1]);
            
            // Vertical crossbar connecting bar
            translate([CHASSIS_WIDTH/2-.5,CHASSIS_LENGTH-CHASSIS_CUTOUT_DEPTH-.5,6.125]) cube([1,.5,PIVOT_POINT_Z+.5-6.125]);
            
            // Shovel
            translate([BUMPER_WIDTH,CHASSIS_LENGTH-CHASSIS_CUTOUT_DEPTH,0])cube([CHASSIS_CUTOUT_WIDTH,CHASSIS_CUTOUT_DEPTH,.125]);
        }
            
        // Mark position #2 of lac attatchment
        color([1,.5,.5]) translate([4,PIVOT_POINT_Y+cos(LAC_ANGLE)*10.43,PIVOT_POINT_Z+sin(LAC_ANGLE)*10.43]) cube([1,1,1], center=true);
        
        // Pistons
        color([1,0.5,0]) {
            // Piston #1
            translate([CHASSIS_WIDTH/2-.5,6.5,5.625])
            rotate([-90,0,0]) cylinder(12,d=.86, $fn=60);
            // Piston #1
            translate([CHASSIS_WIDTH/2+.5,6.5,5.625])
            rotate([-90,0,0]) cylinder(12,d=.86, $fn=60);
        } 
        
        // Add in the io
        if(POSITION != "stowed"){
            translate([IO_ARM_X_POS,IO_ARM_Y_POS,PIVOT_POINT_Z-.5]) rotate([0,0,-18]) mirror([1,0,0]) io_arm();
            translate([CHASSIS_WIDTH-IO_ARM_X_POS,IO_ARM_Y_POS,PIVOT_POINT_Z-.5]) rotate([0,0,18]) io_arm();
        }
        else{
            translate([IO_ARM_X_POS,IO_ARM_Y_POS,PIVOT_POINT_Z-.5]) rotate([0,0,166]) mirror([1,0,0]) io_arm();
            translate([CHASSIS_WIDTH-IO_ARM_X_POS,IO_ARM_Y_POS,PIVOT_POINT_Z-.5]) rotate([0,0,-166]) io_arm();
        }
        
        
        // pretty box
        if(POSITION != "stowed"){
            color([.9,1,0.2]) {
                translate([CHASSIS_WIDTH/2,25.5,0.125]) box();
            }
        }
        else{
            color([.9,1,0.2]) {
                translate([CHASSIS_WIDTH/2,45,0.125]) box();
            }
        }
    }
    
    // Mark position #1 of lac attatchment
    ang = -20;
    color([1,.5,.5]) 
    translate([0,17*cos(ang),17*sin(ang)])translate([4,PIVOT_POINT_Y+cos(LAC_ANGLE)*10.43,PIVOT_POINT_Z+sin(LAC_ANGLE)*10.43]) rotate([0,0,0]) cube([1,1,1], center=true);
}

// ---- ROBOT STUFF ----

// Robot chassis
POSITION = "stowed";// (Strings) "stowed, "loading", "raised", "shooting", or "shot" : correspo
full_chassis(POSITION);

// For determining the height of the chassis
// cube([1,1,1.625]);

// ---- FIELD ELEMENTS ----

// Can we shoot to the switch?
translate([0,35]) switch_fence();

// Or the scale?
//translate([0,35]) scale_fence("UP");

// Can we pass over the wire protector?
 //translate([0,25.5]) bump();

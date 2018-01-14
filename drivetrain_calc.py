from math import *
import sys, json

if len(sys.argv) == 1:
    print('Please provide the filename of the robot json descriptor')
    sys.exit(0)
elif sys.argv[1] == '--help':
    print('Required json parameters:')
    print('  motor_type: string (type if in { cim, minicim, bag, 775pro }) or [float (free speed), float (stall torque)]')
    print('  num_motors: int')
    print('  gear_reduction: float')
    print('  wheel_diameter: float')
    print('  coeff_friction: float')
    print('  weight: float')
    print('  wheelbase: float')
    print('  com_height: float')
    print('  wheels_linked: true/false')
    print('  com_displacement: float (positive is fore; negative aft)')
    print('Default units:')
    print('  length: inches')
    print('  lateral speed: fps')
    print('  rotational speed: rpm')
    print('  force: lb')
    print('  torque: lb-in')
    sys.exit(0)
elif sys.argv[1] == '--template' and len(sys.argv) == 3:
    template = {
        'motor_type': 'string / [float, float]',
        'num_motors': 'int',
        'gear_reduction': 'float',
        'wheel_diameter': 'float',
        'coeff_friction': 'float',
        'weight': 'float',
        'wheelbase': 'float',
        'com_height': 'float',
        'com_displacement': 'float',
        'wheels_linked': 'true/false'
    }
    with open(sys.argv[2], 'w') as file:
        file.write(json.dumps(template, indent=4))
    sys.exit(0)
    
def motor_specs(motor_type):
    return {
        'cim': (5310, 21.4),
        'minicim': (5840, 12.5),
        'bag': (13180, 3.8),
        '775pro': (18730, 6.3)
    }[motor_type.lower()]

# Read in specs of robot
with open(sys.argv[1], 'r') as file:
    robot = json.loads(file.read())
    
# Get motor stats
if type(robot['motor_type']) == str:
    robot['free'], robot['stall'] = motor_specs(robot['motor_type'])
else: robot['free'], robot['stall'] = robot['motor_type'][0], robot['motor_type'][1]

# Calculate the maximum robot speed
max_robot_speed = (robot['free'] / robot['gear_reduction']) * (3.14159 * robot['wheel_diameter']) / 720

# Mark the starting time!
time = 0

# For 20 different speeds
for robot_speed in range(ceil(max_robot_speed)):

    print('time', round(time, 2))

    # Find the motor speed
    motor_speed = robot_speed * 720 / (robot['wheel_diameter'] * 3.14159) * robot['gear_reduction']
    
    print('speed', robot_speed)
    
    # Calculate total (initial) motor torque
    motor_torque = (robot['stall'] * (1 - motor_speed / robot['free'])) * robot['num_motors']

    # Calculate torque post-gearbox
    gearbox_torque = robot['gear_reduction'] * motor_torque

    # Calculate force on wheels
    wheel_force = gearbox_torque / (robot['wheel_diameter'] / 2)

    # Calculate (theoretical) acceleration of the robot
    max_theoretic_accel = wheel_force / robot['weight']

    # If maximum acceleration exceeds the coefficient of friction, bring it down.
    fric_theoretic_accel = max_theoretic_accel if max_theoretic_accel <= robot['coeff_friction'] else robot['coeff_friction']
    
    # Increment time according to how long it will take to get to the next speed at this acceleration.
    time += 1 / (32 * fric_theoretic_accel)

    # Print the acceleration of the robot, both by torque max and by traction limits.
    print('acc', round(max_theoretic_accel, 2), round(fric_theoretic_accel, 2))

    # Account for the torque on the robot
    robot_torque = (fric_theoretic_accel * robot['weight']) * robot['com_height']

    # Counteract that force
    counteracting_force = robot_torque / robot['wheelbase']

    # Force on each set of wheels:
    back_wheels_normal = robot['weight'] * (robot['wheelbase']/2 - robot['com_displacement']) / robot['wheelbase'] + counteracting_force
    front_wheels_normal = robot['weight'] * (robot['wheelbase']/2 + robot['com_displacement']) / robot['wheelbase'] - counteracting_force

    # Print the forces experienced by the front and rear of the robot.
    print('force', round(back_wheels_normal, 2), round(front_wheels_normal, 2))
    
    # Clear for next speed
    print('-------------------')
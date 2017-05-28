# ImageAnalysis

# Meryem:
## Functions:
1. [homes, ordered_items] = Ordering(Regions) --> returns homes (Array of the structures)  and ordered_items an array of x,y positions the robot should follow in order(ordered shapes) 
[ shape1.Centroid ;
  nearesthometoshape1.Centroid;
  shape2.Centroid ;
  nearesthometoshape2.Centroid;
]


2. boolean = CheckRobotHome(LocationRobot,homes) --> checks if Robot is at home (yes or no)

3. angle = cal_angle(path) --> returns positive or negative angle from reference vector = [0 1 0] z-axis only there for calculation purposes (always set to zero in our case)

# Christian:
## Functions:
[ region_shape, region_robot ] = arena_seg( im_original, config )

Will segement original image and look for shapes and robot. Config array can be parametrized if needed

* config

| Fields                  | Value         | Description                                                           |
|:----------------------- |:------------- |:--------------------------------------------------------------------- |
| n_homes                 | scalar        | Number of homes to look for                                           |
| shape_str               | Strings cell  | Name of the shapes                                                    |
| size_min_thresh         | scalar        | Smaller shape to detect (ratio according to full image)               |
| size_max_thresh         | scalar        | Bigger shape to detect (ratio according to full image)                |
| compacity_thresh        | scalar        | Maximum compacity value before descarding detection                   |
| prop_shape_thresh       | scalar        | Minimal probability before discarding detection                       |
| black_v_thresh          | scalar        | Threshold value for detection of black arrow                          |
| r_color_detect          | scalar        | Radius to consider around centroid when looking for color of shape    |
| color_str               | Strings cell  | Name of colors                                                        |
| color_hue_thresh        | scalar        | Values of exprected Hue colors, i.e. mean value (see HSV color space) |
| color_saturation_thresh | scalar        | Maximal saturation value for grey zone                                |
| diplay_res              | logical       | Selection displaying results (1) or not (0)                           |
| save_res                | logical       | Selection saving results (1) or not (0)                               |
| save_filename           | String        | Name of the saved file                                                |


* region_shape

| Fields       | Value         | Description                                                  |
|:------------ |:------------- |:------------------------------------------------------------ |
| Centroid     | [x,y]         | Centroid of the shape                                        |
| BoundingBox  | [x, y, w, h]  | Bounding box expressed as (x,y) corner and w=width, h=heigth |
| Home         | logical       | Assert if home (1) or not (0)                                |
| Color        | String        | String value of the detected color                           |
| Shape        | String        | String value of the detected shape                           |

* region_robot

| Fields      | Value      | Description                         |
|:----------- |:---------- |:----------------------------------- |
| Centroid    | [x,y]      | Centroid of the arrow head          |
| Orientation | scalar     | Angle in degree according to x-axis |

# Patryk:
## Functions:
[ path_linearised ] = shortest_path( bin_img, robot_radius,point_start, point_stop ) --> returns the path from point_start(X-Y) to point_stop(X-Y), avoids obstacles available in the binary_img. Obstacles are pixels = 1, robot can move in pixels = 0. The result path is only an array of linearised path points to follow, including start and stop. Should run less than 2s, since for the path-finding algorithm the image is resized to be smaller. 
**The path finding function is based on http://ch.mathworks.com/matlabcentral/fileexchange/8625-shortest-path-with-obstacle-avoidance--ver-1-3- .  

[ angles, lengths ] = transform_path_to_angle_length( path ) --> Transforms the array of N X-Y path points(from shortest_path() ) to N-1 arrays of  robot rotation angles and lengths in pixels. This array can be used to move the robot. 

[ ] = moveRobot( vid, cfg, pos_fin , motor_l, motor_r) --> Moves robot to a point pos_fin straight. 

[ ] = move_to_avoid_obstacles( vid, config, motor_l, motor_r, p1togo) --> goes to the point with obstacle avoidance (automatically calculates and follows with multiple stops - intermediate points).

[ ] = turn_deg( angle , config, motor_l, motor_r) --> turn the robot by some angle 

[  ] = go_forward_pixels( pixels, config,  motor_l, motor_r ) --> robot goes forward a number of pixels

[ config ] = calibrate( config, vid, motor_l, motor_r ) --> This function calibrates the motor constants is config (degreespersec and pixpersec). the constants are used in turn_deg() and go_forward_pixels() functions.





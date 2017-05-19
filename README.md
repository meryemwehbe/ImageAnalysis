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

# Christian:
## Functions:
[ region_shape, region_robot ] = arena_seg( im_original, config )

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
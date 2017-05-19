load('region.mat');
[homes,ordered] = Ordering(region);

LocationRobot.x = 470; 
LocationRobot.y = 400; 

yesno = CheckRobotHome(LocationRobot,homes);
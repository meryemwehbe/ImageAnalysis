load('region.mat');
[homes,ordered, homeless] = Ordering(region);

LocationRobot.x = 470; 
LocationRobot.y = 400; 

yesno = CheckRobotHome(LocationRobot,homes);
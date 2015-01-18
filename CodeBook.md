###Data dictionary - Getting and Cleanning Data Course Project

####subject (2)

*Identifier of the subject who carried out the experiment*

* 1..30

####activity (18)

*Activity name*

*		LAYING
*		SITTING
*		STANDING
*		WALKING
*		WALKING_DOWNSTAIRS
*		WALKING_UPSTAIRS

####measurementtype (9)
*Type of measurement*

*		frequency
*		time
		
####measurement     (19)
*Measurements taken*

*		BodyAcc 		.Body Linear Acceleration (g)
*		BodyAccJerk		.Body Linear Acceleration Jerk Signal  (g)
*		BodyAccMag		.Body Linear Acceleration Magnitude  (g)
*		BodyBodyAccJerkMag	.Body Linear Acceleration Jerk Signal Magnitude  (g)
*		BodyBodyGyroJerkMag     .Body Angular Velocity Jerk Signal Magnitude  (g)
*		BodyBodyGyroMag		.Body Angular Velocity Magnitude (radian/second)
*		BodyGyro		.Body Angular Velocity  (radian/second)
*		BodyAccJerkMag		.Body Linear Acceleration Jerk Signal Magnitude (radian/second)
*		BodyGyroJerk		.Body Angular Velocity Jerk Signal (radian/second)
*		BodyGyroJerkMag		.Body Angular Velocity Jerk Signal Magnitude (radian/second)
*		BodyGyroMag		.Body Angular Velocity Magnitude (radian/second)
*		GravityAcc		.Gravity Linear Acceleration (g)
*		GravityAccMag		.Gravity Linear Acceleration Magnitude (g)
		
####aggregation (4)
*Aggregation method*
		
*		mean	.Mean value
*		std	   .Standard deviation
		
####axis (2)
*Measurement axis* 
		
*		X	.X axis
*		Y	.Y axis
*		Z	.Z axis
*		NA	.For measurements that are not axis-based (Magnitude)
		
####meanvalue (21)
*Average of each variable for each activity and each subject*	
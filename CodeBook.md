#Codebook for Getting and Cleaning data project

##data files: 

data files are extracted from the zip file. In the readme.txt, it explained the files as: 

> The dataset includes the following files:
> =========================================
> 
> - 'README.txt'
> 
> - 'features_info.txt': Shows information about the variables used on the feature vector.
> 
> - 'features.txt': List of all features.
> 
> - 'activity_labels.txt': Links the class labels with their activity name.
> 
> - 'train/X_train.txt': Training set.
> 
> - 'train/y_train.txt': Training labels.
> 
> - 'test/X_test.txt': Test set.
> 
> - 'test/y_test.txt': Test labels.
> 
> The following files are available for the train and test data. Their descriptions are equivalent. 
> 
> - 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
> 
> - 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
> 
> - 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
> 
> - 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 
> 

In this project, the "Inertial signals" sub-directory are not used. 

##Variables

Here are variables got from subject, activity and feature data

1. **subject**: the subject who performed the activity for each window sample. Its range is from 1 to 30.
1. **activity**: Activity name. Six activities as:
	- WALKING, 
	- WALKING\_UPSTAIRS,
	- WALKING\_DOWNSTAIRS, 
	- SITTING,
	- STANDING, 
	- LAYING
1. **domain**: Signal in time domain or frequency domain
2. **instrument**: Measuring instrument, Accelerometer or Gyroscope)
2. **acceleration**: Acceleration signal (Body or Gravity)
1. **Jerk**: Jerk signal
1. **Magnitude**: Magnitude of the signals calculated using the Euclidean norm
1. **method** values of Mean or standard deviation (std)
1. **axis**:: 3-axial signals in the X, Y and Z directions
1. **meanvalue**: Average of each variable for each activity and each subject 

"subject" and "activity" are form subject file and activity file. Others are extracted from feature name in feature file. Those feature names are something like following: 

    `"tBodyAcc-mean()-X"  "tBodyAcc-mean()-Y"  `
then we extracted the variables from feature names. use "NA" for feature not used in the measurement. the reconstructed feature names are same as following
 
      "time.body.accelerometer.NA.NA.mean.X" 
      "time.body.accelerometer.NA.NA.std.X"       
	  "time.NA.gyroscope.NA.NA.mean.X" 
      "time.NA.gyroscope.NA.NA.mean.Y"   
      "frequency.NA.gyroscope.jerk.magnitue.mean.NA"   
      "frequency.NA.gyroscope.jerk.magnitue.std.NA"   

##Tidy data

Here is part of the Tidy data:

    > dt_final
       subject activity domain instrument acceleration Jerk magnitue method Axis  meanvalue
    1:   1   LAYING frequency accelerometer body   NA   NA   meanX -0.9390991
    2:   1   LAYING frequency accelerometer body   NA   NA   meanY -0.8670652
    3:   1   LAYING frequency accelerometer body   NA   NA   meanZ -0.8826669
    4:   1   LAYING frequency accelerometer body   NA   NAstdX -0.9244374
    5:   1   LAYING frequency accelerometer body   NA   NAstdY -0.8336256
       ---   
    11876:  30 WALKING_UPSTAIRS  time gyroscope   NA jerk   NAstdX -0.7427495
    11877:  30 WALKING_UPSTAIRS  time gyroscope   NA jerk   NAstdY -0.7433370
    11878:  30 WALKING_UPSTAIRS  time gyroscope   NA jerk   NAstdZ -0.6651506
    11879:  30 WALKING_UPSTAIRS  time gyroscope   NA jerk magnitue   mean   NA -0.7187803
    11880:  30 WALKING_UPSTAIRS  time gyroscope   NA jerk magnituestd   NA -0.7744391
    > 
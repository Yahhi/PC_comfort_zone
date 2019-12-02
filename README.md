# PC_Comfort_Zone

## The idea
PC_Comfort_Zone is a mobile app aimed to help preventing diseases related to computer workers. IT specialists usually have to sit in front of computer a lot of time during the day. If they don't care about posture, hourly and daily phisical routines it is common to get diseases: scoliosis, osteochandrosis, myopia and others. This app will help by checking and correcting the user's posture, exercises interval and possibly (if the user will install our sensors) environment parameters. 
To see and check the posture, we use phone's camera, but it is possible to use multiple cameras and get more correct results. User's phone do some photos at predefined time interval and then sends them to the cloud.
Now we use cloud (server with OPEN_CV installed) to check if the posture is good, but it will be more effective if the checking will be executed on Android or iOS device directly without the requirement of the server.

## The prototype
The prototype client app was created during the Cifrovoi Proriv 2019 - the largest hackathon in the World. It is written in Flutter. It was compiled and available for both Android and iOS. ML part was installed on Microsoft servers as a REST service and was available during the hackathon and when the video was recorded.
[![Watch the video](https://img.youtube.com/vi/kZLSQS8FwqY/hqdefault.jpg)](https://youtu.be/kZLSQS8FwqY)

## Plan to bring it to life
I have started learning ML (Udacity Bertselmann AI Nanodegree) to make pose detecture more correct and know how to use ML outside the scope of Open_CV. There are a lot of work to be done: make ML model more correct, transfer it to device instead of cloud, do some user research, determine the best way to make initial user settings (like how to set user's phone to get the best picture and adopt to the initial user's state - it is possible that the user has already have some sort of posture desease). It can take up to 5 months to be done. If I will be selected as a finalist of the Android Developer Challenge, Google professionals can help me with the ML model and user interface analysis.

## About me
I am old enough to care about my health and the deseases that are more likely to happen in my life. So IT deseases prevention is actual for me. I am a mobile app developer. I have 3 years of experience in android native and 1.5 years of Flutter development. I have completed Udacity Android Developer Nanodegree. I am interested in adding Machine Learning to the list of my skills and started to learn it for about half year. My previous projects came from Upwork clients and are related to connecting mobile apps with hardware, making it possible to manage device state via BLE and send/receive data to custom made Bluetooth devices.

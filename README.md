# Track Chronometer
The goal of this project is to create a track chronometer using a flutter application that interfaces with an arduino infrastructure.

Chapters:
1. Brief description
2. Hardware
3. The app
4. Arduino code
5. Observations
6. Credits
 
_________________________
### 1. Brief description
The idea is that we want to measure the time that an athlete takes to conclude a lap (or a fraction) of an athletics track. We want to use 3 checkpoint stations, so finally we want to have the total time, and 2 partial time (between 1 & 2 and between 2 & 3).                                                                       
So we will have, an application that will interfaces with the arduino stations, and 3 stations made with arduino.                                                   
We also want to be able to choose between two types of time starts; one type starts the time after a buzzer sound, and the other type starts the time after the athlete passes by the first station.                                                                                                                                 
The classical control flow is: 1. The app connects to arduino                                                                                                       
                               2. The app tells arduino to start (make buzzer sound or be ready for the athlete to pass)                                             
                               3. When the buzzer sounds or the athlete passes by the first station, arduino tells the app to start the time and tells other arduinos to be ready                                4. When the atlhete passes by the second station, the second arduino informs the first one                                           
                               5. The first arduino inform the app that the athlete is passed by the second station                                                 
                               6. When the atlhete passes by the third station, the third arduino informs the first one                                             
                               7. The first arduino inform the app that the athlete is passed by the third station                                                   
_________________________
### 2. Hardware
For this project I used:
- 3 arduino nanos
- 1 bluetooth module (HC-05)
- 3 radio modules (HC-12)
- 3 ultrasound sensors (HC SR-04)
- 1 buzzer
- 3 leds
- 3 battery banks
- 1 switch
_________________________
### 3. The app
The application has been created using Flutter.
Actually the application does all the work: it has to connect to Arduino via bluetooth and counts the time (time starts and stops respect to commands received from Arduino).
The app has also a mechanism to save the measured times into files, and store them in the smartphone; you can organize your files as you prefer by creating directories, moving files and so on. You can also modify your files and share them.
_______________________
### 4. Arduino code
The Arduino infrastructure is composed by 3 stations as already said, one Master and two Slaves.

The Master is the main Arduino station, it has a bluetooth module to connect to the app, a buzzer and an ultrasound module to start the time measure, and a radio module to communicate with other stations.

The Slave modules are equipped only with radio module, to communicate with the Master, and ultrasound modules to detect when the athlete passes.
_______________________
### 5. Observations
This application could work also with more stations, in order to have more partial times. it could work also with only 2 stations (in total).

Slaves modules are interchangeable one with each other.

it's a good idea to set arduino modules in long range mode; here a guide on how to do it: https://howtomechatronics.com/tutorials/arduino/arduino-and-hc-12-long-range-wireless-communication-module/

the first try on this project was made using a photocell E18-D80NK, which I found that not working at all in my case. Anyway ultrasound sensors don't suffers from any type of light disturb, so should be even better.
_______________________
### 6. Credits
This project idea is taken from an existing project (mainly the arduino part), take a look if you're interested in:
https://cassiophong.wordpress.com/2020/12/08/cronometro-elettrico-atletica/

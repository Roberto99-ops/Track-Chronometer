#include <SoftwareSerial.h>
#include <NewPing.h>
SoftwareSerial HC12(10,11); // HC-12 TX Pin, HC-12 RX Pin
#define TRIG 9
#define ECO 8
NewPing sonar(TRIG, ECO, 500); //500 is the max distance in cm
bool start = false;;
byte incomingByte;
String HC = "";


void HCFun();

void setup() {
  Serial.begin(1200);
  HC12.begin(1200); 
  Serial.println("Slave");
}


void loop() {
  delay(50);
  //it listens on the HC port for incoming messages
  while (HC12.available()) {  // If HC-12 has data
    incomingByte = HC12.read();
    HC += char(incomingByte);
  }
  if(HC != ""){
    HCFun();
  }

  if(start){
    int ultrasound = sonar.ping_cm();
    Serial.println(ultrasound);
    if (ultrasound > 10 && ultrasound < 100) //to prevent errors
    {
      HC12.print("C"); //stops the time
      start = false;
    }
  }
}


//this function describes what arduino must do for each different HC input
void HCFun(){
  Serial.println(HC);
  if(HC == "A")
          {start=true;
          Serial.println("start");}
  if(HC == "B")
          {start=false;
          Serial.println("stop");}
  HC="";
}

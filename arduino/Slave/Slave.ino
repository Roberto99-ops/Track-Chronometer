#include <SoftwareSerial.h>

SoftwareSerial HC12(10,11); // HC-12 TX Pin, HC-12 RX Pin
#define IReceiver 9
bool start = false;;
byte incomingByte;
String HC = "";


void HCFun();

void setup() {
  Serial.begin(9600);
  HC12.begin(9600); 
  pinMode(IReceiver, INPUT);
  Serial.println("Slave");
}


void loop() {
  
  //it listens on the HC port for incoming messages
  while (HC12.available()) {  // If HC-12 has data
    incomingByte = HC12.read();
    HC += char(incomingByte);
  }
  if(HC != ""){
    HCFun();
  }

  if(start){
    int photoCell = digitalRead(IReceiver);
    if (photoCell == HIGH)
    {
      HC12.print("C"); //stops the time
      start = false;
    }
  }
}


//this function describes what arduino must do for each different HC input
void HCFun(){
  if(HC == "A")
          start=true;
  if(HC == "B")
          start=false;
  HC="";
}

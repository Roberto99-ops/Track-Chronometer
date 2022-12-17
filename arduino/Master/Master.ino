 #include <SoftwareSerial.h>
 //this library is because we can't use two serials at the same time
 //I can't even use pin 10 because of this library
 #include <AltSoftSerial.h>
 
 SoftwareSerial HC12(A2,A3); // HC-12(radio) TX Pin, RX Pin -> PWM
 #define sw  A6               // Switch pin
 #define buzzer  6           // buzzer to arduino pin 6 -> PWM
 AltSoftSerial bluetooth;    // Bluet TX = 8, RX=9, because of the library
 #define IReceiver 3
 bool start = false;         //start variable
 int nOfStages = 2;          // this is used to know how many photocells stages we have
 int counter = 0;            //to know how many results we have received yet 
 byte incomingByte;
 String HC = "";             //result of the HC12
 String bt = "";             //result of the bluetooth

 void BlueFun();
 void HCFun();

 
 void setup() {
   Serial.begin(9600);             // Serial port to computer
   HC12.begin(9600);               // Serial port to HC12
   bluetooth.begin(9600);          // Serial port to bluetooth
   pinMode(sw, INPUT);
   pinMode(buzzer, OUTPUT);
   pinMode(IReceiver, INPUT);
   pinMode(start, INPUT);
   analogWrite(buzzer, 0);
 }

void loop() {
  if(start == true) {
    if(analogRead(sw) == LOW){        //in case I want to start the chronometer using a "START" sound
      int temp = random(1000,5000);
      delay(temp);
      analogWrite(buzzer, 255);    
      HC12.print("A");                 // it stands for "start"
      bluetooth.write("A");
      delay(1000);        
      analogWrite(buzzer, 0);
      start=false;
    }
    else{   //in case I want to start the chronometer when the athlet passes by the first station
      int photoCell = digitalRead(IReceiver);
      if (photoCell == HIGH)
      {
        HC12.print("A");               // it stands fot "start"
        bluetooth.write("A"); 
        start=false;
      }
    }
    int returned = 0;
  }

  //it listens on the BT port for incoming messages
   while(bluetooth.available()){
   bt=bluetooth.read();
   Serial.println(bt);
   BlueFun();
 }

 //it listens on the HC port for incoming messages
    while (HC12.available()) {  // If HC-12 has data
    incomingByte = HC12.read();
    HC += char(incomingByte);
  }
  if(HC != ""){
    HCFun();
  }
}


 //function that describes what arduino must do for each bluetooth input
 void BlueFun(){
  if(bt == "65")  //65=A
          start=true;
  if(bt == "66"){ //66=B
          HC12.print("B"); // it stands for "stop"
          start=false;
          counter=0;
  }
  bt="";
 }

 //function that describes what arduino must do for each HC input
 void HCFun(){
  Serial.println(HC);
  if(HC == "C"){
    counter++;
    //sends via bluetooth that we have reached a photocell (first or second)
    if(counter == 1)
      bluetooth.write("B");
    if(counter == 2){
      bluetooth.write("C");
      delay(100);  //necessary to not bug everything...weird
      bt="66";
      BlueFun();
    }
   }
   HC="";
 }

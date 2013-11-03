import processing.serial.*;

Serial myPort;                       // The serial port

int[] serialInArray = new int[385000]; 
//38.5k Hz is the ~clock speed from the Arduino
//38500 is 1 second
//385000 is 10 seconds

int serialCount = 0;
boolean firstContact = false;        // Whether we've heard from the microcontroller

void setup() {
  // Print a list of the serial ports, for debugging purposes:
  println(Serial.list());

  String portName = "COM3"; //change to connected port or add a port selection mechanism
  
  myPort = new Serial(this, portName, 57600); //maximum data rate
}

void serialEvent(Serial myPort) {
  // read a byte from the serial port:
  int inByte = myPort.read();
  // if this is the first byte received, and it's an A,
  // clear the serial buffer and note that you've
  // had first contact from the microcontroller. 
  // Otherwise, add the incoming byte to the array:
  if (!firstContact) {
    if (inByte == 'A') { 
      myPort.clear();          // clear the serial port buffer
      firstContact = true;     // you've had first contact from the microcontroller
      myPort.write('A');       // ask for more
    }
  } 
  else {
    // Add the latest byte from the serial port to array:
    serialInArray[serialCount] = inByte; // 0 to 255;
    serialCount++;
    
    if(serialCount == 385000) {
      noteDetectorThread t = new noteDetectorThread(serialInArray);
      t.start();
      
      serialInArray = new int[385000];
      serialCount = 0;
    }
  }
}


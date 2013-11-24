#include <Servo.h> 

const int SERVO_DELAY = 5;

Servo myservo;
int serialValue = 0;
int count = 0;
int stepDegree = 25;
int middleStepDegree = 12;
int pos = 180 - middleStepDegree;
int asciiNumberOffset = 48;

void setup() { 
  myservo.attach(9); // Servo is on pin 9
  Serial.begin(9600);
  myservo.write( pos );
}

void showEvent( int event ) {
  goToPos(180 - event * stepDegree - middleStepDegree );
  delay(7000);
  goToPos(180 - middleStepDegree);
}

void loop() {
  count++;
  if (count > 255) {
    count = 0;
    delay(100);
  }
  
  if (Serial.available() > 0) {
    serialValue = Serial.read();
    showEvent( serialValue - asciiNumberOffset );
  }
}

void goToPos(int nextPos){
  if ( pos < nextPos ) {
    for ( ; pos < nextPos; pos += 1 ) {
      myservo.write(pos);
      delay(15);
    }
  } else if ( pos > nextPos) {
    for ( ; pos > nextPos; pos -= 1 ) {
      myservo.write(pos);
      delay(15);    
    }
  }
}

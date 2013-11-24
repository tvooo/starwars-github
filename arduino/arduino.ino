#include <Servo.h> 

const int SERVO_DELAY = 5;
const int SECOND = 1000;
const int SERVO_PIN = 9;

Servo myservo;
int serialValue = 0;
int count = 0;
int stepDegree = 25;
int middleStepDegree = 12;
int pos = 180 - middleStepDegree;
int asciiNumberOffset = 48;

void setup() { 
  myservo.attach( SERVO_PIN );
  Serial.begin( 9600 );
  myservo.write( pos );
}

void showEvent( int event ) {
  goToPos(180 - event * stepDegree - middleStepDegree );
  delay(5 * SECOND);
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

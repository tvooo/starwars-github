#include <Servo.h> 

const int SERVO_DELAY = 5;

Servo myservo;
int pos = 0;
int serialValue = 0;
int count = 0;
int stepDegree = 25;

void setup() { 
  myservo.attach(9); // Servo is on pin 9
  Serial.begin(9600);
  myservo.write(0);
}

void loop() {
  count++;
  if (count > 255) {
    count = 0;
    delay(100);
  }
  
  if (Serial.available() > 0) {
    serialValue = Serial.read();
    switch(serialValue) {
      case '1':
        goToPos(1 * stepDegree - (stepDegree / 2));
        break;
      case '2':
        goToPos(2 * stepDegree - (stepDegree / 2));
        break;
      case '3':
        goToPos(3 * stepDegree - (stepDegree / 2));
        break;
      case '4':
        goToPos(4 * stepDegree - (stepDegree / 2));
        break;
      case '5':
        goToPos(5 * stepDegree - (stepDegree / 2));
        break;
      case '6':
        goToPos(6 * stepDegree - (stepDegree / 2));
        break;
      case '7':
        goToPos(7 * stepDegree - (stepDegree / 2));
        break;
    case '8':
        goToPos(-50);
        break;
    default:
        goToPos(0);
        break;
    }
  }
}

void goToPos(int nextPos){
  if (nextPos > pos) {
    for ( ; pos < nextPos; pos += 1 ) {
      myservo.write(int(pos));
      delay(15);
    }
  } else if (nextPos < pos) {
    int targetPos = nextPos;
    for ( ; pos >= nextPos; pos -= 1 ) {
      myservo.write(int(pos));
      delay(15);    
    }
  }
}

int motor1Pin1 = 3; // pin 2 on L293D IC
int motor1Pin2 = 4; // pin 7 on L293D IC
int enable1Pin = 6; // pin 1 on L293D IC
int motor2Pin1 = 8; // pin 10 on L293D IC
int motor2Pin2 = 9; // pin 15 on L293D IC
int enable2Pin = 11; // pin 9 on L293D IC
int state;
bool act;
void setup() {
  // sets the pins as outputs:
  pinMode(motor1Pin1, OUTPUT);
  pinMode(motor1Pin2, OUTPUT);
  pinMode(enable1Pin, OUTPUT);
  pinMode(motor2Pin1, OUTPUT);
  pinMode(motor2Pin2, OUTPUT);
  pinMode(enable2Pin, OUTPUT);
  // sets enable1Pin and enable2Pin high so that motor can turn on:
  digitalWrite(enable1Pin, HIGH);
  digitalWrite(enable2Pin, HIGH);
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  act = false;
}

void loop() {
  //if some data is sent, reads it and saves in state
  if ((Serial.available() > 0) && !act)  {
    state = Serial.read();
    state = state - 48;
    act = true;
  }
  
  if (act) {
    switch (state) {
      case 1: //left forward
        digitalWrite(motor1Pin1, HIGH);
        digitalWrite(motor1Pin2, LOW);
        Serial.println("left forward");
        act = false;
        break;
      case 2: //left stop
        digitalWrite(motor1Pin1, LOW);
        digitalWrite(motor1Pin2, LOW);
        Serial.println("left stop");
        act = false;
        break;
      case 3: //left backward
        digitalWrite(motor1Pin1, LOW);
        digitalWrite(motor1Pin2, HIGH);
        Serial.println("left backward");
        act = false;
        break;
      case 4: //right forward
        digitalWrite(motor2Pin1, HIGH);
        digitalWrite(motor2Pin2, LOW);
        Serial.println("right forward");
        act = false;
        break;
      case 5: //right stop
        digitalWrite(motor2Pin1, LOW);
        digitalWrite(motor2Pin2, LOW);
        Serial.println("right stop");
        act = false;
        break;
      case 6: //right backward
        digitalWrite(motor2Pin1, LOW);
        digitalWrite(motor2Pin2, HIGH);
        Serial.println("right backward");
        act = false;
        break;
      default:
        if (state != 0) {
          Serial.print("invalid state: ");
          Serial.println(state);
        }
        act = false;
        break;
    }
  }
}


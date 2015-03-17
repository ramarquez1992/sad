const int BTRXPin = 10;
const int BTTXPin = 11;

const int LEDPin = 13;

void setup() {
  Serial.begin(9600);
  
  pinMode(BTRXPin, INPUT);
  pinMode(BTTXPin, OUTPUT);
  
  pinMode(LEDPin, OUTPUT);
  digitalWrite(LEDPin, HIGH);
  
}

void loop() {  
  
  if (digitalRead(LEDPin) == HIGH) {
    digitalWrite(LEDPin, LOW);
  } else {
    digitalWrite(LEDPin, HIGH);
  }
  
  Serial.println("Hello, World!");
  
  delay(500);

}

#include "Ultrasonic.h"

const int PINO_TRIGGER = 12;
const int PINO_ECHO = 13;

HC_SR04 sensor(PINO_TRIGGER, PINO_ECHO);

void setup() {
  Serial.begin(9600);
}

void loop () {
  Serial.print("DistMaxima:");
  Serial.print(100);
  Serial.print(" ");
  Serial.print("Distância:");
  Serial.print(sensor.distance());
  Serial.println("cm");
  Serial.print(" ");
  Serial.print("DistMínima:");
  Serial.println(0);

  delay(1000);
}
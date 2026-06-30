#include <Wire.h>
#include <WiFi.h>
#include <WebServer.h>
#include "MAX30105.h"
#include "heartRate.h"

#define I2C_SDA 5
#define I2C_SCL 6

const char* ssid     = "Xiao_HeartRate";
const char* password = "test1234";

MAX30105 particleSensor;
WebServer server(80);
bool sensorOK = false;

const byte RATE_SIZE = 4;
byte  rates[RATE_SIZE];
byte  rateSpot       = 0;
long  lastBeat       = 0;
float beatsPerMinute = 0;
int   beatAvg        = 0;
long  lastIR         = 0;

void handleData() {
  String json = "{\"ir\":"      + String(lastIR) +
                ",\"bpm\":"     + String(beatsPerMinute, 1) +
                ",\"bpm_avg\":" + String(beatAvg) +
                ",\"finger\":"  + String(lastIR > 50000 ? "true" : "false") +
                ",\"sensor\":"  + String(sensorOK ? "true" : "false") + "}";
  server.send(200, "application/json", json);
}

void setup() {
  Serial.begin(115200);
  delay(1000);

  WiFi.disconnect(true);
  WiFi.mode(WIFI_OFF);
  delay(200);
  WiFi.mode(WIFI_AP);
  delay(200);
  WiFi.softAP(ssid, password, 6);
  delay(1000);
  Serial.print("IP: ");
  Serial.println(WiFi.softAPIP());

  server.on("/data", handleData);
  server.onNotFound([]() { server.send(404, "text/plain", "not found"); });
  server.begin();
  Serial.println("WebServer started");

  Wire.begin(I2C_SDA, I2C_SCL);
  sensorOK = particleSensor.begin(Wire, I2C_SPEED_FAST);
  if (sensorOK) {
    particleSensor.setup();
    // prime the FIFO
    for (int i = 0; i < 10; i++) {
      particleSensor.check();
      delay(10);
    }
    Serial.println("Sensor OK");
  } else {
    Serial.println("Sensor FAIL");
  }

  Serial.println("Ready");
}

void loop() {
  server.handleClient();

  if (sensorOK) {
    particleSensor.check();

    if (particleSensor.available()) {
      lastIR = particleSensor.getIR();
      particleSensor.nextSample();

      if (checkForBeat(lastIR)) {
        long delta = millis() - lastBeat;
        lastBeat = millis();
        beatsPerMinute = 60.0f / (delta / 1000.0f);

        if (beatsPerMinute >= 20 && beatsPerMinute <= 255) {
          rates[rateSpot++] = (byte)beatsPerMinute;
          rateSpot %= RATE_SIZE;
          beatAvg = 0;
          for (byte x = 0; x < RATE_SIZE; x++) beatAvg += rates[x];
          beatAvg /= RATE_SIZE;
        }

        Serial.print("IR="); Serial.print(lastIR);
        Serial.print("  BPM="); Serial.print(beatsPerMinute, 1);
        Serial.print("  Avg="); Serial.println(beatAvg);
      }
    }
  }

  delay(1);  // yield to WiFi stack
}
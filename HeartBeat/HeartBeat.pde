import processing.serial.*;

HeartbeatMonitor hb;

void setup() {
  size(400, 200);
  textAlign(CENTER, CENTER);

  // To see all devices: printArray(Serial.list())
  hb = new HeartbeatMonitor(this, Serial.list()[0], 9600);
  hb.setInitialBPM(72);       // nice default so it's not 0 at startup
  hb.setNoiseSigma(1.2);      // ±1-2 BPM wobble feels natural for a demo
}

void draw() {
  background(20);

  hb.update();
  float bpm = hb.getBPM();

  fill(255, 80, 80);
  textSize(64);
  text(nf(bpm, 0, 1), width / 2, height / 2);

  fill(160);
  textSize(16);
  text("BPM", width / 2, height / 2 + 50);
}

// Wire serial events through to the monitor
void serialEvent(Serial p) {
  hb.onSerialEvent(p);
}
/**
 * Example sketch — drop HeartbeatMonitor.pde in the same folder as this file.
 *
 * Before running: join your computer's WiFi to the sensor's network
 * (default ssid "Xiao_HeartRate", password "test1234"). The ESP32's
 * SoftAP IP is printed to its own serial monitor at boot, but it's
 * 192.168.4.1 by default.
 */

HeartbeatMonitor hb;

void setup() {
  size(400, 200);
  textAlign(CENTER, CENTER);

  hb = new HeartbeatMonitor(this, "http://192.168.4.1/data");
  hb.setInitialBPM(72);
  hb.setNoiseSigma(1.2);
  hb.setPollInterval(1000);   // poll the sensor once a second
  hb.setInterpFrames(60);     // spread each step over ~1s at 60fps
}

void draw() {
  background(20);

  hb.update();                // must be called every frame
  float bpm = hb.getBPM();    // use this anywhere in your program

  fill(255, 80, 80);
  textSize(64);
  text(nf(bpm, 0, 1), width / 2, height / 2 - 10);

  fill(160);
  textSize(16);
  text("BPM", width / 2, height / 2 + 40);

  // Optional: surface sensor/finger status for debugging
  fill(hb.isFingerDetected() ? color(80, 255, 80) : color(255, 80, 80));
  textSize(12);
  text(hb.isFingerDetected() ? "finger detected" : "no finger", width / 2, height - 20);
}

void stop() {
  hb.stopPolling();   // shut the background thread down cleanly
  super.stop();
}

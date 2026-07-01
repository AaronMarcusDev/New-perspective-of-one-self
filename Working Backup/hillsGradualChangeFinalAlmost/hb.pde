import processing.serial.*;

class HeartbeatMonitor {
  Serial port;
  float currentBPM   = 72.0;   // smoothed display value
  float targetBPM    = 72.0;   // last real reading received
  float previousBPM  = 72.0;   // reading before that

  // Interpolation part:
  // How many draw() frames to spread one inter-reading journey across.
  // At 60 fps this is ~10 seconds, matching the sensor interval.
  int   interpFrames = 600;
  int   framesSinceReading = 0;

  // Normal-distribution noise on top of the smooth interpolation.
  // Keeps the value looking "alive" between real readings.
  float noiseSigma   = 1.2;    // std-dev in BPM

  // String buffer for incoming serial bytes
  String serialBuffer = "";

  HeartbeatMonitor(PApplet parent, String portName, int baudRate) {
    port = new Serial(parent, portName, baudRate);
    port.bufferUntil('\n');   // fire serialEvent on newline
  }

  void update() {
    framesSinceReading++;

    // So we don't overshoot
    float t = constrain((float) framesSinceReading / interpFrames, 0, 1);
    float interpolated = lerp(previousBPM, targetBPM, t);
    interpolated += randomGaussian() * noiseSigma;

    currentBPM = interpolated;
  }

  // Returns the current (smoothed + noisy) BPM. Use this in draw().
  float getBPM() {
    return currentBPM;
  }

  void onSerialEvent(Serial p) {
    String raw = p.readStringUntil('\n');
    if (raw == null) return;
    raw = trim(raw);

    if (raw.length() == 0) return;
    try {
      float received = Float.parseFloat(raw);
      if (received > 20 && received < 250) {   // check safety range
        previousBPM       = currentBPM;
        targetBPM         = received;
        framesSinceReading = 0;
      }
    } catch (NumberFormatException e) {
      // Ignore malformed lines silently
    }
  }

  // Optional: override the inter-reading frame budget at runtime.
  // Useful for if our sensor rate changes
  void setInterpFrames(int frames) {
    interpFrames = frames;
  }

  // Optional: change how much noise is added between readings.
  void setNoiseSigma(float sigma) {
    noiseSigma = sigma;
  }

  // Optional: seed an initial BPM so the display isn't zero on startup.
  void setInitialBPM(float bpm) {
    currentBPM  = bpm;
    targetBPM   = bpm;
    previousBPM = bpm;
  }
}

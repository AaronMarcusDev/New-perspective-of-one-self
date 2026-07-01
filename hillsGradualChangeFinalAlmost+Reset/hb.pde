/**
 * HeartbeatMonitor (WiFi / HTTP version)
 *
 * Polls a MAX30105-based heart-rate sensor over WiFi (ESP32 SoftAP serving
 * JSON at /data) instead of using wired serial. Fills the gaps between
 * real readings with normally-distributed interpolated values so the
 * display stays lively.
 *
 * Your computer must be joined to the sensor's WiFi network
 * (default ssid "Xiao_HeartRate") for this to reach it.
 *
 * Usage in your main sketch:
 *   HeartbeatMonitor hb;
 *
 *   void setup() {
 *     hb = new HeartbeatMonitor(this, "http://192.168.4.1/data");
 *   }
 *
 *   void draw() {
 *     float bpm = hb.getBPM();   // use this wherever you need it
 *     hb.update();               // call once per draw loop
 *   }
 *
 *   void stop() {
 *     hb.stopPolling();          // clean shutdown
 *     super.stop();
 *   }
 */
class HeartbeatMonitor implements Runnable {

  // --- Networking ---
  String  dataURL;
  Thread  pollThread;
  volatile boolean running = true;

  // How often to hit the sensor's HTTP endpoint, in milliseconds.
  int pollIntervalMillis = 1000;

  // --- BPM state ---
  float currentBPM   = 72.0;   // smoothed display value
  float targetBPM    = 72.0;   // last real reading received
  float previousBPM  = 72.0;   // reading before that

  // --- Interpolation ---
  // Frames to spread one inter-reading journey across.
  // Rule of thumb: (pollIntervalMillis / 1000) * frameRate.
  int   interpFrames = 60;
  int   framesSinceReading = 0;

  // Normal-distribution noise on top of the smooth interpolation.
  float noiseSigma   = 1.2;    // std-dev in BPM; tune to taste

  // --- Latest raw sensor fields, exposed in case you want them ---
  volatile boolean fingerDetected = false;
  volatile boolean sensorOK       = false;
  volatile long     lastIR        = 0;
  volatile int      lastBpmAvg    = 0;

  // -------------------------------------------------------
  HeartbeatMonitor(PApplet parent, String url) {
    this.dataURL = url;
    pollThread = new Thread(this);
    pollThread.start();
  }

  // -------------------------------------------------------
  // Background thread: polls the HTTP endpoint on its own schedule
  // so network latency never blocks draw().
  void run() {
    while (running) {
      fetchOnce();
      try {
        Thread.sleep(pollIntervalMillis);
      } catch (InterruptedException e) {
        // exiting
      }
    }
  }

  // -------------------------------------------------------
  void fetchOnce() {
    try {
      JSONObject json = loadJSONObject(dataURL);
      if (json == null) return;

      sensorOK       = json.getBoolean("sensor", false);
      fingerDetected = json.getBoolean("finger", false);
      lastIR         = json.getLong("ir", 0);
      lastBpmAvg     = json.getInt("bpm_avg", 0);
      float received = json.getFloat("bpm", 0);

      // Only treat it as a "new reading" worth interpolating toward
      // if a finger is present and the value is plausible.
      if (fingerDetected && received > 20 && received < 250) {
        previousBPM        = currentBPM;   // anchor from where we are now
        targetBPM          = received;
        framesSinceReading = 0;
      }
    } catch (Exception e) {
      // Sensor unreachable / malformed JSON — just skip this poll
      println("HeartbeatMonitor: fetch failed (" + e.getMessage() + ")");
    }
  }

  // -------------------------------------------------------
  // Call once per draw() loop.
  void update() {
    framesSinceReading++;

    float t = constrain((float) framesSinceReading / interpFrames, 0, 1);
    float interpolated = lerp(previousBPM, targetBPM, t);
    interpolated += randomGaussian() * noiseSigma;

    currentBPM = interpolated;
  }

  // -------------------------------------------------------
  // Returns the current (smoothed + noisy) BPM. Use this in draw().
  float getBPM() {
    return currentBPM;
  }

  // -------------------------------------------------------
  boolean isFingerDetected() {
    return fingerDetected;
  }

  boolean isSensorOK() {
    return sensorOK;
  }

  // -------------------------------------------------------
  // Optional: override how often the sensor is polled (ms).
  void setPollInterval(int millis) {
    pollIntervalMillis = millis;
  }

  // -------------------------------------------------------
  // Optional: override the inter-reading interpolation frame budget.
  void setInterpFrames(int frames) {
    interpFrames = frames;
  }

  // -------------------------------------------------------
  void setNoiseSigma(float sigma) {
    noiseSigma = sigma;
  }

  // -------------------------------------------------------
  void setInitialBPM(float bpm) {
    currentBPM  = bpm;
    targetBPM   = bpm;
    previousBPM = bpm;
  }

  // -------------------------------------------------------
  // Call this from your sketch's stop() to shut the polling thread down cleanly.
  void stopPolling() {
    running = false;
    pollThread.interrupt();
  }
}

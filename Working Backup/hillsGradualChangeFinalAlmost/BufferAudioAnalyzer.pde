class BufferedAudioAnalyzer extends AudioMonitor {
  int time = 0;
  int interval = 20;
  boolean tickEnabled = false;

  float volumeSum = 0;
  float frequencySum = 0;

  // --- CALIBRATION BOUNDS ---
  // Adjust these if you want the 1-10 scale to be more/less sensitive
  float minExpectedFreq = 0;
  float maxExpectedFreq = 500; // Capped at 500Hz based on your old code

  float minExpectedVol = 0;
  float maxExpectedVol = 100;  // Assumes raw volume falls between 0 and 100

  // These public floats now hold values strictly between 1.0 and 10.0
  float latestAvgFreq = 1;
  float latestAvgVol = 1;
  
  float mappedFreq, mappedVol;

  BufferedAudioAnalyzer(processing.core.PApplet sketch) {
    super(sketch);
    
    mappedFreq = 1;
    mappedVol = 1;
  }

  void update() {
    float currentVol = getRawVolume();
    float currentFreq = getRawFrequency();

    // Start collecting data if we hear something
    if (!tickEnabled && currentFreq > 0 && currentVol > 0) {
      tickEnabled = true;
    }

    // Accumulate data over the interval
    if (tickEnabled) {
      volumeSum += currentVol;
      frequencySum += currentFreq;

      time++;
      time %= interval;
    }

    // When the interval finishes, calculate averages and map them
    if (time == 0 && tickEnabled) {
      tickEnabled = false;

      float rawAvgFreq = frequencySum / interval;
      float rawAvgVol = volumeSum / interval;

      // 1. Map the raw averages to a 1-10 scale
      mappedFreq = map(rawAvgFreq, minExpectedFreq, maxExpectedFreq, 1, 5);
      mappedVol = map(rawAvgVol, minExpectedVol, maxExpectedVol, 1, 5);

      // 2. Constrain them so a super loud noise doesn't output an 11 or 12
      latestAvgFreq = constrain(mappedFreq, 1, 5);
      latestAvgVol = constrain(mappedVol, 1, 5);

      // Reset the sums for the next batch
      frequencySum = 0;
      volumeSum = 0;
    }
  }
}

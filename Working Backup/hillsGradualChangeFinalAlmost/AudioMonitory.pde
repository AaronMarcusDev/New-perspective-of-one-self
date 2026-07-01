class AudioMonitor {
  AudioIn input;
  Amplitude volumeAnalyzer;
  PitchDetector frequencyAnalyzer;
  float confidenceLevel = 0.66;

  AudioMonitor(processing.core.PApplet sketch) {
    input = new AudioIn(sketch, 0);
    input.start();

    volumeAnalyzer = new Amplitude(sketch);
    volumeAnalyzer.input(input);

    frequencyAnalyzer = new PitchDetector(sketch, confidenceLevel);
    frequencyAnalyzer.input(input);
  }

  float getRawVolume() {
    return volumeAnalyzer.analyze() * 100; 
  }

  float getRawFrequency() {
    return frequencyAnalyzer.analyze();
  }
}

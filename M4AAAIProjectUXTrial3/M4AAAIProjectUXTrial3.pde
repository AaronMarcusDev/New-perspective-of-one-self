// Possible parameters:
// Sad/Disgust: <200 Hz & ~2 Amplitude
// Anger: <220 Hz & ~8 Amplitude
// Surprise: >230 Hz & <8 Amplitude
// Fear: >380 Hz & ~10 Amplitude
// Happy:

// SOUND
import processing.sound.*;

AudioIn input;
Amplitude volumeAnalyzer;
PitchDetector frequencyAnalyzer;
FFT fft;
float confidenceLevel = 0.66;
int time = 0;
int interval = 20;
boolean tickEnabled = false;

float volumeSum = 0;
float frequencySum = 0;

// SHAPES
Shapes[] shape = new Shapes [100];
//End end;
PImage fire, slime, cloud, sun, confetti, ghost;
PImage [] images;
int d, failedAttempts, successCount, maxAttempts;
float alpha = 0;

// COLORS
ColorHandler colorHandler;


boolean active = true;

void setup() {
  fullScreen();
  //size(1000, 500);
  background(0);
  colorMode(HSB, 360, 255, 255);

  // SOUND
  input = new AudioIn(this, 0);
  input.start();

  volumeAnalyzer = new Amplitude(this);
  volumeAnalyzer.input(input);

  frequencyAnalyzer = new PitchDetector(this, confidenceLevel);
  frequencyAnalyzer.input(input);


  // SHAPES
  d = 150;
  failedAttempts = 0;
  successCount = 0;
  maxAttempts = 7;

  fire = loadImage("fire.png");
  slime = loadImage("slime.png");
  cloud = loadImage("cloud.png");
  sun = loadImage("sun.png");
  confetti = loadImage("confetti.png");
  ghost = loadImage("ghost.png");

  images = new PImage[] {
    fire, slime, cloud, sun, confetti, ghost
  };

  for (PImage img : images) {
    img.resize(d*2, d*2);
  }
  //end = new End ();

  // COLORS
  colorHandler = new ColorHandler();
}

void draw() {
  boolean placed = false;

  if (active == true) {
    float volume = volumeAnalyzer.analyze();
    float volumeBoost = volume * 100;

    float frequency = frequencyAnalyzer.analyze();

    if (tickEnabled == false && frequency > 0 && volumeBoost > 0) {
      tickEnabled = true;
      volumeSum += volumeBoost;
      frequencySum += frequency;
    }
    if (tickEnabled == true) {
      time++;
      time %= interval;
      println("time = ", str(time));
    }

    if (time == 0 && tickEnabled == true) {
      tickEnabled = false;
      frequencySum /= interval;
      volumeSum /= interval;

      println(str(frequencySum), " Hz");
      println("volumeSum = ", str(volumeSum));

      int tries = 0;
      int maxTries = 5000;

      while (tries < maxTries) {
        // create a test dot with random position and diameter
        Shapes candidate = new Shapes(d);

        boolean isSafe = true;

        // check candidate with every dot already rendered
        for (int i = 0; i < successCount; i++) {
          if (candidate.isOverlapping(shape[i])) {
            isSafe = false;
            break; // stop checking once it doesnt meet the criteria
          }
        }

        // if criteria was met, save and draw the dot
        if (isSafe) {
          shape [successCount] = candidate;
          colorHandler.updateWhite(volumeSum*20, 0, 100);
          colorHandler.updateBlack(volumeSum*20);
          color tCol;

          if (frequencySum <= 200 && volumeBoost >= 7) { // Anger
            tCol = colorHandler.colorPicker(int(frequencySum), colorHandler.angerHue);
            shape[successCount].display(tCol, fire);
          } else if (frequencySum <= 220 && volumeBoost <= 3) { // Sadness
            tCol = colorHandler.colorPicker(int(frequencySum), colorHandler.sadHue);
            shape[successCount].display(tCol, cloud);
          } else if (frequencySum <= 220 && volumeBoost >= 3) { // Disgust
            tCol = colorHandler.colorPicker(int(frequencySum), colorHandler.disgustHue);
            shape[successCount].display(tCol, slime);
          } else if (frequencySum <= 380 && volumeBoost >= 7) { // Surprise
            tCol = colorHandler.colorPicker(int(frequencySum), colorHandler.surpriseHue);
            shape[successCount].display(tCol, confetti);
          } else if (frequencySum >= 380 && volumeBoost >= 7) { // Fear
            tCol = colorHandler.colorPicker(int(frequencySum), colorHandler.disgustHue);
            shape[successCount].display(tCol, ghost);
          } else {                                              // Happy
            tCol = colorHandler.colorPicker(int(frequencySum), colorHandler.happyHue);
            shape[successCount].display(tCol, sun);
          }

          successCount++;
          placed = true;
          break;
        }
        tries++;
      }

      if (!placed) {
        failedAttempts++;
        placed = true;
      }
    }
    if (failedAttempts >= maxAttempts) {
      active = false;
    }
  } else {
    if (alpha <= 256) {
      alpha += 0.1;
    }
    fill(0, 0, 0, alpha);
    rect(0, 0, width, height);
  }
}

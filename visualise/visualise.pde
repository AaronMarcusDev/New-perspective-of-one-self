import ddf.minim.*;
import ddf.minim.signals.*;

Minim minim;
AudioInput mic;
int audioVisualScale;
float aofs;

void setup() {
  size(1200, 850);
  pixelDensity(1);
  audioVisualScale = 5; // to increase how much larger the visual gets depending on the audio input.
  // Essentially a multiplier
  aofs = 0;
  colorMode(HSB, 1);   // important for your hue math
  minim = new Minim(this);

  // Use default audio input (microphone)
  mic = minim.getLineIn(Minim.MONO, 512);
}

void draw() {
  background(0);

  // mic.getLevel() gives a small float (approx 0.0–0.5)
  float level = mic.mix.level();

  // Scale it up to screen height
  // float barHeight = map(level, 0, 0.5, 0, height) * audioVisualScale;
  // Make audio influence the animation speed
  float audioBoost = map(level, 0, 0.3, 0.001, 0.05);

  visualiseSound(audioBoost);

  // fill(0, 200, 255);
  // rect(width/2 - 50, height - barHeight, 100, barHeight);
}

void visualiseSound(float audioBoost) {

  float noiseHue = noise(frameCount * 0.01) * (1 + mic.mix.level() * 0.2);
  //                                                    ^-- add 20% effect of the sound amplitude
  loadPixels();

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {

      float fx = 1.0 * x / width;
      float fy = 1.0 * y / height;
      float d = dist(x, y, width/2, height/2) / width;

      float alpha1 = 2*PI*(d + (fx + .5*fy)) + aofs;
      float alpha2 = 2*PI*(d + (-.5*fx - fy) * sin(.5*aofs)) + aofs;


      float hue = noiseHue + sin(alpha1) * sin(alpha2);

      pixels[y*width + x] = color(hue, 1, 1);
    }
  }

  updatePixels();

  // animate — audio controls speed
  aofs += audioBoost;
}
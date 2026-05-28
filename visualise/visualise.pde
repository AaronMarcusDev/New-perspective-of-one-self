import ddf.minim.*;
import ddf.minim.signals.*;

Minim minim;
AudioInput mic;
int audioVisualScale;

void setup() {
  size(600, 400);
  audioVisualScale = 5; // to increase how much larger the visual gets depending on the audio input.
                        // Essentially a multiplier
  minim = new Minim(this);

  // Use default audio input (microphone)
  mic = minim.getLineIn(Minim.MONO, 512);
}

void draw() {
  background(0);

  // mic.getLevel() gives a small float (approx 0.0–0.5)
  float level = mic.mix.level();

  // Scale it up to screen height
  float barHeight = map(level, 0, 0.5, 0, height) * audioVisualScale;

  fill(0, 200, 255);
  rect(width/2 - 50, height - barHeight, 100, barHeight);
}

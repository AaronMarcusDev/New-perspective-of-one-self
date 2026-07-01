class Microphone {
  PVector pos;
  float lifetime;
  float originalLifetime;
  float fadeOutThreshold;

  PImage icon;

  color micColor = color(255, 255, 255);
  float size = 20;

  float alpha = 255;

  Microphone(PVector pos, float lifetime, float fadeOutThreshold) {
    this.pos = pos;

    this.lifetime = lifetime;
    originalLifetime = lifetime;
    this.fadeOutThreshold = fadeOutThreshold;

    icon = loadImage("Images/microphone.png");
  }

  void update() {
    if (lifetime > 0) {
      lifetime--;
    }

    alpha = map(lifetime, 0, fadeOutThreshold, 0, 255);
    alpha = constrain(alpha, 0, 255);
  }

  void render() {
    if (lifetime > 0) {
      rectMode(CENTER);
      imageMode(CENTER);

      pushMatrix();
      translate(pos.x, pos.y);

      fill(0, 0, 0, alpha/4);
      rect(0, 0, width, height);

      tint(micColor, alpha);
      image(icon, 0, 0);

      popMatrix();

      rectMode(CORNER);
      imageMode(CORNER);
    }
  }

  void reset() {
    lifetime = originalLifetime;
  }

  float getLifetime() {
    return lifetime;
  }
}

class Particle {
  PVector pos;
  PVector speed;
  PVector accel;
  float damp;
  float lifetime;
  float originLifetime;
  float fadeOutTime = 0.1 * 60;
  float size;
  color particleColor;

  Particle (PVector initPos, PVector initSpeed, PVector initAccel, float initDamp, float initLifetime, float initFadeOutTime, float initSize, color initColor) {
    pos = initPos;
    speed = initSpeed;
    accel = initAccel;
    damp = initDamp;
    lifetime = initLifetime;
    originLifetime = initLifetime;
    fadeOutTime = initFadeOutTime * 60;
    size = initSize;
    particleColor = initColor;
  }

  void update() {
    PVector offset = new PVector(noise(lifetime*0.5), noise(lifetime*0.2));
    offset.x *= random(-1, 1);
    offset.y *= random(-1, 1);

    speed.add(accel);
    speed.mult(damp);
    speed.add(offset);
    pos.add(speed);
    pos.add(offset);
    lifetime--;
  }

  void render() {
    pushMatrix();
    translate(pos.x, pos.y);

    float alphaFactor = 255 * (lifetime/fadeOutTime);
    fill(particleColor, alphaFactor);
    scale(lifetime/originLifetime);
    circle(0, 0, size);
    popMatrix();
  }
}

class SpecParticle {
  PVector pos;
  float baseSpeed;
  float size;
  float maxAlpha;

  SpecParticle() {
    pos = new PVector(random(-100, -10), random(height));
    baseSpeed = random(15, 30);
    size = random(2, 10);
    maxAlpha = random(30, 100);
  }

  void update() {
    pos.x += baseSpeed * HeartBeatSpeedMultiplier;

    pos.y += random(-1, 1);
  }

  void display() {
    noStroke();

    fill(180, 180, 180, maxAlpha * 0.5);
    ellipse(pos.x, pos.y, size, size);
    fill(200, 200, 200, maxAlpha);
    ellipse(pos.x, pos.y, size * 0.5, size * 0.5);
  }

  boolean isDead() {
    return pos.x > width + size;
  }
}

class Current {
  ArrayList<PVector> trail;
  PVector head;
  float noiseSeedX;
  boolean isDead;
  float maxTailLength;

  Current(float startY) {
    head = new PVector(random(width), startY);
    trail = new ArrayList<PVector>();
    noiseSeedX = random(1000);
    isDead = false;
    maxTailLength = random(15, 40);
  }

  void update(float currentRiverFront) {
    // Perspective speed for the currents
    float speed = map(head.y, height / 2, height, 1.0, 5.0);
    head.y += speed;

    // 2D Perlin Noise to make the currents drift left and right organically
    float drift = map(noise(noiseSeedX, head.y * 0.01 + frameCount * 0.005), 0, 1, -3, 3);
    head.x += drift;

    trail.add(new PVector(head.x, head.y));

    if (trail.size() > maxTailLength) {
      trail.remove(0);
    }

    // If the current hits the physical wave front, it gets swallowed/dies
    if (head.y >= currentRiverFront) {
      isDead = true;
    }
  }

  void display() {
    noFill();
    strokeWeight(1.5);

    // Use curveVertex for smooth, fluid water lines instead of jagged dashes
    beginShape();
    for (int i = 0; i < trail.size(); i++) {
      PVector p = trail.get(i);
      // Fade the tail out
      float alpha = map(i, 0, trail.size() - 1, 0, 100);
      stroke(150, 190, 220, alpha);
      curveVertex(p.x, p.y);
    }
    endShape();
  }
}

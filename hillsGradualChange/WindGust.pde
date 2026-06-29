class WindGust {
  ArrayList<PVector> history; 
  PVector head;               
  float baseSpeed;
  float noiseOffset;
  float lifespan;
  float maxLength;

  WindGust() {
    head = new PVector(-100, random(100, height - 100));
    history = new ArrayList<PVector>();
    baseSpeed = random(6, 12);               
    noiseOffset = random(1000);          
    lifespan = 255;
    maxLength = random(15, 35);          
  }

  void update() {
    float currentSpeed = baseSpeed * HeartBeatSpeedMultiplier;
    head.x += currentSpeed;
    
    float noiseVal = noise(noiseOffset + frameCount * 0.01);
    head.y += map(noiseVal, 0, 1, -4, 4);

    history.add(new PVector(head.x, head.y));

    if (history.size() > maxLength) {
      history.remove(0);
    }

    if (head.x > width) {
      lifespan -= 10;
    }
  }

  void display() {
    noFill();
    strokeWeight(2);

    beginShape();
    for (int i = 0; i < history.size(); i++) {
      PVector p = history.get(i);
      float alpha = map(i, 0, history.size() - 1, 0, lifespan);
      stroke(200, 220, 255, alpha); 
      vertex(p.x, p.y);
    }
    endShape();
  }

  boolean isDead() {
    return lifespan <= 0;
  }
}

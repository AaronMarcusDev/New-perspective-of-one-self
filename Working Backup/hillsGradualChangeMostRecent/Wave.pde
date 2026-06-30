class Wave {
  float baseX;
  float currentX, currentY;
  float noiseOffsetX, noiseOffsetY;
  float baseSize;

  Wave(float horizonY) {
    baseX = random(width);
    noiseOffsetX = random(1000);
    noiseOffsetY = random(2000); // Different offset so X and Y spasm independently
    baseSize = random(4, 18);
  }

  void update(float frontY) {
    // The spasm effect: Fast-moving noise mixed with random jitter
    // We map it so the jitter gets more violent the further down the screen it goes
    float spasmIntensity = map(frontY, height/2, height, 2, 15);
    
    float xSpasm = map(noise(noiseOffsetX + frameCount * 0.1), 0, 1, -spasmIntensity, spasmIntensity);
    float ySpasm = map(noise(noiseOffsetY + frameCount * 0.1), 0, 1, -spasmIntensity, spasmIntensity);
    
    currentX = baseX + xSpasm + random(-2, 2);
    
    // Y stays anchored to the river's front edge, plus the spasm
    currentY = frontY + ySpasm + random(-2, 2);
    
    // Slowly drift the base X so the foam doesn't stay in vertical lanes
    baseX += random(-0.5, 0.5);
    if (baseX > width) baseX = 0;
    if (baseX < 0) baseX = width;
  }

  void display() {
    noStroke();
    
    // Spasming size and opacity to make it look like boiling/crashing water
    float spasmSize = baseSize + random(-3, 5);
    float alpha = random(100, 255);
    
    // Outer blurry glow of the foam
    fill(180, 220, 255, alpha * 0.4);
    ellipse(currentX, currentY, spasmSize * 1.5, spasmSize * 1.5);
    
    // Bright white-blue core of the foam
    fill(220, 240, 255, alpha);
    ellipse(currentX, currentY, spasmSize, spasmSize);
  }
}

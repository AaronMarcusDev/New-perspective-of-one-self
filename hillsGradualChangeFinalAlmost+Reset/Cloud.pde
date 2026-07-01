class Cloud {
  float posX, posY, size;
  int softness = 0;
  color cloudCol = color(195, 210, 232);
  color currentCol = color(195, 210, 232);
  color strikeCol = color(#636c71);
  float fadeAlpha = 0;       // NEW: 0 = invisible, 255 = fully visible
  float fadeSpeed = 4;  

  // Fixed puff layout: {relX, relY, radius, xSizeOff, ySizeOff} — all relative to centre
  float[][] puffs = {
    {0, -26, 55, 5, 0}, // head
    {0, 10, 68, 0, -5}, // wide base
    {-62, -12, 42, 0, 0}, // left wing
    {62, -12, 42, 0, 0}, // right wing
    {-108, 6, 30, 0, 0}, // left edge [5][0]+[5][2]
    {108, 6, 30, 0, 0}, // right edge [6][0]+[6][2]
    {-50, 20, 44, 0, 0}, // left base
    {50, 20, 44, 0, 0}, // right base
  };

  lightning Lightning;
  boolean hasStruck = false;

  Cloud() { //takes in x position, y position, and s size, keep softness value low
    posY = random(height/15, height/11);
    posX = random(0, width);
    size = random(1, 3);
  }

  void drawCloud() {
    posX += 1*HeartBeatSpeedMultiplier;
    if (posX>=width+138*size) {
      posX=-138*size;
    }

    fadeAlpha = constrain(fadeAlpha + fadeSpeed, 0, 255); // NEW: ramp toward fully visible

    if (hasStruck) {
      Lightning.drawLightning();
    }
    pushMatrix();
    translate(posX, posY);
    noStroke();
    for (float[] p : puffs) {
      puff(p[0] * size, p[1] * size, p[2] * size, p[3], p[4]);
    }
    popMatrix();
    modCloudCol();
  }

   void puff(float cx, float cy, float r, float xOff, float yOff) {
    float xScale = r + xOff;
    float yScale = r + yOff;
    float visibility = fadeAlpha / 255.0; // NEW: 0.0–1.0 multiplier

    fill(currentCol, (25 + softness) * visibility);
    ellipse(cx, cy, xScale * 2.9, yScale * 2.9);
    fill(currentCol, (30 + softness) * visibility);
    ellipse(cx, cy, xScale * 2.4, yScale * 2.4);
    fill(currentCol, (140 + softness) * visibility);
    ellipse(cx, cy, xScale * 2.0, yScale * 2.0);
    fill(currentCol, (165 + softness) * visibility);
    ellipse(cx, cy, xScale * 1.6, yScale * 1.6);
  }

  void triggerLightning(int yLen) {
    this.Lightning = new lightning(int(posX), int(posY), yLen, 18, 3, 7, color(#6091ff), 255);
    changeStruckState();
    currentCol = strikeCol;
  }

  void updateCloud() {
    int liAlpha = Lightning.getLightAlpha();
    if (liAlpha > 0) {
      Lightning.setLightAlpha(liAlpha - 6);
    } else {
      changeStruckState();
    }
  }

  float getPosY() {
    return posY;
  }

  void setCloudCol(color col) {
    cloudCol = col;
  }

  void modCloudCol() {
    currentCol = lerpColor(currentCol, cloudCol, .08);
  }

  void changeStruckState() {
    hasStruck = !hasStruck;
  }

  boolean getStruckState() {
    return hasStruck;
  }
}

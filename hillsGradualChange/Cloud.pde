class Cloud {
  float posX, posY, size;
  int softness = 0;
  color cloudCol = color(195, 210, 232);
  color currentCol = color(195, 210, 232);
  color strikeCol = color(#636c71);

  // Fixed puff layout: {relX, relY, radius, xSizeOff, ySizeOff} — all relative to centre
  float[][] puffs = {
    {0, -26, 55, 5, 0}, // head
    {0, 10, 68, 0, -5}, // wide base
    {-62, -12, 42, 0, 0}, // left wing
    {62, -12, 42, 0, 0}, // right wing
    {-108, 6, 30, 0, 0}, // left edge
    {108, 6, 30, 0, 0}, // right edge
    {-50, 20, 44, 0, 0}, // left base
    {50, 20, 44, 0, 0}, // right base
  };

  lightning Lightning;
  boolean hasStruck = false;

  Cloud(float x, float y, float s) { //takes in x position, y position, and s size, keep softness value low
    this.posX = x;
    this.posY = y;
    this.size = s;
  }

  void drawCloud() {
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

    fill(currentCol, 25 + softness);
    ellipse(cx, cy, xScale * 2.9, yScale * 2.9);
    fill(currentCol, 30 + softness);
    ellipse(cx, cy, xScale * 2.4, yScale * 2.4);
    fill(currentCol, 140 + softness);
    ellipse(cx, cy, xScale * 2.0, yScale * 2.0);
    fill(currentCol, 165 + softness);
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

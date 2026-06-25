Cloud[] clouds;

void setup() {
  size(800, 450);
  clouds = new Cloud[] {
    new Cloud(200, 170, 1.00),
    new Cloud(570, 200, 0.62),
    new Cloud(410, 340, 0.42),
  };
}

void draw() {
  background(232, 242, 252);
  for (Cloud c : clouds) {
    c.drawCloud();
  }
}


class Cloud {
  float posX, posY, size;

  // Fixed puff layout: {relX, relY, radius, xSizeOff, ySizeOff} — all relative to centre
  float[][] puffs = {
    {0, -26, 55, 5, 0},   // head
    {0,  10, 68, 0, -5},   // wide base
    {-62, -12, 42, 0, 0},   // left wing
    {62, -12, 42, 0, 0},   // right wing
    {-108,  6, 30, 0, 0},   // left edge
    {108,  6, 30, 0, 0},   // right edge
    {-50,  20, 44, 0, 0},   // left base
    {50,  20, 44, 0, 0},   // right base
  };

  Cloud(float x, float y, float s) {
    this.posX = x;
    this.posY = y;
    this.size = s;
  }

  void drawCloud() {
    pushMatrix();
    translate(posX, posY);
    noStroke();
    for (float[] p : puffs) {
      puff(p[0] * size, p[1] * size, p[2] * size, p[3], p[4]);
    }
    popMatrix();
  }

  void puff(float cx, float cy, float r, float xOff, float yOff) {
    float xScale = r + xOff;
    float yScale = r + yOff;
    
    fill(195, 210, 232, 25);  
    ellipse(cx, cy, xScale * 2.9, yScale * 2.9); 
    fill(195, 210, 232, 30);
    ellipse(cx, cy, xScale * 2.4, yScale * 2.4);
    fill(195, 210, 232, 140);
    ellipse(cx, cy, xScale * 2.0, yScale * 2.0);
    fill(195, 210, 232, 165);
    ellipse(cx, cy, xScale * 1.6, yScale * 1.6);
  }
}

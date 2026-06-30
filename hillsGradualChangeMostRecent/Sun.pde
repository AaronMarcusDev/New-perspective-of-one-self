class Sun {
  int posX = width;
  int posY = 0;
  int radius = 250;
  color sunColor = color(#fff000);
  color rayColor = color(#FFC400);
  int glowMinWeight = 8;
  int glowMaxWeight = 30;
  int gradientAlpha = 200;
  int radianceSize = 20;
  int radianceAlpha = 200;
  PGraphics auraBuffer;

  void buildAuraBuffer() {
    int bufSize = (radius + radianceSize) * 2;
    auraBuffer = createGraphics(bufSize, bufSize);
    int cx = auraBuffer.width / 2;
    int cy = auraBuffer.height / 2;
    int opacityStep = max(1, radianceAlpha / radianceSize);
    auraBuffer.beginDraw();
    auraBuffer.clear();
    auraBuffer.noStroke();
    auraBuffer.fill(sunColor, opacityStep);
    for (int i = radius; i < radius + radianceSize; i++) {
      auraBuffer.circle(cx, cy, i);
    }
    auraBuffer.endDraw();
  }

  Sun(int x, int y, int rad, int glowMinW, int glowMaxW, int gradAlpha, int radianceSize, int radianceAlpha) {
    // takes in x and y position, radius of the sun, the sun and ray colors, glowMin and glow Max determine the size of the outline, gradAlpha determines the blending of the outline with the body.
    //pls keep radianceSize low :pray:
    this.posX = x;
    this.posY = y;
    this.radius = rad;
    //this.sunColor = sunCol;
    //this.rayColor = rayCol;
    this.glowMinWeight = glowMinW;
    this.glowMaxWeight = glowMaxW;
    this.gradientAlpha = gradAlpha;
    this.radianceSize = radianceSize;
    this.radianceAlpha = radianceAlpha;
  }

  void drawSun() {
    drawAura();
    stroke(rayColor);
    strokeWeight(glowMinWeight);
    fill(rayColor);
    circle(posX, posY, radius);

    int glowMin = radius - glowMinWeight;
    int glowMax = radius - glowMaxWeight;

    noStroke();
    fill(sunColor, gradientAlpha);
    ellipse(posX, posY, glowMin, glowMax);
    fill(sunColor);
    ellipse(posX, posY, glowMin-glowMinWeight, glowMax-glowMaxWeight);
  }

  void drawAura() {
    imageMode(CENTER);
    image(auraBuffer, posX, posY);   // single image blit instead of 100 circles
    imageMode(CORNER);
  }
}

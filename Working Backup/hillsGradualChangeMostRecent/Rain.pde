//rain class
class Rain {
  int[] area = new int[4];
  float windDisp = -7;          // float, was int — needed for smooth easing
  int dropLength = 30;
  int xSpacing = 14;
  int[] displacement = {0, 0};
  color rainCol = color(#73b5e0);
  float spaceMultiplier = 1.20;
  int rainWeight = 1;
  int rainOpacity = 0;
  int rainXSpeed = -5;
  int rainYSpeed = 9;

  // vertex cache: avoids rebuilding drop positions every frame
  int rowStep;
  float[] verts;
  int vertCount;
  float lastWindDisp = 1e10;    // forces a build on first frame
  final float REBUILD_THR = 1.0;

  // Noise / wind drift
  float noiseT = 0, noiseInc = 0.015, xOff = 0;
  final int[] WIND_SPEEDS = {-22, -7, 7, 22};

  Rain(int x1, int y1, int x2, int y2, int wind, int dropLen, int spacing, int xD, int yD) {
    this.area[0] = x1;
    this.area[1] = y1;
    this.area[2] = x2;
    this.area[3] = y2;
    this.windDisp = wind;
    this.dropLength = dropLen;
    this.xSpacing = spacing;
    this.displacement[0] = xD;
    this.displacement[1] = yD;

    // cache rowStep and pre-allocate vertex buffer once
    rowStep = int(dropLength * spaceMultiplier);
    int maxRows = (area[3] - area[1] + 6 * rowStep) / rowStep + 2;
    int maxCols = (area[2] - area[0] + 4 * xSpacing + 200) / xSpacing + 2;
    verts = new float[maxRows * maxCols * 4];
  }

  // Only called when windDisp shifts by the rebuild threshold and not every frame
  void buildVerts() {
    int xStepInc    = int(xSpacing / 2 + windDisp * spaceMultiplier);
    int patternStep = 0;
    vertCount = 0;
    for (int y = area[1] - 5 * rowStep; y < area[3] + rowStep; y += rowStep) {
      int xStep = xStepInc * patternStep;
      for (int x = area[0] - xSpacing + xStep; x < area[2] + xSpacing; x += xSpacing) {
        verts[vertCount++] = x;
        verts[vertCount++] = y;
        verts[vertCount++] = x + windDisp;
        verts[vertCount++] = y + dropLength;
      }
      if (++patternStep > 2) patternStep = 0;
    }
    lastWindDisp = windDisp;
  }

  void drawRain() {
    if (abs(windDisp - lastWindDisp) >= REBUILD_THR) buildVerts();

    pushMatrix();
    translate(displacement[0], displacement[1]); // one transform instead of per-vertex addition
    strokeWeight(rainWeight);
    stroke(rainCol, rainOpacity);
    noFill();
    beginShape(LINES);
    for (int i = 0; i < vertCount; i += 2) {
      vertex(verts[i], verts[i + 1]);
    }
    endShape();
    popMatrix();
  }

  void updateRain() {
    displacement[1] += rainYSpeed;
    if (abs(displacement[1]) > 3 * rowStep) {
      displacement[1] = displacement[1] % rowStep;
    }
    displacement[0] += rainXSpeed;
    if (abs(displacement[0]) > xSpacing) {
      displacement[0] = displacement[0] % xSpacing;
    }
  }

  void modRainSpeed(int setting) {
    float target = WIND_SPEEDS[constrain(setting, 0, 3)];

    noiseT += noiseInc;
    float n = noise(noiseT);
    if      (n > 0.66) xOff += 0.5;
    else if (n < 0.34) xOff -= 0.5;
    xOff = constrain(xOff, -3, 3);

    float setRainDisp = constrain(target + xOff, -30, 30);
    rainXSpeed = int(setRainDisp * 0.5);
    rainYSpeed = (abs(rainXSpeed) > 10) ? 9 : 12;

    if      (windDisp > setRainDisp) windDisp -= 0.4;
    else if (windDisp < setRainDisp) windDisp += 0.4;
  }

  // Unchanged
  void modRainOpacity(int opaque) {
    rainOpacity = constrain(rainOpacity + opaque, 0, 255);
  }

  int getRainOpacity() {
    return rainOpacity;
  }
}

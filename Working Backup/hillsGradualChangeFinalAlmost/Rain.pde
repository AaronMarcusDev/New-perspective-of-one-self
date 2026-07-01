//rain class
class Rain {
  int[] area = new int[4]; // area array follows this format: {x1, y1, x2, y2}. determines the bounding box for the rain to be generated from
  float windDisp = 7;
  int dropLength = 30;
  int xSpacing = 14;
  float[] displacement = {0, 0}; // displacement of the rain relative to the X and Y (movement)
  color rainCol = color(#73b5e0);
  float spaceMultiplier = 1.20;
  int rainWeight = 1;
  int[] rainSpeeds = {-22, -7, 7, 22}; // values to set the slantedness of the rain depending on the wind
  float rainXSpeed = 5;
  float rainYSpeed = 9;
  int rainOpacity = 0;
  
  Rain(int x1, int y1, int x2, int y2, int wind, int dropLen, int spacing, int xD, int yD) { 
    //takes in the coordinates of the area to fill with rain (x1, y1, x2, y2), the angle of the rain lines, the length of the drops, spacing between drops & displacement of drops overall [x, y] (just leave it at 0, 0).
    this.area[0] = x1;
    this.area[1] = y1;
    this.area[2] = x2;
    this.area[3] = y2;
    this.windDisp = wind;
    this.dropLength = dropLen;
    this.xSpacing = spacing;
    this.displacement[0] = xD;
    this.displacement[1] = yD;
  }
  
  void drawRain() { // was supposed to make it so only a certain area on the screen would be rained on, but its very broken so just make it cover the whole screen tbh
    strokeWeight(rainWeight);
    stroke(rainCol, rainOpacity);
    int rowStep = int(dropLength*spaceMultiplier);
    int xStep = 0;
    int xStepInc = int(xSpacing/2 + (windDisp*spaceMultiplier));
    int patternStep = 0;
    
    for (int y = area[1] - 3*dropLength; y < area[3] + 3*dropLength; y += rowStep) {
      xStep = xStepInc * patternStep;
      for (int x = area[0] + xStep - 2*xSpacing; x < area[2] + 2*xSpacing; x += xSpacing) {
        line(x+displacement[0], y+displacement[1], x + windDisp+displacement[0], y + dropLength+displacement[1]);
      }
      patternStep++;
      if (patternStep > 2) {
        patternStep = 0;
      }
    }
  }
  
  void updateRain() {
    displacement[1]+=rainYSpeed;
    if (abs(displacement[1]) > 3*int(dropLength*spaceMultiplier)) {
      displacement[1] = displacement[1] % int(dropLength*spaceMultiplier);
    }
    displacement[0]+=rainXSpeed;
    if (abs(displacement[0]) > xSpacing) {
      displacement[0] = displacement[0] % xSpacing;
    }
  }
  
  void modulateRain(float wind, float xSpeed, float ySpeed) {
    windDisp = constrain(modulateValue(windDisp, wind, 1), 5, 100);
    rainXSpeed = constrain(modulateValue(rainXSpeed, xSpeed, 1), 0, 100);
    rainYSpeed = constrain(modulateValue(rainYSpeed, ySpeed, 1), 0, 100);
  }
  
  float modulateValue(float val, float targetVal, float increment) {
    if (val == targetVal) return val;
    else if (val < targetVal) return val += increment;
    else return val -= increment;
  }

  // Unchanged
  void modRainOpacity(int opaque) {
    rainOpacity = constrain(rainOpacity + opaque, 0, 255);
  }

  int getRainOpacity() {
    return rainOpacity;
  }
}

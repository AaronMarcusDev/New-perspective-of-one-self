class lightning {
  int posX; 
  int startPosY;
  int yLength;
  int[] points;
  int segments;
  float spikinessMin;
  float spikinessMax;
  color lightCol;
  int lightAlpha;
  float weight = 8;
  
  lightning(int x, int y, int yL, int parts, int spikiMin, int spikiMax, color lightCol, int lightAlpha) {
    //takes in the starting x and y position, the number of segments, and then the level of spikiness (minimum and maximum levels determine the displacement on the x axis of each segment)
    this.posX = x;
    this.startPosY = y;
    this.yLength = yL;
    this.spikinessMin = spikiMin;
    this.spikinessMax = spikiMax;
    this.segments = parts+1;
    this.points = new int[this.segments*2];
    this.lightCol = lightCol;
    this.lightAlpha = lightAlpha;
    setSegments();
  }
  
  void setSegments() {
    boolean leftSegment = boolean(int(random(2)));
    int lengthUnit = yLength/segments;
    
    for (int segment = 0; segment < segments; segment++) {
      int yVal = segment * lengthUnit;
      int xOff = int(random(spikinessMin, spikinessMax+1));
      if (leftSegment) {
        xOff = -xOff;
      }
    
      points[segment*2] = posX + xOff;
      points[(segment*2)+1] = startPosY + yVal;
      leftSegment = !leftSegment;
    }
  }
  
  void drawLightning() {
    for (int point = 0; point < (points.length)-2; point += 2) {
      drawSegment(points[point], points[point+1], points[point+2], points[point+3], color(lightCol, lightAlpha), 255, int(weight));
    }
    for (int point = 0; point < (points.length)-2; point += 2) {
      drawSegment(points[point], points[point+1], points[point+2], points[point+3], color(#ffffff, lightAlpha), 255, int(weight/3));
    }
  }
  
  void drawSegment(int x1, int y1, int x2, int y2, color lineCol, int alpha, int weight) {
    stroke(lineCol, alpha);
    strokeWeight(weight);
    line(x1, y1, x2, y2);
    }
    
  void setLightAlpha(int lightAlpha) {
    this.lightAlpha = lightAlpha;
  }
  
  int getLightAlpha() {
    return lightAlpha;
  }
    
}

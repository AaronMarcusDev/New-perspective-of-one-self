lightning LIGHT;

void setup() {
  size(800,600);
  LIGHT = new lightning(width/2, 10, 400, 18, 2, 6);
}

void draw() {
  background(#ffffff);
  LIGHT.drawLightning();
}


class lightning {
  int posX; 
  int startPosY;
  int yLength;
  int[] points;
  int segments;
  float spikinessMin;
  float spikinessMax;
  
  lightning(int x, int y, int yL, int parts, int spikiMin, int spikiMax) {
    this.posX = x;
    this.startPosY = y;
    this.yLength = yL;
    this.spikinessMin = spikiMin;
    this.spikinessMax = spikiMax;
    this.segments = parts+1;
    this.points = new int[this.segments*2];
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
      drawSegment(points[point], points[point+1], points[point+2], points[point+3], color(#6091ff), 255, 10);
    }
    for (int point = 0; point < (points.length)-2; point += 2) {
      drawSegment(points[point], points[point+1], points[point+2], points[point+3], color(#ffffff), 255, 5);
    }
  }
  
  void drawSegment(int x1, int y1, int x2, int y2, color lineCol, int alpha, int weight) {
    stroke(lineCol, alpha);
    strokeWeight(weight);
    line(x1, y1, x2, y2);
    }
    
}

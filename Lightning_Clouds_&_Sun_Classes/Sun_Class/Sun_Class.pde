Sun sun;

void setup() {
  size(1920, 1080);
  background(200,200,200);
  fullScreen();
  sun = new Sun(width, 0, 250, color(#fff000), color(#ff9f00), 6, 20, 200);
}

void draw() {
  sun.drawSun();
}

void keyPressed() {
  if (key == 'x' || keyCode == 27) {
    exit();
  }
}

void generateCloud() {
  
}

class Sun {
  int posX = width; 
  int posY = 0; 
  int radius = 250; 
  color sunColor = color(#fff000);
  color rayColor = color(#ff9f00);
  int glowMinWeight = 8;
  int glowMaxWeight = 30;
  int gradientAlpha = 200;

  Sun(int x, int y, int rad, color sunCol, color rayCol, int glowMinW, int glowMaxW, int gradAlpha) {
    this.posX = x; 
    this.posY = y; 
    this.radius = rad; 
    this.sunColor = sunCol;
    this.rayColor = rayCol;
    this.glowMinWeight = glowMinW;
    this.glowMaxWeight = glowMaxW;
    this.gradientAlpha = gradAlpha;
  }
  
  void drawSun() {
  stroke(rayColor);
  strokeWeight(glowMinWeight);
  fill(rayColor);
  circle(posX, posY, radius);
  
  int glowMin = radius - glowMinWeight;
  int glowMax = radius - glowMaxWeight;
  
  noStroke();
  ellipseMode(RADIUS); // Sets the center of the ellipse to posX and posY, but also changes drawings using ellipse in the process. Change back after if needed <-- !!! IMPORTANT !!!
  fill(sunColor, gradientAlpha);
  ellipse(posX, posY, glowMin, glowMax);
  fill(sunColor);
  ellipse(posX, posY, glowMin-glowMinWeight, glowMax-glowMaxWeight);
}
  
}

Sun sun;
lightning LIGHT;
rain Rain1;
Cloud[] clouds;
flash Flash;

int groundLevel = 600;
boolean rainy = false;

void setup() {
  size(1920, 1080);
  background(#ffffff);
  fullScreen();
  sun = new Sun(width, 0, 450, color(#fff000), color(#ff9f00), 8, 35, 200, 100, 180);
  sun.buildAuraBuffer();
  clouds = new Cloud[] {
    new Cloud(200, 170, 1.20, 0),
    new Cloud(870, 200, 0.82, 0),
    new Cloud(610, 340, 0.92, 0),
  };
  Rain1 = new rain(0, 0, width, height, -10, 30, 50, 0, 0);
  Flash = new flash(0);
}

void draw() {
  background(#d3f2ff);
  Flash.displayFlash();
  drawClouds();
  sun.drawSun();
  displayRain(Rain1);
}

void keyPressed() {
  if (key == 'x' || keyCode == 27) {
    exit();
  } else if (key == 'u') {
    clouds[0].triggerLightning(groundLevel-int(clouds[0].getPosY()));
    Flash.setAlpha(160);
  } else if (key == 'o') {
    clouds[1].triggerLightning(groundLevel-int(clouds[1].getPosY()));
  } else if (key == 'i') {
    clouds[2].triggerLightning(groundLevel-int(clouds[2].getPosY()));
  } else if (key == 'r') {
    rainy = !rainy;
  }
}

void drawClouds() {
  for (Cloud c : clouds) {
    c.drawCloud();
    if (c.getStruckState()) {
      c.updateCloud();
    }
  }
}

void displayRain(rain Rain) {
  int rainOpaqueness = Rain.getRainOpacity();
  if (!rainy) {
    if (rainOpaqueness > 0) {
      Rain.modRainOpacity(-10);
    } else {
      return;
    }
  } else if (rainy && (rainOpaqueness < 255)) {
    Rain.modRainOpacity(10);
  }
  Rain.drawRain();
  Rain1.updateRain();
}

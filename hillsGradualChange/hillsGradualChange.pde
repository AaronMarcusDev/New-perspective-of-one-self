Hill[] hill = new Hill[2];

Wind wind;
Mountains mountain;
River river;
Rain rain;
Sun sun;
Cloud[] clouds;
flash Flash;
FlowerDebris funnyFlowerDebris;
TreeDebris funnyTreeDebris;

int groundLevel = 600;
float mouseForce = 0.3;
float HeartBeatSpeedMultiplier =1;
float HeartBeatAmountMultiplier = 1;
float dryness = 0;
float mountDry;
boolean isDesert;
boolean rainy = false;

void setup() {
  fullScreen();
  noStroke();
  hill[0] = new Hill(false, 255); // wet hill visible
  hill[1] = new Hill(true, 0);    // dry hill hidden

  isDesert = false;

  wind = new Wind();
  mountain = new Mountains();
  river = new River();
  rain = new Rain(0, 0, width, height, -10, 30, 50, 0, 0);
  sun = new Sun(width, 0, 450, color(#fff000), color(#ff9f00), 8, 35, 200, 100, 180);
  sun.buildAuraBuffer();
  clouds = new Cloud[] { //array of clouds, can be adjusted, takes in x and y pos, and then a size multiplier
    new Cloud(width - 350, height/12, 2.80),
    new Cloud(width/9, height/9, 2.5),
    new Cloud(width/4, height/8, 2),
    new Cloud(width/2+200, height/13, 2.3)
  };
  Flash = new flash(0);



  // FLOWER DEBRIS
  funnyFlowerDebris = new FlowerDebris();

  // TREE DEBRIS
  funnyTreeDebris = new TreeDebris();
}

void draw() {
  background(#DEF8FF);

  mountain.display();

  hill[0].underWater();

  river.update();
  for (int i=0; i<2; i++) {
    hill[i].updateAlpha();
    hill[i].updateColors();

    if (hill[i].alpha > 0) {
      hill[i].update();
    }
  }
  funnyFlowerDebris.update();
  funnyFlowerDebris.render();

  funnyTreeDebris.update();
  funnyTreeDebris.render();

  sun.drawSun();
  displayRain(rain);
  if (rainy) {
    Flash.displayFlash();
    drawClouds();
  }
  wind.update();

  dryness = hill[0].alpha;
  mountDry = 255 - dryness;
  fill(0);
  stroke(10);
  line(width/2+300, height-670, width/2+300, height-360);
}

void mousePressed() {
  hill[0].fadeDirection = -1; // wet fades out
  hill[1].fadeDirection = 1;  // dry fades in
  isDesert = !isDesert;

  for (int i=0; i<4; i++) {
    strikeLightning(clouds[i]);
  }

  funnyFlowerDebris.applyForce(mouseForce);
  funnyTreeDebris.applyForce(mouseForce);
}

void keyPressed() {
  if (key == 'r') {
    hill[0].fadeDirection = 1;  // wet fades in
    hill[1].fadeDirection = -1; // dry fades out
    rainy = !rainy;
  }
  if (key == 'p' || key == 'P') {
    funnyFlowerDebris.toggleGrowth(true);
    funnyTreeDebris.toggleGrowth(true);
  } else if (key == 'l' || key == 'L') {
    funnyFlowerDebris.toggleGrowth(false);
    funnyTreeDebris.toggleGrowth(false);
  } else if (key == 't' || key == 'T') {

    PVector pos = new PVector(random(0, width), random(height/2-50, height));
    //while (pos.x > width/2-250 && pos.x < width/2+300 || pos.y > height -360 && pos.y < height-670) {
    //  pos = new PVector(random(0, width), random(height/2-50, height));
    //}
    boolean isInArea = false;

    while (isInArea == false) {
      if (pos.x < width/2-250 && pos.y > height-590) {
        isInArea = true;
      } else if (pos.x > width/2+300 && (pos.y < height-360 && pos.y > height-670)) {
        isInArea = true;
      } else {

        pos = new PVector(random(0, width), random(height/2-50, height));
      }
    }

    funnyTreeDebris.createTree(pos);
  } else if (key == 'f' || key == 'F') {
    boolean isInArea = false;
    PVector pos = new PVector(random(0, width), random(height/2-50, height));
    while (isInArea == false) {
      if (pos.x < width/2-250 && pos.y > height-590) {
        isInArea = true;
      } else if (pos.x > width/2+300 && (pos.y < height-360 && pos.y > height-670)) {
        isInArea = true;
      } else {

        pos = new PVector(random(0, width), random(height/2-50, height));
      }
    }
    funnyFlowerDebris.createFlower(pos);
  }
}

void displayRain(Rain rain2) {
  int rainOpaqueness = rain2.getRainOpacity();
  if (!rainy) {
    if (rainOpaqueness > 0) {
      rain2.modRainOpacity(-10);
    } else {
      return;
    }
  } else if (rainy && (rainOpaqueness < 255)) {
    rain2.modRainOpacity(10);
  }
  rain2.drawRain();
  rain.updateRain();
}


void drawClouds() { //method to draw clouds
  for (Cloud c : clouds) {
    c.drawCloud();
    if (c.getStruckState()) {
      c.updateCloud();
    }
  }
}

void strikeLightning(Cloud cloud) { //call this with one of the clouds in clouds array to summon a lightning from the cloud(i.e. clouds[1])
  cloud.triggerLightning(groundLevel-int(cloud.getPosY()));
  Flash.setAlpha(160); //adjust/remove this if its too epileptic/obnoxious
}

import processing.sound.*;
import processing.serial.*;

Hill[] hill = new Hill[3];
Cloud[] clouds = new Cloud[4];

Wind wind;
Mountains mountain;
River river;
Rain rain;
Sun sun;
BufferedAudioAnalyzer audioAnalyzer;
HeartbeatMonitor hb;

flash Flash;
FlowerDebris funnyFlowerDebris;
TreeDebris funnyTreeDebris;

Microphone microphone;

int groundLevel = 600;
int rainSetting = 3;
int rainTimer = 0;
int cooldown = 300;
int time = 0;
float mouseForce = 0.3;
float HeartBeatSpeedMultiplier =1;
float HeartBeatAmountMultiplier = 1;
float dryness = 0;
float mountDry;
float atmosphereAlpha;
color atmosphereCol;
boolean isDesert;
boolean rainy = false;

void setup() {
  fullScreen();
  noStroke();
  hill[0] = new Hill(0, 255); // wet hill visible
  hill[1] = new Hill(1, 0);    // dry hill hidden
  hill[2] = new Hill(2, 255); // white bacground (so no seethrough)

  isDesert = false;

  wind = new Wind();
  mountain = new Mountains();
  river = new River();
  rain = new Rain(0, 0, width, height, -10, 30, 50, 0, 0);
  sun = new Sun(width, 0, 450, 8, 35, 200, 100, 180);
  sun.buildAuraBuffer();
  for (int i=0; i<4; i++) {
    clouds[i] = new Cloud ();
  }

  Flash = new flash(0);

  // Microphone icon settings
  PVector micPos = new PVector(width/2, height/2);
  float micLifetime = 150; // ticks down per frame
  float micFadeOutThreshold = 90; // per frame
  
  microphone = new Microphone(micPos, micLifetime, micFadeOutThreshold);


  // FLOWER DEBRIS
  funnyFlowerDebris = new FlowerDebris();
  // TREE DEBRIS
  funnyTreeDebris = new TreeDebris();

  audioAnalyzer = new BufferedAudioAnalyzer(this);

  //  textAlign(CENTER, CENTER);

  // To see all devices: printArray(Serial.list())
  //hb = new HeartbeatMonitor(this, Serial.list()[0], 9600);
  //hb.setInitialBPM(72);       // nice default so it's not 0 at startup
  //hb.setNoiseSigma(1.2);      // ±1-2 BPM wobble feels natural for a demo
}


void draw() {
  background(#DEF8FF);
  time++;
  // 1. Tell the analyzer to do its background math
  audioAnalyzer.update();

  // 2. Grab the processed 1-10 numbers
  float currentFreq = audioAnalyzer.latestAvgFreq;
  float currentVol = audioAnalyzer.latestAvgVol;

  HeartBeatSpeedMultiplier = currentFreq;
  HeartBeatAmountMultiplier = currentVol;

  float windForce = wind.getForce();
  funnyFlowerDebris.applyForce(windForce);
  funnyTreeDebris.applyForce(windForce);

  //make it desert/green
  if (currentFreq<=1.3 && currentVol<=1.3 && millis()>5000) {
    hill[0].fadeDirection = -1; // wet fades out
    hill[1].fadeDirection = 1;  // dry fades in
    isDesert = true;
  } else {
    hill[0].fadeDirection = 1;  // wet fades in
    hill[1].fadeDirection = -1; // dry fades out
    isDesert = false;
  }

  //make ligthning
  if (currentFreq<=3 && currentVol>=3) {
    for (int i=0; i<4; i++) {
      strikeLightning(clouds[i]);
    }
    Flash.displayFlash();
  }

  //rain vs no rain
  if (currentFreq >=3 && currentVol >=3) {
    rainy = true;
  } else {
    rainy = false;
  }

  //make trees/flowers grow
  if (time>=cooldown && !isDesert) {
    if (currentVol <= 3) {
      PVector pos = new PVector(random(0, width), random(height/2-50, height));
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

      if (currentVol <= 1.3) {
        funnyTreeDebris.createTree(pos);
      } else {
        funnyFlowerDebris.createFlower(pos);
      }
      time=0;
    }
  }

  mountain.display();
  hill[0].underWater();
  river.update();
  hill[2].updateColors();
  hill[2].update();

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


  wind.update();
  dryness = hill[0].alpha;
  mountDry = 255 - dryness;

  //change atmosphere color
  if (rainy) {
    atmosphereCol=0;
    atmosphereAlpha++;
    atmosphereAlpha = constrain(atmosphereAlpha, 0, 70);
  } else if (hill[1].fadeDirection == 1) {
    atmosphereCol = #FF2C2F;
    atmosphereAlpha++;
    atmosphereAlpha = constrain(atmosphereAlpha, 0, 30);
  } else if (hill[1].fadeDirection == -1) {
    atmosphereAlpha--;
    atmosphereAlpha = constrain(atmosphereAlpha, 0, 30);
  }
  fill(atmosphereCol, atmosphereAlpha);
  rect(0, 0, width, height);

  //make trees and flower die and regrow
  if (hill[1].dead) {
    funnyFlowerDebris.toggleGrowth(false);
    funnyTreeDebris.toggleGrowth(false);
  } else if (hill[1].dead==false) {
    funnyFlowerDebris.toggleGrowth(true);
    funnyTreeDebris.toggleGrowth(true);
  }

  //make clouds
  if (currentVol>=1.2 || currentFreq>=1.2) {
    drawClouds();
  }
  
  microphone.update();
  microphone.render();

  //hb.update();
  //float bpm = hb.getBPM();

  //fill(255, 80, 80);
  //textSize(64);
  //text(nf(bpm, 0, 1), width / 2, height / 2);

  //fill(160);
  //textSize(16);
  //text("BPM", width / 2, height / 2 + 50);
}



void keyPressed() {
  if (key == '1') rainSetting = 0;
  else if (key == '2') rainSetting = 1;
  else if (key == '3') rainSetting = 2;
  else if (key == '4') rainSetting = 3;
}

void displayRain(Rain rain2) {
  rain2.modRainSpeed(rainSetting);
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

int getRainSetting(int heartbeat, int sound) { // change according to rain logic, pass in sensor values, returns a setting mode from 0-3: 0 = extreme left, 1 = soft left, 2 = soft right, 3 = extreme right
  if (heartbeat > 120) return 0;
  if (heartbeat > 50)  return 1;
  if (sound > 60)      return 2;
  return 3;
}

void checkRain(int cooldown) {
  if (millis() >= rainTimer + cooldown) {
    rainTimer   = millis();
    rainSetting = getRainSetting(0, 1); // !!! Important: swap in real sensor variables (heartbeat, sound)
  }
}

//// Wire serial events through to the monitor
//void serialEvent(Serial p) {
//  hb.onSerialEvent(p);
//}

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

flash Fade;
flash Flash;
FlowerDebris funnyFlowerDebris;
TreeDebris funnyTreeDebris;
Microphone microphone;

final int sessionTimeLimit = 3*10*1000; // time limit for the user in milliseconds
final int gracePeriod = 4000; // ms to hold the lush intro before audio starts affecting things
final int resetPauseTime = 5000; // time in ms to hold black screen
int sessionStartTime = millis();
boolean isResetting = false;

int groundLevel = 600;
int cooldown = 300;
int time = 0;
int timer = 0;
float mouseForce = 0.3;
float HeartBeatSpeedMultiplier =1;
float HeartBeatAmountMultiplier = 1;
float dryness = 0;
float mountDry;
float atmosphereAlpha;
color atmosphereCol;
boolean isDesert;
boolean rainy = false;

float s = 5, xS = 5, yS = 8; // debug code for rain - delete if unwanted


void setup() {
  fullScreen();
  noStroke();
  Fade = new flash(color(#000000), 0, 10);
  
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

  Flash = new flash(color(#ffffff), 0, -10);

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
  // 1. Tell the analyzer to do its background math
  audioAnalyzer.update();

  // 2. Grab the processed 1-10 numbers
  float currentFreq = audioAnalyzer.latestAvgFreq;
  float currentVol = audioAnalyzer.latestAvgVol;

  //fixes adjustnments for wind, clouds, rain, and lightning
  HeartBeatSpeedMultiplier = currentFreq; //change to heartbeat
  HeartBeatAmountMultiplier = currentVol; //change with heartbeat

  //adjustment for trees and flowers
  if (HeartBeatAmountMultiplier>=2.5) {
    time++;
  } else {
    time+=3;
  }

  float windForce = wind.getForce();
  funnyFlowerDebris.applyForce(windForce);
  funnyTreeDebris.applyForce(windForce);

  //make it desert/green
  if (!inGracePeriod() && currentFreq<=1.3 && currentVol<=1.3 && millis()>5000 && !rainy) {
    hill[0].fadeDirection = -1; // wet fades out
    hill[1].fadeDirection = 1;  // dry fades in
    isDesert = true;
  } else if (!inGracePeriod()) {
    hill[0].fadeDirection = 1;
    hill[1].fadeDirection = -1;
    isDesert = false;
  } else {
    // force the lush baseline explicitly during the grace window
    hill[0].fadeDirection = 1;
    hill[1].fadeDirection = -1;
    isDesert = false;
  }


  //makeLighntning with adjustment
  if (!inGracePeriod() && currentFreq <= 2.5 && currentVol >= 2.5) {
    timer++;
    if (HeartBeatAmountMultiplier >= 2.5) {
      if (timer >= 20) {
        for (int i = 0; i < 4; i++) {
          strikeLightning(clouds[i]);
        }
        Flash.displayFlash();
        timer = 0;
      }
    } else {
      if (timer >= 40) {
        for (int i = 0; i < 4; i++) {
          strikeLightning(clouds[i]);
        }
        Flash.displayFlash();
        timer = 0;
      }
    }
  } else {
    // Reset the timer when the lightning conditions are no longer true
    timer = 0;
  }

  //rain vs no rain
  if (!inGracePeriod() && currentFreq >=3 && currentVol >=3) {
    rainy = true;
  } else {
    rainy = false;
  }

  //make trees/flowers grow
  if (!inGracePeriod() && time>=cooldown && !isDesert) {
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
  float xSpeed = xS*map(currentFreq, 1, 5, 1, 2);
  float ySpeed = yS*map(currentFreq, 1, 5, 1, 2);
  float slant = s*map(HeartBeatAmountMultiplier, 1, 5, 1, 2);
  displayRain(rain, slant, xSpeed, ySpeed); // change based on desired rain values [see displayRain()]


  wind.update();
  dryness = hill[0].alpha;
  mountDry = 255 - dryness;

  //make clouds
  if (!inGracePeriod() && (currentVol>=1.2 || currentFreq>=1.2)) {
    drawClouds();
  }

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
  
  checkExperienceDuration();
  resetChecker();
}


void displayRain(Rain rain2, float slant, float xSpeed, float ySpeed) { //slant determines the slantedness of the rain, xSpeed and ySpeed determine its movement speed
  rain2.modulateRain(slant, xSpeed, ySpeed);
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


//// Wire serial events through to the monitor
//void serialEvent(Serial p) {
//  hb.onSerialEvent(p);
//}

void resetGlobalVars() {
  groundLevel = 600;
  cooldown = 300;
  time = 0;
  mouseForce = 0.3;
  HeartBeatSpeedMultiplier =1;
  HeartBeatAmountMultiplier = 1;
  dryness = 0;
  rainy = false;

  s = 5;
  xS = 10;
  yS = 8; // debug code for rain - delete if unwanted
}

void setupReset() {
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

  // FLOWER DEBRIS
  funnyFlowerDebris = new FlowerDebris();
  // TREE DEBRIS
  funnyTreeDebris = new TreeDebris();

  audioAnalyzer = new BufferedAudioAnalyzer(this);
}

void resetExperience() {
  resetGlobalVars();
  setupReset();
}

void checkExperienceDuration() {
  if (!isResetting && millis() >= sessionStartTime + sessionTimeLimit) {
    Fade.setAlphaInc(10);
    isResetting = true;
  }
}

void resetChecker() {
  if (isResetting) {
    Fade.displayFlash();
    if (Fade.getAlpha() >= 255) {
      resetExperience();
      delay(resetPauseTime); // hold black screen
      sessionStartTime = millis();
      Fade.setAlphaInc(-10);
    } else if (Fade.getAlpha() <= 0) {
      isResetting = false;
    }
  }
}

boolean inGracePeriod() {
  return millis() - sessionStartTime < gracePeriod;
}

import ddf.minim.*;
import ddf.minim.signals.*;

Minim minim;
AudioInput mic;
int audioVisualScale;
float aofs;


ParticleSystem[] particleSystems;
int maxParticleSystems = 50;
int maxParticlesPerSystem = 100;
int particleSystemLifetime = 30;

int time = 0;
int cooldown = 10;

String particleType = "";

void setup() {
  noStroke();
  ellipseMode(RADIUS);
  pixelDensity(1);
  audioVisualScale = 5;
  aofs = 0;
  minim = new Minim(this);
  mic = minim.getLineIn(Minim.MONO, 512);

  // size(1920, 1200);
  fullScreen();
  noCursor();
  
  background(10, 10, 10);

  particleSystems = new ParticleSystem[maxParticleSystems];
}

void draw() {
  background(10, 10, 10);
  
  time++;

  float level = mic.mix.level();
  float audioBoost = map(level, 0, 0.3, 0.001, 0.05);
  //println(audioBoost);

  if (audioBoost > 0.03) {
    particleType = "Anger";
    cooldown = 3;
  } else if (audioBoost > 0.015 && audioBoost < 0.03) {
    particleType = "Excited";
    cooldown = 5;
  } else if (audioBoost > 0.0035 && audioBoost < 0.015) {
    particleType = "Sadness";
    cooldown = 15;
  } else {
    particleType = "";
    cooldown = 1;
  }

  for (int i = 0; i < particleSystems.length; i++) {
    if (particleSystems[i] != null) {
      particleSystems[i].update();
      particleSystems[i].render();

      if (particleSystems[i].markForDeletion == true) {
        particleSystems[i] = null;
      }
    } else if (particleSystems[i] == null && time % cooldown == 0 && time > 0){
      particleSystems[i] = new ParticleSystem(new PVector(random(0, width), random(0, height)), maxParticlesPerSystem, particleSystemLifetime, particleType);
      time = 0;
    }
  }
}

//void mouseClicked() {
//  PVector mousePos = new PVector(mouseX, mouseY);

//  for (int i = 0; i < particleSystems.length; i++) {
//    if (particleSystems[i] == null) {
//      particleSystems[i] = new ParticleSystem(mousePos, maxParticlesPerSystem, particleSystemLifetime, particleType);
//      break;
//    }
//  }
//}

//void keyPressed() {
//  if (key == '1') {
//    particleType = "Anger";
//  } else if (key == '2') {
//    particleType = "Sadness";
//  } else if (key == '3') {
//    particleType = "Excited";
//  }
//}

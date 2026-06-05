class ParticleSystem {
  PVector pos;
  boolean markForDeletion;
  float time;
  float timeThreshold = 1;

  String particleType;

  Particle[] particles;

  ParticleSystem(PVector initPos, int particleAmount, float initTime, String initParticle) {
    pos = initPos;
    particles = new Particle[particleAmount];
    time = initTime;
    particleType = initParticle;
  }

  void update() {
    time--;

    for (int i = 0; i < particles.length; i++) {
      if (particles[i] != null) {
        particles[i].update();

        if (particles[i].lifetime <= 0) {
          particles[i] = null;
        }
      } else {
        if (time % timeThreshold == 0 && time >= 0) {
          PVector particlePos = pos.copy();
          PVector speed = new PVector();
          PVector accel = new PVector();
          float damping = 0;
          float lifetime = 0;
          float fadeOutTime = 0;
          float size = 0;
          color particleColor = color(0);

          if (particleType == "Anger") {
            particleColor = color(255, 0, 50);
            speed = new PVector(random(-6, 6), random(-3, 3));
            accel = new PVector(0, -2);
            damping = 0.99;
            lifetime = 20;
            fadeOutTime = 1.5;
            size = 80;
          } else if (particleType == "Sadness") {
            particleColor = color(50, 10, 205);
            speed = new PVector(random(-1, 1), random(-1, 3));
            accel = new PVector(0, 0.2);
            damping = 0.93;
            lifetime = 60;
            fadeOutTime = 8;
            size = 50;
          } else if (particleType == "Excited") {
            particleColor = color(250, 200, 10);
            speed = new PVector(random(-10, 10), random(-10, 10));
            accel = new PVector(random(-10, 10), random(-10, 10));
            damping = 0.5;
            lifetime = 60;
            fadeOutTime = 8;
            size = 80;
          }

          particles[i] = new Particle(particlePos, speed, accel, damping, lifetime, fadeOutTime, size, particleColor);
          break;
        }
      }
    }

    if (time <= 0) {
      if (checkParticlesFinished() == true) {
        markForDeletion = true;
      }
    }
  }

  void render() {
    for (int i = 0; i < particles.length; i++) {
      if (particles[i] != null) {
        particles[i].render();
      }
    }
  }

  boolean checkParticlesFinished() {
    for (int i = 0; i < particles.length; i++) {
      if (particles[i] != null) {
        return false;
      }
    }
    return true;
  }
}

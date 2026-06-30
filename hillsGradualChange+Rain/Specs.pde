class Specs {
  ArrayList<SpecParticle> particles;

  Specs() {
    particles = new ArrayList<SpecParticle>();
  }

  void update() {
    float spawnChance = 0.2 * HeartBeatAmountMultiplier;
    float maxSpecs = 40 * HeartBeatAmountMultiplier;
    
    if (random(1) < spawnChance && particles.size() < maxSpecs) {
      particles.add(new SpecParticle());
    }

    for (int i = particles.size() - 1; i >= 0; i--) {
      SpecParticle s = particles.get(i);
      s.update();
      s.display();
      
      if (s.isDead()) {
        particles.remove(i);
      }
    }
  }
}

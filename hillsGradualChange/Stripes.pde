class Stripes {
  ArrayList<WindGust> gusts;

  Stripes() {
   gusts = new ArrayList<WindGust>();
  }
  
  void update() {
    float spawnChance = 0.1 * HeartBeatAmountMultiplier;
    float maxGusts = 10 * HeartBeatAmountMultiplier;
    
    if (random(1) < spawnChance && gusts.size() < maxGusts) {
      gusts.add(new WindGust());
    }

    for (int i = gusts.size() - 1; i >= 0; i--) {
      WindGust g = gusts.get(i);
      g.update();
      g.display();
      
      if (g.isDead()) {
        gusts.remove(i);
      }
    }
  }
}

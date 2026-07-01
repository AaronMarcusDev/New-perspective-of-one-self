class FlowerDebris {
  ArrayList<MSDSystem> flowers;

  // FLOWER SETTINGS
  float flowerLength = 20;
  float flowerWidth = 4;
  float flowerMass = 4;
  float flowerSpringConstant = 0.1;
  float flowerDamping = 0.3;
  int flowerSegments = 3;
  int maxFlowers = 200;

  boolean growEnabled = true;
  float growFactor = 0.5;

  FlowerDebris() {
    flowers = new ArrayList<MSDSystem>();
  }

  void update() {
    for (int i = 0; i < flowers.size(); i++) {
      MSDSystem flower = flowers.get(i);

      if (flower.dead == true) {
        flowers.remove(flower);
      } else {
        flower.update();
      }
    }
  }

  void render() {
    rectMode(CENTER);
    ellipseMode(RADIUS);
    for (MSDSystem flower : flowers) {
      flower.render();
    }
    rectMode(CORNER);
    ellipseMode(CENTER);
  }

  void createFlower(PVector pos) {
    if (flowers.size()<maxFlowers) {
      MSDSystem flower = new MSDSystem(pos, flowerLength, flowerWidth, flowerMass, flowerSpringConstant, flowerDamping, flowerSegments);
      flower.toggleGrowth(growEnabled);
      flower.growFactor = growFactor;

      float scaleMult = map(pos.y, 0, height, 0, 1);
      flower.setScaleFactor(scaleMult);

      int i = 0;

      if (flowers.size() > 0) { // Condition that avoids an error when placing the first flower (with no other flowers present)
        while (pos.y > flowers.get(i).pos.y && i < flowers.size() - 1) { // Checks position of flower to others to set to correct index in array (so the debris renders it after the flowers in front, but before the ones behind it)
          i++;
        }
      }

      flowers.add(i, flower);
    }
  }

  void toggleGrowth(boolean growEnabled) {
    this.growEnabled = growEnabled;
    for (MSDSystem flower : flowers) {
      flower.toggleGrowth(growEnabled);
    }
  }

  void setGrowthFactor(float growFactor) {
    this.growFactor = growFactor;
    for (MSDSystem flower : flowers) {
      flower.growFactor = growFactor;
    }
  }

  void applyForce(float force) {
    for (MSDSystem flower : flowers) {
      flower.applyForce(force);
    }
  }
}

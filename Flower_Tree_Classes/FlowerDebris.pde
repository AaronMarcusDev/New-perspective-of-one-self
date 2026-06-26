class FlowerDebris {
  ArrayList<MSDSystem> flowers;

  // FLOWER SETTINGS
  float flowerLength = 20;
  float flowerWidth = 4;
  float flowerMass = 4;
  float flowerSpringConstant = 0.1;
  float flowerDamping = 0.3;
  int flowerSegments = 3;

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
    for (MSDSystem flower : flowers) {
      flower.render();
    }
  }

  void createFlower(PVector pos) {
    MSDSystem flower = new MSDSystem(pos, flowerLength, flowerWidth, flowerMass, flowerSpringConstant, flowerDamping, flowerSegments);
    flower.toggleGrowth(growEnabled);
    flower.growFactor = growFactor;

    flowers.add(flower);
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

class TreeDebris {
  ArrayList<TreeSystem> trees;

  // TREE SETTINGS
  float treeLength = 70;
  float treeWidth = 5;
  float treeMass = 120;
  float treeSpringConstant = 1;
  float treeDamping = 5;
  int treeDepth = 1;
  int branchingFactor = 3;
  color treeColor = color(120, 80, 0);

  boolean growEnabled = true;
  float growthFactor = 0.5;

  TreeDebris() {
    trees = new ArrayList<TreeSystem>();
  }

  void update() {
    for (int i = trees.size() - 1; i >= 0; i--) {
      TreeSystem tree = trees.get(i);

      if (tree.dead == true) {
        trees.remove(tree);
      } else {
        tree.update();
      }
    }
  }

  void render() {
    rectMode(CENTER);
    ellipseMode(RADIUS);
    for (TreeSystem tree : trees) {
      tree.render();
    }
    rectMode(CORNER);
    ellipseMode(CENTER);
  }

  void createTree(PVector treePos) {
    TreeSystem newTree = new TreeSystem(treePos, treeLength, treeWidth, treeMass, treeSpringConstant, treeDamping, treeDepth, branchingFactor);
    newTree.setColor(treeColor);
    newTree.toggleGrowth(growEnabled);
    newTree.growthFactor = growthFactor;

    float scaleMult = map(treePos.y, 0, height, 0, 1);
    newTree.setScaleFactor(scaleMult);

    int i = 0;

    if (trees.size() > 0) { // Condition that avoids an error when placing the first tree (with no other trees present)
      while (treePos.y > trees.get(i).pos.y && i < trees.size() - 1) { // Checks position of tree to others to set to correct index in array (so the debris renders it after the trees in front, but before the ones behind it)
        i++;
      }
    }

    trees.add(i, newTree);
  }

  void applyForce(float force) {
    for (TreeSystem tree : trees) {
      tree.applyForce(force);
    }
  }

  void toggleGrowth(boolean growEnabled) {
    this.growEnabled = growEnabled;
    for (TreeSystem tree : trees) {
      tree.toggleGrowth(growEnabled);
    }
  }

  void setGrowthFactor(float growthFactor) {
    this.growthFactor = growthFactor;
    for (TreeSystem tree : trees) {
      tree.growthFactor = growthFactor;
    }
  }
}

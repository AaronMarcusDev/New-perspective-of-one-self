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
    for (int i = 0; i < trees.size(); i++) {
      TreeSystem tree = trees.get(i);

      if (tree.dead == true) {
        trees.remove(tree);
      } else {
        tree.update();
      }
    }
  }

  void render() {
    for (TreeSystem tree : trees) {
      tree.render();
    }
  }

  void createTree(PVector treePos) {
    TreeSystem newTree = new TreeSystem(treePos, treeLength, treeWidth, treeMass, treeSpringConstant, treeDamping, treeDepth, branchingFactor);
    newTree.setColor(treeColor);
    newTree.toggleGrowth(growEnabled);
    newTree.growthFactor = growthFactor;

    trees.add(newTree);
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

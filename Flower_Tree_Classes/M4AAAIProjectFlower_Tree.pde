// Parameters for both the tree and the flower can be set in the their respective constructors.
// For the tree, depth is how far the branching goes (e.g. only branching out 4 times), whereas branchingFactor is the amount of branches sprouting from their parent branch (e.g. 3 branches per branch).
// I do warn that some of the code is quite messy in certain areas.

MSDSystem funnyFlower;
TreeSystem funnyTree;
float mouseForce = 0.3;

void setup() {
  fullScreen();
  background(128, 128, 128);

  noStroke();
  rectMode(CENTER);
  ellipseMode(RADIUS);

  // FLOWER SETTINGS
  PVector flowerPos = new PVector(width/4, height * 3/4);
  float flowerLength = height/4;
  float flowerWidth = 4;
  float flowerMass = 4;
  float flowerSpringConstant = 0.1;
  float flowerDamping = 0.3;
  int flowerSegments = 3;

  funnyFlower = new MSDSystem(flowerPos, flowerLength, flowerWidth, flowerMass, flowerSpringConstant, flowerDamping, flowerSegments);
  
  // TREE SETTINGS
  PVector treePos = new PVector(width * 3/4, height * 3/4);
  float treeLength = 200;
  float treeWidth = 15;
  float treeMass = 120;
  float treeSpringConstant = 1;
  float treeDamping = 5;
  int treeDepth = 1;
  int branchingFactor = 3;
  color treeColor = color(120, 80, 0);
  
  funnyTree = new TreeSystem(treePos, treeLength, treeWidth, treeMass, treeSpringConstant, treeDamping, treeDepth, branchingFactor);
  funnyTree.setColor(treeColor);
}

void draw() {
  background(128, 128, 128);

  funnyFlower.update();
  funnyFlower.render();
  
  funnyTree.update();
  funnyTree.render();
}

void mousePressed() {
  funnyFlower.applyForce(mouseForce);
  funnyTree.applyForce(mouseForce);
}

class TreeSystem {
  PVector pos;
  float rootLength;
  float rootWidth;
  float mass;
  float springConstant;
  float damping;
  float branchAngle = PI/4;
  TreeSegment[] treeSegments;

  TreeSystem (PVector pos, float rootLength, float rootWidth, float mass, float springConstant, float damping, int depth, int branchingFactor) {
    this.pos = pos;
    this.rootLength = rootLength;
    this.rootWidth = rootWidth;
    this.mass = mass;
    this.springConstant = springConstant;
    this.damping = damping;



    // Manual calculation for how many branches there are — each branch has n branches, so it's an exponential sum (n^0 -> n^0 + n^1 -> n^0 + n^1 + n^2 -> n^0 + n^1 + n^2 + n^3 -> etc.)
    int totalBranchAmount = 0;
    for (int i = 0; i <= depth; i++) {
      totalBranchAmount += pow(branchingFactor, i);
    }
    treeSegments = new TreeSegment[totalBranchAmount];

    // ROOT
    treeSegments[0] = new TreeSegment(rootLength, rootWidth, mass, springConstant, damping, 0);

    // BRANCHES
    int branchAmount = 0;
    for (int d = 0; d < depth; d++) {

      branchAmount += pow(branchingFactor, d);
      for (int i = 0; i < branchAmount; i++) {
        if (treeSegments[i].children == null) { // If current branch has not branched out yet
          treeSegments[i].children = new TreeSegment[branchingFactor];
          int count = i;
          
          while (treeSegments[count] != null) { // Checks for the next empty spot in the array
            count++;
          }
          // Creates branches
          for (int j = 0; j < branchingFactor; j++) {
            float angleMult = lerp(-1, 1, j/float(branchingFactor-1));
            
            float angle = branchAngle * angleMult;
            float mult = (depth-d)/float(depth);

            TreeSegment newBranch = new TreeSegment(rootLength*mult, rootWidth*mult, mass*mult, springConstant*mult, damping*mult, angle*mult);
            newBranch.setParent(treeSegments[i]);

            treeSegments[count+j] = newBranch; // Adds to array of all branches of this tree
            treeSegments[i].children[j] = newBranch; // Adds child to reference array of the current branch (treeSegments[i])
          }
        }
      }
    }
  }

  void update() {
    for (int i = treeSegments.length - 1; i >= 0; i--) {
      treeSegments[i].update();
    }
  }

  void render() {
    pushMatrix();
    translate(pos.x, pos.y);

    for (int i = 0; i < treeSegments.length; i++) {
      PVector offsetPos = treeSegments[i].offsetPos;

      pushMatrix();
      translate(offsetPos.x, offsetPos.y);
      rotate(treeSegments[i].realAngle);

      treeSegments[i].render();
      popMatrix();
    }

    popMatrix();
  }

  void applyForce(float force) {
    for (int i = 0; i < treeSegments.length; i++) {
      treeSegments[i].force += force;
    }
  }

  void setColor(color newColor) {
    for (int i = 0; i < treeSegments.length; i++) {
      treeSegments[i].segmentColor = newColor;
    }
  }
}

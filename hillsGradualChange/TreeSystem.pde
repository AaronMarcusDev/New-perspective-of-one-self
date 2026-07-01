class TreeSystem {
  PVector pos;
  float rootLength;
  float rootWidth;
  float mass;
  float springConstant;
  float damping;
  int depth;
  int maxDepth;
  int branchingFactor;
  float branchAngle = PI/4;
  ArrayList<TreeSegment> treeSegments;

  boolean growEnabled = true;
  float growthFactor = 1;
  boolean dead = false;

  float scaleFactor = 1;


  TreeSystem (PVector pos, float rootLength, float rootWidth, float mass, float springConstant, float damping, int maxDepth, int branchingFactor) {
    this.pos = pos;
    this.rootLength = rootLength;
    this.rootWidth = rootWidth;
    this.mass = mass;
    this.springConstant = springConstant;
    this.damping = damping;
    depth = 0;
    this.maxDepth = maxDepth;
    this.branchingFactor = branchingFactor;

    treeSegments = new ArrayList<TreeSegment>();

    // ROOT
    treeSegments.add(new TreeSegment(rootLength, rootWidth, mass, springConstant, damping, 0));
  }

  void update() {
    if (treeSegments.size() <= 0) {
      dead = true;
      return;
    }

    for (int i = 0; i < treeSegments.size(); i++) {
      TreeSegment segment = treeSegments.get(i);
      segment.update();

      if (growEnabled == true) {
        segment.growIncrement(growthFactor);
        if (depth < maxDepth) {
          createBranches(segment);
        }
      } else {
        destroyBranches(segment);
      }
    }
  }

  void render() {
    pushMatrix();
    translate(pos.x, pos.y);
    scale(scaleFactor);

    for (TreeSegment segment : treeSegments) {
      PVector offsetPos = segment.offsetPos;

      pushMatrix();
      translate(offsetPos.x, offsetPos.y);
      rotate(segment.realAngle);

      segment.render();

      if ((segment.children == null || segment.children.size() <= 0) && segment != treeSegments.get(0)) { // check if the branch has no children and is not the root
        translate(0, -segment.segmentLength);
        createLeaves(segment);
      }

      popMatrix();
    }

    popMatrix();
  }

  void createBranches(TreeSegment segment) {
    // If current branch has not branched out yet and is fully grown
    if ((segment.children == null || segment.children.size() <= 0) && segment.segmentLength >= segment.maxLength) {
      segment.children = new ArrayList<TreeSegment>();

      // Creates branches
      for (int j = 0; j < branchingFactor; j++) {
        float angleMult = lerp(-1, 1, j/float(branchingFactor-1));

        float angle = branchAngle * angleMult;
        float mult = (maxDepth-depth)/float(maxDepth);

        TreeSegment newBranch = new TreeSegment(rootLength*mult, rootWidth*mult, mass*mult, springConstant*mult, damping*mult, angle*mult);
        newBranch.setParent(segment);

        treeSegments.add(newBranch); // Adds this to the array of all branches of this tree
        segment.children.add(newBranch); // Adds child to reference array of the current branch
      }

      depth++;
    }
  }

  void destroyBranches(TreeSegment segment) {
    boolean branchRemoved = false;

    if ((segment.children == null || segment.children.size() <= 0)) {
      if (segment.segmentLength <= 0) {
        if (segment.parent != null) {
          segment.parent.children.remove(segment);
        }
        treeSegments.remove(segment);
        branchRemoved = true;
      } else {
        segment.growIncrement(-growthFactor);
      }
    }

    if (branchRemoved && depth > 0) {
      depth--;
    }
  }

  void createLeaves(TreeSegment segment) {
    fill(#81DB33);
    circle(0, 0, segment.segmentLength/2);
  }


  void applyForce(float force) {
    for (TreeSegment segment : treeSegments) {
      segment.force += force;
    }
  }

  void setColor(color newColor) {
    for (TreeSegment segment : treeSegments) {
      segment.segmentColor = newColor;
    }
  }

  void toggleGrowth(boolean growEnabled) {
    this.growEnabled = growEnabled;
  }

  void setScaleFactor(float scaleFactor) {
    this.scaleFactor = scaleFactor;
  }
}

class TreeSegment {
  float segmentLength;
  float segmentWidth = 4;
  float mass;
  float force;
  float velocity;
  float angle;
  float startAngle;
  float realAngle;
  float springConstant;
  float damping;
  color segmentColor = color(120, 80, 0);

  TreeSegment parent;
  TreeSegment[] children;
  PVector offsetPos;

  TreeSegment (float newLength, float newWidth, float newMass, float newSpringConstant, float newDamping, float newStartAngle) {
    segmentLength = newLength;
    segmentWidth = newWidth;
    mass = newMass;
    springConstant = newSpringConstant;
    damping = newDamping;
    startAngle = newStartAngle;
    force = 0;
    velocity = 0;
    angle = 0;

    offsetPos = new PVector(0, 0);
  }

  void update() {
    float previousVelocity = 0;
    float previousAngle = 0;
    float nextForce = 0;
    if (parent != null) {
      previousVelocity = parent.velocity;
      previousAngle = parent.angle + parent.startAngle;

      PVector parentHeading = PVector.fromAngle(parent.realAngle - PI/2);
      parentHeading.mult(parent.segmentLength);
      offsetPos.set(parentHeading);
      offsetPos.add(parent.offsetPos);
    }
    if (children != null) {
      for (TreeSegment child : children) {
        nextForce += child.force;
      }
    }

    velocity += (-force+nextForce)/mass;
    angle += velocity-previousVelocity;
    force = angle * springConstant + velocity * damping;

    realAngle = angle + startAngle + previousAngle;
  }

  void render() {
    // Leaves
    if (parent != null) {
      fill(20, 200, 20);
      circle(0, -segmentLength, segmentWidth*8);
    }

    fill(segmentColor);
    rect(0, -segmentLength/2, segmentWidth, segmentLength);
    circle(0, 0, segmentWidth/2);
  }

  void setParent(TreeSegment newParent) {
    parent = newParent;
    startAngle += newParent.startAngle;
  }
}

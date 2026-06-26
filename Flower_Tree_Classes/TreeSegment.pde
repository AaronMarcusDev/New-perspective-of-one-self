class TreeSegment {
  float maxLength;
  float growIncrement = 1;
  float segmentLength = 0;
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
  ArrayList<TreeSegment> children;
  PVector offsetPos;

  TreeSegment (float maxLength, float segmentWidth, float mass, float springConstant, float damping, float startAngle) {
    this.maxLength = maxLength;
    this.segmentWidth = segmentWidth;
    this.mass = mass;
    this.springConstant = springConstant;
    this.damping = damping;
    this.startAngle = startAngle;
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

  void growIncrement(float increment) {
    if (segmentLength <= maxLength && increment > 0 || segmentLength > 0 && increment < 0) {
      segmentLength += increment;
    }
  }

  void render() {
    fill(segmentColor);
    rect(0, -segmentLength/2, segmentWidth, segmentLength);
    circle(0, 0, segmentWidth/2);
  }

  void setParent(TreeSegment newParent) {
    parent = newParent;
    startAngle += newParent.startAngle;
  }
}

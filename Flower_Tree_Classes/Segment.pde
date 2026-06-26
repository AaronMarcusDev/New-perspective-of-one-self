class Segment {
  float segmentLength;
  float maxLength;
  float segmentWidth = 4;
  float mass;
  float force;
  float velocity;
  float angle;
  float springConstant;
  float damping;
  color segmentColor = color(80, 240, 80);

  Segment (float segmentLength, float segmentWidth, float mass, float springConstant, float damping) {
    this.maxLength = segmentLength;
    this.segmentWidth = segmentWidth;
    this.mass = mass;
    this.springConstant = springConstant;
    this.damping = damping;
    force = 0;
    velocity = 0;
    angle = 0;
  }

  void update(float previousVelocity, float nextForce) {
    velocity += (-force+nextForce)/mass;
    angle += velocity-previousVelocity;
    force = angle * springConstant + velocity * damping;
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
}

class Segment {
  float segmentLength;
  float segmentWidth = 4;
  float mass;
  float force;
  float velocity;
  float angle;
  float springConstant;
  float damping;
  color segmentColor = color(80, 240, 80);

  Segment (float newLength, float newWidth, float newMass, float newSpringConstant, float newDamping) {
    segmentLength = newLength;
    segmentWidth = newWidth;
    mass = newMass;
    springConstant = newSpringConstant;
    damping = newDamping;
    force = 0;
    velocity = 0;
    angle = 0;
  }

  void update(float previousVelocity, float nextForce) {
    velocity += (-force+nextForce)/mass;
    angle += velocity-previousVelocity;
    force = angle * springConstant + velocity * damping;
  }

  void render() {
    fill(segmentColor);
    rect(0, -segmentLength/2, segmentWidth, segmentLength);
    circle(0, 0, segmentWidth/2);
  }
}

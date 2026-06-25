class MSDSystem {
  PVector pos;
  float systemLength;
  float systemWidth;
  float mass;
  float springConstant;
  float damping;
  Segment[] segments;
  boolean isFlower;

  MSDSystem (PVector pos, float systemLength, float systemWidth, float mass, float springConstant, float damping, int segmentAmount) {
    this.pos = pos;
    this.systemLength = systemLength;
    this.systemWidth = systemWidth;
    this.mass = mass;
    this.springConstant = springConstant;
    this.damping = damping;

    segments = new Segment[segmentAmount];
    for (int i = 0; i < segmentAmount; i++) {
      segments[i] = new Segment(systemLength/segmentAmount, systemWidth, mass, springConstant, damping);
    }
  }

  void update() {
    for (int i = segments.length - 1; i >= 0; i--) {
      float previousVelocity = 0;
      float nextForce = 0;
      if (i != 0) {
        previousVelocity = segments[i-1].velocity;
      } else if (i != segments.length - 1) {
        nextForce = segments[i+1].force;
      }

      segments[i].update(previousVelocity, nextForce);
    }
  }

  void render() {
    pushMatrix();
    translate(pos.x, pos.y);
    
    float lastSegmentOffset = 0;

    for (int i = 0; i < segments.length; i++) {
      float segmentOffset = segments[i].segmentLength;
      float segmentAngle = segments[i].angle;

      if (i != 0) { // Doesn't apply offset for the starting segment
        translate(0, -segmentOffset);
      }
      rotate(segmentAngle);

      segments[i].render();
      
      lastSegmentOffset = segmentOffset;
    }
    fill(255, 255, 0);
    circle(0, -lastSegmentOffset, 20);

    popMatrix();
  }

  void applyForce(float force) {
    for (int i = 0; i < segments.length; i++) {
      segments[i].force += force;
    }
  }

  void setColor(color newColor) {
    for (int i = 0; i < segments.length; i++) {
      segments[i].segmentColor = newColor;
    }
  }
}

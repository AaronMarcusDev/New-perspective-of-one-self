class MSDSystem {
  PVector pos;
  float systemLength;
  float systemWidth;
  float mass;
  float springConstant;
  float damping;
  int segmentAmount;
  ArrayList<Segment> segments;
  boolean isFlower;

  boolean growEnabled = true;
  float growFactor = 1;
  boolean dead = false;

  float scaleFactor = 1;

  MSDSystem (PVector pos, float systemLength, float systemWidth, float mass, float springConstant, float damping, int segmentAmount) {
    this.pos = pos;
    this.systemLength = systemLength;
    this.systemWidth = systemWidth;
    this.mass = mass;
    this.springConstant = springConstant;
    this.damping = damping;
    this.segmentAmount = segmentAmount;

    segments = new ArrayList<Segment>();

    segments.add(new Segment(systemLength/segmentAmount, systemWidth, mass, springConstant, damping));
    //for (int i = 0; i < segmentAmount; i++) {
    //  segments[i] = new Segment(systemLength/segmentAmount, systemWidth, mass, springConstant, damping);
    //}
  }

  void update() {
    if (segments.size() <= 0) {
      dead = true;
      return;
    }

    for (int i = segments.size() - 1; i >= 0; i--) {
      Segment segment = segments.get(i);

      float previousVelocity = 0;
      float nextForce = 0;
      if (i != 0) {
        previousVelocity = segments.get(i-1).velocity;
      } else if (i != segments.size() - 1) {
        nextForce = segments.get(i+1).force;
      }

      segment.update(previousVelocity, nextForce);

      if (growEnabled == true) {
        segment.growIncrement(growFactor);
        if (i == segments.size() - 1 && segment.segmentLength >= segment.maxLength && segments.size() < segmentAmount) {
          segments.add(new Segment(systemLength/segmentAmount, systemWidth, mass, springConstant, damping));
        }
      } else {
        if (i == segments.size() - 1) {
          segment.growIncrement(-growFactor);

          if (segment.segmentLength <= 0) {
            segments.remove(segment);
          }
        }
      }
    }
  }

  void render() {
    pushMatrix();
    translate(pos.x, pos.y);
    scale(scaleFactor);

    float lastSegmentOffset = 0;

    for (int i = 0; i < segments.size(); i++) {
      Segment segment = segments.get(i);

      float segmentOffset = segment.maxLength;
      float segmentAngle = segment.angle;

      if (i != 0) { // Doesn't apply offset for the starting segment
        translate(0, -segmentOffset);
      }
      rotate(segmentAngle);

      segment.render();

      lastSegmentOffset = segmentOffset;
    }
    if (segments.size() >= segmentAmount && segments.get(segments.size()-1).segmentLength >= segments.get(segments.size()-1).maxLength) {
      fill(255, 255, 0);
      circle(0, -lastSegmentOffset, segments.get(segments.size()-1).segmentLength);
    }

    popMatrix();
  }

  void applyForce(float force) {
    for (Segment segment : segments) {
      segment.force += force;
    }
  }

  void toggleGrowth(boolean growEnabled) {
    this.growEnabled = growEnabled;
  }

  void setColor(color newColor) {
    for (Segment segment : segments) {
      segment.segmentColor = newColor;
    }
  }

  void setScaleFactor(float scaleFactor) {
    this.scaleFactor = scaleFactor;
  }
}

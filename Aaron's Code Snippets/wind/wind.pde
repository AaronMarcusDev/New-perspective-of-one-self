ArrayList<WindGust> gusts;

void setup() {
  size(800, 600);
  gusts = new ArrayList<WindGust>();
}

void draw() {
  // Dark background with slight transparency for a smooth motion blur trail
  fill(20, 24, 35, 40);
  rect(0, 0, width, height);

  // Randomly trigger new wind gusts
  if (random(1) < 0.1 && gusts.size() < 10) {
    gusts.add(new WindGust());
  }

  // Update and draw each gust
  for (int i = gusts.size() - 1; i >= 0; i--) {
    WindGust g = gusts.get(i);
    g.update();
    g.display();
    
    if (g.isDead()) {
      gusts.remove(i);
    }
  }
}

class WindGust {
  ArrayList<PVector> history; // Stores the points of the line
  PVector head;               // The leading tip of the wind line
  float speed;
  float noiseOffset;
  float lifespan;
  float maxLength;

  WindGust() {
    // Start off-screen to the left at a random height
    head = new PVector(-50, random(100, height - 100));
    history = new ArrayList<PVector>();
    speed = random(6, 12);               // Speed of the gust
    noiseOffset = random(1000);          // Unique starting point for Perlin noise
    lifespan = 255;
    maxLength = random(15, 35);          // Number of vertices in the line
  }

  void update() {
    // Move the head forward
    head.x += speed;
    
    // Use Perlin noise to make the head drift up and down gracefully
    float noiseVal = noise(noiseOffset + frameCount * 0.01);
    head.y += map(noiseVal, 0, 1, -4, 4);

    // Save current head position to the history list
    history.add(new PVector(head.x, head.y));

    // Keep the line length under control
    if (history.size() > maxLength) {
      history.remove(0);
    }

    // Fade away when leaving the screen
    if (head.x > width) {
      lifespan -= 10;
    }
  }

  void display() {
    noFill();
    strokeWeight(2);

    // Draw the gust as a continuous curving stroke
    beginShape();
    for (int i = 0; i < history.size(); i++) {
      PVector p = history.get(i);
      
      // Gradually fade out toward the tail of the line
      float alpha = map(i, 0, history.size() - 1, 0, lifespan);
      stroke(200, 220, 255, alpha); 
      
      vertex(p.x, p.y);
    }
    endShape();
  }

  boolean isDead() {
    return lifespan <= 0;
  }
}

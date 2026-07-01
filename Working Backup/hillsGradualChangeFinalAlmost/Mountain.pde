class Mountains {
  int steps;
  float invDryness;
  float[] heights;
  float[] litDepths;
  float baseY;
  float mountTop;
  boolean isDry;

  Mountains() {
    steps = width;
    heights = new float[steps];
    litDepths = new float[steps];
    invDryness = map(dryness, 0, 255, 255, 0);
    baseY = height / 2 - 50;
    mountTop = height * 0.06;
    isDry = false;

    generate();
  }

  void generate() {
    float noiseOff = random(1000);
    float p1       = random(0.15, 0.35);
    float p2       = random(0.65, 0.85);
    float h1scale  = random(0.6, 1.0);
    float h2scale  = random(0.6, 1.0);
    float w1       = random(0.13, 0.17);
    float w2       = random(0.10, 0.20);

    // 1. Generate the raw geometry
    for (int i = 0; i < steps; i++) {
      float t  = (float) i / (steps - 1);
      float g1 = h1scale * exp(-pow((t - p1) / w1, 2));
      float g2 = h2scale * exp(-pow((t - p2) / w2, 2));
      float envelope = max(g1, g2);

      float n1 = noise(noiseOff +        t * width * 0.004);
      float n2 = noise(noiseOff + 300 +  t * width * 0.012) * 0.50;
      float n3 = noise(noiseOff + 600 +  t * width * 0.030) * 0.25;
      float n4 = noise(noiseOff + 900 +  t * width * 0.070) * 0.12;
      float n  = (n1 + n2 + n3 + n4) / 1.87;

      float h  = constrain(envelope * 0.70 + n * 0.55, 0, 1);
      heights[i] = map(h, 0, 1, baseY, mountTop);
    }

    heights = smoothArray(heights, 8);

    // 2. Calculate the Macro-Slope for lighting
    float[] rawLit = new float[steps];
    int lookahead = 15;

    for (int i = 0; i < steps; i++) {
      int next = min(i + lookahead, steps - 1);
      int prev = max(i - lookahead, 0);
      float slope = heights[next] - heights[prev];

      if (slope > 6) {
        rawLit[i] = 1.0;
      } else {
        rawLit[i] = 0.0;
      }
    }

    litDepths = smoothArray(rawLit, 20);
  }

  float[] smoothArray(float[] arr, int passes) {
    for (int p = 0; p < passes; p++) {
      float[] out = new float[arr.length];
      out[0] = arr[0];
      out[arr.length - 1] = arr[arr.length - 1];
      for (int i = 1; i < arr.length - 1; i++) {
        out[i] = (arr[i-1] + arr[i] + arr[i+1]) / 3.0;
      }
      arr = out;
    }
    return arr;
  }

  void display() {
    noStroke();

    // --- LAYER 1: BASE MOUNTAIN ---
    fill(106, 114, 137, 220);
    beginShape();
    vertex(0, baseY);
    for (int i = 0; i < steps; i++) {
      vertex(i, heights[i]);
    }
    vertex(width, baseY);
    endShape();

    // --- LAYER 2: LIT ROCK FACES ---
    fill(160, 170, 185);
    beginShape();
    for (int i = 0; i < steps; i++) {
      vertex(i, heights[i]);
    }
    for (int i = steps - 1; i >= 0; i--) {
      float maxDrop = baseY - heights[i];
      float ruggedNoise = noise(i * 0.01) * 0.8 + noise(i * 0.05) * 0.2;
      float noiseWobble = map(ruggedNoise, 0, 1, 0.2, 1);
      float dropAmount = maxDrop * litDepths[i] * noiseWobble * 0.8;
      float bottomY = min(heights[i] + dropAmount, baseY - 20);
      vertex(i, bottomY);
    }
    endShape();

    // --- LAYER 3: MELTING SNOWCAPS ---
    // Increased the cap to 40 so it melts slower than the river dries

    float activeDryness = min(mountDry, 255);

    // Maps the melt over a wider range (0 to 40 instead of 0 to 25)
    float snowDepth = map(activeDryness, 0, 40, 130, 0);

    if (snowDepth > 0) {
      fill(245, 250, 255);
      beginShape();

      for (int i = 0; i < steps; i++) {
        vertex(i, heights[i]);
      }

      for (int i = steps - 1; i >= 0; i--) {
        float snowLine = mountTop + snowDepth + map(noise(i * 0.015), 0, 1, -30, 30);
        vertex(i, max(heights[i], snowLine));
      }
      endShape();
    }
  }
}

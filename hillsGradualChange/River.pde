class River {
  float horizonY;
  float riverFrontY;
  ArrayList<Current> currents;
  ArrayList<Wave> waveFront;

  River() {
    horizonY = height / 2 - 50;
    riverFrontY = horizonY; // The river starts at the horizon
    currents = new ArrayList<Current>();
    waveFront = new ArrayList<Wave>();

    // Pre-populate the wave front particles
    for (int i = 0; i < 200; i++) {
      waveFront.add(new Wave(horizonY));
    }
  }

  void update() {
    // 1. Determine where the river front SHOULD be based on dryness
    float targetY = (dryness <= 250) ? horizonY : height + 100;

    // 2. Perspective Speed: Accelerate the closer the front gets to the bottom
    float speedMultiplier = map(riverFrontY, horizonY, height, 0.5, 6.0);

    // 3. Move the river front
    if (abs(riverFrontY - targetY) > 2) {
      if (riverFrontY < targetY) {
        riverFrontY += 1.5 * speedMultiplier; // Surging forward
      } else {
        riverFrontY -= 1.0 * speedMultiplier; // Receding (slightly slower)
      }
    }

    // Keep it within bounds
    riverFrontY = constrain(riverFrontY, horizonY, height + 100);

    // 4. Draw the River (Only if it has advanced past the horizon)
    if (riverFrontY > horizonY + 2) {
      noStroke();
      fill(#4580b0);
      // Draw the main body of water trailing behind the wave front
      rect(0, horizonY, width, riverFrontY - horizonY);

      // 5. Update and Draw the Organic Currents (The new texture)
      // Only spawn new currents if the river is flowing
      if (dryness < 25 && random(1) < 0.8) {
        currents.add(new Current(horizonY));
      }

      for (int i = currents.size() - 1; i >= 0; i--) {
        Current c = currents.get(i);
        c.update(riverFrontY);
        c.display();

        if (c.isDead) {
          currents.remove(i);
        }
      }

      // 6. Update and Draw the Spasming Wave Front
      // We only want the aggressive foam if the river is visible
      for (Wave sc : waveFront) {
        sc.update(riverFrontY);
        sc.display();
      }
    }
  }
}

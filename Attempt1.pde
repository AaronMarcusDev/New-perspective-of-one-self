Shapes[] shape = new Shapes [100];
End end;
PImage fire, slime, cloud, sun, confetti, ghost;
PImage [] images;
int d, failedAttempts, successCount;
boolean Placed = false;
int state = 1;

void setup() {
  fullScreen();
  background (0);
  d = 150;
  failedAttempts = 0;
  successCount = 0;


  fire = loadImage("fire.png");
  slime = loadImage("slime.png");
  cloud = loadImage("cloud.png");
  sun = loadImage("sun.png");
  confetti = loadImage("confetti.png");
  ghost = loadImage("ghost.png");

  images = new PImage[] {
    fire, slime, cloud, sun, confetti, ghost
  };

  for (PImage img : images) {
    img.resize(d*2, d*2);
  }
  
  end = new End ();
}

void draw () {
  if (state == 2) {
    end.black();
  }
}


void keyPressed () {
  Placed = false;
  if (state == 1 ) {

    if (successCount >= shape.length) return;

    int tries = 0;
    int maxtries = 5000;

    while (tries < maxtries) {
      // create a test dot with random position and diameter
      Shapes candidate = new Shapes(d);

      boolean isSafe = true;

      // check candidate with every dot already rendered
      for (int i = 0; i < successCount; i++) {
        if (candidate.isOverlapping(shape[i])) {
          isSafe = false;
          break; // stop checking once it doesnt meet the criteria
        }
      }

      // if criteria was met, save and draw the dot
      if (isSafe) {
        shape [successCount] = candidate;

        if (key == 'h') {
          shape[successCount].display(255, sun);
        } else if (key == 's') {
          shape[successCount].display(255, cloud);
        } else if (key == 'd') {
          shape[successCount].display(255, slime);
        } else if (key == 'a') {
          shape[successCount].display(255, fire);
        } else if (key == 'f') {
          shape[successCount].display(255, ghost);
        } else if (key == 'u') {
          shape[successCount].display(255, confetti);
        }
        successCount++;
        Placed = true;
        break;
      }
      tries++;
    }
  }
  if (!Placed) {
    failedAttempts ++;
    Placed = true;
  }

  if (failedAttempts == 5) {
    state = 2;
  }
}

FlowerDebris funnyFlowerDebris;
TreeDebris funnyTreeDebris;

float mouseForce = 0.3;

void setup() {
  fullScreen();
  //size(500, 500);
  background(128, 128, 128);

  noStroke();
  rectMode(CENTER);
  ellipseMode(RADIUS);

  // FLOWER DEBRIS
  funnyFlowerDebris = new FlowerDebris();

  // TREE DEBRIS
  funnyTreeDebris = new TreeDebris();
}

void draw() {
  background(128, 128, 128);

  funnyFlowerDebris.update();
  funnyFlowerDebris.render();

  funnyTreeDebris.update();
  funnyTreeDebris.render();
}

void mousePressed() {
  funnyFlowerDebris.applyForce(mouseForce);
  funnyTreeDebris.applyForce(mouseForce);
}

void keyPressed() {
  if (key == 'p' || key == 'P') {
    funnyFlowerDebris.toggleGrowth(true);
    funnyTreeDebris.toggleGrowth(true);
  } else if (key == 'l' || key == 'L') {
    funnyFlowerDebris.toggleGrowth(false);
    funnyTreeDebris.toggleGrowth(false);
  } else if (key == 't' || key == 'T') {

    PVector pos = new PVector(random(0, width), random(0, height));
    funnyTreeDebris.createTree(pos);
  } else if (key == 'f' || key == 'F') {

    PVector pos = new PVector(random(0, width), random(0, height));
    funnyFlowerDebris.createFlower(pos);
  }
}

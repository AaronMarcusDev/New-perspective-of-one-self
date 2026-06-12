class Shapes {
  int x, y, d;


  Shapes (int d) {
    this.d=d;
    x = int(random(width-d*2));
    y = int(random(height-d*2));
    //all images
  }

  boolean isOverlapping (Shapes other) {
    float distance = dist(this.x, this.y, other.x, other.y);
    return (distance < (this.d + other.d));
  }

  void display (color col, PImage img) {
    tint (col);
    image(img, x, y);
  }


}

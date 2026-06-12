class Start {
  float x, y, col, r;


  Start () {
    //x=width/2;
    //y=height/2;
    col = 255;
    r=1;
  }

  void writing (PImage img) {
    col -= r*1.1;

    //textSize(200);
    //text("Make a sound", x/2-80, y-50);
    tint (col);
    image(img, x, y);
  }
}

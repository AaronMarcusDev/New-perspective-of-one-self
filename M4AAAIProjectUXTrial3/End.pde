class End {
  int x, y;
  float alpha;

  End () {
    x= width;
    y=height;
    alpha = 0;
  }

  void black () {
    alpha+=0.1;
    fill(0, alpha);
    noStroke();
    rect(0, 0, x, y);
  }
}

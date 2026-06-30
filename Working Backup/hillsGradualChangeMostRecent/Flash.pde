class flash {
  int alpha = 0;
  color fCol= (#ffffff);
  
  flash(int alpha) {
    this.alpha = alpha;
  }
  
  void drawFlash() {
    noStroke();
    fill(fCol, alpha);
    rect(0, 0, width, height);
  }
  
  void displayFlash() {
    alpha = constrain(alpha, 0, 255);
    if (alpha > 0) {
      alpha-= 10;
      drawFlash();
    }
  }
    
  void setAlpha(int alpha) {
    this.alpha = alpha;
  }
  
}

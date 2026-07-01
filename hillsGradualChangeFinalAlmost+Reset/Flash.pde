class flash {
  float alpha = 0;
  color fCol = (#ffffff);
  float alphaInc = -10;
  
  flash(color col, float alpha, float alphaInc) {
    this.fCol = col;
    this.alpha = alpha;
    this.alphaInc = alphaInc;
  }
  
  void drawFlash() {
    noStroke();
    fill(fCol, alpha);
    rect(0, 0, width, height);
  }
  
  void displayFlash() {
     alpha+= alphaInc;
     alpha = constrain(alpha, 0, 255);
     if (alpha > 0) {
      drawFlash();
    }
  }
    
  void setAlpha(float alpha) {
    this.alpha = alpha;
  }
  
  float getAlpha() {
    return alpha;
  }
  
  void setAlphaInc(float alphaInc) {
    this.alphaInc = alphaInc;
  }
  
}

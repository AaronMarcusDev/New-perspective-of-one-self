class Wind {
  Stripes stripes;
  Specs specs;

  Wind() {
    stripes = new Stripes();
    specs = new Specs();
  }

  void update() {
    stripes.update();
    specs.update();
  }
}

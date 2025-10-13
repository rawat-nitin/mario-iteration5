class Coin {
  float x, y;
  boolean collected;

  Coin(float x, float y) {
    this.x = x;
    this.y = y;
    this.collected = false;
  }

  void update() {
    x -= 5;
  }

  void display() {
    if (!collected) {
      fill(255, 215, 0);
      ellipse(x, y, 25, 25);
    }
  }
}

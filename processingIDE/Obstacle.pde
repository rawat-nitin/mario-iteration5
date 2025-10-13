class Obstacle {
  float x;
  float w = 10;
  float h = 20;

  Obstacle(float x) {
    this.x = x;
  }

  void update() {
    x -= 5;
  }

  void display() {
    fill(139, 69, 19);
    rect(x, groundY - h, w, h);
  }
}

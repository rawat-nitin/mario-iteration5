class Sprite {
  PImage image;
  float x, y;
  float vx, vy;
  float w, h;

  Sprite(String filename, float scale, float x, float y) {
    image = loadImage(filename);
    w = image.width * scale;
    h = image.height * scale;
    this.x = x;
    this.y = y;
  }

  void display() {
    image(image, x - w / 2, y - h, w, h);
  }

  void update() {
    x += vx;
    y += vy;
  }
}

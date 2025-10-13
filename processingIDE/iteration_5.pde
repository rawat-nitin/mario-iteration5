// === Mario Game (Processing + Arduino Joystick) ===
import processing.serial.*;

Serial myPort;
PImage mario;
float marioX, marioY;
float groundY;
float velocity = 0;
boolean jumping = false;
boolean serialAvailable = false;
boolean gameOver = false;

// Obstacle
float obstacleX;
float obstacleY;
float obstacleW = 15;
float obstacleH = 20;
float marioSpeedX = 0;   // Horizontal speed of Mario

// Coin
float coinX;
float coinY;
boolean coinCollected = false;
int score = 0;

// Game state
boolean moving = false;
String lastCommand = "REST";

void setup() {
  size(1080, 810);
  groundY = height - 100;
  marioY = groundY;

  // Load and scale Mario
  mario = loadImage("mario.png");
  mario.resize(50, 0); // Shrink large image while keeping aspect ratio
  marioX = width / 2 - 25;

  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[2], 115200); // adjust index!

  resetObstacles();
  resetCoin();
}

void draw() {
  background(135, 206, 250); // Sky blue

  // Ground
  fill(34, 139, 34);
  rect(0, groundY, width, 100);

  if (!gameOver) {
    updateGame();
  } else {
    fill(255, 0, 0);
    textSize(32);
    text("GAME OVER!", width/2 - 100, height/2);
    textSize(16);
    text("Press Down on Joystick to restart", width/2 - 120, height/2 + 40);
  }

  // HUD
  fill(0);
  textSize(16);
  text("Score: " + score, 20, 30);

  // ✅ Always read serial data, even after Game Over
  handleSerial();
}

void updateGame() {
  marioX += marioSpeedX;

  // Move obstacles & coins relative to Mario if Mario is past middle
  if (moving && marioX > width / 2) {
    obstacleX -= marioSpeedX; // move background in opposite direction
    coinX -= marioSpeedX;
    marioX = width / 2; // Keep Mario centered
  }

  // Gravity for jump
  if (jumping) {
    velocity += 0.6;
    marioY += velocity;
    marioX = constrain(marioX, 0, width - mario.width);
    marioY = constrain(marioY, 0, groundY);  // Prevent going below ground
    if (marioY >= groundY) {
      marioY = groundY;
      jumping = false;
    }
  }

  // Draw Mario
  image(mario, marioX, marioY - mario.height);

  // Move background elements depending on joystick direction
  if (moving) {
    if (lastCommand.equals("RIGHT")) {
      obstacleX -= 4;  // move background left → Mario goes right
      coinX -= 4;
    } else if (lastCommand.equals("LEFT")) {
      obstacleX += 4;  // move background right → Mario goes left
      coinX += 4;
    }
  }

  // Draw Obstacle
  fill(0, 50, 0);
  rect(obstacleX, obstacleY, obstacleW, obstacleH);

  // Draw Coin
  if (!coinCollected) {
    fill(255, 215, 0);
    ellipse(coinX, coinY, 25, 25);
  }

  // Reset obstacle when it goes off-screen
  if (obstacleX < -obstacleW) resetObstacles();
  if (coinX < -25) resetCoin();

  // Collision detection
  if (marioX + 40 > obstacleX && marioX < obstacleX + obstacleW &&
      marioY > groundY - obstacleH - 5) {
    gameOver = true;
    myPort.write("GAMEOVER\n");
  }

  // Coin collection
  if (!coinCollected && dist(marioX + 20, marioY - 25, coinX, coinY) < 30) {
    coinCollected = true;
    score++;
    myPort.write("COIN\n"); // Tell Arduino to play sound
  }
}

void resetObstacles() {
  obstacleX = width + random(300, 600);
  obstacleY = groundY - obstacleH;
}

void resetCoin() {
  coinX = width + random(200, 700);
  coinY = random(groundY - 150, groundY - 50);
  coinCollected = false;
}

void restartGame() {
  gameOver = false;
  score = 0;
  marioX = 100;
  marioY = groundY;
  resetCoin();
  resetObstacles();
}

void handleSerial() {
  if (myPort.available() > 0) {
    String data = trim(myPort.readStringUntil('\n'));
    if (data != null) {
      serialAvailable = true;
      lastCommand = data.trim();
      println("Received from Arduino: " + lastCommand);

      switch (lastCommand) {
        case "LEFT":
          marioSpeedX = -4;
          moving = true;
          break;
        case "RIGHT":
          marioSpeedX = 4;
          moving = true;
          break;
        case "UP":
          if (!jumping) {
            velocity = -15;  // Jump Impulse
            jumping = true;
          }
          break;
        case "REST":
          marioSpeedX = 0;
          moving = false;
          break;
        case "DOWN":   // Restart game when joystick pressed down
          if (gameOver) {
            restartGame();
          }
          break;
      }
    }
  }
}

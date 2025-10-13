# mario-iteration5
This is a fun project which includes Arduino + JoyStick + Processing IDE.

**Summary**
| Component | Role | Notes |
|-----------|-----------|-----------|
| Arduino UNO R3 | Reads joystick, plays buzzer sounds, sends direction strings | “UP”, “LEFT”, “RIGHT”, “DOWN” |
| Processing | Receives serial messages, animates Mario | Handles jump and horizontal movement |
		
> **Note:** This project pitches.h file to be installed for Arduino IDE to compile and flash the code.
>
> Yes 👍 — here’s a **short, clear summary** of your **Arduino–Processing Mario game joystick setup**:

---

### 🎮 **Arduino–Processing Mario Game: Connection Summary**

#### 🧠 Components:

* Arduino UNOR3
* 1 × Joystick module
* 1 × Passive buzzer (for sounds)

---

### ⚡ **Connections**

#### 🕹️ **Joystick Module**

| Joystick Pin | Arduino Pin | Description                      |
| ------------ | ----------- | -------------------------------- |
| **VCC**      | **5V**      | Power for joystick               |
| **GND**      | **GND**     | Common ground                    |
| **VRx**      | **A0**      | X-axis analog input (LEFT/RIGHT) |
| **VRy**      | **A1**      | Y-axis analog input (UP/DOWN)    |
| **SW**       | **D2**      | Joystick button (optional use)   |

#### 🔊 **Buzzer**

| Buzzer Pin       | Arduino Pin | Description                    |
| ---------------- | ----------- | ------------------------------ |
| **+ (positive)** | **D8**      | Plays sounds (COIN, GAME OVER) |
| **– (negative)** | **GND**     | Ground                         |

---

### 🔌 **Serial Communication**

* Arduino sends joystick commands (`LEFT`, `RIGHT`, `UP`, `DOWN`, `REST`) via **Serial (115200 baud)**.
* Processing receives these and moves Mario accordingly.
* Processing sends back messages like `"COIN"` or `"GAMEOVER"` to trigger buzzer sounds.

---

Would you like me to also include a **simple diagram** (schematic-style) for the same connections?


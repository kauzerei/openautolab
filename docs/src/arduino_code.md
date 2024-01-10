# Arduino Code Dependencies

If you don't want to customize the software you can just use the [Web Flashing Utility](./web_update.md) to flash the latest OpenAutoLab firmware to the main board.

These instructions are intended for people that want to modify the code.

## Arduino IDE

The [Arduino Legacy IDE](https://www.arduino.cc/en/software) is the easiest way to program the board.
The [official documenation](https://docs.arduino.cc/software/ide-v1) contains guides on how to install the Arduino IDE v1.

## Libraries

Install the libraries using the Arduino IDE library manager.
Take a look at the [official documentation](https://docs.arduino.cc/software/ide-v1/tutorials/installing-libraries) for hints on how to install libraries.

You need the following libraries:

 - The [Arduino Servo library](https://www.arduino.cc/reference/en/libraries/servo/) allows to control the servo motor.
 - [LiquidCrystal I2C by Frank de Brabander](https://github.com/johnrickman/LiquidCrystal_I2C) is the library that manages LCD output.
 - The [HX711 by Bogdan Necula](https://github.com/bogde/HX711) library to manage load cell for measuring amount of liquid in tank.

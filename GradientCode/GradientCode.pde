import processing.serial.*;
import processing.io.*;

boolean UVLightON = false;


// Constants
int Y_AXIS = 1;
int X_AXIS = 2;
color colorLeft, colorRight, red, green, blue, black;

// Windows Size
float widthX = 410;
float heightY = 410;

// Position
float startPosX = 300-widthX/2;
float startPosY = 330-heightY/2;
float startPosX2 = 800-widthX/2;
float startPosY2 = 330-heightY/2;
float startPosX3 = 1400-widthX/2;

// Seconds
float redSeconds = 10;
float greenSeconds = 10;
float blueSeconds = 10;

boolean testBegun = false;
float lastMillis = 0;
int time = 0;

void setup() {
  //size(800, 480);
  fullScreen(P2D, 2);

  // Define colors
  red = color(255, 0, 0);
  green = color(0, 255, 0);
  blue = color(0, 0, 255);
  black = color(0);

  colorLeft = color(0, 0, 0);
  colorRight = red;
  
  GPIO.pinMode(4, GPIO.OUTPUT);

  loop();
}

void draw() {
  background(black);
  if (testBegun) {
    float m = millis() - lastMillis;
    //float m = millis()/1000;
    

    if (millis() > lastMillis + 1000) {
      println(time);
      time++;
      lastMillis = millis();
    }
    
    if (time <= redSeconds) {
      float redN = widthX / redSeconds;
      float redO = time * redN;
      fill(red);
      noStroke();
      rect(widthX + startPosX, startPosY, -redO, heightY/3);
      rect(widthX + startPosX2, startPosY2, -redO, heightY/3);
      rect(widthX + startPosX3, startPosY2, -redO, heightY/3);
    }

    if (time <= greenSeconds) {
      float greenN = widthX / greenSeconds;
      float greenO = time * greenN;
      fill(green);
      noStroke();
      rect(widthX + startPosX, heightY/3 + startPosY, -greenO, heightY/3);
      rect(widthX + startPosX2, heightY/3 + startPosY2, -greenO, heightY/3);
      rect(widthX + startPosX3, heightY/3 + startPosY2, -greenO, heightY/3);
    }

    if (time <= blueSeconds) {
      float blueN = widthX / blueSeconds;
      float blueO = time * blueN;
      fill(blue);
      noStroke();
      rect(widthX + startPosX, heightY/3+heightY/3 + startPosY, -blueO, heightY/3);
      rect(widthX + startPosX2, heightY/3+heightY/3 + startPosY2, -blueO, heightY/3);
      rect(widthX + startPosX3, heightY/3+heightY/3 + startPosY2, -blueO, heightY/3);
    }
  } 
  if(UVLightON) {
    GPIO.digitalWrite(4, GPIO.HIGH);
  } else {
    GPIO.digitalWrite(4, GPIO.LOW);
  }
}

void keyPressed() {
  if (key == ' ') {
    println("Test Started");
    testBegun = true;
  }
  
  if(key == 'u') {
    println("UV LIGHT ON!");
    UVLightON = !UVLightON;
  }
}

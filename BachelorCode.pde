import controlP5.*;
import java.util.*;
import processing.serial.*;
import processing.io.*;

ControlP5 cp5;

Texsim texsim;
Serial port;

File dir;
File [] files;

File preDir;
File [] preFiles;

File optDir;
File [] optFiles;

File testDir;
File []testFiles;

ProjectorScreen projectorScreen;

Serial ser;


static final int Red = 0;
static final int Green = 1;
static final int Blue = 2;

boolean isOnRaspBerry = false;
boolean UVLightON = false;
double lidarDistance = 0;

boolean isFinished = false;
boolean isNew = true;

boolean isReleased = true;
boolean startUp = true;
String showPreview = "no";
boolean hasRun = false;
boolean UVOnce = false;
boolean previewWaitForDraw = false;

boolean mouseIsPressed = false;

int projectionSpeed = 15;

int state; // Which state the program is in
int time1;
int loadingBarProgress = 0;

int highestTime = 0;
int uvLightTime = 0;
int pictureDuration = 0;
int time = 0;
int time2 = 0;
int imgWidthFactor = 100;
int imgHeightFactor = 100;
int imgWidthFactor2 = 100;
int imgHeightFactor2 = 100;
int imgSizeW = 0;
int imgSizeH = 0;

int imgCenterX = 310;
int imgCenterY = 194;

float resizeWidth = 1;
float resizeHeight = 1;

Button previewButton;
Button projectButton;

color crimson, white, grey, colorForButton, backgroundColor, buttonPressedColor, listBackgroundColor, listLineColor, listTextColor;
PFont f1;
PImage img, previewImg, projectionImg, projectedImage, selectedImage, imgShownOnProjector, finishedImg;
String selectedImg, fileName;


HashMap<String, OptimizedTimes> optValues1;
HashMap<String, OptimizedTimes> optValues2;
HashMap<String, String> previewTestValues;
ArrayList<ArrayList<Integer>> pictureTimesArray;


void setup() {
  // Colors
  crimson = color(220, 20, 60);
  white = color(255);
  grey = color(128);
  colorForButton = color(50, 83, 184);
  buttonPressedColor = color(32, 54, 120);
  backgroundColor = color(100);
  listBackgroundColor = color(200);
  listLineColor = color(100);
  listTextColor = color(0);


  if (isOnRaspBerry) {
    ser = new Serial(this, "/dev/ttyS0", 115200);
    GPIO.pinMode(4, GPIO.OUTPUT);
  }

  windowTitle("PIScreen");
  size(800, 480);
  //fullScreen(1);


  cp5 = new ControlP5(this);
  projectorScreen = new ProjectorScreen();
  //projectorScreen.setParent(this);


  preDir = new File(sketchPath("previewObjects/"));
  preFiles = preDir.listFiles();

  optDir = new File(sketchPath("OptimizationCode/"));
  optFiles = optDir.listFiles();

  time1 = millis();
  thread("readOptimizedValuesFile");

  state = 0;
}


void draw() {
  if (state == 0) {
    updateBackground();
    loadingScreen();
    getLidarData();
  }
  if (isNew) {
    background(backgroundColor);
    isNew = false;
    if (state == 1) { // FIRST SCREEN
      if (startUp) {
        loadFiles();
        startUp = false;
        isNew = true;
      } else {
        updateBackground();
        fill(0);
        rectMode(CENTER);
        rect(310, 194, 600, 346);
        cp5.show();
        ButtonClass selectButton = new ButtonClass(600/3*2 + 20, height - 60, 180, 60, "SELECT", 5, 5, colorForButton);
        ButtonClass previewButton = new ButtonClass(600/3*1 - 20, height - 60, 180, 60, "PREVIEW", 5, 5, colorForButton);
        selectButton.create();
        previewButton.create();

        imgCenterX = 310;
        imgCenterY = 194;

        if (fileName != null) {
          if (previewWaitForDraw) {
            createPreviewImage();
            previewWaitForDraw = false;
          }

          if (selectButton.isPressed() && isReleased) {
            println("SELECT");
            isReleased = false;
            state = 3;
            cp5.hide();
            updateBackground();
            pictureDuration = 0;
            imgSizeW = img.width;
            imgSizeH = img.height;
            imgCenterX = 310;
            imgCenterY = 194;
            imgWidthFactor = 100;
            imgHeightFactor = 100;
            imgWidthFactor2 = 100;
            imgHeightFactor2 = 100;
            getLidarData();
            isNew = true;
          }

          if (previewButton.isPressed() && isReleased) {
            println("Preview");
            isReleased = false;
            fill(white);
            textSize(30);
            textAlign(CENTER, CENTER);
            text("GENERATING PREVIEW IMAGE", 580/2, 348/2);
            previewWaitForDraw = true;
          }


          if (!isOnRaspBerry) {
            switch(showPreview) {
            case "yes":
              img = loadImage("previewObjects/" + fileName);
              break;
            case "no":
              img = loadImage("projectorObjects/" + fileName);
              break;
            }
          } else {
            switch(showPreview) {
            case "yes":
              img = loadImage("previewObjects/" + fileName);
              break;
            case "no":
              img = loadImage("/media/hello/MAGNUS/" + fileName);
              break;
            }
          }
          if (img != null) {
            img = returnResized(img, 580, 326);
          }
          if (img != null) {
            if (!previewWaitForDraw) {
              imageMode(CENTER);
              image(img, 310, 194);
            }
          }
          if (state == 3) {
            updateBackground();
            isNew = true;
          }
        }
      }
    }
  }

  if (state == 3) {
    if (fileName != null) {
      fill(0);
      rectMode(CENTER);
      rect(310, 194, 600, 346);

      if (loadImage("previewObjects/" + fileName) == null) {
        createPreviewImage();
      }
      if (isOnRaspBerry) {
        imgShownOnProjector = loadImage("/media/hello/MAGNUS/" + fileName);
      } else {
        imgShownOnProjector = loadImage("projectorObjects/" + fileName);
      }

      img = loadImage("previewObjects/" + fileName);
      selectedImage = loadImage("previewObjects/" + fileName);
      selectedImage = returnResized(selectedImage, 1280, 720);
      selectedImage.resize(selectedImage.width/100*imgWidthFactor, selectedImage.height/100*imgHeightFactor);
      projectorScreen.setProject(true);
      projectorScreen.setImage(selectedImage);
      imageMode(CENTER);
      img.resize(imgSizeW/100*imgWidthFactor, imgSizeH/100*imgHeightFactor);
      image(img, imgCenterX, imgCenterY);

      ButtonClass backButton = new ButtonClass(600/3*1 - 20, height - 60, 180, 60, "BACK", 5, 5, colorForButton);
      backButton.create();

      resizeAndMoveImg();

      ButtonClass projectButton = new ButtonClass(600/3*2 + 20 - 20, height - 60, 180, 60, "PROJECT", 5, 5, colorForButton);
      projectButton.create();
      if (projectButton.isPressed() && isReleased) {
        if (!hasRun) {
          thread("confirmProjection");
          state = 4;
        }
        isReleased = false;
        updateBackground();
        isNew = true;
        println("Project");
      }

      if (backButton.isPressed() && isReleased) {
        isReleased = false;
        println("Back");
        UVLightON = false;
        isFinished = true;
        hasRun = false;
        state = 1;
        updateBackground();
        projectorScreen.setProject(false);
        isNew = true;
      }
    }
  }

  if (state == 4) {
    if (fileName != null) {
      textSize(20);
      fill(0);
      textAlign(CENTER);
      if (hasRun) {
        updateBackground();
        text("Projection Time: ", width-20-(160/2), height/4*2 - 15);
        text(str(pictureDuration) + " Seconds", width-20-(160/2), height/4*2 + 15);
      } else {
        text("Calculating estimated time", width-20-(160/2), height/4*1 - 15);
      }
      text("UV Light Time: ", width-100, height/4*1 - 15);
      text(uvLightTime + " Seconds", width-20-(160/2), height/4*1 + 15);
      text("Total: ", width-100, height/4*3 - 15);
      text((uvLightTime + pictureDuration) + " Seconds", width-20-(160/2), height/4*3 + 15);

      fill(0);
      rectMode(CENTER);
      rect(310, 194, 600, 346);

      if (loadImage("previewObjects/" + fileName) == null) {
        createPreviewImage();
      }
      if (isOnRaspBerry) {
        imgShownOnProjector = loadImage("/media/hello/MAGNUS/" + fileName);
      } else {
        imgShownOnProjector = loadImage("projectorObjects/" + fileName);
      }
      img = loadImage("previewObjects/" + fileName);
      selectedImage = loadImage("previewObjects/" + fileName);
      selectedImage = returnResized(selectedImage, 1280, 720);
      selectedImage.resize(selectedImage.width/100*imgWidthFactor, selectedImage.height/100*imgHeightFactor);
      projectorScreen.setProject(true);
      projectorScreen.setImage(selectedImage);
      imageMode(CENTER);
      img.resize(imgSizeW/100*imgWidthFactor, imgSizeH/100*imgHeightFactor);
      image(img, imgCenterX, imgCenterY);

      ButtonClass backButton = new ButtonClass(600/3*1 - 20, height - 60, 180, 60, "BACK", 5, 5, colorForButton);
      backButton.create();
      if (hasRun) {
        ButtonClass startButton = new ButtonClass(600/3*2 + 20 - 20, height - 60, 180, 60, "START", 5, 5, colorForButton);
        startButton.create();
        if (startButton.isPressed() && isReleased) {
          isReleased = false;
          // Start UV LIGHT
          state = 5;
          UVOnce = true;
          projectorScreen.setImage(null);
          projectorScreen.setProject(false);
          updateBackground();
          println("Start");
          isNew = true;
        }
      } else {
        ButtonClass projectButton = new ButtonClass(600/3*2 + 20 - 20, height - 60, 180, 60, "PROJECT", 5, 5, colorForButton);
        projectButton.create();
        if (projectButton.isPressed() && isReleased) {
          if (!hasRun) {
            thread("confirmProjection");
            hasRun = true;
          }
          isReleased = false;
          updateBackground();
          println("Project");
          isNew = true;
        }
      }

      if (backButton.isPressed() && isReleased) {
        isReleased = false;
        println("Back");
        UVLightON = false;
        isFinished = true;
        hasRun = false;
        state = 1;
        updateBackground();
        isNew = true;
        projectorScreen.setProject(false);
      }
    }
  }

  // PROJECTION IN ACTION
  if (state == 5) {
    if (fileName != null) {
      fill(0);
      rectMode(CENTER);
      rect(310, 194, 600, 346);
      finishedImg = loadImage("previewObjects/" + fileName);
      imageMode(CENTER);
      PImage smallerPic = returnResized(finishedImg, 580, 326);
      image(smallerPic, 310, 194);
      ButtonClass cancelButton = new ButtonClass(600/2, height - 60, 360, 60, "CANCEL", 5, 5, colorForButton);
      cancelButton.create();
      textSize(20);
      fill(0);
      textAlign(CENTER);
      text("UV Time Left: ", width-20-(160/2), height/3*1 - 20);
      textSize(30);
      text((uvLightTime - time2), width-20-(160/2), height/3*1 + 20);

      textSize(20);
      fill(0);
      textAlign(CENTER);
      text("Time Left: ", width-20-(160/2), height/3*2 - 20);
      textSize(30);
      text((pictureDuration - time), width-20-(160/2), height/3*2 + 20);
      if (UVOnce) {
        thread("uvLight");
        UVOnce = false;
      }

      if (cancelButton.isPressed() && isReleased) {
        isReleased = false;
        println("Cancel");
        UVLightON = false;
        isFinished = true;
        state = 1;
        hasRun = false;
        projectorScreen.setProject(false);
        if (isOnRaspBerry) {
          GPIO.digitalWrite(4, GPIO.LOW);
        }
        updateBackground();
        isNew = true;
      }
    }
  }
}


void runOnce() {
  hasRun = true;
}

void mouseReleased() {
  isReleased = true;
  mouseIsPressed = false;
}

void mouseDragged() {
  isNew = true;
}

void mousePressed() {
  isNew = true;
}

void readOptimizedValuesFile() {
  //HashMap<String, OptimizedTimes> optValues = new HashMap<>();
  optValues1 = new HashMap<String, OptimizedTimes>();
  optValues2 = new HashMap<String, OptimizedTimes>();
  BufferedReader reader = createReader("OptimizationCode/optimizedValues.txt");
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      String[] pieces = split(line, ",");
      String redAmount = pieces[0];
      String greenAmount = pieces[1];
      String blueAmount = pieces[2];
      int redTime = Integer.parseInt(pieces[3]);
      int greenTime = Integer.parseInt(pieces[4]);
      int blueTime = Integer.parseInt(pieces[5]);
      String colorRGB = redAmount + "," + greenAmount + "," + blueAmount;

      highestTime = (redTime > highestTime ? redTime:highestTime);
      highestTime = (greenTime > highestTime ? greenTime:highestTime);
      highestTime = (blueTime > highestTime ? blueTime:highestTime);

      OptimizedTimes optimizedTimes = new OptimizedTimes(redTime, greenTime, blueTime);

      if (Integer.parseInt(redAmount) < 128) {
        optValues1.put(colorRGB, optimizedTimes);
      } else if (Integer.parseInt(redAmount) >= 128) {
        optValues2.put(colorRGB, optimizedTimes);
      }
    }
    println("Hello im done");
    reader.close();
  }
  catch (IOException e) {
    e.printStackTrace();
  }
}


public void resizeAndMoveImg() {
  ButtonClass plusButton = new ButtonClass(width-20-(160/2), height/4*1, 100, 100, "+", 5, 5, colorForButton);
  ButtonClass minusButton = new ButtonClass(width-20-(160/2), height/4*2, 100, 100, "-", 5, 5, colorForButton);
  plusButton.create();
  minusButton.create();

  double screenWidth = lidarDistance * 8.35 / 10;
  double screenHeight = lidarDistance * 4.7 / 10;
  double realWidth =  screenWidth / 1280 * selectedImage.width;
  double realHeight = screenHeight / 720 * selectedImage.height;
  textSize(15);
  fill(0);
  textAlign(CENTER);
  text("Width  : " + nf((float)realWidth, 0, 2) + " CM", width-20-(160/2), height - 75);
  text("Height : " + nf((float)realHeight, 0, 2) + " CM", width-20-(160/2), height - 45);


  if (plusButton.isPressed() && isReleased) {
    isReleased = false;
    if (img.width < (imgSizeW/100*imgWidthFactor+5) && img.height < (imgSizeH/100*imgHeightFactor+5)) {
      imgWidthFactor += 5;
      imgHeightFactor += 5;
      getLidarData();
    }
    updateBackground();
    isNew = true;
  }

  if (minusButton.isPressed() && isReleased) {
    isReleased = false;
    if (imgSizeW/100*imgWidthFactor-5 > 0 && imgSizeH/100*imgHeightFactor-5 > 0) {
      imgWidthFactor -= 5;
      imgHeightFactor -= 5;
      getLidarData();
    }
    updateBackground();
    isNew = true;
  }


  if (mousePressed && mouseX > (310 - (580/2)) && mouseX < (310 + (580/2)) && mouseY > (194 - (326/2)) && mouseY < (194 + (326/2))) {
    if (mouseX - img.width/2 > (310 - (580/2)) && mouseX + img.width/2 < (310 + (580/2)) && mouseY - img.height/2 > (194 - (326/2)) && mouseY + img.height/2 < (194 + (326/2))) {
      imgCenterX = mouseX;
      imgCenterY = mouseY;
      projectorScreen.setXY(imgCenterX, imgCenterY);
    }
  }
}

public PImage returnResized(PImage image, int x, int y) {
  if (image != null) {
    double scaling = 0;
    double imgW = image.width;
    double imgH = image.height;
    scaling = y / imgH;
    image.resize((int)(imgW * scaling), (int)(imgH * scaling));
    return image;
  }
  return null;
}


public void updateBackground() {
  //background(backgroundColor);
}

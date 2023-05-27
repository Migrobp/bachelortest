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
int lidarDistance = 0;

boolean isFinished = false;

boolean isReleased = true;
boolean startUp = true;
String showPreview = "no";
boolean hasRun = false;
boolean UVOnce = false;
boolean previewWaitForDraw = false;

boolean mouseIsPressed = false;

int projectionSpeed = 20;

int state; // Which state the program is in
int time1;
int loadingBarProgress = 0;

int highestTime = 0;
int uvLightTime = 0;
int pictureDuration = 0;
int time = 0;
int time2 = 0;
int imgWidthFactor = 1;
int imgHeightFactor = 1;
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


  preDir = new File(sketchPath("PreviewObjects/"));
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
  }

  if (state == 1) { // FIRST SCREEN
    if (startUp) {
      loadFiles();
      startUp = false;
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
          if (img.width > 580 && img.height > 326) {
            float imgW = img.width;
            float imgH = img.height;
            resizeWidth = imgW/580;
            resizeHeight = imgH/326;
            int newImageWidth = (int)(img.width/resizeWidth);
            if (img.width == img.height) {
              newImageWidth = (int)(img.width/resizeHeight);
            }
            int newImageHeight = (int)(img.height/resizeHeight);
            img.resize(newImageWidth, newImageHeight);
          }
          if (!previewWaitForDraw) {
            imageMode(CENTER);
            image(img, 310, 194);
          }
          if (state == 3) {
            updateBackground();
          }
        }
      }
    }
  }


  if (state == 3) {
    if (fileName != null) {
      if (imgWidthFactor == 1 && imgHeightFactor == 1) {
        imgWidthFactor = img.width;
        imgHeightFactor = img.height;
        imgSizeW = img.width;
        imgSizeH = img.height;
        println(imgWidthFactor);
      }

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
      selectedImage.resize(imgShownOnProjector.width, imgShownOnProjector.height);
      projectorScreen.setProject(true);
      projectorScreen.setImage(selectedImage);
      imageMode(CENTER);
      img.resize(imgWidthFactor, imgHeightFactor);
      image(img, imgCenterX, imgCenterY);

      ButtonClass backButton = new ButtonClass(600/3*1 - 20, height - 60, 180, 60, "BACK", 5, 5, colorForButton);
      backButton.create();

      resizeAndMoveImg();

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
        state = 4;
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
        text("Calculating estimated time", width-20-(160/2), height/4*4 - 15);
      }
      text("UV Light Time: ", width-100, height/4*1 - 15);
      text(uvLightTime + " Seconds", width-20-(160/2), height/4*1 + 15);
      text("Total: ", width-100, height/4*3 - 15);
      text((uvLightTime + pictureDuration) + " Seconds", width-20-(160/2), height/4*3 + 15);

      if (imgWidthFactor == 1 && imgHeightFactor == 1) {
        imgWidthFactor = img.width;
        imgHeightFactor = img.height;
        imgSizeW = img.width;
        imgSizeH = img.height;
        println(imgWidthFactor);
      }

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
      selectedImage.resize(imgShownOnProjector.width, imgShownOnProjector.height);
      projectorScreen.setProject(true);
      projectorScreen.setImage(selectedImage);
      imageMode(CENTER);
      img.resize(imgWidthFactor, imgHeightFactor);
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
      PImage smallerPic = returnResized(finishedImg);
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
        updateBackground();
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

      if (redTime > highestTime) {
        highestTime = redTime;
      }
      if (greenTime > highestTime) {
        highestTime = greenTime;
      }
      if (blueTime > highestTime) {
        highestTime = blueTime;
      }

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
  ButtonClass plusButton = new ButtonClass(width-20-(160/2), height/3*1, 100, 100, "+", 5, 5, colorForButton);
  ButtonClass minusButton = new ButtonClass(width-20-(160/2), height/3*2, 100, 100, "-", 5, 5, colorForButton);
  plusButton.create();
  minusButton.create();

  if (plusButton.isPressed() && isReleased) {
    isReleased = false;
    //projectorScreen.makeBigger();
    if (img.width < ((imgSizeW*110)/100) && img.height < ((imgSizeH*110)/100)) {
      imgWidthFactor = (imgWidthFactor*110)/100;
      imgHeightFactor = (imgHeightFactor*110)/100;
    }
    projectorScreen.setImgFactor(imgWidthFactor, imgHeightFactor);
  }

  if (minusButton.isPressed() && isReleased) {
    isReleased = false;
    //projectorScreen.makeSmaller();
    //if ((imgWidthFactor/110)*100 > 0 && (imgHeightFactor/110)*100 > 0) {
    imgWidthFactor = (imgWidthFactor/110)*100;
    imgHeightFactor = (imgHeightFactor/110)*100;
    //}
    projectorScreen.setImgFactor(imgWidthFactor, imgHeightFactor);
  }


  if (mousePressed && mouseX > (310 - (580/2)) && mouseX < (310 + (580/2)) && mouseY > (194 - (326/2)) && mouseY < (194 + (326/2))) {
    if (mouseX - img.width/2 > (310 - (580/2)) && mouseX + img.width/2 < (310 + (580/2)) && mouseY - img.height/2 > (194 - (326/2)) && mouseY + img.height/2 < (194 + (326/2))) {
      imgCenterX = mouseX;
      imgCenterY = mouseY;
      projectorScreen.setXY(imgCenterX, imgCenterY);
    }
  }
}

public PImage returnResized(PImage image) {
  if (image != null) {
    if (image.width > 580 && image.height > 326) {
      float imgW = image.width;
      float imgH = image.height;
      resizeWidth = imgW/580;
      resizeHeight = imgH/326;
      int newImageWidth = (int)(image.width/resizeWidth);
      if (image.width == image.height) {
        newImageWidth = (int)(image.width/resizeHeight);
      }
      int newImageHeight = (int)(image.height/resizeHeight);
      image.resize(newImageWidth, newImageHeight);
    }
    return image;
  }
  return null;
}


public void updateBackground() {
  background(backgroundColor);
}

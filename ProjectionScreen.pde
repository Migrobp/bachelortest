public class ProjectorScreen extends PApplet {
  PImage displayedImage;
  boolean yesNo = false;

  boolean isNewImage = true;
  int imgSizeW = 0;
  int imgSizeH = 0;
  int imgCenterX = 1280/2;
  int imgCenterY = 720/2;
  boolean resizeDone = false;
  boolean isActive = false;

  public ProjectorScreen() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    fullScreen(2);
    noSmooth();
  }

  public void setup() {
    windowTitle("Projection");
    background(255);
    noLoop();
  }

  public void draw() {
    if (isActive) {
      background(255);
    } else {
      background(0);
    }
    if (yesNo) {
      if (displayedImage != null) {
        imageMode(CENTER);
        image(displayedImage, imgCenterX, imgCenterY);
        //println("Width: " + displayedImage.width + " Height: " + displayedImage.height);
      }
    } else {
      background(0);
    }
  }

  public void setImage(PImage img) {
    if (img != null) {
      imgSizeW = img.width;
      imgSizeH = img.height;
      displayedImage = img;
      redraw();
    }
  }

  public void setProject(boolean bool) {
    yesNo = bool;
    redraw();
  }

  public void resetImgFactor() {
    imgWidthFactor = 100;
    imgHeightFactor = 100;
  }

  public void setActive(boolean bool) {
    isActive = bool;
  }

  public void setXY(int x, int y) {
    imgCenterX = 1280/580*x;
    imgCenterY = 720/326*y;
    redraw();
  }
}

public class ProjectorScreen extends PApplet {
  PImage displayedImage;
  boolean yesNo = false;

  boolean isNewImage = true;
  int imgWidthFactor = 1;
  int imgHeightFactor = 1;
  int imgSizeW = 0;
  int imgSizeH = 0;
  int imgCenterX = 1280/2;
  int imgCenterY = 720/2;

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
    background(0);
    noLoop();
  }

  public void draw() {
    background(0);
    if (yesNo) {
      if (displayedImage != null) {
        imageMode(CENTER);
        displayedImage.resize(imgWidthFactor, imgHeightFactor);
        imageMode(CENTER);
        image(displayedImage, imgCenterX, imgCenterY);
      }
    } else {
      background(0);
    }
  }

  public void setImage(PImage img) {
    displayedImage = img;
    if (imgWidthFactor == 1 && imgHeightFactor == 1) {
      imgWidthFactor = displayedImage.width;
      imgHeightFactor = displayedImage.height;
      imgSizeW = displayedImage.width;
      imgSizeH = displayedImage.height;
      println(imgWidthFactor);
    }
    redraw();
  }

  public void setProject(boolean bool) {
    yesNo = bool;
  }

  public void setImgFactor(int w, int h) {
    imgWidthFactor = 1280/580*w;
    imgHeightFactor = 720/326*h;
  }

  public void makeBigger() {
    if (displayedImage.width < ((imgSizeW*110)/100) && displayedImage.height < ((imgSizeH*110)/100)) {
      imgWidthFactor = (imgWidthFactor*110)/100;
      imgHeightFactor = (imgHeightFactor*110)/100;
      redraw();
    }
  }

  public void makeSmaller() {
    if ((imgWidthFactor/110)*100 > 0 && (imgHeightFactor/110)*100 > 0) {
      imgWidthFactor = (imgWidthFactor/110)*100;
      imgHeightFactor = (imgHeightFactor/110)*100;
      redraw();
    }
  }

  public void resetImgFactor() {
    imgWidthFactor = 1;
    imgHeightFactor = 1;
  }

  public void setXY(int x, int y) {
    imgCenterX = 1280/580*x;
    imgCenterY = 720/326*y;
    redraw();
  }
}

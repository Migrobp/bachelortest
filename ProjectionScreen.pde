public class ProjectorScreen extends PApplet {
  PImage displayedImage;
  boolean yesNo = false;

  public ProjectorScreen() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    fullScreen(P2D, 2);
    smooth();
  }

  //public void setParent(PIScreen parent) {
  //this.parent = parent;
  //}

  public void setup() {
    windowTitle("Projection");
    background(0);
  }

  public void draw() {
    if (yesNo) {
      if (displayedImage != null) {
        imageMode(CENTER);
        image(displayedImage, img.width, img.height);
      }
    } else {
      background(0);  
    }
  }

  public void setImage(PImage img) {
    displayedImage = img;
  }

  public void setProject(boolean bool) {
    yesNo = bool;
  }
}

public class ButtonClass {
  private int posX;
  private int posY;
  private int buttonHeight;
  private int buttonWidth;
  private String buttonText;
  private int buttonRadius;
  private int buttonFunction;
  private color buttonColor;
  private boolean state = false;
  private boolean buttonPressed = false;

  public ButtonClass(int posX, int posY, int buttonWidth, int buttonHeight, String buttonText, int buttonRadius, int buttonFunction, color buttonColor) {
    this.posX = posX;
    this.posY = posY;
    this.buttonHeight = buttonHeight;
    this.buttonWidth = buttonWidth;
    this.buttonText = buttonText;
    this.buttonRadius = buttonRadius;
    this.buttonFunction = buttonFunction;
    this.buttonColor = buttonColor;
  }

  public void create() {
    fill(buttonColor);
    noStroke();
    rectMode(CENTER);
    rect(posX, posY, buttonWidth, buttonHeight, buttonRadius);
    textSize(buttonHeight-20);
    fill(255);
    textAlign(CENTER, CENTER);
    text(buttonText, posX, posY-5);
  }

  public boolean isPressed() {
    if (mousePressed && mouseX > (posX - (buttonWidth/2)) && mouseX < (posX + (buttonWidth/2)) && mouseY > (posY - (buttonHeight/2)) && mouseY < (posY + (buttonHeight/2))) {
      return true;
    } else {
      return false;
    }
  }

  public void changeName(String newName) {
    buttonText = newName;
  }

  public void changeColor(color c) {
    this.buttonColor = c;
  }

  public boolean getState() {
    return state;
  }
}

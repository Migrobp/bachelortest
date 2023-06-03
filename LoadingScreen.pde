public void loadingScreen() {
  int updateTime = 600;
  textAlign(CENTER);
  textSize(32);
  fill(0);
  text("MOBILE REPROGRAMMER", width/2, height/2 - 10);
  rect(width/2 - 200, height/2 + 10, 400, 30);
  fill(crimson);
  rect(width/2 - 195, height/2 + 15, loadingBarProgress, 20);

  int timePassed = (millis() - time1);
  if (timePassed > updateTime && loadingBarProgress < 390) {
    loadingBarProgress += 1;
  } else if (loadingBarProgress == 390) {
    updateBackground();
    state = 1;
    isNew = true;
  }
}

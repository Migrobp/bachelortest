public void projection() {
  println("Project Happening");
  isFinished = false;
  int updateTime = 1000/projectionSpeed;
  time = 0;
  int savedTime = millis();
  println(pictureDuration);
  int test = 0;
  while (!isFinished) {
    int timePassed = (millis() - savedTime);
    for (int p = 0; p < pictureTimesArray.get(time).size(); p++) {
      //int newRedColor = 0;
      //int newGreenColor = 0;
      //int newBlueColor = 0;
      int redColor = (int)red(projectionImg.pixels[pictureTimesArray.get(time).get(p)]);
      int greenColor = (int)green(projectionImg.pixels[pictureTimesArray.get(time).get(p)]);
      int blueColor = (int)blue(projectionImg.pixels[pictureTimesArray.get(time).get(p)]);

      int pixelRedTime = 255;
      int pixelGreenTime = 255;
      int pixelBlueTime = 255;

      if (redColor < 128) {
        OptimizedTimes pixel = optValues1.get(redColor + "," + greenColor + "," + blueColor);
        pixelRedTime = pixel.getRed();
        pixelGreenTime = pixel.getGreen();
        pixelBlueTime = pixel.getBlue();
      }
      if (redColor >= 128) {
        OptimizedTimes pixel = optValues2.get(redColor + "," + greenColor + "," + blueColor);
        pixelRedTime = pixel.getRed();
        pixelGreenTime = pixel.getGreen();
        pixelBlueTime = pixel.getBlue();
      }

      int newRedColor = (time > pixelRedTime ? 0:255);
      int newGreenColor = (time > pixelGreenTime ? 0:255);
      int newBlueColor = (time > pixelBlueTime ? 0:255);

      projectedImage.pixels[pictureTimesArray.get(time).get(p)] = color(newRedColor, newGreenColor, newBlueColor);
      projectedImage.updatePixels();
      //Thread.sleep(long);
    }
    test++;
    if (timePassed >= updateTime) {
      savedTime += updateTime;
    } else {
      long sleepTime = updateTime - timePassed;
      try {
        Thread.sleep(sleepTime);
      }
      catch(InterruptedException e) {
        println("Got interrupted!");
      }
    }
    println(test);
    test = 0;
    savedTime = millis();
    projectorScreen.setProject(true);
    projectorScreen.setImage(projectedImage);
    updateBackground();
    time++;

    if (time >= pictureDuration) {
      projectorScreen.setProject(false);
      isFinished = true;
      state = 1;
      showPreview = "no";
      updateBackground();
    }
  }
}

public void projection() { //<>//
  println("Project Happening");
  isFinished = false;
  int updateTime = 1000/projectionSpeed;
  time = 0;
  int savedTime = millis();
  while (!isFinished) {
    int timePassed = (millis() - savedTime);
    for (int p = 0; p < pictureTimesArray.get(time).size(); p++) {
      int redColor = (int)red(projectionImg.pixels[pictureTimesArray.get(time).get(p)]);
      int greenColor = (int)green(projectionImg.pixels[pictureTimesArray.get(time).get(p)]);
      int blueColor = (int)blue(projectionImg.pixels[pictureTimesArray.get(time).get(p)]);

      int pixelRedTime = 0;
      int pixelGreenTime = 0;
      int pixelBlueTime = 0;


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

      int newRedColor = (time >= pixelRedTime ? 0:255);
      int newGreenColor = (time >= pixelGreenTime ? 0:255);
      int newBlueColor = (time >= pixelBlueTime ? 0:255);

      projectedImage.pixels[pictureTimesArray.get(time).get(p)] = color(newRedColor, newGreenColor, newBlueColor);
    }
    if (timePassed >= updateTime) {
      savedTime += updateTime;
    } else {
      long sleepTime = updateTime - timePassed;
      //println(sleepTime);
      try {
        Thread.sleep(sleepTime);
      }
      catch(InterruptedException e) {
        println("Got interrupted!");
      }
    }
    projectedImage.updatePixels();
    savedTime = millis();
    projectorScreen.setProject(true);
    projectorScreen.setActive(true);
    projectorScreen.setImage(projectedImage);
    updateBackground();
    time++;
    isNew = true;

    if (time >= pictureDuration) {
      projectorScreen.setProject(false);
      projectorScreen.setActive(false);
      isFinished = true;
      state = 1;
      showPreview = "no";
      updateBackground();
      isNew = true;
    }
  }
}

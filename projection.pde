public void projection() {
  println("Project Happening");
  int updateTime = 1000/projectionSpeed;
  time = 0;
  int savedTime = millis();
  println(pictureDuration);
  while (!isFinished) {
    int timePassed = (millis() - savedTime);
    for (int p = 0; p < pictureTimesArray.get(time).size(); p++) {
      int newRedColor = 0;
      int newGreenColor = 0;
      int newBlueColor = 0;
      int redColor = (int)red(projectionImg.pixels[pictureTimesArray.get(time).get(p)]);
      int greenColor = (int)green(projectionImg.pixels[pictureTimesArray.get(time).get(p)]);
      int blueColor = (int)blue(projectionImg.pixels[pictureTimesArray.get(time).get(p)]);

      int pixelRedTime = 255;
      int pixelGreenTime = 255;
      int pixelBlueTime = 255;

      if (redColor < 128) {
        pixelRedTime = optValues1.get(redColor + "," + greenColor + "," + blueColor).getRed();
        pixelGreenTime = optValues1.get(redColor + "," + greenColor + "," + blueColor).getGreen();
        pixelBlueTime = optValues1.get(redColor + "," + greenColor + "," + blueColor).getBlue();
      }
      if (redColor >= 128) {
        pixelRedTime = optValues2.get(redColor + "," + greenColor + "," + blueColor).getRed();
        pixelGreenTime = optValues2.get(redColor + "," + greenColor + "," + blueColor).getGreen();
        pixelBlueTime = optValues2.get(redColor + "," + greenColor + "," + blueColor).getBlue();
      }

      if (time > pixelRedTime) {
        newRedColor = 0;
      } else {
        newRedColor = 255;
      }

      if (time > pixelGreenTime) {
        newGreenColor = 0;
      } else {
        newGreenColor = 255;
      }

      if (time > pixelBlueTime) {
        newBlueColor = 0;
      } else {
        newBlueColor = 255;
      }

      projectedImage.pixels[pictureTimesArray.get(time).get(p)] = color(newRedColor, newGreenColor, newBlueColor);
      projectedImage.updatePixels();
    }

    if (timePassed > updateTime) {
      savedTime = millis();
      projectorScreen.setProject(true);
      projectorScreen.setImage(projectedImage);
      updateBackground();
      //redraw();
      time++;
    }

    if (time >= pictureDuration) {
      projectorScreen.setProject(false);
      isFinished = true;
      state = 1;
      showPreview = "no";
      updateBackground();
    }
  }
}

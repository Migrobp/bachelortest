public void confirmProjection() {
  pictureDuration = 0;
  if (isOnRaspBerry) {
    projectionImg = loadImage("/media/hello/MAGNUS/" + fileName);
  } else {
    projectionImg = loadImage("projectorObjects/" + fileName);
  }

  //projectionImg = returnResized(projectionImg, 1280, 720);
  projectionImg.loadPixels();
  projectionImg = returnResized(projectionImg, 1280, 720);
  projectionImg.resize(projectionImg.width/100*imgWidthFactor, projectionImg.height/100*imgHeightFactor);
  projectedImage = createImage(projectionImg.width, projectionImg.height, RGB);
  projectedImage.loadPixels();

  getLidarData();

  pictureTimesArray = new ArrayList<ArrayList<Integer>>();
  if (isOnRaspBerry) {
    double maxTime = Math.pow(lidarDistance/10.0, 2) * highestTime;
    for (double i = 0; i <= maxTime; i++) {
      pictureTimesArray.add(new ArrayList<Integer>());
    }
  } else {
    for (int i = 0; i <= highestTime; i++) {
      pictureTimesArray.add(new ArrayList<Integer>());
    }
  }
  for (int i = 0; i < projectionImg.pixels.length; i++) {
    color pixelColor = projectionImg.pixels[i];
    int r = (int)red(pixelColor);
    int g = (int)green(pixelColor);
    int b = (int)blue(pixelColor);
    int redTime = 0;
    int greenTime = 0;
    int blueTime = 0;

    if (r < 128) {
      OptimizedTimes pixel = optValues1.get(r + "," + g + "," + b);
      redTime = pixel.getRed();
      greenTime = pixel.getGreen();
      blueTime = pixel.getBlue();
    }
    if (r >= 128) {
      OptimizedTimes pixel = optValues2.get(r + "," + g + "," + b);
      redTime = pixel.getRed();
      greenTime = pixel.getGreen();
      blueTime = pixel.getBlue();
    }

    if (isOnRaspBerry) {
      double multiplyer = Math.pow(lidarDistance/10.0, 2);
      redTime = (int)(multiplyer * redTime);
      greenTime = (int)(multiplyer * greenTime);
      blueTime = (int)(multiplyer * blueTime);
    }


    pictureDuration = (redTime > pictureDuration ? redTime:pictureDuration);
    pictureDuration = (greenTime > pictureDuration ? greenTime:pictureDuration);
    pictureDuration = (blueTime > pictureDuration ? blueTime:pictureDuration);

    pictureTimesArray.get(redTime).add(i);
    pictureTimesArray.get(greenTime).add(i);
    pictureTimesArray.get(blueTime).add(i);

    r = (r != 0 ? 255:0);
    g = (g != 0 ? 255:0);
    b = (b != 0 ? 255:0);

    projectedImage.pixels[i] = color(255, 255, 255);
  }

  hasRun = true;
  updateBackground();
  isNew = true;
}

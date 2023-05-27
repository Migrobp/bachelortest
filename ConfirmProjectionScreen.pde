public void confirmProjection() {
  pictureDuration = 0;
  if (isOnRaspBerry) {
    projectionImg = loadImage("/media/hello/MAGNUS/" + fileName);
  } else {
    projectionImg = loadImage("projectorObjects/" + fileName);
  }
  if (projectionImg.width > 1280) {
    float imgW = projectionImg.width;
    resizeWidth = imgW/1280;
  } else {
    resizeWidth = 1;
  }
  if (projectionImg.height > 720) {
    float imgH = projectionImg.height;
    resizeHeight = imgH/720;
  } else {
    resizeHeight = 1;
  }
  projectionImg.loadPixels();
  int newImageWidth = (int)(projectionImg.width/resizeWidth);
  int newImageHeight = (int)(projectionImg.height/resizeHeight);
  projectionImg.resize(newImageWidth, newImageHeight);
  projectionImg.resize(1280/580*imgWidthFactor, 720/326*imgHeightFactor);
  projectedImage = createImage(1280/580*imgWidthFactor, 720/326*imgHeightFactor, RGB);
  projectedImage.loadPixels();

  getLidarData();
  println(lidarDistance);  
  pictureTimesArray = new ArrayList<ArrayList<Integer>>();
  for (int i = 0; i <= highestTime; i++) {
    pictureTimesArray.add(new ArrayList<Integer>());
  }

  for (int i = 0; i < projectionImg.pixels.length; i++) {
    int r = (int)red(projectionImg.pixels[i]);
    int g = (int)green(projectionImg.pixels[i]);
    int b = (int)blue(projectionImg.pixels[i]);
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

    pictureDuration = (redTime > pictureDuration ? redTime:pictureDuration);
    pictureDuration = (greenTime > pictureDuration ? greenTime:pictureDuration);
    pictureDuration = (blueTime > pictureDuration ? blueTime:pictureDuration);

    pictureTimesArray.get(redTime).add(i);
    pictureTimesArray.get(greenTime).add(i);
    pictureTimesArray.get(blueTime).add(i);

    
    //r = (r != 0 ? 255:0);
    //g = (r != 0 ? 255:0);
    //b = (r != 0 ? 255:0);

    //projectedImage.pixels[i] = color(r, g, b);
  }
}

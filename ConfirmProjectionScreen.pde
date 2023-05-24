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

  projectedImage = createImage(newImageWidth, newImageHeight, RGB);
  projectedImage.loadPixels();

  int r, g, b;

  pictureTimesArray = new ArrayList<ArrayList<Integer>>();
  for (int i = 0; i <= highestTime; i++) {
    pictureTimesArray.add(new ArrayList<Integer>());
  }

  for (int i = 0; i < projectionImg.pixels.length; i++) {
    r = (int)red(projectionImg.pixels[i]);
    g = (int)green(projectionImg.pixels[i]);
    b = (int)blue(projectionImg.pixels[i]);
    int redTime = 0;
    int greenTime = 0;
    int blueTime = 0;

    if (r < 128) {
      if (optValues1.get(r + "," + g + "," + b) != null) {
        redTime = optValues1.get(r + "," + g + "," + b).getRed();
        greenTime = optValues1.get(r + "," + g + "," + b).getGreen();
        blueTime = optValues1.get(r + "," + g + "," + b).getBlue();
      } else {
        if (optValues2.get(r + "," + g + "," + b) != null) {
          redTime = optValues2.get(r + "," + g + "," + b).getRed();
          greenTime = optValues2.get(r + "," + g + "," + b).getGreen();
          blueTime = optValues2.get(r + "," + g + "," + b).getBlue();
        }
      }
    }

    if (redTime > pictureDuration) {
      pictureDuration = redTime;
    }
    if (greenTime > pictureDuration) {
      pictureDuration = greenTime;
    }
    if (blueTime > pictureDuration) {
      pictureDuration = blueTime;
    }

    pictureTimesArray.get(redTime).add(i);
    pictureTimesArray.get(greenTime).add(i);
    pictureTimesArray.get(blueTime).add(i);

    if (r != 0) {
      r = 255;
    }
    if (g != 0) {
      g = 255;
    }
    if (b != 0) {
      b = 255;
    }
    projectedImage.pixels[i] = color(r, g, b);
    //image(projectedImage, 0, 0, 800, 480);
  }
}

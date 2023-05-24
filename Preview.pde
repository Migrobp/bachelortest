public void createPreviewImage() {
  if (fileName != null) {
    if (img.width > 1280) {
      float imgW = img.width;
      resizeWidth = imgW/1280;
    } else {
      resizeWidth = 1;
    }
    if (img.height > 720) {
      float imgH = img.height;
      resizeHeight = imgH/720;
    } else {
      resizeHeight = 1;
    }
    img.loadPixels();
    int newImageWidth = (int)(img.width/resizeWidth);
    int newImageHeight = (int)(img.height/resizeHeight);
    img.resize(newImageWidth, newImageHeight);

    previewImg = createImage(newImageWidth, newImageHeight, RGB);
    previewImg.loadPixels();
    for (int i = 0; i < previewImg.pixels.length; i++) {
      previewImg.pixels[i] = color(0, 0, 0);
    }
    previewImg.updatePixels();

    Opt opt = new Opt();
    Point3D currentColorPixel = new Point3D(0.0, 0.0, 0.0);
    Point3D[][][] newColorPixel = new Point3D[256][256][256];

    color tempPixelColor;
    int size = img.pixels.length;
    for (int i = 0; i < size; i++) {
      tempPixelColor = img.pixels[i];
      int r, g, b, cyan, magenta, yellow;
      r = (int)red(tempPixelColor);
      g = (int)green(tempPixelColor);
      b = (int)blue(tempPixelColor);

      cyan = 255 - (int)red(tempPixelColor);
      magenta = 255 - (int)green(tempPixelColor);
      yellow = 255 -(int)blue(tempPixelColor);

      texsim = new Texsim();

      if (newColorPixel[cyan][magenta][yellow] == null) {
        newColorPixel[cyan][magenta][yellow] = texsim.compute_color(opt.optimize_times(new Point3D(cyan, magenta, yellow)));
      }

      currentColorPixel = newColorPixel[cyan][magenta][yellow];
      r = 255 - (int)currentColorPixel.getX();
      g = 255 - (int)currentColorPixel.getY();
      b = 255 - (int)currentColorPixel.getZ();


      previewImg.pixels[i] = color(r, g, b);
    }
    previewImg.save("PreviewObjects/" + selectedImg);
    println("Preview Made!");
    showPreview = "yes";
  }
}

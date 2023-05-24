Opt opt;
color backgroundColor;
PrintWriter output;

void setup() {
  size(800, 480);
  backgroundColor = color(0);

  opt = new Opt();

  output = createWriter("optimizedValues.txt");
}

void draw() {
  background(backgroundColor);
}


void keyPressed() {
  if (key == ' ') {
    println("Optimization Started!");
    backgroundColor = color(255, 0, 0);
    redraw();
    runOpt();
  }
}

void runOpt() {
  for(int r = 0; r <= 255; r++) {
    for(int g = 0; g <= 255; g++) {
      for(int b = 0; b <= 255; b++) {
        //println(r + " , "+ g + " , " + b);
        Point3D out = opt.optimize_times(new Point3D(r, g, b));
        String currentColor = String.format(r + "," + g + "," + b+ ",");
        output.println(currentColor + (int)out.getX() + "," + (int)out.getY() + "," + (int)out.getZ());
      }
    }
    println(r);
  }
  output.flush();
  output.close();
  println("Optimization Done!");
  exit();
}

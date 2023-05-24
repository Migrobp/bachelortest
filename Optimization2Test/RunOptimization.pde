import java.util.*;

Texsim texsim;
Opt opt;
color backgroundColor;
PrintWriter output;

static final int Red = 0;
static final int Green = 1;
static final int Blue = 2;

Point3D currentColorPixel = new Point3D(0.0, 0.0, 0.0);
Point3D[][][] newColorPixel = new Point3D[256][256][256];

color tempPixelColor;

HashMap<String, String> optValues;

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
  for (int r = 0; r <= 255; r++) {
    println(r);
    for (int g = 0; g <= 255; g++) {
      for (int b = 0; b <= 255; b++) {
        //println(r + " , "+ g + " , " + b);
        String currentColor = String.format("(" + r + "," + g + "," + b + ")" + ":");

        tempPixelColor = color(r, g, b);
        int cyan, magenta, yellow;
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
        output.println(currentColor + ";" + cyan + ";" + magenta + ";" + yellow);
      }
    }
  }
  output.flush();
  output.close();
  println("Optimization Done!");
  exit();
}

public class Opt {

  static final int cyan = 0;
  static final int magenta = 1;
  static final int yellow = 2;

  static final boolean debug = false;

  float[] red = new float[3];
  float[] green = new float[3];
  float[] blue = new float[3];

  int cyan_with_red = 4103;
  int cyan_with_green = 3536;
  int cyan_with_blue = 10000;

  int magenta_with_red = 10000;
  int magenta_with_green = 2394;
  int magenta_with_blue = 10000;

  int yellow_with_red = 10000;
  int yellow_with_green = 2379;
  int yellow_with_blue = 181;

  Point3D t, t_old;

  float deactivation_increase = 0.7;

  Point3D c_color;

  float steps, distance_threshold;

  Opt() {

    //deactivation parameters to deactivate cyan
    red[cyan] = 255.0/(cyan_with_red*(1+deactivation_increase));
    green[cyan] = 255.0/(cyan_with_green*(1+deactivation_increase));
    blue[cyan] = 255.0/(cyan_with_blue*(1+deactivation_increase));

    //deactivation parameters to deactivate magenta
    red[magenta] = 255.0/(magenta_with_red*(1+deactivation_increase));
    green[magenta] = 255.0/(magenta_with_green*(1+deactivation_increase));
    blue[magenta] = 255.0/(magenta_with_blue*(1+deactivation_increase));

    //deactivation parameters to deactivate yellow dye
    red[yellow] = 255.0/(yellow_with_red*(1+deactivation_increase));
    green[yellow] = 255.0/(yellow_with_green*(1+deactivation_increase));
    blue[yellow] = 255.0/(yellow_with_blue*(1+deactivation_increase));

    steps = 0.01;
    distance_threshold = 0.0001;

    t_old = new Point3D(0.0, 0.0, 0.0);
    t     = new Point3D(0.0, 0.0, 0.0);

    c_color = new Point3D(255.0, 255.0, 255.0);
  }
  // in_color is the target color
  // return value is a 3D vectror with illumination duration for RGB light
  Point3D optimize_times(Point3D in_color) {

    float F_r, F_g, F_b;

    float arg_x, arg_y, arg_z;

    float c_distance = 1000;
    float c_distance_old = 10000;
    int counter = 0;

    t.clear();
    t_old.clear();

    while (abs(c_distance-c_distance_old)>distance_threshold) {

      t_old.duplicate(t);
      c_distance_old = c_distance;
      Point3D current_color = new Point3D();

      float sum1, sum2, sum3;
      sum1 = red[cyan]*t_old.getX();
      sum2 = green[cyan]*t_old.getY();
      sum3 = blue[cyan]*t_old.getZ();

      F_r = 255 - (sum1>255 ? 255 : sum1) -
        (sum2>255 ? 255 : sum2) -
        (sum3>255 ? 255 : sum3);
      current_color.setX(F_r);

      F_r = (F_r<0?0:F_r) - in_color.getX();

      sum1 = red[magenta]*t_old.getX();
      sum2 = green[magenta]*t_old.getY();
      sum3 = blue[magenta]*t_old.getZ();

      F_g = 255 - (sum1>255 ? 255 : sum1) -
        (sum2>255 ? 255 : sum2) -
        (sum3>255 ? 255 : sum3);
      current_color.setY(F_g);

      F_g = (F_g<0?0:F_g) - in_color.getY();

      sum1 = red[yellow]*t_old.getX();
      sum2 = green[yellow]*t_old.getY();
      sum3 = blue[yellow]*t_old.getZ();

      F_b = 255 - (sum1>255 ? 255 : sum1) -
        (sum2>255 ? 255 : sum2) -
        (sum3>255 ? 255 : sum3);
      current_color.setZ(F_b);

      F_b = (F_b<0?0:F_b) - in_color.getZ();

      arg_x = t_old.getX() + steps*(F_r*red[cyan] + F_g*red[magenta] + F_b*red[yellow]);
      arg_y = t_old.getY() + steps*(F_r*green[cyan] + F_g*green[magenta] + F_b*green[yellow]);
      arg_z = t_old.getZ() + steps*(F_r*blue[cyan] + F_g*blue[magenta] + F_b*blue[yellow]);

      t.setX((arg_x<0) ? 0 : arg_x);
      t.setY((arg_y<0) ? 0 : arg_y);
      t.setZ((arg_z<0) ? 0 : arg_z);

      c_distance = sqrt(F_r*F_r + F_g*F_g + F_b*F_b);

      if (debug) {
        println("In Color: ", in_color.getX(), in_color.getY(), in_color.getZ());
        println("Illumination_time: ", t.getX(), t.getY(), t.getZ());
        println("Approximated Color: ", current_color.getX(), current_color.getY(), current_color.getZ());
        println("Distance: ", c_distance);
      }
      counter++;
      //if (counter > 500000 && counter % 50001 == 0) {
      //  println(in_color, counter);
      //}
      //println(t_old, "-->", t, "\t", abs(c_distance-c_distance_old));
    }
    // if(in_color.getX()<200) {
    //println("In Color: ",in_color.getX(),in_color.getY(),in_color.getZ());
    //println("Illumination_time: ",t.getX(),t.getY(),t.getZ());
    //}
    //println("Converged in Iterations: ",counter);
    //if (counter > 50000) {
    //    println(in_color, counter);
    //  }
    //println(in_color, counter);
    return t;
  }

  float compute_distance(Point3D in_color) {
    float F_r, F_g, F_b;

    F_r = 255 - red[cyan]*t_old.getX() -
      green[cyan]*t_old.getY() -
      blue[cyan]*t_old.getZ();

    F_g = 255 - red[magenta]*t_old.getX() -
      green[magenta]*t_old.getY() -
      blue[magenta]*t_old.getZ();

    F_b = 255 - red[yellow]*t_old.getX() -
      green[yellow]*t_old.getY() -
      blue[yellow]*t_old.getZ();

    F_r = (F_r - in_color.getX())*(F_r - in_color.getX());
    F_g = (F_g - in_color.getY())*(F_g - in_color.getY());
    F_b = (F_b - in_color.getZ())*(F_b - in_color.getZ());

    return(sqrt(F_r + F_g + F_b));
  }
}

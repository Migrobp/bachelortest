public class Texsim {
  
  static final boolean debug = true;
  
  float[] a = new float[3];
  float[] b = new float[3];
  float[] c = new float[3];
  
  Point3D t,in_color;
  
  Point3D c_color;
  Point3D C_real,M_real,Y_real,K_real;
  
  float steps,distance_threshold;
  
  Texsim() {
    //deactivation parameters to deactivate cyan
    a[Red]   = 1.0/(650.0);
    a[Green] = 1.0/(1500.0);
    a[Blue]  = 1.0/(600.0);
    
    //deactivation parameters to deactivate magenta
    b[Red]   = 1.0/(1500.0);
    b[Green] = 1.0/(600.0);
    b[Blue]  = 1.0/(320.0);
    
    //deactivation parameters to deactivate yellow dye
    c[Red]   = 1.0/(10000.0);
    c[Green] = 1.0/(500.0);
    c[Blue]  = 1.0/(30.0);
    
    C_real = new Point3D(116.0,114.0,0.0);
    C_real.scale(1.0);
    M_real = new Point3D(0.0,200.0,55.0);
    M_real.scale(1.0);
    Y_real = new Point3D(0.0,20.0,172.0);
    K_real = new Point3D(C_real.getX()+M_real.getX()+Y_real.getX(),
                         C_real.getY()+M_real.getY()+Y_real.getY(),
                         C_real.getZ()+M_real.getZ()+Y_real.getZ());
                         
    float max;
    if(K_real.getX()>K_real.getY())
      max = K_real.getX();
    else
      max = K_real.getY();
      
    if(max<K_real.getZ())
      max = K_real.getZ();
    
    float normalize = 255/max;
    
    C_real.scale(normalize);
    M_real.scale(normalize);
    Y_real.scale(normalize);
    K_real.scale(normalize);
    
    steps = 0.001;
    distance_threshold = 0.0001;
    
    in_color = new Point3D(0.0,0.0,0.0);
    t     = new Point3D(0.0,0.0,0.0);
    
    c_color = new Point3D(255.0,255.0,255.0);
  }
  
  Point3D compute_color(Point3D in_color) {
    
    Point3D current_color = new Point3D();
    float cyan_factor,magenta_factor,yellow_factor;
   
    cyan_factor    = (in_color.getX()*a[Red] < 1.0 ? in_color.getX()*a[Red] : 1.0) +
                       (in_color.getY()*a[Green] <1.0 ? in_color.getY()*a[Green] : 1.0)+
                       (in_color.getZ()*a[Blue] < 1.0 ? in_color.getZ()*a[Blue] : 1.0);
    cyan_factor    = (cyan_factor < 1.0 ? cyan_factor : 1.0);
    
      
    magenta_factor = (in_color.getX()*b[Red] < 1.0 ? in_color.getX()*b[Red] : 1.0) +
                       (in_color.getY()*b[Green] <1.0 ? in_color.getY()*b[Green] : 1.0)+
                       (in_color.getZ()*b[Blue] < 1.0 ? in_color.getZ()*b[Blue] : 1.0);
    magenta_factor = (magenta_factor < 1.0 ? magenta_factor : 1.0);
      
    yellow_factor  = (in_color.getX()*c[Red] < 1.0 ? in_color.getX()*c[Red] : 1.0) +
                       (in_color.getY()*c[Green] <1.0 ? in_color.getY()*c[Green] : 1.0)+
                       (in_color.getZ()*c[Blue] < 1.0 ? in_color.getZ()*c[Blue] : 1.0);
    yellow_factor  = (yellow_factor < 1.0 ? yellow_factor : 1.0);
      
    current_color.setX(K_real.getX() - C_real.getX()*cyan_factor);
    current_color.setY(K_real.getY() - C_real.getY()*cyan_factor - 
                                       M_real.getY()*magenta_factor - 
                                       Y_real.getY()*yellow_factor);
    current_color.setZ(K_real.getZ() - M_real.getZ()*magenta_factor - Y_real.getZ()*yellow_factor);
    
    return(current_color); 
  } 
}

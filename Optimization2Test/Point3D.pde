public class Point3D {
    private float x;
    private float y;
    private float z;
    
    public Point3D(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
    
    public Point3D() {
        this.x = 0.0;
        this.y = 0.0;
        this.z = 0.0;
    }
    
    public float distance(Point3D a) {
     
      return(sqrt((a.getX()-this.x)*(a.getX()-this.x)+
                  (a.getY()-this.y)*(a.getY()-this.y)+
                  (a.getZ()-this.z)*(a.getZ()-this.z)));
      
    }
    
    public String toString() {
        return "P(" + this.x + ", " + this.y + ", " + this.z + ")";
    }
    public boolean is_close(Point3D a, float distance) {
     
      if(((a.getX()-this.x)>distance) || ((a.getY()-this.y)>distance) || ((a.getZ()-this.z)>distance))
        return false;
      
      return true;
      
    }
   
    // Returns the x-coordinate of this Point3D.
    public float getX() {
        return x;
    }
    
    // Returns the y-coordinate of this Point3D.
    public float getY() {
        return y;
    }
    
    // Returns the z-coordinate of this Point3D.
    public float getZ() {
        return z;
    }
    
    // Assigns the x-coordinate of this Point3D.
    public void setX(float new_x) {
      this.x = new_x;
     
    }
    
    // Assigns the y-coordinate of this Point3D.
    public void setY(float new_y) {
      this.y = new_y;
   
    }
    
    // Assigns the z-coordinate of this Point3D.
    public void setZ(float new_z) {
      this.z = new_z;

    }
    
    void coo(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
    
    public void rotateXY(float degree) {
      
      this.x = this.x * cos(radians(degree)) - this.y * sin(radians(degree));
      this.y = this.x * sin(radians(degree)) + this.y * cos(radians(degree));
           
    }
    
    public void scaleXY(float scale) {
      
      this.x = scale * this.x;
      this.y = scale * this.y;
      
    }
    
    public void scale(float scale) {
      
      this.x = scale * this.x;
      this.y = scale * this.y;
      this.z = scale * this.z;
      
    }
    
    Point3D multiply(float s) {
     Point3D out = new Point3D();
     
     out.duplicate(this);
     out.scale(s);
     return(out);
    }
    
    public void duplicate(Point3D in)  {
      
      this.x = in.getX();
      this.y = in.getY();
      this.z = in.getZ();
    
    }
    
    public void clear() {
      this.x = 0.0;
      this.y = 0.0;
      this.z = 0.0;
    }
    
}

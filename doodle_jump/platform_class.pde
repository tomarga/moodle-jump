class Platform {
  
    private float x_pos, y_pos;
  private float p_length=75;
          
  private int tip;
  
  public Platform( float x, float y, int t) {
    this.x_pos = x;
    this.y_pos = y;
    
    tip=t;
    
  }
  
  public void display() {
    

    PImage slika=slikaplatniz.get(tip);
    
    image(slika, x_pos, y_pos, p_length, p_length*slika.height/slika.width);
    
  }
  
  public void destroy() {
    this.x_pos = 600;
  }
  
}

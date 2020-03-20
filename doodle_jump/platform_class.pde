abstract class Platform {
  
  protected float x_pos, y_pos;
  protected float p_length;
  protected PImage slikapl;
      
  
  public Platform( float x, float y ) {
    x_pos = x;
    y_pos = y;
    
    p_length = 75;   
  }
  
  public void display() {   
    image(slikapl, x_pos, y_pos, p_length, p_length*slikapl.height/slikapl.width);
  }
  
  public void destroy() {
    this.x_pos = 600;
  }
  public float get_x() {
  return x_pos;
  }
  public float get_y() {
    return y_pos;
  }
  
  abstract void update();
}

class Regular_Platform extends Platform {
  
  public Regular_Platform( float x, float y ){
    super( x, y );
    slikapl = loadImage( "platforma_obicna.png" );
  }  
  public void update() {   
  }
}

class Moving_Platform extends Platform {
  
  private float x_velocity;
  
  public Moving_Platform( float x, float y ){
    super( x, y );
    slikapl = loadImage( "platforma_pomicna.png" );
    x_velocity = 2;
  }  
  public void update() {   
    x_pos += x_velocity;
    //nakon sto platforma prede desnu granicu prozora,
    //platforma se crta lijevo
    if ( x_pos > width ){
      x_pos = - p_length ;
    }
  }
}

class Disappearing_Platform extends Platform {
  
  public Disappearing_Platform( float x, float y ){
    super( x, y );
    slikapl = loadImage( "platforma_nestajuca.png" );
  } 
  public void update(){
  }
}

class Broken_Platform extends Platform {
  
  private PImage slikapl2;
  private boolean broken;
  
  public Broken_Platform( float x, float y ){
    super( x, y );
    
    broken = false;
    slikapl = loadImage( "platforma_slomljena1.png" );
    slikapl2 = loadImage( "platforma_slomljena4.png" );
  } 
  
  public void display(){
    if ( broken ){
      slikapl = slikapl2;
    }
    image(slikapl, x_pos, y_pos, p_length, p_length*slikapl.height/slikapl.width);
  }
  public void update(){
  }
  public void break_pl(){
    broken = true;
  } 
}

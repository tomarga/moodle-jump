abstract class Platform {
  
  protected float x_pos, y_pos;
  protected float p_length;
  protected PImage slikapl, power;
  protected String superpower;
      
  
  public Platform( float x, float y, String spower ) {
    x_pos = x;
    y_pos = y;
    
    p_length = 75;  
    
    superpower = spower;
      
    if ( superpower.equals( "" ) == false ){
      String string_slika = superpower + ".png";
      power = loadImage( string_slika );
      power.resize( (int)( power.width/2.25 ), (int)( power.height/2.25 ) );
    }
    
  }
  
  public void display() {  
    
    //ako na platformi postoji supermoc
    if ( superpower.equals( "" ) == false ) {     
      image( power, x_pos, y_pos - power.height );
    }
      
    image(slikapl, x_pos, y_pos, p_length, p_length*slikapl.height/slikapl.width );
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
  public String get_power(){
    return superpower;
  }
  
  abstract void update();
}

class Regular_Platform extends Platform {
  
  public Regular_Platform( float x, float y, String spower ){
    super( x, y, spower );
    slikapl = loadImage( "platforma_obicna.png" );
  }  
  public void update() {   
  }
}

class Moving_Platform extends Platform {
  
  private float x_velocity;
  
  public Moving_Platform( float x, float y, String spower ){
    super( x, y, spower );
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
  
  public Disappearing_Platform( float x, float y, String spower ){
    super( x, y, spower );
    slikapl = loadImage( "platforma_nestajuca.png" );
  } 
  public void update(){
  }
}

class Broken_Platform extends Platform {
  
  private PImage slikapl0, slikapl1, slikapl2, slikapl3, slikapl4, slikapl5;
  private boolean broken;
  
  public Broken_Platform( float x, float y ){
    super( x, y, "" );
    
    broken = false;

    slikapl0 = loadImage( "platforma_slomljena1.png" );
    slikapl1 = loadImage( "platforma_slomljena2.png" );
    slikapl2 = loadImage( "platforma_slomljena4.png" );
    slikapl3 = loadImage( "platforma_slomljena3.png" );
    slikapl4 = loadImage( "platforma_slomljena4.png" );
    slikapl5 = loadImage( "platforma_slomljena5.png" );
    
    slikapl = slikapl0;
  } 
  
  public void display(){
    
    if ( slikapl == slikapl1 ){
      slikapl = slikapl2;
    }        
    else if ( slikapl == slikapl2 ){
      slikapl = slikapl3;
    }
    else if ( slikapl == slikapl3 ){
      slikapl = slikapl4;
    }
    else if ( slikapl == slikapl4 ){
      slikapl = slikapl5;
    }
    else if ( broken &&  ( slikapl == slikapl0 ) ){
      slikapl = slikapl1;
    }
    image(slikapl, x_pos, y_pos, p_length, p_length*slikapl.height/slikapl.width);
    
  }
  public void update(){
  }
  public void break_pl(){
    broken = true;
  } 
}

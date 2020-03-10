class Player {
  private float x, y, x_velocity, y_velocity, gravity=2, size;
  private float climb = 0;
  private int tip;


  //konstruktor
  // p = Player(135, 475, 0, 0, 2, 10);
  public Player(int x, int y, int x_velocity, int y_velocity, int size, int t) {
    this.x = x;
    this.y = y;
    this.x_velocity = x_velocity;
    this.y_velocity = y_velocity;
    this.size = size;
    this.tip = t;
  }

  public void update( ArrayList<Platform> platforms ) {
    
    this.check_collision( platforms );
    this.move();
    this.move_world( platforms );
         
  }
  
  public void display() {
    PImage slika=moodlers.get(tip);
    image(slika,x,y,100,100);
  }
  
  public void move() {
    
    if (keyPressed && keyCode == LEFT) {
      this.x -= 10;
      tip=1;
    }
    else if (keyPressed && keyCode == RIGHT)  {
        this.x += 10;
        tip=0;
    }
    this.y_velocity += gravity;
    
    this.x += this.x_velocity;
    this.y += this.y_velocity/2;
      
  }
  
  public void move_world( ArrayList<Platform> platforms ) {
    if (this.y < 300) {
      this.climb = (300 - this.y);
      this.y = 300;
      for (int i=0; i<platforms.size(); i++) {
        platforms.get(i).y_pos += this.climb;
      }
    }
  }
  
  public void check_collision( ArrayList<Platform> platforms ) {
    
    //ako se igrac sudari sa zidom, preazi na drugu stranu, ne odbija se
    
    if (this.x <= 0) this.x = width + this.x;
    if (this.x >= width) this.x = this.x - width;
    
    //sudaranje s platformama
    
    for (int i=0; i<platforms.size(); i++) {
      if (( (this.y >= platforms.get(i).y_pos-110) && (this.y <= platforms.get(i).y_pos-90) && 
            (this.y_velocity >=0) &&
            (this.x >= platforms.get(i).x_pos-90) && (this.x <= platforms.get(i).x_pos+60))) {
              
              //ako je platforma valjana, kocka se odbije
              //brzina joj postane negativna (što znači, prema gore)
              if(platforms.get(i).tip<=2)
              {
              this.y = platforms.get(i).y_pos-50;
              this.y_velocity = -48;
              }
              
              //ako je platforma potrgana, postane potrganija
              //kocka se ne odbije, ostaje joj pozitivna brzina
              if(platforms.get(i).tip==3)
              {
                platforms.get(i).tip=4;
                //this.y_velocity=0;
              }
            }
    }
  }
}

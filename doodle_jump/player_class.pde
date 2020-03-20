  class Player {
    private float x, y, x_velocity, y_velocity, gravity=2, size;
    private float climb = 0;
    private int tip;
    public int score;
  
  
    //konstruktor
    // p = Player(135, 475, 0, 0, 2, 10);
    public Player(int x, int y, int x_velocity, int y_velocity, int size, int t) {
      this.x = x;
      this.y = y;
      this.x_velocity = x_velocity;
      this.y_velocity = y_velocity;
      this.size = size;
      this.tip = t;
      this.score = 0;
    }
  
    public void update( ArrayList<Platform> platforms, ArrayList<Broken_Platform> broken_platforms, MyFloat first_horiz_line ) {
      
      this.check_collision( platforms, broken_platforms );
      this.move();
      this.move_world( platforms, broken_platforms, first_horiz_line );
           
    }
    
    public void display( ) {
      PImage slika=moodlers.get(tip);
      image(slika, this.x, this.y, this.size, this.size);
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
    
    public void move_world( ArrayList<Platform> platforms, ArrayList<Broken_Platform> broken_platforms, MyFloat first_horiz_line ) {
      
      if (this.y < 300) {
        //azuriranje scorea
        this.score++;
        this.climb = (300 - this.y);
        this.y = 300;
        
        //spustanje platfromi
        for (int i=0; i<platforms.size(); i++) {
          platforms.get(i).y_pos += this.climb;
        }
        //spustanje slomljenih platformi
        for (int i=0; i<broken_platforms.size(); i++) {
          broken_platforms.get(i).y_pos += this.climb;
        }
        
        //azuriranje prve gornje horizontalne linije u mrezi pozadine
        first_horiz_line.value = ( first_horiz_line.value + this.climb ) % line_dist;               
      }
    }
    
    public void check_collision( ArrayList<Platform> platforms, ArrayList<Broken_Platform> broken_platforms ) {
      
      //ako se igrac sudari sa zidom, preazi na drugu stranu, ne odbija se
      //moodler se crta s one strane gdje se nalazi vise od "pola" lika    
      if (this.x + this.size/2 <= 0) this.x = width + this.x;
      if (this.x >= width - this.size/2 ) this.x = this.x - width;
      
      //sudaranje s platformama
      //prvo provjeravamo platforme koje se ne lome
      for (int i=0; i<platforms.size(); i++) {
        if (( (this.y >= platforms.get(i).y_pos-110) && (this.y <= platforms.get(i).y_pos-90) && 
              (this.y_velocity >=0) &&
              (this.x >= platforms.get(i).x_pos-90) && (this.x <= platforms.get(i).x_pos+60))) {
                           
                  //ako je nestajuća, igrac moze odskociti od nje samo jednom
                  if ( platforms.get(i) instanceof Disappearing_Platform )
                    platforms.get(i).destroy();
                    
                  //brzina joj postane negativna (što znači, prema gore) 
                  this.y = platforms.get(i).y_pos-50;
                  this.y_velocity = -48;
                  break;
                }            
                //ako je platforma potrgana, postane potrganija
                //kocka se ne odbije, ostaje joj pozitivna brzina
                //if(platforms.get(i).tip==3)
               // {
                 // platforms.get(i).tip=4;
                  //this.y_velocity=0;
               // }
      }
      //sada provjeravamo platforme koje se lome
      for ( int i = 0; i < broken_platforms.size(); i++ ) {
        if (( (this.y >= broken_platforms.get(i).y_pos-110) && (this.y <= broken_platforms.get(i).y_pos-90) && 
              (this.y_velocity >=0) &&
              (this.x >= broken_platforms.get(i).x_pos-90) && (this.x <= broken_platforms.get(i).x_pos+60))){
                broken_platforms.get(i).break_pl();
        } 
      }
    }
  }

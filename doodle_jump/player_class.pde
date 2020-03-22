enum Orientation {
  LEFT,
  RIGHT
}

enum State {
  REGULAR,
  SPRINGS,
  SHIELD,
  PROPELLER,
  RIP
}

class Player {
    private float x, y, x_velocity, y_velocity, gravity, size;
    private float climb;
    public int score;
    //duljina trajanja supermoci u milisekundama
    //sve supermoci traju jednako(6s), osim propelera(3s)
    //t_start ce oznacavati vrijeme kada je igrac pokupio moc
    private int sp_duration, propeller_duration, t_start;
    private Orientation orientation;
    private State state;
  
    //konstruktor
    public Player(int x, int y, int x_velocity, int y_velocity, int size) {
      this.x = x;
      this.y = y;
      this.x_velocity = x_velocity;
      this.y_velocity = y_velocity;
      this.size = size;
      this.score = 0;
      this.climb = 0;
      this.gravity = 2;
      this.orientation = Orientation.RIGHT;
      this.state = State.REGULAR;
      this.sp_duration = 6000;
      this.propeller_duration = 3000;
      this.t_start = -1;
      
    }
  
    public void update( ArrayList<Platform> platforms, ArrayList<Broken_Platform> broken_platforms, MyFloat first_horiz_line ) {
      
      this.update_state();
      this.check_collision( platforms, broken_platforms );
      this.move();
      this.move_world( platforms, broken_platforms, first_horiz_line );
           
    }
    
    public void display( ) {
      
      int tip = 0;
      switch( state ){
        case REGULAR :
          tip = 0; 
          break;
        case SPRINGS :
          tip = 2; 
          break;
        case SHIELD :
          tip = 4;
          break;
        case PROPELLER :
          tip = 6; 
          break;
        case RIP :
          tip = 8;
          break;
      }
      if ( orientation == Orientation.LEFT ){
        tip++;
      }
      PImage slika = moodlers.get( tip );
      if ( tip == 6 || tip == 7 ) {
        image( slika, this.x, this.y, this.size + 25, this.size + 25 );
      }
      else {
      image( slika, this.x, this.y, this.size, this.size );
      }
    }
    
    public void move() {
      
      if (keyPressed && keyCode == LEFT) {
        this.x -= 10;
        orientation = Orientation.LEFT;
      }
      else if (keyPressed && keyCode == RIGHT)  {
        this.x += 10;
        orientation = Orientation.RIGHT;
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
        
        //ažuriranje zadaće
        HW.y_pos+=this.climb;
      }
    }
    
    public void check_collision( ArrayList<Platform> platforms, ArrayList<Broken_Platform> broken_platforms ) {
      
      //ako igrac ima supermoc "propela" ili je mrtav, ne radi nista
      if ( ( state == State.PROPELLER ) || ( state == State.RIP ) ) {
        return;
      }
      
      //ako se igrac sudari sa zidom, preazi na drugu stranu, ne odbija se
      //moodler se crta s one strane gdje se nalazi vise od "pola" lika    
      if (this.x + this.size/2 <= 0) this.x = width + this.x;
      if (this.x >= width - this.size/2 ) this.x = this.x - width;
      
      //sudaranje s platformama
      //prvo provjeravamo platforme koje se ne lome
      for ( Platform platform : platforms ) {
        
        if (( ( y >= platform.y_pos-110 ) && ( y <= platform.y_pos-90 ) && ( y_velocity >=0 ) &&
              ( x >= platform.x_pos-90 ) && ( x <= platform.x_pos+60))) {  
                
            platform.visited = true;
                           
            //ako je nestajuća, igrac moze odskociti od nje samo jednom
            if ( platform instanceof Disappearing_Platform )
              platform.destroy();
              
            //ako igrac nema moci, skuplja je, ako postoji na platformi
            if ( state == State.REGULAR ) {
              
              //slucajevi ovisno postoji li i koja supermoc na platformi
              switch( platform.get_power() ){
                case "" :
                  //brzina joj postane negativna (što znači, prema gore) 
                  this.y = platform.y_pos-50;
                  this.y_velocity = -48;
                  break;
               case "federi" :
                 this.t_start = millis();
                 this.state = State.SPRINGS;
                 this.gravity = 1.25;
                 this.y = platform.y_pos-50;
                 this.y_velocity = -48;
                 break;
               case "stit" :
                 this.t_start = millis();
                 this.state = State.SHIELD;
                 this.y = platform.y_pos-50;
                 this.y_velocity = -48;
                 break;
               case "propela" :
                 this.t_start = millis();
                 this.state = State.PROPELLER;
                 this.gravity = 0;
                 this.y = platform.y_pos-50;
                 this.y_velocity = -48;
                 break;
            }
          }
          //ako vec ima moc, ne moze skupiti novu
          else {
            this.y = platform.y_pos-50;
            this.y_velocity = -48;
            break;
          }   
        }
      }
      //sada provjeravamo platforme koje se lome
      for ( int i = 0; i < broken_platforms.size(); i++ ) {
        
        if (( (this.y >= broken_platforms.get(i).y_pos-110) && (this.y <= broken_platforms.get(i).y_pos-90) && 
              (this.y_velocity >=0) &&
              (this.x >= broken_platforms.get(i).x_pos-90) && (this.x <= broken_platforms.get(i).x_pos+60))){
                broken_platforms.get(i).break_pl();
        } 
      }      
      //i sad nakraju provjeravamo koliziju sa zadaćom
      //ako igrac ima stit ili propelu, nista se ne dogada
      if( state != State.SHIELD || state != State.SHIELD ) {
        if(rect_intersect(HW.x_pos, HW.y_pos, HW.x_pos+HW.x_size, HW.y_pos+HW.y_size, x,y,x+size,y+size)>0)
        {
          state = State.RIP;
        }
      }
      
    }
  
    //azurira stanje player-a, tj upravlja timerom za supermoci
    public void update_state(){
      
      //ako nema supermoc, ne radi nista
      if ( state == State.REGULAR || state == State.RIP ) {
        return;
      }
      if ( state == State.PROPELLER && ( millis() - t_start >= propeller_duration ) ) {
        state = State.REGULAR;
        gravity = 2;
      }
      else if ( millis() - t_start >= sp_duration ) {
        state = State.REGULAR;
        gravity = 2;
      }   
      
  }
  
}

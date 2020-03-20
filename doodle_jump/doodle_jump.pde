import java.util.ArrayList;
int state=0;
final int MAIN_MENU=0;
final int GAME=1;

Player p;
Platform zadnja;
Broken_Platform prva_slomljena;
ArrayList<Platform> platforms;
ArrayList<Broken_Platform> broken_platforms;
ArrayList<PImage> moodlers;
//razmak izmedu linija u pozadinskoj mrezi
MyFloat first_horiz_line;
int line_dist;

void setup() {
  size(500, 800);
  
  first_horiz_line = new MyFloat();
  line_dist = 25;
  
  p = new Player(135, 475, 0, 0, 100, 0);
  platforms = new ArrayList<Platform>();
  reset(); //funkcija služi da resetira sve varijable nakon što igrač padne
  
  moodlers= new ArrayList<PImage>(); 
  moodlers.add(loadImage("moodler_D.png"));
  moodlers.add(loadImage("moodler_L.png"));
  moodlers.add(loadImage("moodler_kapa_D.png"));
  moodlers.add(loadImage("moodler_kapa_L.png"));
}

void draw_background() {
  
  //vertikalne linije
  for ( int x = 0; x < 500; x += line_dist ){
    stroke( 150 );
    //crvena linija
    if ( x == 100 ){
      stroke( 205, 92, 92 );
    }
    line( x, 0, x, 800 );
  }
  //horizontalne linije
  for ( float y = first_horiz_line.value ; y < 800; y += line_dist ){
    line( 0, y, 500, y ); 
  }
  
}

void draw() {

  switch(state) {
  
    case MAIN_MENU:
      background(225);
      draw_background();
      textSize(50);
      fill(27);
      text("   oodle Jump", 100, 200);
      rect(140,380,200,100);
      fill(255);
      textSize(35);
      text("START",187, 445);
      image(moodlers.get(0),90,145,70,70);
      
      if(mouseX > 140 && mouseX < 140+200 && mouseY > 380 && mouseY < 380+100 && mousePressed)
        state=1;
       break;
        
    case GAME:
  
      frameRate(40);
      background(225);
      text("Score: "+str(p.score), 20, 40);
      //update svih platformi
      for ( Platform platform : platforms ) {       
        platform.update();
      }
      //update playera
      p.update(platforms, broken_platforms, first_horiz_line); 
      
      draw_background();
  
      //prvo se crtaju platforme pa player da bi player bio 'ispred' njih
      for ( Platform platform : platforms ) {       
        platform.display();
      }
      //crtanje slomljenih platformi
      for ( Broken_Platform broken_platform : broken_platforms ) {       
        broken_platform.display();
      }
      //crtanje playera
      p.display();  
  
      add_remove_platforms();
      if (p.y > 800+25){
      reset();
        state=0;}
      break;
  }
}

void add_remove_platforms() {
  
  //brise platforme ako su 'izletile' iz prozora
  for (int i=0; i<platforms.size(); i++) {
    if (platforms.get(i).y_pos >= height) platforms.remove(i);
  }
  //brise slomljene platforme
  for (int i=0; i<broken_platforms.size(); i++) {
    if (broken_platforms.get(i).y_pos >= height) broken_platforms.remove(i);
  }

  //broj platformi ovisi o visini na kojoj se igrac nalazi, tj score-u
  //najvise ih je 16(na pocetku), a najmanje 6
  int broj_pl = ( 16 - p.score/250 > 5 ) ? ( 16 - p.score/250 ) : 6; 
  
  //vjerojatnost da platforma bude obicna
  //vjerojatnost je obrnuto proporcionalna score-u
  float P_obicna = ( p.score/3000 < 1 ) ? ( 1 - (Float.valueOf(p.score)/3000 ) ): 0;
  //System.out.println( P_obicna );
  
  //vjerojatnost da platforma bude pomicna
  //vjerojatnost da platforma bude nestajuća je tada ( 1 - P_obicna - P_pomicna )
  float P_pomicna = ( p.score/6000 < 1 ) ? ( P_obicna - (Float.valueOf(p.score)/6000 ) ) : 0;
  
  //prvo crtamo platforme koje se slamaju
  //njihov broj je konstantan = 3
  while( broken_platforms.size() < 3 ){
    Broken_Platform new_broken = new Broken_Platform( random( 425 ), -300  * broken_platforms.size() );
    broken_platforms.add( new_broken );
  }
  
  //sada crtamo ostale platforme
  int razmak = 800/( broj_pl - 1 );
  Platform new_platform;
  //vjerojatnost da se supermoći nalaze na platformi
  double P_federi = (double)3/400;
  //System.out.println( P_federi );
  double P_stit = (double)2/400;
  //System.out.println( P_stit );
  double P_propela = (double)1/400;
  //System.out.println( P_propela );
  
  while ( platforms.size() < broj_pl ) {
    
    String superpower = "";
    
    //o vrijednosti rnd ovisi koja vrsta platforme ce se stvoriti, te
    //hoce li i koja supermoc biti na toj platformi
    float rnd = random( 0, 1 );

    if ( rnd <= P_propela ) {
      //System.out.println( "propela" );
      superpower = "propela";
    }
    else if ( rnd <= P_propela + P_stit ) {
      //System.out.println( "stit" );
      superpower = "stit";
    }
    else if ( rnd <= P_propela + P_stit + P_federi ) {
      //System.out.println( "federi" );
      superpower = "federi";
    }
     
    if ( rnd <= P_obicna ){
      new_platform = new Regular_Platform( random(425), zadnja.get_y() - razmak, superpower);
    }
    else if ( rnd <= P_obicna + P_pomicna ){
      new_platform = new Moving_Platform( random(425), zadnja.get_y() - razmak, superpower);
    } 
    else {
      new_platform = new Disappearing_Platform( random(425), zadnja.get_y() - razmak, superpower);
    }  
    
    platforms.add(new_platform);
    zadnja = new_platform;
  }  
  
}

//funkcija služi da resetira sve varijable nakon što igrač padne
void reset(){
  for (int i = platforms.size() - 1; i >= 0; i--) {
    platforms.remove(i);
  }
  //pocetna platforma
  zadnja = new Regular_Platform(100, 700, "");
  platforms.add(zadnja);
  
  //inicijalizacija liste slomljenih platformi(prazna lista)
  broken_platforms = new ArrayList<Broken_Platform>();
  
  p.x=80;
  p.y=475;
  p.x_velocity=0;
  p.y_velocity=0;
  p.score = 0;
  
  first_horiz_line.value = 0;
}
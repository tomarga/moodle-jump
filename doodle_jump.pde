import java.util.ArrayList;
int state=0;
final int MAIN_MENU=0;
final int GAME=1;
int score = -5;
Player p;
ArrayList<Platform> platforms;
ArrayList<PImage> slikaplatniz;
ArrayList<PImage> moodlers;



void setup() {
  size(500, 800);
  
  p = new Player(135, 475, 0, 0, 50, 0);
  platforms = new ArrayList<Platform>();
  reset(); //funkcija služi da resetira sve varijable nakon što igrač padne
  
  slikaplatniz= new ArrayList<PImage>();
  moodlers= new ArrayList<PImage>();
  
  slikaplatniz.add(loadImage("platforma_obicna.png"));
  slikaplatniz.add(loadImage("platforma_nestajuca.png"));
  slikaplatniz.add(loadImage("platforma_pomicna.png"));
  slikaplatniz.add(loadImage("platforma_slomljena2.png"));
  slikaplatniz.add(loadImage("platforma_slomljena4.png"));
  
  moodlers.add(loadImage("moodler_D.png"));
  moodlers.add(loadImage("moodler_L.png"));
  moodlers.add(loadImage("moodler_kapa_D.png"));
  moodlers.add(loadImage("moodler_kapa_L.png"));
}


void draw() {
  
  switch(state) {
  
    case MAIN_MENU:
      background(225);
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
      text("Score: "+str(score), 20, 40);
      p.update(platforms);
      p.display();
  
      for (int i=0; i<platforms.size(); i++) {
        platforms.get(i).display();
      }
  
      add_remove_platforms();
      if (p.y > 800+25){
      reset();
        state=0;}
      break;
  }
}

void add_remove_platforms() {
  for (int i=0; i<platforms.size(); i++) {
    if (platforms.get(i).y_pos >= height) platforms.remove(i);
  }
  
  while (platforms.size() < 6) {
    Platform new_platform = new Platform( random(425), 700-(145*platforms.size()), 0);
    platforms.add(new_platform);
    score++;
    
    //new_platform = new Platform( random(425), random(700), 3);
    //platforms.add(new_platform);
  }
}
void reset(){
  for (int i = platforms.size() - 1; i >= 0; i--) {
    platforms.remove(i);
  }
  Platform starter_platform = new Platform(100, 700, 0);
  platforms.add(starter_platform);
  p.x=135;
  p.y=475;
  p.x_velocity=0;
  p.y_velocity=0;
  score=-5;
}

import java.util.ArrayList;
int state=0;
final int MAIN_MENU=0;
final int GAME=1;
Player p;
ArrayList<Platform> platforms;

void setup() {
  size(500, 800);
  
  p = new Player(135, 475, 0, 0, 50);
  platforms = new ArrayList<Platform>();
  reset(); //funkcija služi da resetira sve varijable nakon što igrač padne
}


void draw() {
  
  switch(state) {
    case MAIN_MENU:
      background(225);
      textSize(50);
      fill(27);
      text("Moodle Jump", 100, 200);
      rect(140,380,200,100);
      fill(255);
      textSize(35);
      text("START",187, 445);
      
      if(mouseX > 140 && mouseX < 140+200 && mouseY > 380 && mouseY < 380+100 && mousePressed)
        state=1;
       break;
        
    case GAME:
  
      frameRate(40);
      background(225);
  
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
    Platform new_platform = new Platform( random(425), 700-(145*platforms.size()));
    platforms.add(new_platform);
  }
}
void reset(){
  for (int i = platforms.size() - 1; i >= 0; i--) {
    platforms.remove(i);
  }
  Platform starter_platform = new Platform(100, 700);
  platforms.add(starter_platform);
  p.x=135;
  p.y=475;
  p.x_velocity=0;
  p.y_velocity=0;
}

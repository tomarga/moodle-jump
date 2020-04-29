import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.ArrayList; 
import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class moodle_jump extends PApplet {

//biblioteke



//globalne varijable
int state = 0;
final int MAIN_MENU = 0;
final int GAME = 1;
final int HIGHSCORES = 2;
final int GAME_OVER = 3;

//glazba
SoundFile Gauda, Rainbows, Gameover, Fall;
String audioName1 = "Rainbows.mp3";
String audioName2 = "Gauda.mp3";
String audioName3 = "MoodleJump_gameover.mp3";
String audioName4 = "Moodle_Fall.mp3";

//neke varijable koje su mi trebale za gameover screen(MK)
int GOTime;
int GOFall;

homework HW;
IntList highscores;
Player p;
Platform last;
ArrayList<Platform> platforms;
ArrayList<Broken_Platform> broken_platforms;
ArrayList<PImage> moodlers;
ArrayList<Bullet> bullets;
PImage bullet_img;
//razmak izmedu linija u pozadinskoj mrezi
MyFloat first_horiz_line;
int line_dist;
int score = 0;

public void setup() {
  
  Rainbows = new SoundFile(this, audioName1);
  Gauda = new SoundFile(this, audioName2);
  Gameover = new SoundFile(this, audioName3);
  Fall = new SoundFile(this, audioName4);
  Rainbows.loop();
  
  first_horiz_line = new MyFloat();
  line_dist = 25;
  highscores = new IntList(0,0,0,0,0,0);
  
  p = new Player(135, 475, 0, 0, 100);
  
  HW= new homework(150,100);
  reset(); //funkcija služi da resetira sve varijable nakon što igrač padne
  
  //slike moodlera
  moodlers= new ArrayList<PImage>(); 
  moodlers.add(loadImage("moodler_D.png"));//0
  moodlers.add(loadImage("moodler_L.png"));//1
  moodlers.add(loadImage("moodler_federi_D.png"));//2
  moodlers.add(loadImage("moodler_federi_L.png"));//3
  moodlers.add(loadImage("moodler_stit_D.png"));//4
  moodlers.add(loadImage("moodler_stit_L.png"));//5
  moodlers.add(loadImage("moodler_propela2_D.png"));//6
  moodlers.add(loadImage("moodler_propela2_L.png"));//7
  moodlers.add(loadImage("moodler_rip_D.png"));//8
  moodlers.add(loadImage("moodler_rip_L.png"));//9
  moodlers.add(loadImage("moodler_ljuti_D.png"));//10
  moodlers.add(loadImage("moodler_ljuti_L.png"));//11 
  //slika metka
  bullet_img = loadImage("metak.png");
  bullet_img.resize(bullet_img.width / 6, bullet_img.height / 6);
  
}

public void draw_background() {
  
  //vertikalne linije
  for (int x = 0; x < 500; x += line_dist){
    stroke(150);
    //crvena linija
    if (x == 100){
      stroke(205, 92, 92);
    }
    line(x, 0, x, 800);
  }
  //horizontalne linije
  for (float y = first_horiz_line.value ; y < 800; y += line_dist){
    line(0, y, 500, y); 
  }
  
}

public void draw() {

  switch(state) {
    
    case MAIN_MENU:
    
      background(225);
      draw_background();
      textAlign(CENTER);
      textSize(70);
      fill(27);
      text("   oodle Jump", width/2, 175);
      textSize(25);
      fill(255, 100, 0);
      text("A or LEFT for left,  D or RIGHT for right", width/2, 250);
      text("LCLICK for shoot", width/2, 300);
      fill(27);
      rect(125,350,250,100);
      rect(125,550,250,100);
      fill(255);
      textSize(35);
      text("START",width/2, 415);
      text("HIGHSCORES",width/2, 615);
      image(moodlers.get(0), 20, 111, 80, 80);
      image(loadImage("dz.png"), 220, 470, 60, 60);
    
      if(mouseX > 125 && mouseX < 125+250 && mouseY > 350 && mouseY < 350+100 && mousePressed){
        state=1;
        Rainbows.stop();
        Gauda.jump(2.5f);
      }
      if(mouseX > 125 && mouseX < 125+250 && mouseY > 550 && mouseY < 550+100 && mousePressed)
        state=2;
       break;
       
    case HIGHSCORES:
    
        background(225);
        draw_background();
        fill(27);
        rect(125,75,250,100);
        textSize(40);
        fill(255);
        textAlign(CENTER);
        text("BACK", width/2, 140);
        textSize(40);
        fill(27);
        fill(0, 0, 255);
        for(int i = 0; i < 5; i++){
          textAlign(LEFT);
          text((i+1)+".    "+str(highscores.get(i)), 50, 200+(i+1)*100);
        }
        if(mouseX > 125 && mouseX < 125+250 && mouseY > 75 && mouseY < 75+100 && mousePressed)
          state=0;
        
        break;
        
        
    case GAME:
    
      if(Gauda.isPlaying() == false && p.state != State.RIP)
        Gauda.jump(2.5f);
      frameRate(40);
      background(225);
      //update svih platformi
      for (Platform platform : platforms) {       
        platform.update();
      }
      //update playera
      p.update(platforms, broken_platforms, first_horiz_line);
      //update metaka
      for (Bullet bullet : bullets) {
        bullet.update();
      }
      //update cudovista
      HW.update();
      
      draw_background();
  
      //prvo se crtaju platforme pa player da bi player bio 'ispred' njih
      for (Platform platform : platforms) {       
        platform.display();
      }
      //crtanje slomljenih platformi
      for (Broken_Platform broken_platform : broken_platforms) {       
        broken_platform.display();
      }
      //crtanje metaka
      for (Bullet bullet : bullets) {
        bullet.display();
      }
      //crtanje cudovista
      HW.display();
      //crtanje playera
      p.display();  
      
      remove_bullets();
      text("Score: "+str(p.score), 100, 40);
      
      add_remove_platforms();
      if (p.y > 800+25){
        score = p.score;
        //ako je igrač napravio bolji rekord(top 5), dodaj na listu
        if(highscores.get(5)<score){
          highscores.add(5,score);
          highscores.sortReverse();  
        }
        state=3;
        Gauda.stop();       
        
        if(GOFall==0)
        {
          GOFall=1;
          Fall.play();
        }      
        reset();
      }
      break;
      
      case GAME_OVER:       
        background(225);
        draw_background();
        textSize(60);
        fill(255,0,0);
        text("GAME OVER :(", width/2, 150);
        if(score > highscores.get(1)){
        textSize(50);
        fill(255,100,0);
        text("NEW RECORD!", width/2,300);
        }
        else {
        textSize(45);
        fill(255,100,0);
        text("SCORE", width/2, 300);
        }
        textSize(80);
        fill(255,100,0);
        text(score, width/2, 425);
        fill(27);
        rect(125,650,250,100);
        textSize(40);
        fill(255);
        text("BACK", width/2, 715);
        fill(27);
        rect(125,500,250,100);
        textSize(40);
        fill(255);
        text("RESTART", width/2, 565);
        if(mouseX > 125 && mouseX < 125+250 && mouseY > 650 && mouseY < 650+100 && mousePressed){
          state=0; 
          Gauda.stop();
          Gameover.stop();
          Rainbows.loop();
        }
        if(mouseX > 125 && mouseX < 125+250 && mouseY > 500 && mouseY < 500+100 && mousePressed){
          state=1;
          Gameover.stop();
          Gauda.jump(2.5f);
        }
        
        if(GOFall==0)
        {
          GOFall=1;
          Fall.play();
          GOTime-=0.8f*frameRate;
        }
        
        if(GOFall==1)
        {
          GOTime++;
          
          if(GOTime>0.8f*frameRate)
          {
            GOFall=2;
            Gameover.play();
          }
        }
        
        break;
          
  }
}

//metak se ispaljuje nakon klika mišem
public void mousePressed() {  
  
  //klik na start ili ako je igrač mrtav ne smije ispucati metak
  if (state != 1  || p.state == State.RIP){
    return;
  }
  Bullet new_bullet = new Bullet(mouseX, mouseY);
  bullets.add(new_bullet);
  //Moodler je ljut kad puca
  if (p.state == State.REGULAR){
    p.state = State.ANGRY;
  }  
}

public void remove_bullets(){

    for (int i = 0; i < bullets.size(); i++) {
    if (bullets.get(i).get_x() + bullet_img.width < 0 || bullets.get(i).get_x() >= width ||
      bullets.get(i).get_y() + bullet_img.height < 0 || bullets.get(i).get_y() >= height) {
        
        bullets.remove(i);
        //ako nema više metaka u zraku, Moodler se odljuti
        if (bullets.size() == 0 && p.state == State.ANGRY){
          p.state = State.REGULAR;
        }
    } 
  }
}
public void add_remove_platforms() {
  
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
  int broj_pl = (16 - p.score/250 > 5) ? (16 - p.score/250) : 6; 
  
  //vjerojatnost da platforma bude obicna
  //vjerojatnost je obrnuto proporcionalna score-u
  float P_obicna = (p.score/3000 < 1) ? (1 - (Float.valueOf(p.score)/3000)): 0;
  //System.out.println(P_obicna);
  
  //vjerojatnost da platforma bude pomicna
  //vjerojatnost da platforma bude nestajuća je tada (1 - P_obicna - P_pomicna)
  float P_pomicna = (p.score/6000 < 1) ? (P_obicna - (Float.valueOf(p.score)/6000)) : 0;
  
  //prvo crtamo platforme koje se slamaju
  //njihov broj je konstantan = 3
  while(broken_platforms.size() < 3){
    Broken_Platform new_broken = new Broken_Platform(random(425), -300  * broken_platforms.size());
    broken_platforms.add(new_broken);
  }
  
  //sada crtamo ostale platforme
  int razmak = 800/(broj_pl - 1);
  Platform new_platform;
  
  //vjerojatnost da se supermoći nalaze na platformi
  double P_federi = (double)5/400;
  //System.out.println(P_federi);
  double P_stit = (double)2/400;
  //System.out.println(P_stit);
  double P_propela = (double)1/400;
  //System.out.println(P_propela);
  
  while (platforms.size() < broj_pl) {
    
    String superpower = "";
    
    //o vrijednosti rnd ovisi koja vrsta platforme ce se stvoriti, te
    //hoce li i koja supermoc biti na toj platformi
    float rnd = random(0, 1);

    if (rnd <= P_propela) {
      //System.out.println("propela");
      superpower = "propela";
    }
    else if (rnd <= P_propela + P_stit) {
      //System.out.println("stit");
      superpower = "stit";
    }
    else if (rnd <= P_propela + P_stit + P_federi) {
      //System.out.println("federi");
      superpower = "federi";
    }
     
    if (rnd <= P_obicna){
      new_platform = new Regular_Platform(random(425), last.get_y() - razmak, superpower);
    }
    else if (rnd <= P_obicna + P_pomicna){
      new_platform = new Moving_Platform(random(425), last.get_y() - razmak, superpower);
    } 
    else {
      new_platform = new Disappearing_Platform(random(425), last.get_y() - razmak, superpower);
    }  
    
    platforms.add(new_platform);
    last = new_platform;
  }   
}



//funkcija služi da resetira sve varijable nakon što igrač padne
public void reset(){
  
 //inicijalizacija liste platformi
  platforms = new ArrayList<Platform>();
  
  //pocetna platforma
  last = new Regular_Platform(100, 700, "");
  platforms.add(last);
  
  //inicijalizacija liste metaka
  bullets = new ArrayList<Bullet>();
  
  //inicijalizacija liste slomljenih platformi(prazna lista)
  broken_platforms = new ArrayList<Broken_Platform>();
  
  p.x=80;
  p.y=475;
  p.x_velocity=0;
  p.y_velocity=0;
  p.score = 0;
  p.gravity = 2;
  p.state = State.REGULAR;
  p.orientation = Orientation.RIGHT;
  
  first_horiz_line.value = 0;
  
  HW.y_pos=100;
  //šta je sad ovo?
  //umjesto toga
  HW.rest();
  
  
  GOTime=0;
  if(GOFall!=1)
  {GOFall=0;}
  
}
enum Direction{
  LEFT,
  RIGHT
}

//klasa za metke koje Moodler ispaljuje
class Bullet {
  
  private float x_pos, y_pos;   
  private float angle;
  private Direction direction; 
  //bingo je true ako je metak pogodio cudoviste
  private boolean bingo;
  
  public Bullet( float x_click, float y_click ) {
    
    //metak se ispaljuje od pozicije playera
    x_pos = p.get_x() + 25;
    y_pos = p.get_y() + 25;
    
    float x_dist = ( x_click - x_pos );
    float y_dist = ( y_click - y_pos );
    
    angle = atan( y_dist / x_dist );
    
    if ( x_click >= x_pos ){
      direction = Direction.RIGHT;
    }
    else {
      direction = Direction.LEFT;
    }
    
    bingo = false;
  }
  
  public float get_x() {   
    return x_pos;
  }  
  public float get_y() {   
    return y_pos;
  } 
  
  public void display() {
    
      //ovdje koristimo pushMatrix i popMatrix jer želimo samo micati samo metke,a ostale stvari se ne miču
      pushMatrix();
      translate( x_pos + bullet_img.width / 2, y_pos + bullet_img.height / 2 );
      if ( direction == Direction.RIGHT ){
        rotate(radians( 90) + angle );
      }
      else {
        rotate( -( radians(90) - angle ) );
      }
      image( bullet_img, 0, 0 );
      popMatrix();
    
  }
  
  public void update() {
    
    //ako je metak pogodio metu, vise se ne prikazuje
    if ( bingo ){
      y_pos = height;
    }
    else {
      switch( direction ){
        case RIGHT :
          x_pos += 15 * cos( angle );
          y_pos += 15 * sin( angle );
          break;
        case LEFT :
          x_pos -= 15 * cos( angle );
          y_pos -= 15 * sin( angle );
          break;
      }
    }    
  }
  
}
//ovdje ću implementirati domaće zadaće, seminare i ostale more

float Pi=3.141592653589793f;

//klasa put u R^2, kao u intrafu
//klasa sama pamti (i inkrementira) parametar t
abstract class path2
{
  protected int t;
  protected int tmax;
  
  protected float x,y;
  
  
  public abstract int tset(int tt);
  public abstract int tnext();
  public abstract int trest();
  
  public float getx(){return x;}
  public float gety(){return y;}
  
}

class path2linear extends path2
{
  private float a, b;
  
  public int trest()
  {
    t=0; x=0; y=0;
    return 0;
  }
  public int tset(int tt)
  {
    if (tt>=tmax)
    {
      t=-tmax;
    }
    else t=tt;
    
    x=(tmax-abs(t))*a;
    y=(tmax-abs(t))*b;
    
    return t;
  }
  
  public int tnext()
  {
    t++;
    return tset(t);
  }
  
  public path2linear(float aa, float bb, int N)
  {
    a=aa/N; b=bb/N;
    tmax=N;
  }
  
}

class path2ellipse extends path2
{
  private float Ax, Ay, fx, fy;
  
  
  public int trest()
  {
    t=0; x=0; y=0;
    return 0;
  }
  public int tset(int tt)
  {
    t=tt%tmax;
    
    x=Ax*cos(fx*t);
    y=Ay*sin(fy*t);
    
    return t;
  }
  
  public int tnext()
  {
    t++;
    return tset(t);
  }
  
  public path2ellipse(float H, float V, int N, int xr, int yr)
  {
    Ax=H; Ay=V;
    tmax=N;
    
    fx=2*Pi*xr/N;
    fy=2*Pi*yr/N;
    
    trest();
  }
}

float HW_initial_size=60;
String HW_default_image_name="dz.png";
String SEM_default_image_name="seminar.png";

class homework
{
  int type;
  //domaća zadaća
  //ima položaj i veličinu (kao i platforma)
  float x_pos, y_pos;
  float x_size[]={0,0}, y_size[]={0,0};
  
  PImage HWImage[]={null, null};
  int health; //ovo se smanji kad ga pogodimo
  int i = 0;

  float x_velocity, y_velocity;
  path2 HWpath[]; 
  
  public homework(float x, float y)
  {
    x_pos=x;
    y_pos=y;
        
    HWImage[0]=loadImage(HW_default_image_name);
    HWImage[1]=loadImage(SEM_default_image_name);
    //ovo smo vani definirali za slučaj kada bi trebali to ponovo koristiti
    x_size[0]=HW_initial_size;
    y_size[1]=HW_initial_size;
    y_size[0]=x_size[0]*HWImage[0].height/HWImage[0].width;
    x_size[1]=y_size[1]*HWImage[1].width/HWImage[1].height;
       
    x_velocity=0;
    y_velocity=0;

    HWpath= new path2[2];
    HWpath[0]= new path2ellipse(10, 5, 20, 1, -2);
    HWpath[1]= new path2ellipse(0, 10, 60, 0, 1);
    
    type=0;
    health=1;
  }
  
  public void display()
  {
    
    if ( health > 0 ) {
      image(HWImage[type], x_pos+HWpath[type].getx(), y_pos+HWpath[type].gety(), x_size[type], y_size[type]);
    }
    
  }
  
  public void update()
  {
    //zadaća će biti jako malo, samo jedna će se pokazivati istovremeno
    //umjesto polja s zadaćama, koristit ćemo samo jednu zadaću i reciklirati je dok umre
    
    //ovo mozda treba staviti vani
    //provjera je li zadaću pogodio metak
    for ( Bullet bullet : bullets ){
      if ( rect_intersect( x_pos, y_pos, x_pos + x_size[type], y_pos + y_size[type], 
        bullet.x_pos, bullet.y_pos, bullet.x_pos + bullet_img.width, bullet.y_pos + bullet_img.height ) > 0 ) {   

        health --;
        bullet.bingo = true;
      }
    }
    
    if(health == 0)
    {
      float rnd=random(12);
      
      type=PApplet.parseInt(rnd)/9;
      
      makeHW(type);
    }

    if(y_pos>=height)
    {
      health=0;
    }
    
    HWpath[type].tnext();
            
  }
   
  //t=0 make a homework, t=1 make a seminar
  private void makeHW(int t)
  {
    type=t;
    
    switch(t){
      case 0 :
        x_pos=random(400);
        y_pos=-1*random(600)-400;
        
        
        health=1;
        
      break;
      case 1:
        x_pos=random(400);
        y_pos=-1*random(1000);
        
        health=2;
        
      break;
    }
  }
  
  
  public float get_size_x()
  {
    return x_size[type];
  }
  public float get_size_y()
  {
    return y_size[type];
  }
  
  public void rest()
  {
    makeHW(0);
  }
  
}

//pokušaj da se provjera kolizije bolje implementira
//ako dva pravokutnika imaju neprazan presjek, u koliziji su
//funkcija prima redom:
//xy koordinate gornjeg lijevog vrha prvog pravokutnika
//xy koordinate donjeg desnog vrha prvog pravokutnika
//analogno gornji lijevi i donji desni vrh drugog pravokutnika
public float rect_intersect(float x11, float y11, float x12, float y12, float x21, float y21, float x22, float y22)
{
  float x1=max(x11,x21);
  float y1=max(y11,y21);
  
  float x2=min(x12,x22);
  float y2=min(y12,y22);
  
  if(x2==x1 || y1==y2)
  {
    //pravokutnici imaju zajednički rub
    return 0;}
  if(x2<x1 || y2<y1)
  {
    //pravokutnici nemaju ništa zajedničko
    return -1;
  }
  
  //pravokutnici imaju neprazan presjek
  //i slučajno znamo točnu površinu
  return (x2-x1)*(y2-y1);
  
}
abstract class Platform {
  
  protected float x_pos, y_pos;
  protected float p_length;
  protected PImage platformImage, power;
  //superpower moze biti "", "federi", "stit", "propela"
  protected String superpower;
  //visited je true ako je igrac ikad prešao preko platforme
  public boolean visited;
  
  public Platform( float x, float y, String spower ) {
    x_pos = x;
    y_pos = y;
    
    p_length = 75;  
    
    superpower = spower;
    
    visited = false;
      
    if ( superpower.equals( "" ) == false ){
      String stringImage = superpower + ".png";
      power = loadImage( stringImage );
      power.resize( (int)( power.width/2.25f ), (int)( power.height/2.25f ) );
    }
    
  }
  
  public void display() {  
    
    //ako na platformi postoji supermoc
    if ( superpower.equals( "" ) == false && !visited ) {     
      image( power, x_pos, y_pos - power.height );
    }
      
    image(platformImage, x_pos, y_pos, p_length, p_length*platformImage.height/platformImage.width );
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
  
  public abstract void update();
}

class Regular_Platform extends Platform {
  
  public Regular_Platform( float x, float y, String spower ){
    super( x, y, spower );
    platformImage = loadImage( "platforma_obicna.png" );
  }  
  public void update() {   
  }
}

class Moving_Platform extends Platform {
  
  private float x_velocity;
  
  public Moving_Platform( float x, float y, String spower ){
    super( x, y, spower );
    platformImage = loadImage( "platforma_pomicna.png" );
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
    platformImage = loadImage( "platforma_nestajuca.png" );
  } 
  public void update(){
  }
}

class Broken_Platform extends Platform {
  
  private PImage platformImage0, platformImage1, platformImage2, platformImage3, platformImage4, platformImage5;
  private boolean broken;
  
  public Broken_Platform( float x, float y ){
    super( x, y, "" );
    
    broken = false;

    platformImage0 = loadImage( "platforma_slomljena1.png" );
    platformImage1 = loadImage( "platforma_slomljena2.png" );
    platformImage2 = loadImage( "platforma_slomljena4.png" );
    platformImage3 = loadImage( "platforma_slomljena3.png" );
    platformImage4 = loadImage( "platforma_slomljena4.png" );
    platformImage5 = loadImage( "platforma_slomljena5.png" );
    
    platformImage = platformImage0;
  } 
  
  public void display(){
    
    if ( platformImage == platformImage1 ){
      platformImage = platformImage2;
    }        
    else if ( platformImage == platformImage2 ){
      platformImage = platformImage3;
    }
    else if ( platformImage == platformImage3 ){
      platformImage = platformImage4;
    }
    else if ( platformImage == platformImage4 ){
      platformImage = platformImage5;
    }
    else if ( broken &&  ( platformImage == platformImage0 ) ){
      platformImage = platformImage1;
    }
    else if ( platformImage == platformImage5 ){
      this.y_pos += 5;
    }
    image(platformImage, x_pos, y_pos, p_length, p_length*platformImage.height/platformImage.width);
    
  }
  public void update(){
  }
  public void break_pl(){
    broken = true;
  } 
}
enum Orientation {
  LEFT,
  RIGHT
}

enum State {
  REGULAR,
  ANGRY,
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
    
    public float get_x() {
      return x;
    }
    public float get_y() {
      return y;
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
        case ANGRY :
          tip = 10;
          break;
      }
      if ( orientation == Orientation.LEFT ){
        tip++;
      }
      PImage slika = moodlers.get( tip );
      if ( tip == 6 || tip == 7 ){
        image( slika, this.x, this.y, this.size + 25, this.size + 25 );
      }
      else if ( tip == 4 || tip == 5 ) {
        image( slika, this.x, this.y, this.size + 10, this.size + 10 );
      }
      else {
      image( slika, this.x, this.y, this.size, this.size );
      }
    }
    
    public void move() {
      
      if (keyPressed && ( keyCode == LEFT || key == 'a' || key == 'A' ) ) {
        this.x -= 10;
        orientation = Orientation.LEFT;
      }
      else if (keyPressed && ( keyCode == RIGHT || key == 'd' || key == 'D' ) )  {
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
        
        if (( ( y >= platform.y_pos-110 ) && ( y <= platform.y_pos-90 ) &&
              ( x >= platform.x_pos-90 ) && ( x <= platform.x_pos+60))) {  
                           
            //ako igrac nema moci, skuplja je, ako postoji na platformi
            if ( state == State.REGULAR || state == State.ANGRY ) {
              
              platform.visited = true;
              
              //slucajevi ovisno postoji li i koja supermoc na platformi
              switch( platform.get_power() ){
                case "" :
                  break;
               case "federi" :
                 this.t_start = millis();
                 this.state = State.SPRINGS;
                 this.gravity = 1.25f;
                 break;
               case "stit" :
                 this.t_start = millis();
                 this.state = State.SHIELD;
                 break;
               case "propela" :
                 this.t_start = millis();
                 this.state = State.PROPELLER;
                 this.gravity = 0;
                 this.y_velocity = -48;
                 break;
            }
          }
           
           //ako se Moodler sudari s platformom dok je u padu, odskače od nje
           if ( y_velocity >= 0 ) {
                                          
            //ako je nestajuća, igrac moze odskociti od nje samo jednom
             if ( platform instanceof Disappearing_Platform )
               platform.destroy();
              
             this.y = platform.y_pos-50;
             this.y_velocity = -48;
            
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
      //i sad na kraju provjeravamo koliziju sa zadaćom
      //ako igrac ima stit ili smo ubili cudoviste, nista se ne dogada
      if( state != State.SHIELD && HW.health >= 0 ) {
        if(rect_intersect(HW.x_pos, HW.y_pos, HW.x_pos+HW.get_size_x(), HW.y_pos+HW.get_size_y(), x,y,x+size,y+size)>0)
        {
          
          state = State.RIP;
          Gauda.stop();
          Fall.play();
          GOFall=1;
        }
      }
      
    }
  
    //azurira stanje player-a, tj upravlja timerom za supermoci
    public void update_state(){
      
      //ako nema supermoći, ne radi nista
      if ( state == State.ANGRY || state == State.REGULAR || state ==State.RIP ){
        return;
      }
      
      //ako je isteklo vrijeme neke supermoći
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
//pomocna klasa
class MyFloat {  
  float value;
}
  public void settings() {  size(500, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--hide-stop", "moodle_jump" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

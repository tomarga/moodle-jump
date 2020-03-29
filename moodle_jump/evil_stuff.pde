//ovdje ću implementirati domaće zadaće, seminare i ostale more

float HW_initial_size=60;
String HW_default_image_name="dz.png";

class homework
{
  //domaća zadaća
  //ima položaj i veličinu (kao i platforma)
  float x_pos, y_pos;
  float x_size, y_size;
  
  PImage HWImage;
  int health; //ovo se smanji kad ga pogodimo
  
  //možda će se zadaća i micati?
  float x_velocity, y_velocity;
  //ili ne?
  
  
  public homework(float x, float y)
  {
    x_pos=x;
    y_pos=y;
    
    x_size=HW_initial_size;
    y_size=x_size;//*HWImage.height/HWImage.width;
    HWImage=loadImage(HW_default_image_name);
    //ovo smo vani definirali za slučaj kada bi trebali to ponovo koristiti
    
    x_velocity=0;
    y_velocity=0;
    //s ovim ćemo se kasnije zabavljati
    
    health=1;
    //ovo smo isto mogli (ili trebali) vani definirati;
  }
  
  public void display()
  {
    
    //ovaj dio već sigurno napamet znate
    if ( health > 0 ) {
    image(HWImage, x_pos, y_pos, x_size, y_size);
    }
    
  }
  
  public void update()
  {
    //zadaća će biti jako malo, samo jedna će se pokazivati istovremeno
    //umjesto polja s zadaćama, koristit ćemo samo jednu zadaću i reciklirati je dok umre
    
    //ovo mozda treba staviti vani
    //provjera je li zadaću pogodio metak
    for ( Bullet bullet : bullets ){
      if ( rect_intersect( x_pos, y_pos, x_pos + x_size, y_pos + y_size, 
        bullet.x_pos, bullet.y_pos, bullet.x_pos + bullet_img.width, bullet.y_pos + bullet_img.height ) > 0 ) {   

        health --;
        bullet.bingo = true;
      }
    }
    
    if(health == 0)
    {
      health=1;
      y_pos=-100;
      x_pos=random(400);
    }

    if(y_pos>=height)
    {
      health=0;
    }
            
  }
  
}


//pokušaj da se provjera kolizije bolje implementira
//ako dva pravokutnika imaju neprazan presjek, u koliziji su
//funkcija prima redom:
//xy koordinate gornjeg lijevog vrha prvog pravokutnika
//xy koordinate donjeg desnog vrha prvog pravokutnika
//analogno gornji lijevi i donji desni vrh drugog pravokutnika
float rect_intersect(float x11, float y11, float x12, float y12, float x21, float y21, float x22, float y22)
{
  float x1=max(x11,x21);
  float y1=max(y11,y21);
  
  float x2=min(x12,x22);
  float y2=min(y12,y22);
  
  //print((x2-x1)*(y2-y1));
  
  
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

abstract class Obstacle extends Entity{
  PImage skin_day, skin_night;
  
  protected Obstacle(float w, float h, float x, float y, float vx, float vy, PImage skin_day, PImage skin_night){
    this.w = w;
    this.h = h;
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.skin_day = skin_day;
    this.skin_night = skin_night;
  }
  Obstacle(float w, float h, PImage skin_day, PImage skin_night){
    this(w,h);
    this.skin_day = skin_day;
    this.skin_night = skin_night;
  }
  Obstacle(float w, float h){
    this.w = w;
    this.h = h;
    this.x = width+w/2;
    this.y = height-field.GROUND_HEIGHT-h/2;
  }
  
  void move(float vel){
    x -= vel;
  }
  
  void display(FieldState state){
    if(skin_day != null){
      switch(state){
        case DAY:
          image(skin_day, x, y, w, h);
          break;
        case NIGHT:
          image(skin_night, x, y, w, h);
          break;
      }
    }
    else{
      fill(#EBEEFF);
      rect(x, y, w, h);
    }
  }
  
  boolean collidesWith(Player p){
    return (p.x+p.w/2 >= x-w/2 && p.x+p.w/2 <= x+w/2 ||
            p.x-p.w/2 >= x-w/2 && p.x-p.w/2 <= x+w/2) &&
           (p.y-p.h/2 <= y-h/2 && p.y+p.h/2 >= y-h/2 ||
            p.y-p.h/2 <= y+h/2 && p.y+p.h/2 >= y+h/2);
  }
  
  void shadow(FieldState state){
    float mult = map(y, height/4, height-field.GROUND_HEIGHT, 0.8, 1.2);
    switch (state){
      case DAY:
        fill(#C59F34);
        break;
      case NIGHT:
        fill(10);
        break;
      default:
        fill(10,10,10,20);
        break;
    }
    ellipse(x, height-field.GROUND_HEIGHT, w*mult, w/5*mult);
  }
  
  abstract Obstacle clone();
}

class Cactus extends Obstacle{
  Cactus(float UNIT, PImage skin_day, PImage skin_night){
    super(UNIT*0.75, UNIT*1.5, skin_day, skin_night);
  }
  private Cactus(float w, float h, float x, float y, float vx, float vy, PImage skin_day, PImage skin_night){
    super(w, h, x, y, vx, vy, skin_day, skin_night);
  }
  
  boolean collidesWith(Player p){
    float newCactusTop = y - h/2 + w/2;
    float newPlayerBottom = p.y + p.h/2 - p.w/2;
    return  sqrt(sq(p.x - x)+sq(newPlayerBottom - newCactusTop)) < w/2+p.w/2 || 
           (p.x+p.w/2 >= x-w/2 && p.x+p.w/2 <= x+w/2 ||
            p.x-p.w/2 >= x-w/2 && p.x-p.w/2 <= x+w/2) &&
           (newPlayerBottom >= newCactusTop);
  }
  
  Cactus clone(){
    return new Cactus(w, h, x, y, vx, vy, skin_day, skin_night);
  }
}

class Tumbleweed extends Obstacle{
  float baseY;
  int rotationPhase;
   
  Tumbleweed(float UNIT, PImage skin_day, PImage skin_night){
    super(UNIT/2, UNIT/2, skin_day, skin_night);
    baseY = y;
    vx = UNIT/20;
    rotationPhase = 0;
  }
  private Tumbleweed(float w, float h, float x, float y, float vx, float vy, PImage skin_day, PImage skin_night){
    super(w, h, x, y, vx, vy, skin_day, skin_night);
    this.baseY = y;
  }
  
  void move(float vel){
    x -= vel+vx;
    vy = abs(sin(radians(frameCount*5+180))*h/2);
    y = baseY - vy;
    
    rotationPhase = -floor(frameCount/6)%16;
  }
  
  void display(FieldState state){
    pushMatrix();
    translate(x,y);
    rotate(rotationPhase*HALF_PI/4);
    switch(state){
      case DAY:
        image(skin_day, 0, 0, w, h);
        break;
      case NIGHT:
        image(skin_night, 0, 0, w, h);
        break;
    }
    popMatrix();
  }
  
  boolean collidesWith(Player p){
    return sqrt(sq(x - p.x) + sq(y - p.y - p.h/2 + p.w/2)) < p.w/2 + h/2;
  }
  
  Tumbleweed clone(){
    return new Tumbleweed(w, h, x, y, vx, vy, skin_day, skin_night);
  }
}

class Cloud extends Obstacle{
  Cloud(float UNIT, PImage skin_day, PImage skin_night){
    super(UNIT*1.5, UNIT*0.75, skin_day, skin_night);
    y -= UNIT*3/4;
    vx = UNIT / 40;
  }
  private Cloud(float w, float h, float x, float y, float vx, float vy, PImage skin_day, PImage skin_night){
    super(w, h, x, y, vx, vy, skin_day, skin_night);
  }
  
  void move(float vel){
    x -= vel+vx;
  }
  
  boolean collidesWith(Player p){
    return p.y-p.h/2 <= y+h/2 &&
           (sqrt(sq(x - p.x) + sq(y + h/2 - p.y + p.h/2 - p.w/2)) < p.w/2 + h/2 ||
            sqrt(sq(x - p.x) + sq(y + h/2 - p.y - p.h/2 + p.w/2)) < p.w/2 + h/2);
  }
  
  Cloud clone(){
    return new Cloud(w, h, x, y, vx, vy, skin_day, skin_night);
  }
}
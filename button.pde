class StartButton extends Button{
  PImage skin;
  
  StartButton(){
    super(width/2, height/2, UNIT*1.5);
  }
  
  void loadCostume(){
    skin = loadImage("play_button.png");
  }
  
  @Override
  public void display(){
    if(is_pressed) r = lerp(r, r_pressed, 0.4);
    else r = lerp(r, r_original, 0.4);
    
    
    image(skin, x, y, r, r);
  }
}

class Button{
  protected float x, y;
  protected float r, r_pressed, r_original;
  
  public boolean is_pressed;
  
  Button(float x, float y, float r){
    this.x = x;
    this.y = y;
    this.r = r;
    this.r_original = r;
    this.r_pressed = r*0.8;
  }
  Button(float x, float y){
    this(x, y, UNIT);
  }
  
  public void update_state(float x_in, float y_in){
    is_pressed = sqrt(sq(x - x_in) + sq(y - y_in)) <= r;
  }
  
  public void display(){
    if(is_pressed) r = lerp(r, r_pressed, 0.2);
    else r = lerp(r, r_original, 0.2);
    
    pushMatrix();
    translate(x,y);
    stroke(100);
    strokeWeight(10);
    line(-r/4, -r/2, r/4, 0);
    line(-r/4, r/2, r/4, 0);
    noStroke();
    popMatrix();
  }
}
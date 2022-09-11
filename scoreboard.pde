class Scoreboard implements AppState{
  private short[] scores;
  private short length;
  
  public short highscore;
  private short highscore_id;
  
  private Score latest_score;
  
  private final Button button;
  private float scroll_position;
  private float total_height;
  
  private float scroll_velocity;
  private final float DRAG = 0.95;
  
  Scoreboard(){
    scores = new short[10000];
    length = -1;
    highscore_id = 0;
    button = new Button(width-UNIT*1.25, UNIT/2, UNIT/3);
    
    //loadSavedData();
  }
  
  private void loadSavedData(){
    Score temp = new Score();
    for(int i = 0; i < 80; i++){
      temp.value = (short)floor(random(random(1000)));
      put(temp);
    }
  }
  
  public void handle_input(Input input){
    switch(input){
      case PRESSED:
        button.update_state(Input.x,Input.y);
        scroll_velocity = 0;
        break;
      case MOVED:
        button.update_state(Input.x,Input.y);
        if(!button.is_pressed){
          scroll_position += Input.delta_y;
        }
        break;
      case RELEASED:
        if(button.is_pressed){
          button.update_state(Input.x,Input.y);
          if(button.is_pressed){
            button.is_pressed = false;
            exit();
          }
        }
        else{
          scroll_velocity = mouseY-pmouseY;//Input.delta_y;
          scroll_velocity = Math.signum(scroll_velocity)*min(abs(scroll_velocity), UNIT/2);
          //println("scoreboard released");
          // delta_y A SZAR (mouseY - pmouseY működik)
        }
        break;
      default:
        error_message("Scoreboard -> handle_input");
        break;
    }
  }
  
  public void update(){
    if(abs(scroll_velocity) > UNIT/100){
      scroll_position += scroll_velocity;
      scroll_velocity *= DRAG;
    }
    else scroll_velocity = 0;
    
    if(scroll_position < min(height*0.9 - UNIT*7/6 - total_height, 0)){
      scroll_position = lerp(scroll_position, min(height*0.9 - UNIT*7/6 - total_height, 0), 0.1);
      scroll_velocity = 0;
    }
    else if(scroll_position > 0){
      scroll_position = lerp(scroll_position, 0, 0.1);
      scroll_velocity = 0;
    }
  }
  
  public void enter(Score score_in){
    app_state = this;
    field.state = FieldState.NIGHT;
    
    put(score_in);
    
    scroll_position = 0;
    scroll_velocity = 0;
    total_height = (length+1)*UNIT/3;
  }
  
  public void exit(){
    transitioner.capture(this);
    transitioner.transition(0.35);
            
    HOMESCREEN.enter(latest_score);
  }
  
  private void put(Score score_in){
    latest_score = score_in;
    length++;
    scores[length] = latest_score.value;
    
    if(latest_score.value > highscore){
      highscore = latest_score.value;
      highscore_id = length;
    }
  }
  
  public void display(){
    background(0);
    
    pushMatrix();
    translate(0, height/10+UNIT);
    
    float pos_y = scroll_position-UNIT*3/7;
    for(short i = length; i >= 0; i--){
      pos_y += UNIT/3;
      if(pos_y < -UNIT || pos_y > height) continue;
      
      if(i == highscore_id) fill(38, 80, 100);
      else fill(100);
      
      textAlign(LEFT, TOP);
      text("GAME #"+nf(i+1, 2), UNIT, pos_y);
      
      textAlign(RIGHT, TOP);
      text(int(scores[i]), width-UNIT, pos_y);
      
      
    }
    popMatrix();
    
    fill(0);
    rect(width/2, UNIT/2+10, width, UNIT+20);
    
    pushMatrix();
    translate(0, UNIT/2);
    
    pushStyle();
    fill(100);
    textAlign(LEFT, CENTER);
    textSize(UNIT/2);
    text("SCOREBOARD", UNIT, 0);
    
    stroke(100);
    strokeWeight(2);
    line(UNIT, UNIT/2, width-UNIT, UNIT/2);
    popStyle();
    
    popMatrix();
    button.display();
  }
  
  public void enter(){
    app_state = this;
  }
}

class Score{
  public short value, highscore;
  
  Score(){
    value = 0;
    highscore = 0;
  }
  
  public void update(){
    if(frameCount % 2 == 0) value++;
    if(value > highscore) highscore = value;
  }
  
  public void display(){
    text("HIGHSCORE  "+highscore, width*0.85, height*0.1);
    text("SCORE  "+value, width*0.85, height*0.17);
  }
  
  public void reset(){
    value = 0;
    highscore = SCOREBOARD.highscore;
  }
}
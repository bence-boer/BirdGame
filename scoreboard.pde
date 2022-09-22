class Scoreboard implements AppState{
  private short[] scores;
  private short length;
  
  public short highscore;
  private short highscoreId;
  
  private Score latestScore;
  
  private final Button button;
  private float scrollPosition;
  private float totalHeight;
  
  private float scrollVelocity;
  private final float DRAG = 0.95;
  
  Scoreboard(){
    scores = new short[10000];
    length = -1;
    highscoreId = 0;
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
  
  public void handleInput(Input input){
    switch(input){
      case PRESSED:
        button.updateState(Input.x,Input.y);
        scrollVelocity = 0;
        break;
      case MOVED:
        button.updateState(Input.x,Input.y);
        if(!button.isPressed){
          scrollPosition += Input.deltaY;
        }
        break;
      case RELEASED:
        if(button.isPressed){
          button.updateState(Input.x,Input.y);
          if(button.isPressed){
            button.isPressed = false;
            exit();
          }
        }
        else{
          scrollVelocity = mouseY-pmouseY; //Input.deltaY;
          scrollVelocity = Math.signum(scrollVelocity)*min(abs(scrollVelocity), UNIT/2);
          // println("scoreboard released");
          // XXX deltaY  (mouseY - pmouseY működik)
        }
        break;
      default:
        errorMessage("Scoreboard -> handleInput");
        break;
    }
  }
  
  public void update(){
    if(abs(scrollVelocity) > UNIT/100){
      scrollPosition += scrollVelocity;
      scrollVelocity *= DRAG;
    }
    else scrollVelocity = 0;
    
    if(scrollPosition < min(height*0.9 - UNIT*7/6 - totalHeight, 0)){
      scrollPosition = lerp(scrollPosition, min(height*0.9 - UNIT*7/6 - totalHeight, 0), 0.1);
      scrollVelocity = 0;
    }
    else if(scrollPosition > 0){
      scrollPosition = lerp(scrollPosition, 0, 0.1);
      scrollVelocity = 0;
    }
  }
  
  public void enter(Score scoreIn){
    appState = this;
    field.state = FieldState.NIGHT;
    
    put(scoreIn);
    
    scrollPosition = 0;
    scrollVelocity = 0;
    totalHeight = (length+1)*UNIT/3;
  }
  
  public void exit(){
    transitioner.capture(this);
    transitioner.transition(0.35);
            
    HOMESCREEN.enter(latestScore);
  }
  
  private void put(Score scoreIn){
    latestScore = scoreIn;
    length++;
    scores[length] = latestScore.value;
    
    if(latestScore.value > highscore){
      highscore = latestScore.value;
      highscoreId = length;
    }
  }
  
  public void display(){
    background(0);
    
    pushMatrix();
    translate(0, height/10+UNIT);
    
    float posY = scrollPosition-UNIT*3/7;
    for(short i = length; i >= 0; i--){
      posY += UNIT/3;
      if(posY < -UNIT || posY > height) continue;
      
      if(i == highscoreId) fill(38, 80, 100);
      else fill(100);
      
      textAlign(LEFT, TOP);
      text("GAME #"+nf(i+1, 2), UNIT, posY);
      
      textAlign(RIGHT, TOP);
      text(int(scores[i]), width-UNIT, posY);
      
      
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
    appState = this;
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
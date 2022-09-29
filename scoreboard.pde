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
    this.scores = new short[10000];
    this.length = -1;
    this.highscoreId = 0;
    this.button = new Button(Environment.WIDTH - Environment.UNIT * 1.25, Environment.UNIT / 2, Environment.UNIT / 3);
    
    //loadSavedData();
  }
  
  private void loadSavedData(){
    Score temp = new Score();
    for(int i = 0; i < 80; i++){
      temp.value = (short)floor(random(random(1000)));
      this.put(temp);
    }
  }
  
  public void handleInput(Input input){
    switch(input){
      case PRESSED:
        this.button.updateState(Input.x, Input.y);
        this.scrollVelocity = 0;
        break;
      case MOVED:
        this.button.updateState(Input.x, Input.y);
        if(!this.button.isPressed()){
          this.scrollPosition += Input.deltaY;
        }
        break;
      case RELEASED:
        if(this.button.isPressed()){
          this.button.updateState(Input.x, Input.y);
          if(this.button.isPressed()){
            this.button.setPressed(false);
            exit();
          }
        }
        else{
          this.scrollVelocity = mouseY - pmouseY; //Input.deltaY;
          this.scrollVelocity = Math.signum(this.scrollVelocity) * min(abs(this.scrollVelocity), Environment.UNIT/2);
          // XXX deltaY  (mouseY - pmouseY működik)
        }
        break;
      default:
        errorMessage("Scoreboard -> handleInput");
        break;
    }
  }
  
  public void update(){
    if(abs(scrollVelocity) > Environment.UNIT / 100){
      this.scrollPosition += this.scrollVelocity;
      this.scrollVelocity *= this.DRAG;
    }
    else this.scrollVelocity = 0;
    
    if(this.scrollPosition < min(Environment.HEIGHT * 0.9 - Environment.UNIT * 7 / 6 - this.totalHeight, 0)){
      this.scrollPosition = lerp(this.scrollPosition, min(Environment.HEIGHT * 0.9 - Environment.UNIT * 7 / 6 - this.totalHeight, 0), 0.1);
      this.scrollVelocity = 0;
    }
    else if(this.scrollPosition > 0){
      this.scrollPosition = lerp(this.scrollPosition, 0, 0.1);
      this.scrollVelocity = 0;
    }
  }
  
  public void enter(Score scoreIn){
    appState = this;
    gameField.state = FieldState.NIGHT;
    
    this.put(scoreIn);
    
    this.scrollPosition = 0;
    this.scrollVelocity = 0;
    this.totalHeight = (this.length + 1) * Environment.UNIT / 3;
  }
  
  public void exit(){
    transitioner.capture(this);
    transitioner.transition(0.35);
            
    HOMESCREEN.enter(latestScore);
  }
  
  private void put(Score scoreIn){
    this.latestScore = scoreIn;
    this.length++;
    this.scores[length] = this.latestScore.value;
    
    if(this.latestScore.value > this.highscore){
      this.highscore = this.latestScore.value;
      this.highscoreId = this.length;
    }
  }
  
  public void display(){
    background(0);
    
    pushMatrix();
    translate(0, height / 10 + Environment.UNIT);
    
    float posY = this.scrollPosition - Environment.UNIT * 3 / 7;
    for(short i = length; i >= 0; i--){
      posY += Environment.UNIT / 3;
      if((posY < -Environment.UNIT) || (posY > Environment.HEIGHT)) continue;
      
      if(i == this.highscoreId) fill(38, 80, 100);
      else fill(100);
      
      textAlign(LEFT, TOP);
      text("GAME #" + nf(i + 1, 2), Environment.UNIT, posY);
      
      textAlign(RIGHT, TOP);
      text(int(this.scores[i]), Environment.WIDTH - Environment.UNIT, posY);
      
      
    }
    popMatrix();
    
    fill(0);
    rect(Environment.WIDTH / 2, Environment.UNIT / 2 + 10, Environment.WIDTH, Environment.UNIT + 20);
    
    pushMatrix();
    translate(0, Environment.UNIT / 2);
    
    pushStyle();
    fill(100);
    textAlign(LEFT, CENTER);
    textSize(Environment.UNIT / 2);
    text("SCOREBOARD", Environment.UNIT, 0);
    
    stroke(100);
    strokeWeight(2);
    line(Environment.UNIT, Environment.UNIT / 2, Environment.WIDTH - Environment.UNIT, Environment.UNIT / 2);
    popStyle();
    
    popMatrix();
    this.button.display();
  }
  
  public void enter(){
    appState = this;
  }
}

class Score{
  public short value, highscore;
  
  Score(){
    this.value = 0;
    this.highscore = 0;
  }
  
  public void update(){
    if(frameCount % 2 == 0) this.value++;
    if(this.value > this.highscore) this.highscore = this.value;
  }
  
  public void display(){
    text("HIGHSCORE  " + this.highscore, Environment.WIDTH * 0.85, Environment.HEIGHT * 0.1);
    text("SCORE  " + this.value, Environment.WIDTH * 0.85, Environment.HEIGHT * 0.17);
  }
  
  public void reset(){
    this.value = 0;
    this.highscore = SCOREBOARD.highscore;
  }
}

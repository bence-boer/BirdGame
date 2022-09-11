class GameState implements AppState{
  Player player;
  Score score;
  
  GameState(){
    initializePlayerStates();
    player = new Player();
    player.load_costumes();
  }
  
  public void handle_input(Input input){
    player.handle_input(input);
  }
  
  private void reset(){
    player.reset();
    field.reset();
    score.reset();
    
    frameCount = 0;
  }
  
  public void enter(Score score){
    this.score = score;
    this.reset();
    app_state = this;
    field.state = FieldState.DAY;
  }
  
  public void exit(){
    transitioner.capture(this);
    transitioner.transition(0.35, 0.5);
    
    SCOREBOARD.enter(score);
  }
  
  public void update(){
    field.update();
    player.update();
    score.update();
  }
  
  public void display(){
    field.display();
    player.display();
    
    fill(20);
    score.display();
  }
  
  public boolean is_on(){
    return app_state == this;
  }
  
  void initializePlayerStates(){
    RUNNING_STATE = new RunningState();
    JUMPING_STATE = new JumpingState();
    FALLING_STATE = new FallingState();
    SLOW_FALL_STATE = new SlowFallState();
    FAST_FALL_STATE = new FastFallState();
    DUCKING_STATE = new DuckingState();
  }
}
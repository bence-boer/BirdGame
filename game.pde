/**
 * The GameState class is the implementation of the AppState interface
 * responsible for updating and rendering the game world
 * and handling inputs during the game.
 * It stores the player and the player's current in-game score.
 * Created based on the 'state' design pattern.
 *
 * @author  Bence Boér
 * @version 1.0
 * @since   2022-09-01 
 */
public class GameState implements AppState{
  Player player;
  Score score;
  
  GameState(){
    initializePlayerStates();
    player = new Player();
    player.loadCostumes();
  }
  
  public void handleInput(Input input){
    player.handleInput(input);
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
    appState = this;
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
  
  public boolean isOn(){
    return appState == this;
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
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
    this.initializePlayerStates();
    this.player = new Player();
    this.player.loadCostumes();
  }
  
  public void handleInput(Input input){
    this.player.handleInput(input);
  }
  
  private void reset(){
    this.player.reset();
    gameField.reset(); // XXX: Should be modularized
    this.score.reset();
    
    frameCount = 0;
  }
  
  public void enter(Score score){
    this.score = score;
    this.reset();
    appState = this;
    gameField.state = FieldState.DAY; // XXX: Should be modularized
  }
  
  public void exit(){
    transitioner.capture(this);
    transitioner.transition(0.35, 0.5);
    
    SCOREBOARD.enter(score);
  }
  
  public void update(){
    gameField.update(); // XXX: Should be modularized
    this.player.update();
    this.score.update();
  }
  
  public void display(){
    gameField.display(); // XXX: Should be modularized
    this.player.display();
    
    fill(20);
    this.score.display();
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

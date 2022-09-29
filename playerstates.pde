/**
 * The PlayerState interface is used to represent the state of a player.
 * It's built according to the state design pattern.
 * Classes implementing this interface are responsible for the behavior of the player,
 * depending on the state of the player.
 *
 * @author  Bence Boér
 * @version 1.0
 * @since   2022-09-01 
 */
interface PlayerState{
  void handleInput(Player character, Input input); 
  void enter(Player character);
  void update(Player character);
}

class RunningState implements PlayerState{
  void enter(Player character){
    character.width = Environment.UNIT*2/3;
    character.height = Environment.UNIT;
      
    character.yVelocity = 0;
    character.reposition();
      
    character.costumes = character.runningSprite;
  }
  
  void handleInput(Player character, Input input){
    switch(input){
      case UP_PRESSED:
        character.state = JUMPING_STATE;
        character.state.enter(character);
        break;
      case DOWN_PRESSED:
        character.state = DUCKING_STATE;
        character.state.enter(character);
        break;
      default:
        // do nothing
        break;
    }
  }
  
  void update(Player character){
    // no action needed
  }
}
  
class JumpingState implements PlayerState{
  private final float gravity;
  private final float jumpingVelocity;
  
  JumpingState(){
    this.gravity = Environment.HEIGHT/200; // XXX: should be specified in Environment.UNITs
    this.jumpingVelocity = -Environment.WIDTH/30; // XXX: should be specified in Environment.UNITs
  }
    
  void enter(Player character){
    character.yVelocity = this.jumpingVelocity;
    character.width = Environment.UNIT*2/3;
    character.height = Environment.UNIT;
    
    character.costumes = character.runningSprite;
  }
  
  void handleInput(Player character, Input input){
    switch(input){
      case UP_PRESSED:
        character.state = SLOW_FALL_STATE;
        character.state.enter(character);
        break;
      case DOWN_PRESSED:
        character.state = FAST_FALL_STATE;
        character.state.enter(character);
        break;
      default:
        // do nothing
        break;
    }
  }   
  void update(Player character){
    character.yVelocity += this.gravity;
    if(character.yVelocity >= 0){
      switch(currentInput){
        case UP_PRESSED:
          character.state = SLOW_FALL_STATE;
          break;
        case DOWN_PRESSED:
          character.state = FAST_FALL_STATE;
          break;
        default:
          character.state = FALLING_STATE;
          break;
      }
      character.state.enter(character);
    }
  }
}

class FallingState implements PlayerState{
  private final float gravity;
  
  FallingState(){
    this.gravity = Environment.HEIGHT/200; // XXX: should be specified in Environment.UNITs
  }
    
  void enter(Player character){
    character.width = Environment.UNIT*2/3;
    character.height = Environment.UNIT;
    
    character.costumes = character.runningSprite;
  }
  
  void handleInput(Player character, Input input){
    switch(input){
      case UP_PRESSED:
        character.state = SLOW_FALL_STATE;
        break;
      case DOWN_PRESSED:
        character.state = FAST_FALL_STATE;
        break;
      default:
        // do nothing
        break;
    }
    character.state.enter(character);
  }
  
  void update(Player character){
    character.yVelocity += this.gravity;
    
    if(character.hasLanded()){
      character.state = RUNNING_STATE;
      character.state.enter(character);
    }
  }
}
  
class SlowFallState implements PlayerState{
  private final float fallingSpeed;

  SlowFallState(){
    this.fallingSpeed = Environment.HEIGHT/80; // XXX: should be specified in Environment.UNITs
  }
  
  void enter(Player character){
    character.width = Environment.UNIT;
    character.height = Environment.UNIT/2;
    
    character.costumes = character.duckingSprite;
  }
  
  void handleInput(Player character, Input input){
    switch(input){
      case UP_RELEASED:
        character.state = FALLING_STATE;
        break;
      case DOWN_PRESSED:
        character.state = FAST_FALL_STATE;
        break;
      default:
        // do nothing
        break;
    }
    character.state.enter(character);
  }
    
  void update(Player character){
    character.yVelocity = this.fallingSpeed;
      
    if(character.hasLanded()){
      character.state = RUNNING_STATE;
      character.state.enter(character);
    }
  }
}

class FastFallState implements PlayerState{
  private final float gravity;
  
  FastFallState(){
    this.gravity = Environment.HEIGHT/100; // XXX: should be specified in Environment.UNITs
  }
  
  void enter(Player character){
    character.width = Environment.UNIT;
    character.height = Environment.UNIT/2;
    
    character.costumes = character.duckingSprite;
  }
  
  void handleInput(Player character, Input input){
    switch(input){
      case UP_PRESSED:
        character.state = SLOW_FALL_STATE;
        break;
      case DOWN_RELEASED:
        character.state = FALLING_STATE;
        break;
      default:
        // do nothing
        break;
    }
    character.state.enter(character);
  }   
  void update(Player character){
    character.yVelocity += this.gravity;
      
     if(character.hasLanded()){
      character.state = DUCKING_STATE;
      character.state.enter(character);
    }
  }
}
    
class DuckingState implements PlayerState{
  void enter(Player character){
    character.width = Environment.UNIT;
    character.height = Environment.UNIT/2;
    character.yVelocity = 0;
    
    character.reposition();
    
    character.costumes = character.duckingSprite;
  }
    
  void handleInput(Player character, Input input){
    switch(input){
      case UP_PRESSED:
        character.state = JUMPING_STATE;
        break;
      case DOWN_RELEASED:
        character.state = RUNNING_STATE;
        break;
      default:
        // do nothing
        break;
    }
    character.state.enter(character);
  }
  
  void update(Player character){
    // no action needed
  }
}
public static PlayerState RUNNING_STATE;
public static PlayerState JUMPING_STATE;
public static PlayerState FALLING_STATE;
public static PlayerState SLOW_FALL_STATE;
public static PlayerState FAST_FALL_STATE;
public static PlayerState DUCKING_STATE;

class Player extends Entity{
  private PlayerState state;
 
  private PImage[] runningSprite;
  private PImage[] duckingSprite;
  private PImage[] costumes;
  private int step;
  
  Player(){
    this.w = UNIT*2/3;
    this.h = UNIT;
    
    this.x = width/5;
    this.y = width/10;
    
    this.vx = width/80;
    this.vy = 0;
    
    this.state = FALLING_STATE;
    this.state.enter(this);
    
    this.step = 1;
  }
  
  void update(){
    state.update(this);
    move();
    cycleCostume();
    checkForCollision();
  }
  
  void checkForCollision(){
    for(Obstacle o: field.obstacles){
      if(o.collidesWith(this)){
        die();
      }
    }
  }
  
  void move(){
    y += vy;
  }
  
  void cycleCostume(){
    if(frameCount % 5 == 0) step = 1-step;
  }
  
  void handleInput(Input input){
    state.handleInput(this, input);
  } 
  
  void die(){
    GAME.exit();
  }
  
  boolean hasLanded(){
    return this.y + this.h/2 > height-field.GROUND_HEIGHT;
  }
  
  void reposition(){
    this.y = height-field.GROUND_HEIGHT-this.h/2;
  }

  void display(){
    shadow();
    image(costumes[step], x, y, w, h);
  }
  
  void loadCostumes(){
    runningSprite = new PImage[2];
    duckingSprite = new PImage[2];
    
    runningSprite[0] = loadImage("birdRunning_1.png");
    runningSprite[1] = loadImage("birdRunning_2.png");
    duckingSprite[0] = loadImage("birdDodging_1.png");
    duckingSprite[1] = loadImage("birdDodging_2.png");
    
    costumes = runningSprite;
  }
  
  void reset(){
    this.x = width/5;
    this.y = width/10;
    this.vx = width/80;
    this.vy = 0;
    this.w = UNIT*2/3;
    this.h = UNIT;
    
    this.state = FALLING_STATE;
    this.state.enter(this);
  }
}

interface PlayerState{
  void handleInput(Player character, Input input); 
  void enter(Player character);
  void update(Player character);
}

class RunningState implements PlayerState{
  
  void enter(Player character){
    character.w = UNIT*2/3;
    character.h = UNIT;
      
    character.vy = 0;
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
    gravity = height/200;
    jumpingVelocity = -width/30;
  }
    
  void enter(Player character){
    character.vy = jumpingVelocity;
    character.w = UNIT*2/3;
    character.h = UNIT;
    
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
    character.vy += gravity;
    if(character.vy >= 0){
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
    gravity = height/200;
  }
    
  void enter(Player character){
    character.w = UNIT*2/3;
    character.h = UNIT;
    
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
    character.vy += gravity;
    
    if(character.hasLanded()){
      character.state = RUNNING_STATE;
      character.state.enter(character);
    }
  }
}
  
class SlowFallState implements PlayerState{
  private final float fallingSpeed;

  SlowFallState(){
    fallingSpeed = height/80;
  }
  
  void enter(Player character){
    character.w = UNIT;
    character.h = UNIT/2;
    
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
    character.vy = fallingSpeed;
      
    if(character.hasLanded()){
      character.state = RUNNING_STATE;
      character.state.enter(character);
    }
  }
}

class FastFallState implements PlayerState{
  private final float gravity;
  
  FastFallState(){
    gravity = height/100;
  }
  
  void enter(Player character){
    character.w = UNIT;
    character.h = UNIT/2;
    
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
    character.vy += gravity;
      
     if(character.hasLanded()){
      character.state = DUCKING_STATE;
      character.state.enter(character);
    }
  }
}
    
class DuckingState implements PlayerState{
  void enter(Player character){
    character.w = UNIT;
    character.h = UNIT/2;
    character.vy = 0;
    
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

abstract class Entity{
  public float w, h;
  public float x, y;
  public float vx, vy;
  
  void shadow(){
    float mult = map(y, height/4, height-field.GROUND_HEIGHT, 0.8, 1.2);
    fill(#C59F34);
    ellipse(x, height-field.GROUND_HEIGHT, w*mult, w/8*mult);
  }
}


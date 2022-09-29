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
    this.width = Environment.UNIT * 2 / 3;
    this.height = Environment.UNIT;
    
    this.xCoordinate = Environment.WIDTH / 5;
    this.yCoordinate = Environment.WIDTH / 10;
    
    this.xVelocity = Environment.WIDTH / 80;
    this.yVelocity = 0;
    
    this.state = FALLING_STATE;
    this.state.enter(this);
    
    this.step = 1;
  }
  
  private void update(){
    this.state.update(this);
    this.move();
    this.cycleCostume();
    this.checkForCollision();
  }
  
  void checkForCollision(){
    for(Obstacle obstacle: gameField.obstacles){
      if(obstacle.collidesWith(this)){
        this.die();
      }
    }
  }
  
  private void move(){
    this.yCoordinate += this.yVelocity;
  }
  
  private void cycleCostume(){
    if(frameCount % 5 == 0) this.step = 1 - this.step;
  }
  
  private void handleInput(Input input){
    state.handleInput(this, input);
  } 
  
  private void die(){
    GAME.exit();
  }
  
  private boolean hasLanded(){
    return this.yCoordinate + this.height/2 > Environment.HEIGHT - gameField.GROUND_HEIGHT;
  }
  
  private void reposition(){
    this.yCoordinate = Environment.HEIGHT - gameField.GROUND_HEIGHT - this.height / 2;
  }

  private void display(){
    this.shadow();
    image(this.costumes[this.step],
          this.xCoordinate,
          this.yCoordinate,
          this.width,
          this.height);
  }
  
  private void loadCostumes(){
    this.runningSprite = new PImage[2];
    this.duckingSprite = new PImage[2];
    
    this.runningSprite[0] = loadImage("bird_running_1.png");
    this.runningSprite[1] = loadImage("bird_running_2.png");
    this.duckingSprite[0] = loadImage("bird_dodging_1.png");
    this.duckingSprite[1] = loadImage("bird_dodging_2.png");
    
    this.costumes = runningSprite;
  }
  
  private void reset(){
    this.xCoordinate = Environment.WIDTH / 5;
    this.yCoordinate = Environment.WIDTH / 10;
    this.xVelocity = Environment.WIDTH / 80;
    this.yVelocity = 0;
    this.width = Environment.UNIT*2/3;
    this.height = Environment.UNIT;
    
    this.state = FALLING_STATE;
    this.state.enter(this);
  }
}

abstract class Entity{
  protected float width, height;
  protected float xCoordinate, yCoordinate;
  protected float xVelocity, yVelocity;
  
  protected void shadow(){
    float multiplier = map(this.yCoordinate, Environment.HEIGHT / 4, Environment.HEIGHT - gameField.GROUND_HEIGHT, 0.8, 1.2);
    fill(#C59F34);
    ellipse(this.xCoordinate, Environment.HEIGHT - gameField.GROUND_HEIGHT, this.width * multiplier, this.width / 8 * multiplier);
  }
}

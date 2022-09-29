/**
 * The Obstacle class is responsible for creating the obstacles that the player must avoid.
 * 
 *
 * @author  Bence Boér
 * @version 1.0
 * @since   2022-09-01 
 */
abstract class Obstacle extends Entity{
  PImage skinDay, skinNight;
  
  protected Obstacle(float widthIn, float heightIn, float xCoordinateIn, float yCoordinateIn, float xVelocityIn, float yVelocityIn, PImage skinDayIn, PImage skinNightIn){
    this.width = widthIn;
    this.height = heightIn;
    this.xCoordinate = xCoordinateIn;
    this.yCoordinate = yCoordinateIn;
    this.xVelocity = xVelocityIn;
    this.yVelocity = yVelocityIn;
    this.skinDay = skinDayIn;
    this.skinNight = skinNightIn;
  }
  Obstacle(float widthIn, float heightIn, PImage skinDayIn, PImage skinNightIn){
    this(widthIn,heightIn);
    this.skinDay = skinDayIn;
    this.skinNight = skinNightIn;
  }
  Obstacle(float widthIn, float heightIn){
    this.width = widthIn;
    this.height = heightIn;
    this.xCoordinate = width+widthIn/2;
    this.yCoordinate = height-field.GROUND_HEIGHT-heightIn/2;
  }
  
  public void move(float velocityIn){
    this.xCoordinate -= velocityIn;
  }
  
  void display(FieldState state){
    if(this.skinDay != null){
      switch(state){
        case DAY:
          image(this.skinDay, this.xCoordinate, this.yCoordinate, this.width, this.height);
          break;
        case NIGHT:
          image(this.skinNight, this.xCoordinate, this.yCoordinate, this.width, this.height);
          break;
      }
    }
    else{
      fill(#EBEEFF);
      rect(this.xCoordinate, this.yCoordinate, this.width, this.height);
    }
  }
  
  boolean collidesWith(Player player){
    return (((player.xCoordinate + player.width / 2) >= (this.xCoordinate - this.width / 2)) && (player.xCoordinate + player.width / 2) <= (this.xCoordinate + this.width / 2) ||
            ((player.xCoordinate - player.width / 2) >= (this.xCoordinate - this.width / 2)) && (player.xCoordinate - player.width / 2) <= (this.xCoordinate + this.width / 2)) &&
           (((player.yCoordinate - player.height / 2) <= (this.yCoordinate - this.height / 2)) && (player.yCoordinate + player.height / 2) >= (this.yCoordinate - this.height / 2) ||
            ((player.yCoordinate - player.height / 2) <= (this.yCoordinate + this.height / 2)) && (player.yCoordinate + player.height / 2) >= (this.yCoordinate + this.height / 2));
  }
  
  void shadow(FieldState state){
    float multiplier = map(this.yCoordinate, Environment.HEIGHT/4, Environment.HEIGHT-field.GROUND_HEIGHT, 0.8, 1.2); // XXX: Should be specified in Environment.UNITs
    switch (state){
      case DAY:
        fill(#C59F34);
        break;
      case NIGHT:
        fill(10);
        break;
      default:
        fill(10,10,10,20);
        break;
    }
    ellipse(this.xCoordinate, Environment.HEIGHT-field.GROUND_HEIGHT, this.width*multiplier, this.width/5*multiplier);
  }
  
  abstract Obstacle clone();
}

class Cactus extends Obstacle{
  Cactus(PImage skinDayIn, PImage skinNightIn){
    super(Environment.UNIT*0.75, Environment.UNIT*1.5, skinDayIn, skinNightIn);
  }
  private Cactus(float widthIn, float heightIn, float xCoordinateIn, float yCoordinateIn, float xVelocityIn, float yVelocityIn, PImage skinDayIn, PImage skinNightIn){
    super(widthIn, heightIn, xCoordinateIn, yCoordinateIn, xVelocityIn, yVelocityIn, skinDayIn, skinNightIn);
  }
  
  boolean collidesWith(Player player){
    float newCactusTop = this.yCoordinate - this.height / 2 + this.width / 2;
    float newPlayerBottom = player.yCoordinate + player.height / 2 - player.width / 2;
    return  sqrt(sq(player.xCoordinate - this.xCoordinate) + sq(newPlayerBottom - newCactusTop)) < this.width / 2 + player.width / 2 || 
           (player.xCoordinate + player.width / 2 >= this.xCoordinate - this.width / 2 && player.xCoordinate + player.width / 2 <= this.xCoordinate + this.width / 2 ||
            player.xCoordinate - player.width / 2 >= this.xCoordinate - this.width / 2 && player.xCoordinate - player.width / 2 <= this.xCoordinate + this.width / 2) &&
           (newPlayerBottom >= newCactusTop);
  }
  
  Cactus clone(){
    return new Cactus(this.width,
                      this.height,
                      this.xCoordinate,
                      this.yCoordinate,
                      this.xVelocity,
                      this.yVelocity,
                      this.skinDay,
                      this.skinNight);
  }
}

class Tumbleweed extends Obstacle{
  private float baseYCoordinate;
  private int rotationPhase;
   
  Tumbleweed(PImage skinDayIn, PImage skinNightIn){
    super(Environment.UNIT/2, Environment.UNIT/2, skinDayIn, skinNightIn);
    this.baseYCoordinate = this.yCoordinate;
    this.xVelocity = Environment.UNIT/20;
    this.rotationPhase = 0;
  }
  private Tumbleweed(float widthIn, float heightIn, float xCoordinateIn, float yCoordinateIn, float xVelocityIn, float yVelocityIn, PImage skinDayIn, PImage skinNightIn){
    super(widthIn, heightIn, xCoordinateIn, yCoordinateIn, xVelocityIn, yVelocityIn, skinDayIn, skinNightIn);
    this.baseYCoordinate = yCoordinateIn;
  }
  
  void move(float xVelocityIn){
    this.xCoordinate -= xVelocityIn + this.xVelocity;

    this.yVelocity = abs(sin(radians(frameCount * 5 + 180)) * this.height / 2);
    this.yCoordinate = this.baseYCoordinate - this.yVelocity;
    
    this.rotationPhase = -floor(frameCount / 6) % 16;
  }
  
  void display(FieldState state){
    pushMatrix();
    translate(this.xCoordinate, this.yCoordinate);
    rotate(this.rotationPhase * HALF_PI / 4);
    switch(state){
      case DAY:
        image(this.skinDay, 0, 0, this.width, this.height);
        break;
      case NIGHT:
        image(this.skinNight, 0, 0, this.width, this.height);
        break;
    }
    popMatrix();
  }
  
  boolean collidesWith(Player player){
    return sqrt(sq(this.xCoordinate - player.xCoordinate) + sq(this.yCoordinate - player.yCoordinate - player.height / 2 + player.width / 2)) < player.width / 2 + this.height / 2;
  }
  
  Tumbleweed clone(){
    return new Tumbleweed(this.width,
                          this.height,
                          this.xCoordinate,
                          this.yCoordinate,
                          this.xVelocity,
                          this.yVelocity,
                          this.skinDay,
                          this.skinNight);
  }
}

class Cloud extends Obstacle{
  Cloud(PImage skinDayIn, PImage skinNightIn){
    super(Environment.UNIT * 1.5, Environment.UNIT * 0.75, this.skinDayIn, this.skinNightIn);
    this.yCoordinate -= Environment.UNIT * 0.75;
    this.xVelocity = Environment.UNIT / 40;
  }
  private Cloud(float widthIn, float heightIn, float xCoordinateIn, float yCoordinateIn, float xVelocityIn, float yVelocityIn, PImage skinDayIn, PImage skinNightIn){
    super(widthIn, heightIn, xCoordinateIn, yCoordinateIn, xVelocityIn, yVelocityIn, skinDayIn, skinNightIn);
  }
  
  void move(float xVelocityIn){
    this.xCoordinate -= xVelocityIn + this.xVelocityIn;
  }
  
  boolean collidesWith(Player player){
    return player.yCoordinate - player.height / 2 <= this.yCoordinate + this.height / 2 &&
           (sqrt(sq(this.xCoordinate - player.xCoordinate) + sq(this.yCoordinate + this.height / 2 - player.yCoordinate + player.height / 2 - player.width / 2)) < player.width / 2 + this.height / 2 ||
            sqrt(sq(this.xCoordinate - player.xCoordinate) + sq(this.yCoordinate + this.height / 2 - player.yCoordinate - player.height / 2 + player.width / 2)) < player.width / 2 + this.height / 2);
  }
  
  Cloud clone(){
    return new Cloud(this.width,
                     this.height,
                     this.xCoordinate,
                     this.yCoordinate,
                     this.xVelocity,
                     this.yVelocity,
                     this.skinDay,
                     this.skinNight);
  }
}
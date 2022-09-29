/**
 * The Button class is responsible for defining the structure of a generic unstyled button.
 * A button's press state can be retrieved by calling the isPressed() method.
 *
 * @author  Bence Boér
 * @version 1.0
 * @since   2022-09-01 
 */
public class Button{
  protected final float RADIUS_WHEN_PRESSED, RADIUS_ORIGINAL;

  protected float radius;
  protected float xCoordinate, yCoordinate;
  
  private boolean isPressed;
  
  Button(float xCoordinateIn, float yCoordinateIn, float radiusIn){
    this.xCoordinate = xCoordIn;
    this.yCoordinate = yCoordIn;
    this.radius = radiusIn;
    this.radiusOriginal = radiusIn;
    this.radiusWhenPressed = radiusIn*0.8;
  }
  Button(float xCoordinateIn, float yCoordinateIn){
    this(xCoordinateIn, yCoordinateIn, Environment.UNIT);
  }
  
  public boolean isPressed(){
    return this.isPressed;
  }

  public void updateState(float xCoordinateIn, float yCoordinateIn){
    this.isPressed = sqrt(sq(this.xCoordinate - xCoordinateIn) + sq(this.yCoordinate - yCoordinateIn)) <= this.radius;
  }
  
  public void display(){
    if(this.isPressed) this.radius = lerp(this.radius, this.RADIUS_WHEN_PRESSED, 0.2);
    else this.radius = lerp(this.radius, RADIUS_ORIGINAL, 0.2);
    
    pushMatrix();
    translate(this.xCoordinate, this.yCoordinate);
    stroke(100);
    strokeWeight(10);
    line(-this.radius/4, -this.radius/2, this.radius/4, 0);
    line(-this.radius/4, this.radius/2, this.radius/4, 0);
    noStroke();
    popMatrix();
  }
}

/**
 * The StartButton class is a subclass of the Button class.
 * It's responsible for defining the structure of a start button.
 *
 * @author  Bence Boér
 * @version 1.0
 * @since   2022-09-01 
 */
class StartButton extends Button{
  private PImage skin;
  
  StartButton(){
    super(Environment.WIDTH/2, Environment.HEIGHT/2, Environment.UNIT*1.5);
  }
  
  public void loadCostume(){
    this.skin = loadImage("play_button.png");
  }
  
  @Override
  public void display(){
    if(this.isPressed()) this.radius = lerp(this.radius, this.RADIUS_WHEN_PRESSED, 0.4);
    else this.radius = lerp(this.radius, this.RADIUS_ORIGINAL, 0.4);
    
    image(this.skin, this.xCoordinate, this.yCoordinate, this.radius, this.radius);
  }
}
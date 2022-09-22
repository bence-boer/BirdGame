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
  protected float xCoord, yCoord;
  
  private boolean isPressed;
  
  Button(float xCoordIn, float yCoordIn, float radiusIn){
    this.xCoord = xCoordIn;
    this.yCoord = yCoordIn;
    this.radius = radiusIn;
    this.radiusOriginal = radiusIn;
    this.radiusWhenPressed = radiusIn*0.8;
  }
  Button(float x, float y){
    this(xCoord, yCoord, UNIT);
  }
  
  public boolean isPressed(){
    return isPressed;
  }

  public void updateState(float xCoordIn, float yCoordIn){
    this.isPressed = sqrt(sq(this.xCoord - xCoordIn) + sq(this.yCoord - yCoordIn)) <= radius;
  }
  
  public void display(){
    if(isPressed) this.radius = lerp(this.radius, radiusWhenPressed, 0.2);
    else this.radius = lerp(this.radius, radiusOriginal, 0.2);
    
    pushMatrix();
    translate(this.xCoord, this.yCoord);
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
    super(width/2, height/2, UNIT*1.5);
  }
  
  public void loadCostume(){
    this.skin = loadImage("play_button.png");
  }
  
  @Override
  public void display(){
    if(this.isPressed()) this.radius = lerp(this.radius, this.radiusWhenPressed, 0.4);
    else this.radius = lerp(this.radius, this.radiusOriginal, 0.4);
    
    image(this.skin, this.xCoord, this.yCoord, this.radius, this.radius);
  }
}
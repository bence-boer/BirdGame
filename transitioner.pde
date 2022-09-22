class AppStateTransitioner{
  private PImage capturedFrame;
  private float transitionLength;
  private int startpoint, endpoint;
  public boolean active;
  
  AppStateTransitioner(){
    capturedFrame = createImage(width, height, RGB);
    active = false;
  }
  
  public void capture(AppState stateToCapture){
    stateToCapture.display();
    
    capturedFrame.loadPixels();
    loadPixels();
    
    capturedFrame.pixels = pixels;
    capturedFrame.updatePixels();
  }
  
  public void update(){
    if(millis() > endpoint) active = false;
  }
  
  public void display(){
    pushStyle();
    imageMode(CORNER);
    tint(100, (endpoint-millis())/transitionLength*0.1);
    image(capturedFrame, 0, 0, width, height);
    popStyle();
  }
  
  public void transition(float transitionLength){
    transition(transitionLength, 0);
  }
  public void transition(float transitionLength, float delay){
    this.transitionLength = transitionLength;
    startpoint = millis() + (int)(delay*1000);
    endpoint = startpoint + (int)(transitionLength*1000);
    active = true;
  }
}
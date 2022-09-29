class AppStateTransitioner{
  private PImage capturedFrame;
  private float transitionLength;
  private int startpoint, endpoint;
  public boolean active;
  
  AppStateTransitioner(){
    this.capturedFrame = createImage((int)Environment.WIDTH, (int)Environment.HEIGHT, RGB);
    this.active = false;
  }
  
  public void capture(AppState stateToCapture){
    stateToCapture.display();
    
    this.capturedFrame.loadPixels();
    loadPixels();
    
    this.capturedFrame.pixels = pixels;
    this.capturedFrame.updatePixels();
  }
  
  public void update(){
    if(millis() > this.endpoint) this.active = false;
  }
  
  public void display(){
    pushStyle();
    imageMode(CORNER);
    tint(100, (this.endpoint - millis()) / this.transitionLength * 0.1);
    image(this.capturedFrame, 0, 0, Environment.WIDTH, Environment.HEIGHT);
    popStyle();
  }
  
  public void transition(float transitionLengthIn){
    this.transition(transitionLengthIn, 0);
  }
  public void transition(float transitionLengthIn, float delay){
    this.transitionLength = transitionLengthIn;
    this.startpoint = millis() + (int)(delay*1000);
    this.endpoint = this.startpoint + (int)(this.transitionLength*1000);
    this.active = true;
  }
}

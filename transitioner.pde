class AppStateTransitioner{
  private PImage captured_frame;
  private float transition_length;
  private int startpoint, endpoint;
  public boolean active;
  
  AppStateTransitioner(){
    captured_frame = createImage(width, height, RGB);
    active = false;
  }
  
  public void capture(AppState state_to_capture){
    state_to_capture.display();
    
    captured_frame.loadPixels();
    loadPixels();
    
    captured_frame.pixels = pixels;
    captured_frame.updatePixels();
  }
  
  public void update(){
    if(millis() > endpoint) active = false;
  }
  
  public void display(){
    pushStyle();
    imageMode(CORNER);
    tint(100, (endpoint-millis())/transition_length*0.1);
    image(captured_frame, 0, 0, width, height);
    popStyle();
  }
  
  public void transition(float transition_length){
    transition(transition_length, 0);
  }
  public void transition(float transition_length, float delay){
    this.transition_length = transition_length;
    startpoint = millis() + (int)(delay*1000);
    endpoint = startpoint + (int)(transition_length*1000);
    active = true;
  }
}
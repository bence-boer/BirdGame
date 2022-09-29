void touchStarted(){
  Input.updateValues(touches[touches.length-1].x, touches[touches.length-1].y, currentInput);
  
  if(GAME.isOn()) currentInput = Input.x < width/2 ? Input.DOWN_PRESSED : Input.UP_PRESSED;
  else currentInput = Input.PRESSED;
  appState.handleInput(currentInput);
}

void touchMoved(){
  if(!GAME.isOn()){
    currentInput = Input.MOVED;
    Input.updateValues(touches[touches.length-1].x, touches[touches.length-1].y, currentInput);
    appState.handleInput(currentInput);
  }
}

void touchEnded(){
  if(touches.length == 0){
    /* FIXME - updateValues input típus átállítás előtt
       következmény: 0-ra default-ol */
    if(GAME.isOn()) currentInput = currentInput == Input.UP_PRESSED ? Input.UP_RELEASED : Input.DOWN_RELEASED;
    else currentInput = Input.RELEASED;
    Input.updateValues(mouseX, mouseY, currentInput);
    
    appState.handleInput(currentInput);
    currentInput = Input.NULL;
  }
  else {
    Input.updateValues(touches[touches.length-1].x, touches[touches.length-1].y, currentInput);
    
    if(GAME.isOn()) currentInput = Input.x < width/2 ? Input.DOWN_RELEASED : Input.UP_RELEASED;
    else currentInput = Input.RELEASED;
    
    appState.handleInput(currentInput);
  }
}

static enum Input{
  UP_PRESSED,
  UP_RELEASED,
  DOWN_PRESSED,
  DOWN_RELEASED,
  NULL,
  PRESSED,
  MOVED,
  RELEASED;
  
  public static float x, y;
  public static float deltaX, deltaY;
  public static void updateValues(float xIn, float yIn, Input input){
    switch(input){
      case MOVED:
        deltaX = xIn - x;
        deltaY = yIn - y;
        break;
      case RELEASED:
        deltaX = xIn - x;
        deltaY = yIn - y;
        break;
      default:
        deltaX = 0;
        deltaY = 0;
    }
    
    x = xIn;
    y = yIn;
  }
}
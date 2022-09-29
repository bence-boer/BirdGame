/*
@Override
void touchStarted(){
  Input.updateValues(touches[touches.length-1].x, touches[touches.length-1].y, currentInput);
  
  if(GAME.isOn()) currentInput = Input.x < width/2 ? Input.DOWN_PRESSED : Input.UP_PRESSED;
  else currentInput = Input.PRESSED;
  appState.handleInput(currentInput);
}
*/
@Override
void mousePressed(){
  float xTouchPoint = mouseX, yTouchPoint = mouseY;
  Input.updateValues(xTouchPoint, yTouchPoint, currentInput);
}

/*
@Override
void touchMoved(){
  if(!GAME.isOn()){
    currentInput = Input.MOVED;
    Input.updateValues(touches[touches.length-1].x, touches[touches.length-1].y, currentInput);
    appState.handleInput(currentInput);
  }
}
*/
@Override
void mouseMoved(){
  if(!GAME.isOn()){
    float xTouchPoint = mouseX, yTouchPoint = mouseY;
    currentInput = Input.MOVED;
    Input.updateValues(xTouchPoint, yTouchPoint, currentInput);
    appState.handleInput(currentInput);
  }
}

/*
@Override
void touchEnded(){
  if(touches.length == 0){
    // FIXME - updateValues input típus átállítás előtt következmény: 0-ra default-ol
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
*/
@Override
void mouseReleased(){
  /* FIXME - updateValues input típus átállítás előtt
     következmény: 0-ra default-ol */
  if(GAME.isOn()) currentInput = currentInput == Input.UP_PRESSED ? Input.UP_RELEASED : Input.DOWN_RELEASED;
  else currentInput = Input.RELEASED;
  Input.updateValues(mouseX, mouseY, currentInput);
    
  appState.handleInput(currentInput);
  currentInput = Input.NULL;
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

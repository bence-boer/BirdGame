/*
@Override
void touchStarted(){
  Input.updateDeltaValues(touches[touches.length-1].x, touches[touches.length-1].y, currentInput);
  
  if(GAME.isOn()) currentInput = Input.x < width/2 ? Input.DOWN_PRESSED : Input.UP_PRESSED;
  else currentInput = Input.PRESSED;
  appState.handleInput(currentInput);
}
*/
@Override
void mousePressed(){
  Input.updateDeltaValues(mouseX, mouseY, currentInput);
  
  if(GAME.isOn()) currentInput = Input.x < width/2 ? Input.DOWN_PRESSED : Input.UP_PRESSED;
  else currentInput = Input.PRESSED;
  appState.handleInput(currentInput);
}
@Override
void keyPressed(){
  Input.updateDeltaValues(mouseX, mouseY, currentInput);
  if(GAME.isOn() && key == CODED){
    switch(keyCode){
      case UP:
        currentInput = Input.UP_PRESSED;
        break;
      case DOWN:
        currentInput = Input.DOWN_PRESSED;
        break;
    }
  }
  else currentInput = Input.PRESSED;
  appState.handleInput(currentInput);
}

/*
@Override
void touchMoved(){
  if(!GAME.isOn()){
    currentInput = Input.MOVED;
    Input.updateDeltaValues(touches[touches.length-1].x, touches[touches.length-1].y, currentInput);
    appState.handleInput(currentInput);
  }
}
*/
@Override
void mouseDragged(){
  if(!GAME.isOn()){
    currentInput = Input.MOVED;
    Input.updateDeltaValues(mouseX, mouseY, currentInput);
    appState.handleInput(currentInput);
  }
}

/*
@Override
void touchEnded(){
  if(touches.length == 0){
    // FIXME - updateDeltaValues input típus átállítás előtt következmény: 0-ra default-ol
    if(GAME.isOn()) currentInput = currentInput == Input.UP_PRESSED ? Input.UP_RELEASED : Input.DOWN_RELEASED;
    else currentInput = Input.RELEASED;
    Input.updateDeltaValues(mouseX, mouseY, currentInput);
    
    appState.handleInput(currentInput);
    currentInput = Input.NULL;
  }
  else {
    Input.updateDeltaValues(touches[touches.length-1].x, touches[touches.length-1].y, currentInput);
    
    if(GAME.isOn()) currentInput = Input.x < width/2 ? Input.DOWN_RELEASED : Input.UP_RELEASED;
    else currentInput = Input.RELEASED;
    
    appState.handleInput(currentInput);
  }
}
*/
@Override
void mouseReleased(){
  /* FIXME: updateDeltaValues meghívódik az input típus átállítása előtt
     következmény: deltaX és deltaY 0 értékre default-ol */
  if(GAME.isOn()) currentInput = currentInput == Input.UP_PRESSED ? Input.UP_RELEASED : Input.DOWN_RELEASED;
  else currentInput = Input.RELEASED;
  Input.updateDeltaValues(mouseX, mouseY, currentInput);
    
  appState.handleInput(currentInput);
  currentInput = Input.NULL;
}
@Override
void keyReleased(){
if(GAME.isOn()) currentInput = currentInput == Input.UP_PRESSED ? Input.UP_RELEASED : Input.DOWN_RELEASED;
  else currentInput = Input.RELEASED;
  Input.updateDeltaValues(mouseX, mouseY, currentInput);
    
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
  public static void updateDeltaValues(float xIn, float yIn, Input input){
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

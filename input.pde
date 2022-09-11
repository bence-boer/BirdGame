void touchStarted(){
  Input.updateValues(touches[touches.length-1].x, touches[touches.length-1].y, currentInput);
  
  if(GAME.is_on()) currentInput = Input.x < width/2 ? Input.DOWN_PRESSED : Input.UP_PRESSED;
  else currentInput = Input.PRESSED;
  app_state.handle_input(currentInput);
}

void touchMoved(){
  if(!GAME.is_on()){
    currentInput = Input.MOVED;
    Input.updateValues(touches[touches.length-1].x, touches[touches.length-1].y, currentInput);
    app_state.handle_input(currentInput);
  }
}

void touchEnded(){
  if(touches.length == 0){
    // ITT A HIBA: updateValues input típus átállítás előtt
    // következmény: 0-ra default-ol
    if(GAME.is_on()) currentInput = currentInput == Input.UP_PRESSED ? Input.UP_RELEASED : Input.DOWN_RELEASED;
    else currentInput = Input.RELEASED;
    Input.updateValues(mouseX, mouseY, currentInput);
    
    app_state.handle_input(currentInput);
    currentInput = Input.NULL;
  }
  else {
    Input.updateValues(touches[touches.length-1].x, touches[touches.length-1].y, currentInput);
    
    if(GAME.is_on()) currentInput = Input.x < width/2 ? Input.DOWN_RELEASED : Input.UP_RELEASED;
    else currentInput = Input.RELEASED;
    
    app_state.handle_input(currentInput);
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
  public static float delta_x, delta_y;
  public static void updateValues(float x_in, float y_in, Input input){
    switch(input){
      case MOVED:
        delta_x = x_in - x;
        delta_y = y_in - y;
        //println("moved - x: "+delta_x+"; y: "+delta_y);
        break;
      case RELEASED:
        delta_x = x_in - x;
        delta_y = y_in - y;
        //println("released - x: "+delta_x+"; y: "+delta_y);
        break;
      default:
        delta_x = 0;
        delta_y = 0;
    }
    
    x = x_in;
    y = y_in;
  }
}
public class HomeScreen implements AppState{
  private StartButton button;
  private int countdown;
  private Score score;
  
  HomeScreen(){
    button = new StartButton();
    button.loadCostume();
    
    score = new Score();
    countdown = 3;
  }
  
  public void enter(Score score){
    this.score = score;
    this.reset();
    appState = this;
    field.state = FieldState.NIGHT;
  }
  
  public void exit(){
    transitioner.capture(this);
    transitioner.transition(0.35, 0.2);
    GAME.enter(score);
    countdown = 0;
  }
  
  public void reset(){
    countdown = 3;
  }
  
  public void update(){
    if(countdown == 2) countdown--;
    else if(countdown == 1){
      exit();
    } 
  }
  public void display(){
    field.display();
    button.display();
    
    fill(80);
    score.display();
  }
  
  public void handleInput(Input input){
    switch(input){
      case PRESSED:
        button.updateState(Input.x,Input.y);
        break;
      case MOVED:
        button.updateState(Input.x,Input.y);
        break;
      case RELEASED:
        if(button.isPressed){
          button.updateState(Input.x,Input.y);
          if(button.isPressed){
            countdown = 2;
            button.isPressed = false;
          }
        }
        break;
      default:
        errorMessage("HomeScreen -> handleInput");
        break;
    }
  }
}
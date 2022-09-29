public class HomeScreen implements AppState{
  private StartButton button;
  private int countdown;
  private Score score;
  
  HomeScreen(){
    this.button = new StartButton();
    this.button.loadCostume();
    
    this.score = new Score();
    this.countdown = 3;
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
    this.countdown = 0;
  }
  
  public void reset(){
    this.countdown = 3;
  }
  
  public void update(){
    if(this.countdown == 2) this.countdown--;
    else if(this.countdown == 1){
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
            this.countdown = 2;
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
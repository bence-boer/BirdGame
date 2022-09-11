public GameState GAME;
public HomeScreen HOMESCREEN;
public Scoreboard SCOREBOARD;

public AppState app_state;
public Field field;
public AppStateTransitioner transitioner;

private Input currentInput;

private float UNIT;
private PFont f;


void setup(){
  fullScreen(P2D);
  frameRate(100);
  strokeCap(ROUND);
  rectMode(CENTER);
  imageMode(CENTER);
  textAlign(RIGHT,CENTER);
  colorMode(HSB,100);
  
  /*f = createFont("arcadeclassic.ttf",72);
  textFont(f);*/
  textSize(60);
  noStroke();
  
  UNIT = width/10;
  
  GAME = new GameState();
  HOMESCREEN = new HomeScreen();
  SCOREBOARD = new Scoreboard();
  
  app_state = HOMESCREEN;
  currentInput = Input.NULL;
  
  field = new Field();
  field.load_costumes();
  field.initialize_spawners();
  
  transitioner = new AppStateTransitioner();
}

void draw(){
  if(!transitioner.active){
    app_state.update();
    app_state.display();
  }
  if(transitioner.active){
    app_state.display();
    
    transitioner.update();
    transitioner.display();
  }
}

interface AppState{
  public void handle_input(Input input);
  public void update();
  public void display();
  public void enter(Score score);
  public void exit();
}

void error_message(String origin){
  println("Something's wroooong here:\n"+origin);
}
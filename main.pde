public GameState GAME;
public HomeScreen HOMESCREEN;
public Scoreboard SCOREBOARD;

public AppState appState;
public GameField gameField;
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
  
  font = createFont("arcadeclassic.ttf",72);
  textFont(font);
  textSize(60);
  noStroke();
  
  UNIT = width/10;
  
  GAME = new GameState();
  HOMESCREEN = new HomeScreen();
  SCOREBOARD = new Scoreboard();
  
  appState = HOMESCREEN;
  currentInput = Input.NULL;
  
  gameField = new GameField();
  gameField.loadCostumes();
  gameField.initializeSpawners();
  
  transitioner = new AppStateTransitioner();
}

void draw(){
  if(!transitioner.active){
    appState.update();
    appState.display();
  }
  if(transitioner.active){
    appState.display();
    
    transitioner.update();
    transitioner.display();
  }
}

interface AppState{
  public void handleInput(Input input);
  public void update();
  public void display();
  public void enter(Score score);
  public void exit();
}

void errorMessage(String origin){
  println("Something's wroooong here:\n"+origin);
}
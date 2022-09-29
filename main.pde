public GameState GAME;
public HomeScreen HOMESCREEN;
public Scoreboard SCOREBOARD;

public AppState appState;
public GameField gameField;
public AppStateTransitioner transitioner;

private Input currentInput;

private PFont FONT;


public void setup(){
  Environment.setup(width, height);
  setupDisplaySettings();
  setupFontSettings();
    
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

public void draw(){
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

private void setupDisplaySettings(){
  fullScreen(P2D);
  frameRate(60);
  strokeCap(ROUND);
  rectMode(CENTER);
  imageMode(CENTER);
  textAlign(RIGHT,CENTER);
  colorMode(HSB,100);
}

private void setupFontSettings(){
  FONT = createFont("arcadeclassic.ttf",72);
  textFont(FONT);
  textSize(60);
  noStroke();
}

interface AppState{
  public void handleInput(Input input);
  public void update();
  public void display();
  public void enter(Score score);
  public void exit();
}

static class Environment{
  static float UNIT;
  // static PFont FONT; // TODO: implement font
  static final WIDTH;
  static final HEIGHT;

  static void setup(float windowWidth, float windowHeight){
    WIDTH = windowWidth;
    HEIGHT = windowHeight;
    UNIT = windowWidth/10; // XXX: Should be specified relative to height
    // FONT = createFont("arcadeclassic.ttf",72);
  }
}

void errorMessage(String origin){
  println("Something's wroooong here:\n"+origin);
}
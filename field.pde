/**
 * The GameField class is 
 */
class GameField{
  public FieldState state;
  private ArrayList<ObstacleSpawner> obstacleSpawners;
  
  LinkedList<Obstacle> obstacles;
  final float GROUND_HEIGHT;
  private float offset;
  
  HashMap<String, PImage> skins; // TODO: move skins below to hashmap
  PImage cactusDay, cactusNight,
         tumbleweedDay, tumbleweedNight,
         cloudDay, cloudNight;
  PImage sun, moon;
  
  int t1, t2;
  float v1, v2a, v2b;
  
  GameField(){
    this.obstacles = new LinkedList<Obstacle>();
    this.GROUND_HEIGHT = Environment.HEIGHT / 5;
    this.offset = 0;
    
    this.state = FieldState.NIGHT;
    
    this.t1 = 80;
    this.t2 = 50;
    
    float d1 = Environment.WIDTH;
    this.v1 = d1 / (float)t1;
    
    float d2 = 1.5; 
    this.v2a = d2 / (float)t2;
    this.v2b = v2a * t1 / t2;
  }
  
  void update(){
    switch(state){
      case DAY:
        if(frameCount % 46 == 0 || frameCount % 82 == 0) this.spawnRandomObstacle(); // TODO: store intervals in array
        this.updateObstacles();
        break;
      case NIGHT:
        // don't update
        break;
      default:
        errorMessage("Field -> update() -> switch(state)");
        break;
    }
  }
  
  void updateObstacles(){
    for(int i = this.obstacles.size()-1; i >= 0; i--){
      Obstacle obstacle = this.obstacles.get(i);
      obstacle.move(v1);
      if(obstacle.xCoordinate < -obstacle.width/2) obstacles.remove(i);
    }
  }
  
  void spawnRandomObstacle(){
    int type = 3 - floor(sqrt(random(14) + 1));
    Obstacle spawnedObstacle = obstacleSpawners.get(type).spawn();
    obstacles.add(spawnedObstacle);
  }
  
  void display(){
    switch(state){
      case DAY:
        background(#00C6C1);
    
        fill(#F6C740);
        ground();
        image(this.sun, Environment.WIDTH / 5, Environment.WIDTH / 10, Environment.UNIT, Environment.UNIT);
        break;
      case NIGHT:
        background(0);
    
        fill(20);
        ground();
        image(this.moon, Environment.WIDTH / 5, Environment.WIDTH / 10, Environment.UNIT, Environment.UNIT);
        break;
      default:
        errorMessage(this.getClass().getSimpleName() + " -> display() -> switch(state)");
        break;
    }
    for(Obstacle obstacle: obstacles){
      obstacle.shadow(state);
      obstacle.display(state);
    }
  }
  
  // XXX: DON'T TOUCH IT
  void ground(){
    float xoff = this.offset;
    
    beginShape();
    vertex(0, Environment.HEIGHT);
    for(int i = 0; i <= t2; i++){
      vertex(i * Environment.WIDTH / t2, Environment.HEIGHT - GROUND_HEIGHT - map(noise(xoff), 0, 1, Environment.HEIGHT * 0.05, Environment.HEIGHT * 0.15));
      xoff += v2b;
    }
    vertex(Environment.WIDTH ,Environment.HEIGHT);
    endShape(CLOSE);
    if(GAME.isOn()) this.offset += v2a;
    
    rect(Environment.WIDTH / 2, Environment.HEIGHT - GROUND_HEIGHT/2, Environment.WIDTH, GROUND_HEIGHT * 1.4);
  }
  
  void loadCostumes(){
    try{
      this.cactusDay = loadImage("cactus_big.png");
      this.cactusNight = loadImage("cactus_big_night.png");
    
      this.tumbleweedDay = loadImage("tumbleweed.png");
      this.tumbleweedNight = loadImage("tumbleweed.png");
    
      this.cloudDay = loadImage("cloud_big.png");
      this.cloudNight = loadImage("cloud_big_night.png");
    
      this.sun = loadImage("sun.png");
      this.moon = loadImage("moon.png");
    }
    catch(Exception e){
      println(e); 
    }
  }
  
  void initializeSpawners(){
    Cactus CACTUS_PROTOTYPE = new Cactus(cactusDay, cactusNight);
    Tumbleweed TUMBLEWEED_PROTOTYPE = new Tumbleweed(tumbleweedDay, tumbleweedNight);
    Cloud CLOUD_PROTOTYPE = new Cloud(cloudDay, cloudNight);
    
    ObstacleSpawner CACTUS_SPAWNER = new ObstacleSpawner(CACTUS_PROTOTYPE);
    ObstacleSpawner TUMBLEWEED_SPAWNER = new ObstacleSpawner(TUMBLEWEED_PROTOTYPE);
    ObstacleSpawner CLOUD_SPAWNER = new ObstacleSpawner(CLOUD_PROTOTYPE);
    
    obstacleSpawners = new ArrayList<ObstacleSpawner>();
    obstacleSpawners.add(CACTUS_SPAWNER);
    obstacleSpawners.add(TUMBLEWEED_SPAWNER);
    obstacleSpawners.add(CLOUD_SPAWNER);
  }
  
  void reset(){
    this.obstacles.clear();
   
    this.offset = 0;
    
    float d1 = Environment.WIDTH;
    this.v1 = d1 / (float)t1;
    
    float d2 = 1.5; 
    this.v2a = d2 / (float)t2;
    this.v2b = v2a * t1 / t2;
  }
}

/* 
 * ObstacleSpawner -- multi-instance (general) class
 * Copies given obstacle prototype object
 */
class ObstacleSpawner{
  private final Obstacle PROTOTYPE;
  
  ObstacleSpawner(Obstacle prototypeIn){
    this.PROTOTYPE = prototypeIn;
  }
  
  private Obstacle spawn(){
    return PROTOTYPE.clone();
  }
}

enum FieldState{
  DAY, NIGHT
}

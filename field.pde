/**
 * The GameField class is 
 */
class GameField{
  public FieldState state;
  private ArrayList<ObstacleSpawner> obstacleSpawners;
  private ObstacleSpawner CACTUS_SPAWNER;
  private ObstacleSpawner TUMBLEWEED_SPAWNER;
  private ObstacleSpawner CLOUD_SPAWNER;
  
  ArrayList<Obstacle> obstacles;
  final float GROUND_HEIGHT;
  float offset;
  PImage cactusDay, cactusNight,
         tumbleweedDay, tumbleweedNight,
         cloudDay, cloudNight;
  PImage sun, moon;
  
  int t1, t2;
  float v1, v2a, v2b;
  
  GameField(){
    this.obstacles = new ArrayList<Obstacle>();
    this.GROUND_HEIGHT = height/5;
    offset = 0;
    
    this.state = FieldState.NIGHT;
    
    this.t1 = 80;
    this.t2 = 50;
    
    float d1 = width;
    this.v1 = d1/(float)t1;
    
    float d2 = 1.5; 
    this.v2a = d2/(float)t2;
    this.v2b = v2a*t1/t2;
  }
  
  void update(){
    switch(state){
      case DAY:
        if(frameCount % 46 == 0 || frameCount % 82 == 0) spawnRandomObstacle();
        updateObstacles();
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
    for(int i = obstacles.size()-1; i >= 0; i--){
      obstacles.get(i).move(v1);
      if(obstacles.get(i).x < -obstacles.get(i).w/2) obstacles.remove(i);
    }
  }
  
  void spawnRandomObstacle(){
    int type = 3-floor(sqrt(random(14)+1));
    Obstacle nextObstacle = obstacleSpawners.get(type).spawn();
    obstacles.add(nextObstacle);
  }
  
  void display(){
    switch(state){
      case DAY:
        background(#00C6C1);
    
        fill(#F6C740);
        ground();
        image(sun, width/5, width/10, UNIT, UNIT);
        break;
      case NIGHT:
        background(0);
    
        fill(20);
        ground();
        image(moon, width/5, width/10, UNIT, UNIT);
        break;
      default:
        errorMessage("Field -> display() -> switch(state)");
        break;
    }
    for(Obstacle o: obstacles){
      o.shadow(state);
      o.display(state);
    }
  }
  
  void ground(){
    float xoff = offset;
    
    beginShape();
    vertex(0,height);
    for(int i = 0; i <= t2; i++){
      vertex(i*width/t2, height-GROUND_HEIGHT-map(noise(xoff), 0, 1, height*0.05, height*0.15));
      xoff += v2b;
    }
    vertex(width,height);
    endShape(CLOSE);
    if(GAME.isOn()) offset += v2a;
    
    rect(width/2, height-GROUND_HEIGHT/2, width, GROUND_HEIGHT*1.4);
  }
  
  void loadCostumes(){
    try{
      this.cactusDay = loadImage("cactusBig.png");
      this.cactusNight = loadImage("cactusBigNight.png");
    
      this.tumbleweedDay = loadImage("tumbleweed.png");
      this.tumbleweedNight = loadImage("tumbleweed.png");
    
      this.cloudDay = loadImage("cloudBig.png");
      this.cloudNight = loadImage("cloudBigNight.png");
    
      this.sun = loadImage("sun.png");
      this.moon = loadImage("moon.png");
    }
    catch(Exception e){
      println(e); 
    }
  }
  
  void initializeSpawners(){
    CACTUS_SPAWNER = new ObstacleSpawner(new Cactus(UNIT, cactusDay, cactusNight));
    TUMBLEWEED_SPAWNER = new ObstacleSpawner(new Tumbleweed(UNIT, tumbleweedDay, tumbleweedNight));
    CLOUD_SPAWNER = new ObstacleSpawner(new Cloud(UNIT, cloudDay, cloudNight));
    
    obstacleSpawners = new ArrayList<ObstacleSpawner>();
    obstacleSpawners.add(CACTUS_SPAWNER);
    obstacleSpawners.add(TUMBLEWEED_SPAWNER);
    obstacleSpawners.add(CLOUD_SPAWNER);
  }
  
  void reset(){
    this.obstacles = new ArrayList<Obstacle>();
   
    offset = 0;
    
    float d1 = width;
    this.v1 = d1/(float)t1;
    
    float d2 = 1.5; 
    this.v2a = d2/(float)t2;
    this.v2b = v2a*t1/t2;
  }
}

/* 
 * ObstacleSpawner -- multi-instance (general) class
 * Copies given obstacle prototype object
 */
class ObstacleSpawner{
  private final Obstacle prototype;
  
  ObstacleSpawner(Obstacle prototype){
    this.prototype = prototype;
  }
  
  private Obstacle spawn(){
    return (Obstacle) prototype.clone();
  }
}
/*class ObstacleSpawner<ObstacleType extends Obstacle>{
  private final ObstacleType prototype;
  
  ObstacleSpawner(ObstacleType prototype){
    this.prototype = prototype;
  }
  
  private ObstacleType spawn(){
    return (ObstacleType) prototype.clone();
  }
}*/

enum FieldState{
  DAY, NIGHT
}
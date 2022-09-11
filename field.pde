/**
 * Field -- single instance class
 * Handles Obstacle instances
 * Displays background/texture elements
 */
 
class Field{
  public FieldState state;
  private ArrayList<ObstacleSpawner> obstacle_spawners;
  private ObstacleSpawner CACTUS_SPAWNER;
  private ObstacleSpawner TUMBLEWEED_SPAWNER;
  private ObstacleSpawner CLOUD_SPAWNER;
  
  ArrayList<Obstacle> obstacles;
  final float GROUND_HEIGHT;
  float offset;
  PImage cactus_day, cactus_night,
         tumbleweed_day, tumbleweed_night,
         cloud_day, cloud_night;
  PImage sun, moon;
  
  int t1, t2;
  float v1, v2a, v2b;
  
  Field(){
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
        if(frameCount % 46 == 0 || frameCount % 82 == 0) spawn_random_obstacle();
        update_obstacles();
        break;
      case NIGHT:
        // don't update
        break;
      default:
        error_message("Field -> update() -> switch(state)");
        break;
    }
  }
  
  void update_obstacles(){
    for(int i = obstacles.size()-1; i >= 0; i--){
      obstacles.get(i).move(v1);
      if(obstacles.get(i).x < -obstacles.get(i).w/2) obstacles.remove(i);
    }
  }
  
  void spawn_random_obstacle(){
    int type = 3-floor(sqrt(random(14)+1));
    Obstacle next_obstacle = obstacle_spawners.get(type).spawn();
    obstacles.add(next_obstacle);
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
        error_message("Field -> display() -> switch(state)");
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
    if(GAME.is_on()) offset += v2a;
    
    rect(width/2, height-GROUND_HEIGHT/2, width, GROUND_HEIGHT*1.4);
  }
  
  void load_costumes(){
    try{
      this.cactus_day = loadImage("cactus_big.png");
      this.cactus_night = loadImage("cactus_big_night.png");
    
      this.tumbleweed_day = loadImage("tumbleweed.png");
      this.tumbleweed_night = loadImage("tumbleweed.png");
    
      this.cloud_day = loadImage("cloud_big.png");
      this.cloud_night = loadImage("cloud_big_night.png");
    
      this.sun = loadImage("sun.png");
      this.moon = loadImage("moon.png");
    }
    catch(Exception e){
      println(e); 
    }
  }
  
  void initialize_spawners(){
    CACTUS_SPAWNER = new ObstacleSpawner(new Cactus(UNIT, cactus_day, cactus_night));
    TUMBLEWEED_SPAWNER = new ObstacleSpawner(new Tumbleweed(UNIT, tumbleweed_day, tumbleweed_night));
    CLOUD_SPAWNER = new ObstacleSpawner(new Cloud(UNIT, cloud_day, cloud_night));
    
    obstacle_spawners = new ArrayList<ObstacleSpawner>();
    obstacle_spawners.add(CACTUS_SPAWNER);
    obstacle_spawners.add(TUMBLEWEED_SPAWNER);
    obstacle_spawners.add(CLOUD_SPAWNER);
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
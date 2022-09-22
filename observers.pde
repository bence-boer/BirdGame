/*public interface Observer{
  public void onNotify(Entity entity, Event event);
}

public interface Observable{
  private ArrayList<Observer> observers;
  
  public void addObserver(Observer o);
  public void removeObserver(Observer o);
  protected void notify();{
    for(Observable o: observers){
      o.onNotify(entity, event);
    }
  }
}

public enum Event{
  DIE,
  JUMP
}*/
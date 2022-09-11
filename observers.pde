/*public interface Observer{
  public void on_notify(Entity entity, Event event);
}

public interface Observable{
  private ArrayList<Observer> observers;
  
  public void add_observer(Observer o);
  public void remove_observer(Observer o);
  protected void notify();{
    for(Observable o: observers){
      o.on_notify(entity, event);
    }
  }
}

public enum Event{
  DIE,
  JUMP
}*/
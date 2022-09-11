/*import android.view.MotionEvent;

private final float TOUCH_SCALE_FACTOR = 180.0f / 320;
private float previousX;
private float previousY;

@Override
public boolean onTouchEvent(MotionEvent e) {

  float x = e.getX();
  float y = e.getY();

  switch (e.getAction()) {
    case MotionEvent.ACTION_MOVE:
      float dx = x - previousX;
      float dy = y - previousY;

      // reverse direction of rotation above the mid-line
      if (y > getHeight() / 2) {
        dx = dx * -1 ;
      }

      // reverse direction of rotation to left of the mid-line
      if (x < getWidth() / 2) {
        dy = dy * -1 ;
      }
  }
  
  previousX = x;
  previousY = y;
  return true;
}*/
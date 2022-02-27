class Tile extends Game {
  float x, y, w;
  color c;
  int counter;
  boolean isWall;
  boolean discovered;
  boolean used;
  Tile foundBy = null;
  float cost = 0;

  Tile(float _x, float _y, float _w, int _counter) {
    x = _x;
    y = _y;
    w = _w;
    counter = _counter;
  }

  void display() {
    
    if (isWall) {
      c = color(155, 103, 60);
    }
    fill(c);
    if(discovered){
      fill(255,0,0);
    }
    if(used){
      fill(100,100,255);
    }
    rect(x, y, w, w);
    
    fill(0);
    if(cost!=0){
      text(cost, x, y-10);
    }
    
    c = color(255);
    color(255,255,255);
    showFoundBy();
  }
  
  void showFoundBy(){
    if(discovered){
      PVector temp1 = new PVector(x,y);
      PVector temp2 = new PVector(foundBy.x,foundBy.y);
      PVector temp3 = temp2.sub(temp1);
      temp3.normalize();
      temp3.mult(6);
      push();
      translate(x,y+10);
      
      translate(temp3.x,temp3.y);
      
      PVector temp4 = temp3.copy();
      temp4.rotate(2.356);
      line(0,0,temp4.x,temp4.y);
      
      PVector temp5 = temp3.copy();
      temp5.rotate(-2.356);
      line(0,0,temp5.x,temp5.y);
      
      pop();
    }
  }
  
  void mouseHover(boolean hovering, int tilePath) {
    if (hovering) {
      if (tilePath == 1) {
        c = color(50, 100, 50);
      } else if (tilePath == 2) {
        c = color(100, 50, 50);
      }
    } else {
      c = color(155, 103, 60);
    }
  }
}

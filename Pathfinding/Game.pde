class Game {
  boolean drawingWalls = false;
  boolean pickingPath = true;
  float offsetX = 50;
  float offsetY = 150;
  
  int tilePath = 1;

  ArrayList<Tile> tileList = new ArrayList<Tile>();
  Path path;

  float hoveringX, hoveringY = 0;

  void setup() {
    makeMap();
    path = new Path(tileList);
  }

  void draw() {
    clear();
    background(200);
    push();
    translate(offsetX,offsetY);
      if (pickingPath || drawingWalls) {
        tileSelect();
      }
      drawWalls();
      displayMap();
      path.display();
    pop();
    coordinatesMouse();
    fill(0);
  }

  void mousePressed() {
    if (pickingPath) {
      pickPath();
    }
  }

  
  void keyPressed() {
    //s checks for new step 
    if (key == 's') {
      if (path.pathTwoPicked) {
        path.findPath();
      }
    }
    //t switches between drawing walls and picking a path
    if (key == 't') {
      drawingWalls = !drawingWalls;
      pickingPath = !pickingPath;
    }
  }
  
  void coordinatesMouse(){
    for(Tile t: tileList){
      if(checkMouse(t.x,t.y,t.w,t.w)){
        push();
        textSize(12);
        textAlign(CENTER, CENTER);
        stroke(0);
        text("x: " + t.x+ " y: "+t.y,mouseX,mouseY-50);
        pop();
      }
    }
  }
  
  //The tile the mouse is hovering over is selected
  void tileSelect() {
    for (Tile t : tileList) {
      if (checkMouse(t.x, t.y, t.w, t.w)) { 
        if (pickingPath) {
          t.mouseHover(true, tilePath);
        } else if (drawingWalls) {
          t.mouseHover(false, 0);
        }
        hoveringX = t.x;
        hoveringY = t.y;
      }
    }
  }
  
  //
  void pickPath() {
    if (!path.pathOnePicked) {
      path.pathOnePicked = true;
      path.startX = hoveringX;
      path.startY = hoveringY;
      tilePath = 2;
      //Set starting tile to discovered
      path.getTileByCoords(new Coords(path.startX,path.startY)).used = true;
      path.getTileByCoords(new Coords(path.startX,path.startY)).foundBy = path.getTileByCoords(new Coords(path.startX,path.startY));
      //Make tiles around start point discovered
      Coords[] tempCoords = path.coordsAround(new Coords(path.startX,path.startY));
      for(Tile t: tileList){
        for(int i = 0; i<tempCoords.length; i++){
          if(t.x == tempCoords[i].x && t.y == tempCoords[i].y){
            t.discovered = true;
            t.foundBy = path.getTileByCoords(new Coords(path.startX,path.startY));
          }
        }
      }
    } else if (!path.pathTwoPicked) {
      path.pathTwoPicked = true;  
      path.goalX = hoveringX;
      path.goalY = hoveringY;
      pickingPath = false;
      tilePath = 1;
      path.setCostForDiscoveredTiles(path.findAllDiscoveredTiles());
      ArrayList<Tile> dTiles = path.findAllDiscoveredTiles();
      path.findCheapestTile(dTiles);
    }
  }

  
  void drawWalls() {
    if (mousePressed && drawingWalls) {
      for (Tile t : tileList) {
        if (checkMouse(t.x, t.y, t.w, t.w)) {
          t.isWall = true;
        }
      }
    }
  }

  void makeMap() {
    int counter = 0;
    for (int i = 0; i<=1500; i+=50) {
      for (int k = 0; k<=600; k+=50) {
        counter++;
        tileList.add(new Tile(i, k, 50, counter));
      }
    }
  }

  void displayMap() {
    for (Tile t : tileList) {
      t.display();
    }
  }

  boolean checkMouse(float x, float y, float w, float h) {
    if (mouseX>x-25+offsetX && mouseX<x+w-25+offsetX && mouseY>y-25+offsetY && mouseY<y+h-25+offsetY) {
      return true;
    }
    return false;
  }
}

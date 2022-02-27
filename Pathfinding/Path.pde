
class Path extends Game {
  float size = 50;
  float startX, startY, goalX, goalY = 0;

  boolean pathOnePicked;
  boolean pathTwoPicked;
  boolean found;

  ArrayList<Tile> tileList;

  Path(ArrayList tile) {
    tileList = tile;
  }

  void display() {
    if (pathOnePicked) {
      fill(100, 200, 100);
      rect(startX, startY, size, size);
    }
    if (pathTwoPicked) {
      fill(200, 100, 100);
      if (found) {
        fill(100, 100, 255);
      }
      rect(goalX, goalY, size, size);
    }
    fill(255);
    if (found) {
      lightUpFoundPath();
    }
  }

  //Main function that finds the path between home and goal
  void findPath() {
    if (!found) {
      //Get arraylist with all discovered tiles
      ArrayList<Tile> discoveredTiles = findAllDiscoveredTiles();

      //Find cheapest of the tiles
      Tile cheapestTile = findCheapestTile(discoveredTiles);
      cheapestTile.used = true;

      //discover tiles around the cheapest tile
      discoverTilesAround(cheapestTile);

      setCostForDiscoveredTiles(findAllDiscoveredTiles());
    }
    checkIfFound();
  }

  void lightUpFoundPath() {
    Tile goal = getTileByCoords(new Coords(goalX, goalY));
    fill(255, 215, 0);
    rect(goal.x,goal.y,50,50);
    Tile currentTile = goal;
    boolean done = false;
    while (!done) {
      currentTile = currentTile.foundBy;
      rect(currentTile.x, currentTile.y, 50, 50);
      if (currentTile.x == startX && currentTile.y == startY) {
        done = true;
      }
    }
  }

  void checkIfFound() {
    Tile goal = getTileByCoords(new Coords(goalX, goalY));
    if (goal.used) {
      found = true;
    }
  }

  void setCostForDiscoveredTiles(ArrayList<Tile> inputDiscoveredTiles) {
    //Set costs for all tiles
    for (Tile t : inputDiscoveredTiles) {
      t.cost = totalTravelCost(t);
    }
  }

  ArrayList<Tile> findAllDiscoveredTiles() {
    ArrayList<Tile> dTiles = new ArrayList<Tile>();
    for (Tile t : tileList) {
      if (t.discovered) {
        dTiles.add(t);
      }
    }
    return dTiles;
  }

  //Finds the cheapest tile
  Tile findCheapestTile(ArrayList<Tile> inputDiscoveredTiles) {
    //Set cheapest tile to a random tile that is not used
    Tile cheapestTile = inputDiscoveredTiles.get(0);
    for (int i = 0; i<inputDiscoveredTiles.size(); i++) {
      if (!inputDiscoveredTiles.get(i).used) {
        cheapestTile = inputDiscoveredTiles.get(i);
      }
    }
    //Find cheapest cost
    float cheapestCost = inputDiscoveredTiles.get(0).cost;
    for (Tile t : inputDiscoveredTiles) {
      if (cheapestCost > t.cost) {
        if (!t.used) {
          cheapestCost = t.cost;
        }
      }
    }
    //Find all tiles that share cheapest cost
    ArrayList<Tile> allCheapestTiles = new ArrayList<Tile>();
    for (Tile t : inputDiscoveredTiles) {
      if (t.cost == cheapestCost) {
        if (!t.used) {
          allCheapestTiles.add(t);
        }
      }
    }

    //Find the cheapest distance
    float cheapestDistance = dist(allCheapestTiles.get(0).x, allCheapestTiles.get(0).y, goalX, goalY);
    for (Tile t : allCheapestTiles) {
      if (dist(t.x, t.y, goalX, goalY) < cheapestDistance) {
        cheapestDistance = dist(t.x, t.y, goalX, goalY);
      }
    }
    //Return cheapest tile
    for (Tile t : allCheapestTiles) {
      if (dist(t.x, t.y, goalX, goalY) == cheapestDistance) {
        return t;
      }
    }

    return cheapestTile;
  }

  //Discover tiles around 
  void discoverTilesAround(Tile inputTile) {    
    //Get coordinates around 
    Coords[] coordsAround = coordsAround(new Coords(inputTile.x, inputTile.y));
    for (int i = 0; i<coordsAround.length; i++) {
      Tile t = getTileByCoords(coordsAround[i]);
      if (!t.isWall) {
        t.discovered = true;
        float newCost = travelCost(new Coords(startX, startY), new Coords(inputTile.x, inputTile.y))+travelCost(new Coords(inputTile.x, inputTile.y), new Coords(t.x, t.y))+travelCost(new Coords(t.x, t.y), new Coords(goalX, goalY));
        if (t.foundBy == null) {
          t.foundBy = inputTile;
        } else if (newCost < totalTravelCost(t)) {
          if (inputTile.foundBy != t) {
            t.foundBy = inputTile;
          }
        }
      } else {
        break;
      }
    }
  }

  //Makes an array that holds coordinates for all 8 tiles around
  Coords[] coordsAround(Coords inputCoords) {
    float l = 50; //line length
    Coords[] coords = new Coords[8];
    for (int i = 0; i<8; i++) {
      switch(i) {
        case(0):  
        coords[i] = new Coords(inputCoords.x-l, inputCoords.y-l); 
        break;
        case(1):
        coords[i] = new Coords(inputCoords.x, inputCoords.y-l); 
        break;
        case(2):
        coords[i] = new Coords(inputCoords.x+l, inputCoords.y-l); 
        break;
        case(3):
        coords[i] = new Coords(inputCoords.x-l, inputCoords.y); 
        break;
        case(4):
        coords[i] = new Coords(inputCoords.x+l, inputCoords.y); 
        break;
        case(5):
        coords[i] = new Coords(inputCoords.x-l, inputCoords.y+l); 
        break;
        case(6):
        coords[i] = new Coords(inputCoords.x, inputCoords.y+l); 
        break;
        case(7):
        coords[i] = new Coords(inputCoords.x+l, inputCoords.y+l); 
        break;
      }
    }
    return coords;
  }

  Tile getTileByCoords(Coords inputCoords) {
    for (Tile t : tileList) {
      if (t.x == inputCoords.x && t.y == inputCoords.y) {
        return t;
      }
    }
    return tileList.get(0);
  }

  //Travel cost between home -> foundby , and foundby -> inputTile , inputTile -> goal
  float totalTravelCost(Tile inputTile) {
    float cost = 0;
    cost = travelCost(new Coords(startX, startY), new Coords(inputTile.foundBy.x, inputTile.foundBy.y));
    cost += travelCost(new Coords(inputTile.foundBy.x, inputTile.foundBy.y), new Coords(inputTile.x, inputTile.y));
    cost += travelCost(new Coords(inputTile.x, inputTile.y), new Coords(goalX, goalY));
    return cost;
  }

  //Travel cost between tile and coords
  float travelCost(Coords coords1, Coords coords2) {
    float cost = 0;
    float high = 0, low = 0;
    float xDiff = 0;
    float yDiff = 0;

    yDiff = abs(coords1.y-coords2.y)*2/100;
    xDiff = abs(coords1.x-coords2.x)*2/100;

    if (xDiff>yDiff) {
      high = xDiff;
      low = yDiff;
    } else if (xDiff<yDiff) {
      high = yDiff;
      low = xDiff;
    } else {
      return sqrt(2)*xDiff;
    }

    float diagonalTimes = low;
    float straightTimes = high-low;
    cost = (diagonalTimes*sqrt(2))+(straightTimes);
    return cost;
  }
}

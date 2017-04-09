class Bullet {
  PVector pos, vel;
  float radius;
  float speed;
  float padding = radius+speed+1;
  Cell cell;
  int createdS = second();
  int lifeSpan = 10;
  int hits = 0;

  Bullet(float x, float y, float rotation, Cell c, float r, float sp) { //slightly more simple then the second, gives great controll of how the bullet looks and acts
    speed = sp;
    radius = r;
    cell = c;
    pos = new PVector(x, y);
    vel = new PVector(speed*cos(radians(rotation)), speed*sin(radians(rotation)));
  }
  
  Bullet(float x, float y, float rotation, Cell c, float r, float sp, int life) { //includes a edit to the life parameter
    lifeSpan = life;
    speed = sp;
    radius = r;
    cell = c;
    pos = new PVector(x, y);
    vel = new PVector(speed*cos(radians(rotation)), speed*sin(radians(rotation)));
  }

  void drawBullet() { //draws the bullet
    noStroke();
    fill(0);
    ellipse(pos.x, pos.y, 2*radius, 2*radius);
  }

  void move() { //moves the bullet by adding vel
    checkMove();
    pos.add ( vel );
    updateCell();
  }

  void checkMove() { //very complex method to check for collsions, bullet collisions are a lot more fiddly then tank ones
    boolean vertPrimary, vertEdge, horPrimary, horEdge, horRight, vertDown; //stores what type of impact and where
    vertPrimary = vertEdge = horPrimary = horEdge = horRight = vertDown = false;
    HashSet<Wall> walls = cell.getAllWalls(); //get a set of the walls near the bullet
    PVector nextPos = pos; //predicts the positiob of the bullet next step
    nextPos.add(vel);
    Area bulletArea = new Area(new Ellipse2D.Float(nextPos.x -radius, nextPos.y - radius, 2*radius, 2*radius));
    for (Wall wall : walls) {
      Area wallArea = new Area(new Rectangle(wall.x, wall.y, wall.widthW, wall.heightW));
      if (testIntersection(bulletArea, wallArea)) { //in a wall
        hits++;
        if (wall.vertical) {
          if (pos.y > wall.y + wall.heightW || pos.y < wall.y) { //edge
            vertEdge = true;
            if (pos.y > wall.y+(wall.heightW/2)) vertDown = true; //bottom of a vertical wall
            if(vertDown){ //set ball strictly outside wall stops bullets getting stuck in walls
              pos.y = wall.y + wall.heightW + radius;
            }else{
              pos.y = wall.y - radius;
            }
          } else { //face
            vertPrimary = true;
            if (pos.x-radius< wall.x) { //set ball strictly outside wall stops bullets getting stuck in walls
              pos.x = wall.x - radius;
            } else if (pos.x+radius> wall.x + wall.widthW) {
              pos.x = wall.x + wall.widthW + radius;
            }
          }
        } else {
          if (pos.x > wall.x + wall.widthW || pos.x < wall.x) { //edge
            horEdge = true;
            if (pos.x > wall.x+(wall.widthW/2)) horRight = true; //right of a horizontal wall
            if(horRight){ //set ball strictly outside wall stops bullets getting stuck in walls
              pos.x = wall.x + wall.widthW + radius;
            }else{
              pos.x = wall.x - radius;
            }
          } else {//face
            horPrimary = true;
            if (pos.y - radius< wall.y) { //set ball strictly outside wall stops bullets getting stuck in walls
              pos.y = wall.y - radius;
            } else if (pos.y + radius > wall.y + wall.heightW) {
              pos.y = wall.y + wall.heightW + radius;
            }
          }
        }
      }
    }
    //After the wall collsions have been computed, what to do is decided by the booleans set
    //if (vertPrimary || horPrimary || vertEdge || horEdge) println("VertP: " + vertPrimary + " HorP: " + horPrimary + " VertE: " + vertEdge + " HorE: " + horEdge);
    if (vertPrimary || horPrimary) { //primary bounces are easy
      if (vertPrimary) vel.x = vel.x * -1;
      if (horPrimary) vel.y = vel.y * -1;
    } else {
      if (vertEdge && horEdge) { //Hit a corner of two walls
        //This ensures a correct corner bounce no matter what, else it can get funny, hitting a wall before then cornering
        //println("CORNER"); //This corner code resolves many bugs
        if (horRight && vertDown) { //Bottom right
          if(vel.x < 0) vel.x = vel.x*-1;
          if(vel.y < 0) vel.y = vel.y*-1;
        }else if(!horRight && !vertDown){ //Top left
          if(vel.x > 0) vel.x = vel.x*-1;
          if(vel.y > 0) vel.y = vel.y*-1;
        }else if(!horRight && vertDown){ //Bottom Left
          if(vel.x > 0) vel.x = vel.x*-1;
          if(vel.y < 0) vel.y = vel.y*-1;
        }else if(horRight && !vertDown){ //Top right
          if(vel.x < 0) vel.x = vel.x*-1;
          if(vel.y > 0) vel.y = vel.y*-1;
        }
        pos.add ( vel );
      } else if (vertEdge) { //Hit the point of a wall -*<-
        vel.y = vel.y * -1;
      } else if (horEdge) {
        vel.x = vel.x * -1;
      }
    }
  }

  boolean testIntersection(Area a, Area b) { //Test to see if there is an intersection between two areas
    b.intersect(a);
    return !b.isEmpty();
  }

  boolean checkTime() { //Test to see if the bullet has lived its life
    int time;
    if (second() < createdS) {
      time = 60 + second();
    } else {
      time = second();
    }
    return time - createdS >= lifeSpan;
  }

  void updateCell() { //Checks to see of the cell should be moved or not
    int cellX = cell.x;
    int cellY = cell.y;
    int cellWidth = cell.widthC;
    if (pos.x<cellX) cell = cell.leftC;
    if (pos.x>cellX+cellWidth) cell = cell.rightC;
    if (pos.y<cellY) cell = cell.topC;
    if (pos.y>cellY+cellWidth) cell = cell.bottomC;
  }
}
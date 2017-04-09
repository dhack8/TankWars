class Tank {
  PImage img;
  int score;
  boolean alive;
  float x, y;
  color colour;
  float rotation = 0;
  float speed = 1.5;
  int widthT = 24;
  int heightT = 16;
  Cell current;
  int xOrigin[] = {-widthT/2, -widthT/2, widthT/2, widthT/2}; //locations of the corners of the tank at origin
  int yOrigin[] = {-heightT/2, heightT/2, heightT/2, -heightT/2};
  Weapon currentWeapon = new Default(widthT); //the weapon currently equiped
  ArrayList<Weapon> weapons = new ArrayList<Weapon>(); //all the weapons being animated

  Tank(Cell c, color col) {
    img = loadImage("flames.png");
    score = 0;
    alive = true;
    colour = col;
    current = c;   
    x = c.getCenterX();
    y = c.getCenterY();
    weapons.add(currentWeapon);
  }

  void updateTank(int yScore) { //draws the tank
    purgeUsedWeapons(); //deletes empty and expened weapons
    if(currentWeapon.expended())setCurrentW(); //finds the most appropiate weapon to equip
    if (current.crate != null && currentWeapon instanceof Default) { //pick up a better weapon
      currentWeapon = current.crate;
      current.crate = null;
      weapons.add(currentWeapon);
    }
    for(Weapon w: weapons){w.updateBullets();} //draws the weapons with bullets
    
    pushMatrix(); // draws actual tank
    translate(x, y);
    rotate(radians(rotation));
    fill(colour);
    stroke(0);
    rect(0-(widthT/2), 0-(heightT/2), widthT, heightT);
    currentWeapon.updateWeapon(heightT);
    //line(0, 0, 500, 0);
    if (!alive) image(img, 0-((widthT+5)/2), 0-((widthT+5)/2.5), widthT+5, widthT+5);
    popMatrix();

    pushMatrix(); //draw score board tank
    translate(25, yScore);
    rect(0-(widthT/2), 0-(heightT/2), widthT, heightT);
    currentWeapon.updateWeapon(heightT);
    if (!alive) image(img, 0-((widthT+5)/2), 0-((widthT+5)/2.5), widthT+5, widthT+5);
    fill(0);
    textSize(20);
    text(score, -10, 35);
    popMatrix();
  }
  
  void setCurrentW(){ //finds best non expended weapon
    for(int i = 0; i<weapons.size(); i++){
      if(!weapons.get(i).expended()){
        currentWeapon = weapons.get(i);
      }
    }
  }
  
  void purgeUsedWeapons(){ //deleted expended and empty weapons
    for(int i = 0; i<weapons.size(); i++){
      Weapon w = weapons.get(i);
      if(w.expended() && w.isEmpty()){
        weapons.remove(i);
      }
    }
  }

  void antiClock() { //rotates the tank by a given angle left
    rotation -= 4.5;
  }
  void clockWise() { //rotates the tank by a given angle right
    rotation += 4.5;
  }
  void forward() { //Increments the tank position forwards
    x += speed*cos(radians(rotation));
    y += speed*sin(radians(rotation));
  }
  void backward() { //Increments the tank position backwards
    x -= (speed/2)*cos(radians(rotation));
    y -= (speed/2)*sin(radians(rotation));
  }
  void triggerDown() {
    float bulletX = x + (widthT/1.5)*cos(radians(rotation));
    float bulletY = y + (widthT/1.5)*sin(radians(rotation));
    currentWeapon.triggerDown(bulletX, bulletY, rotation, current);
  }
  void triggerUp() {
      currentWeapon.triggerUp();
  }

  Bullet checkBullets(ArrayList<Bullet> bullets) {
    Area tankArea = new Area(calcTankShape(1, 0));
    for (Bullet b : bullets) {
      if (b != null && tankArea.contains(b.pos.x, b.pos.y)) {
        return b;
      }
    }
    return null;
  }

  boolean checkMove(double n) { //Checks to see if the tank should be allowed to move forwards or backwards
    HashSet<Wall> walls = current.getAllWalls();
    Area tankArea = new Area(calcTankShape(n, 0));
    Area weaponArea = new Area(currentWeapon.getShape(x, y, n, 0, speed, rotation)); 
    tankArea.add(weaponArea); //include weapon area
    for (Wall wall : walls) {
      Area wallArea = new Area(new Rectangle(wall.x, wall.y, wall.widthW, wall.heightW));
      if (testIntersection(tankArea, wallArea)) return false;
    }
    return true;
  }

  void checkRotate(float m) { //Checks to see if the tank can rotate without hitting a wall, if it is going to hit a wall it shifts it away from wall
    HashSet<Wall> walls = current.getAllWalls();
    Area tankArea = new Area(calcTankShape(1, m));
    Area weaponArea = new Area(currentWeapon.getShape(x, y, 1, m, speed, rotation));
    tankArea.add(weaponArea); //include weapon area
    for (Wall wall : walls) {
      Area wallArea = new Area(new Rectangle(wall.x, wall.y, wall.widthW, wall.heightW));
      if (testIntersection(tankArea, wallArea)) { //intersection found on next rotate so resolve
        if (wall.vertical) { //If it is vertical wall
          if (wall.y - widthT*0.3 > y) {
            y -= 0.5;
          } else if (wall.y + widthT*0.3 + wall.heightW < y) {
            y += 0.5;
          } else {
            if (wall.x < x) x += 0.5;
            if (wall.x > x) x -= 0.5;
          }
        } else { //If the wall is horizontal
          if (wall.x - widthT*0.3 > x) {
            x -= 0.5;
          } else if (wall.x + widthT*0.3 + wall.widthW < x) {
            x += 0.5;
          } else {
            if (wall.y < y) y += 0.5;
            if (wall.y > y) y -= 0.5;
          }
        }
      }
    }
  }

  boolean testIntersection(Area a, Area b) { //Test to see if there is an intersection between two areas
    b.intersect(a);
    return !b.isEmpty();
  }

  Shape calcTankShape(double n, float m) { //Calculates the tanks shape with modifiers to predict its future position n forwards or back, m rotation
    int xPoints[] = new int[4]; //Returns a java polygon type therefore the corner positions of the tank must be calculated
    int yPoints[] = new int[4];
    for (int i = 0; i<xPoints.length; i++) {
      xPoints[i] = (int) ((x + n*speed*cos(radians(rotation + m))) + ((xOrigin[i]*cos(radians(rotation + m)) - yOrigin[i]*sin(radians(rotation + m)))));
    }
    for (int o = 0; o<xPoints.length; o++) {
      yPoints[o] = (int) ((y + n*speed*sin(radians(rotation + m))) + ((xOrigin[o]*sin(radians(rotation + m)) + yOrigin[o]*cos(radians(rotation + m)))));
    }
    Shape tankShape = new Polygon(xPoints, yPoints, 4);
    return tankShape;
  }

  void updateCell() { //Checks to see of the cell should be moved or not
    int cellX = current.x;
    int cellY = current.y;
    int cellWidth = current.widthC;
    if (x<cellX) current = current.leftC;
    if (x>cellX+cellWidth) current = current.rightC;
    if (y<cellY) current = current.topC;
    if (y>cellY+cellWidth) current = current.bottomC;
  }

  void reset(Cell c) { //used for a soft reset
    alive = true;
    currentWeapon = new Default(widthT);
    weapons.clear();
    weapons.add(currentWeapon);
    x = c.getCenterX();
    y = c.getCenterY();
    current = c;
  }
  
  ArrayList<Bullet> getBullets(){ //returns all bullets from all weapons
      ArrayList<Bullet> returned = new ArrayList<Bullet>();
      for(Weapon w: weapons){returned.addAll(w.getBullets());}
      return returned;
  }
  
  void deleteBullet(Bullet b){ //deletes a bullet from its weapon
      for(Weapon w: weapons){w.deleteBullet(b);}
  }
}
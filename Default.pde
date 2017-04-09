class Default implements Weapon { //REFER TO INTERFACE FOR COMMENTS ON METHODS

  int xOrigin[];
  int yOrigin[];
  int widthW;
  int heightW;

  boolean ready = true; //semi auto action
  Bullet[] bullets = new Bullet[5]; //Chose to use an array for its fixed size

  Default(int widthT) {
    widthW = (int) (widthT*0.7);
    heightW = 4;
    int[] xOriginT = {0, 0, widthW, widthW};
    int[] yOriginT = {-heightW/2, heightW/2, -heightW/2, heightW/2};
    xOrigin = xOriginT;
    yOrigin = yOriginT;
  }
  
  public boolean expended(){ //little bit different to other weapons, its allways equiped
    return false;
  }
  
  public boolean isEmpty(){
    return false;
  }
  
  public void drawCrate(int x, int y, int widthC){
    //Unsupported op
  }

  public void triggerDown(float x, float y, float rotation, Cell cell) { //finds a free slot and populates it with a bullet
    if (ready) {
      for (int i = 0; i<bullets.length; i++) {
        if (bullets[i] == null) {
          bullets[i] = new Bullet(x, y, rotation, cell, 2.5, 0.9);
          break;
        }
      }
      ready = false;
    }
  }

  public void triggerUp() {
    ready = true;
  }

  public void updateWeapon(int heightT) { //draws a nromal weapon
    rect(0, -heightW/2, widthW, heightW);
    ellipse(0, 0, heightT*0.75, heightT*0.75);
  }

  public void updateBullets() {
    for (int i = 0; i<bullets.length; i++) {
      if (bullets[i] != null) {
        bullets[i].move();
        bullets[i].drawBullet();
        if (bullets[i].checkTime()) bullets[i] = null;
      }
    }
  }

  public ArrayList<Bullet> getBullets() {
    return new ArrayList<Bullet>(Arrays.asList(bullets));
  }

  public void deleteBullet(Bullet b) {
    for (int i =0; i<5; i++) {
      if (bullets[i] != null && bullets[i].equals(b)) {
        bullets[i] = null;
      }
    }
  }

  public Shape getShape(float x, float y, double n, float m, float speed, float rotation) {
    int xPoints[] = new int[4]; //Returns a java polygon type therefore the corner positions of the tank must be calculated
    int yPoints[] = new int[4];
    for (int i = 0; i<xPoints.length; i++) {
      xPoints[i] = (int) ((x + n*speed*cos(radians(rotation + m))) + ((xOrigin[i]*cos(radians(rotation + m)) - yOrigin[i]*sin(radians(rotation + m)))));
    }
    for (int o = 0; o<xPoints.length; o++) {
      yPoints[o] = (int) ((y + n*speed*sin(radians(rotation + m))) + ((xOrigin[o]*sin(radians(rotation + m)) + yOrigin[o]*cos(radians(rotation + m)))));
    }
    Shape weaponShape = new Polygon(xPoints, yPoints, 4);
    return weaponShape;
  }
}
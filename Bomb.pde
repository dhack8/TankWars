class Bomb implements Weapon { //REFER TO INTERFACE FOR COMMENTS ON METHODS

  int xOrigin[];
  int yOrigin[];
  int widthW;
  int heightW;
  PImage img;
  final int pelletCount = 40;

  boolean ready = true;
  boolean primed = false;
  boolean exploded = false;
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();

  Bomb(int widthT) {
    widthW = (int) (widthT*0.8);
    heightW = 8;
    int[] xOriginT = {0, 0, widthW, widthW};
    int[] yOriginT = {-heightW/2, heightW/2, -heightW/2, heightW/2};
    xOrigin = xOriginT;
    yOrigin = yOriginT;
  }

  public boolean expended() {
    return primed && bullets.isEmpty();
  }
  
  public boolean isEmpty(){
    return bullets.isEmpty();
  }

  public void drawCrate(int x, int y, int widthC) {
    if (img == null) img = loadImage("bomb.png"); //draws a bomb crate
    fill(100);
    rect(x, y, widthC/2, widthC/2);
    image(img, x + 3, y + 3, widthC/2 - 6, widthC/2 -6);
  }

  public void triggerDown(float x, float y, float rotation, Cell cell) {
    if (primed && ready && !exploded) {//blow up bomb
      exploded = true;
      Bullet bomb = bullets.remove(0);
      for (int i = 0; i<pelletCount; i++) { //shrapnel
        float random = random(1, 360);
        bullets.add(new Bullet(bomb.pos.x, bomb.pos.y, random, bomb.cell, 1.25, 2));
      }
    } else if (ready && !primed) {//shoot bomb
      bullets.add(new Bullet(x, y, rotation, cell, 5, 0.9)); //shoot bomb
      ready = false; //save player from blowing themselves up, semi auto
      primed = true;
    }
  }

  public void triggerUp() {
    ready = true;
  }

  public void updateWeapon(int heightT) { //draws a fat barrel
    rect(0, -heightW/2, widthW, heightW);
    ellipse(0, 0, heightT*0.75, heightT*0.75);
  }

  public void updateBullets() {
    for (int i = 0; i<bullets.size(); i++) {
      Bullet b = bullets.get(i);
      if (b != null) {
        b.move();
        b.drawBullet();
        if (b.checkTime()) bullets.remove(i);
        if (exploded && b.hits > 0) bullets.remove(i);
      }
    }
  }

  public ArrayList<Bullet> getBullets() {
    return bullets;
  }

  public void deleteBullet(Bullet b) {
    for (int i =0; i<bullets.size(); i++) {
      if (bullets.get(i) != null && bullets.get(i).equals(b)) {
        bullets.remove(i);
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
class Minigun implements Weapon { //REFER TO INTERFACE FOR COMMENTS ON METHODS
  int xOrigin[];
  int yOrigin[];
  int widthW;
  int heightW;
  PImage img;
  int time;
  int count = 2;
  final int ammoCount = 40;
  
  boolean ammo = true;
  boolean flip = true;
  boolean expended = false;
  boolean primed = false;
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();

  Minigun(int widthT) {
    widthW = (int) (widthT*0.7);
    heightW = 6;
    int[] xOriginT = {0, 0, widthW, widthW};
    int[] yOriginT = {-heightW/2, heightW/2, -heightW/2, heightW/2};
    xOrigin = xOriginT;
    yOrigin = yOriginT;
  }

  public boolean expended() {
    return expended;
  }
  
  public boolean isEmpty(){
    return bullets.isEmpty();
  }

  public void drawCrate(int x, int y, int widthC) { //draw a minigun crate
    if (img == null) img = loadImage("minigun.png");
    fill(100);
    rect(x, y, widthC/2, widthC/2);
    image(img, x + 3, y + 3, widthC/2 - 6, widthC/2 -6);
  }

  public void triggerDown(float x, float y, float rotation, Cell cell) {
    if (primed) {
      if (bullets.size()<ammoCount && ammo) { //checks if it can shoot
        if (flip) { //flip is to reduce the fire rate
          bullets.add( new Bullet(x, y, rotation + random(-7, 7), cell, 1.5, 1.2, 7));
          flip = false;
        } else {
          flip = true;
        }
      } else {
        ammo = false;
      }
    } else if (time != second()) { //spool up timer slightly differnt to others used in this programe
      time = second();
      count--;
      if (count == 0) {
        primed = true;
      }
    }
  }

  public void triggerUp() { //release the trigger and its over
    expended = true; 
  }

  public void updateWeapon(int heightT) { //draw a minigun
    rect(0, -heightW/2, widthW, heightW);
    line(0, -1, widthW, -1);
    line(0, 1, widthW, 1);
    ellipse(0, 0, heightT*0.75, heightT*0.75);
  }

  public void updateBullets() {
    for (int i = 0; i<bullets.size(); i++) {
      Bullet b = bullets.get(i);
      if (b != null) {
        b.move();
        b.drawBullet();
        if (b.checkTime()) bullets.remove(i);
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
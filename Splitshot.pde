class Splitshot implements Weapon { //REFER TO INTERFACE FOR COMMENTS ON METHODS

  PImage img;
  int xOrigin[];
  int yOrigin[];
  int widthW;
  int heightW;
  int ammo = 4;
  int degrees = 5;

  boolean ready = true;
  ArrayList<Spliter> bullets = new ArrayList<Spliter>(); //Spliter is a class at the bottom of this page

  Splitshot(int widthT) {
    widthW = (int) (widthT*0.7);
    heightW = 8;
    int[] xOriginT = {0, 0, widthW, widthW};
    int[] yOriginT = {-heightW/2, heightW/2, -heightW/2, heightW/2};
    xOrigin = xOriginT;
    yOrigin = yOriginT;
  }

  public boolean expended() {
    return ammo<=0 && ready;
  }

  public boolean isEmpty() {
    return bullets.isEmpty();
  }

  public void drawCrate(int x, int y, int widthC) { //draw a splitshot crate
    if (img == null) img = loadImage("splitshot.png");
    fill(100);
    rect(x, y, widthC/2, widthC/2);
    image(img, x + 3, y + 3, widthC/2 - 6, widthC/2 -6);
  }

  public void triggerDown(float x, float y, float rotation, Cell cell) {
    if (ready && ammo > 0) { //similar to default
      Bullet b = new Bullet(x, y, rotation + random(-5,5), cell, 3.5, 0.9, 2);
      bullets.add(new Spliter(b, true));
      ammo--;
      ready = false;
    }
  }

  public void triggerUp() {
    ready = true; //semi auto
  }

  public void updateWeapon(int heightT) { //draw a wedge gun !
    triangle(0, 0, widthW, heightW/2, widthW, -heightW/2);
    ellipse(0, 0, heightT*0.75, heightT*0.75);
  }

  public void updateBullets() { //more complicated then other updatebullet methods due to split
    for (int i = 0; i<bullets.size(); i++) {
      Spliter b = bullets.get(i);
      if (b != null) {
        b.bullet.move();
        b.bullet.drawBullet();
        if (b.bullet.checkTime()) {
          if (b.split) { //if it was an origonal shot
            float x = b.bullet.pos.x;
            float y = b.bullet.pos.y;
            Cell cell = b.bullet.cell;
            float rotation = (atan(b.bullet.vel.y/b.bullet.vel.x)*180/PI);
            if (b.bullet.vel.x<0) rotation = 180 + rotation;
            bullets.add(new Spliter(new Bullet(x, y, rotation, cell, 2, 1, 8), false));
            for (int p = 1; p<4; p++) { //adds a arc of bullets around the one that split. these dont split
              bullets.add(new Spliter(new Bullet(x, y, rotation+degrees*p, cell, 2, 1, 8), false));
              bullets.add(new Spliter(new Bullet(x, y, rotation-degrees*p, cell, 2, 1, 8), false));
            }
          }
          bullets.remove(i);
        }
      }
    }
  }

  public ArrayList<Bullet> getBullets() {
    ArrayList<Bullet> returned = new ArrayList<Bullet>();
    for (Spliter s : bullets) {
      returned.add(s.bullet);
    }
    return returned;
  }

  public void deleteBullet(Bullet b) {
    for (int i =0; i<bullets.size(); i++) {
      if (bullets.get(i) != null && bullets.get(i).bullet.equals(b)) {
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

class Spliter { //used to tell the bullet to split or not
  Bullet bullet;
  Boolean split;
  Spliter(Bullet b, Boolean s) {
    bullet = b;
    split = s;
  }
}
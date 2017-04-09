interface Weapon{
  void triggerUp(); //Informs the weapon that the player realesed the trigger
  void triggerDown(float x, float y, float rotation, Cell cell); //tells the weapon the trigger is down. more complex then up
  void updateWeapon(int heightT); //draws the weapon
  void updateBullets(); //draws and animates the bullets looking for collisions
  ArrayList<Bullet> getBullets(); //returns all the weapons bullets
  void deleteBullet(Bullet b); //deletes a specific bullet
  Shape getShape(float x, float y, double n, float m, float speed, float rotation); //returns the shape of the weapon for tank hitting wall collisions
  boolean expended(); //if the weapon has been used up but still has bullets to animate
  boolean isEmpty(); //weapon has no bullets
  void drawCrate(int x, int y, int widthC); //draws the weapon crate on the maze fo requested by a cell
}